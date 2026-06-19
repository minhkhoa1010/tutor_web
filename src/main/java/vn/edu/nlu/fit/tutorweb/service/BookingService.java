package vn.edu.nlu.fit.tutorweb.service;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.http.Part;
import vn.edu.nlu.fit.tutorweb.dao.BookingDAO;
import vn.edu.nlu.fit.tutorweb.entity.Booking;
import vn.edu.nlu.fit.tutorweb.db.DBConnect;
import vn.edu.nlu.fit.tutorweb.utils.CloudinaryConfig;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class BookingService {

    private final BookingDAO bookingDAO = new BookingDAO();

    public List<Booking> getHiredTutors(long parentId) {
        if (parentId <= 0) return new ArrayList<>();
        return bookingDAO.getHiredTutorsByParentId(parentId);
    }

    /**
     * CỔNG 1: XỬ LÝ THANH TOÁN TỪ GIỎ HÀNG (CheckoutAllServlet)
     */
    public String processRentTutor(Booking booking) {
        boolean alreadyHired = bookingDAO.isAlreadyHired(booking.getParentId(), booking.getTutorId());
        if (alreadyHired) return "ERR_DUPLICATE_SCHEDULE";

        if (bookingDAO.isScheduleClash(booking.getTutorId(), booking.getSchedule())) {
            return "ERR_SCHEDULE_CLASH";
        }

        int sessions = countSessions(booking.getSchedule());
        booking.setTotalPrice(booking.getTotalPrice() * sessions);

        long currentBalance = bookingDAO.getUserBalance(booking.getParentId());
        if (currentBalance < booking.getTotalPrice()) return "ERR_INSUFFICIENT_BALANCE";

        return executeBookingTransaction(booking);
    }

    /**
     * CỔNG 2: XỬ LÝ THUÊ TRỰC TIẾP TỪ NÚT "THUÊ NGAY" (HireServlet)
     */
    public String processDirectRentTutor(Booking booking, long hourlyRate) {
        if (booking.getSchedule() == null || booking.getSchedule().isBlank()) {
            return "ERR_EMPTY_SCHEDULE";
        }

        if (bookingDAO.isScheduleClash(booking.getTutorId(), booking.getSchedule())) {
            return "ERR_SCHEDULE_CLASH";
        }

        int sessions = countSessions(booking.getSchedule());
        long finalCalculatedPrice = hourlyRate * sessions;
        booking.setTotalPrice(finalCalculatedPrice);

        long currentBalance = bookingDAO.getUserBalance(booking.getParentId());
        if (currentBalance < booking.getTotalPrice()) {
            return "ERR_BALANCE_NOT_ENOUGH";
        }

        return executeBookingTransaction(booking);
    }

    private int countSessions(String schedule) {
        if (schedule == null || schedule.isBlank() || "Theo thỏa thuận".equalsIgnoreCase(schedule.trim())) {
            return 1;
        }
        String[] sessions = schedule.split(",");
        int count = 0;
        for (String s : sessions) {
            if (!s.trim().isEmpty()) count++;
        }
        return count > 0 ? count : 1;
    }

    private String executeBookingTransaction(Booking booking) {
        long totalPrice = booking.getTotalPrice();
        long serviceFee = (long) (totalPrice * 0.10);
        long tutorAmount = totalPrice - serviceFee;

        try {
            DBConnect.get().useTransaction(handle -> {
                handle.createUpdate("UPDATE users SET balance = balance - :amount WHERE id = :parentId")
                        .bind("amount", totalPrice)
                        .bind("parentId", booking.getParentId())
                        .execute();

                long bookingId = handle.createUpdate("""
                    INSERT INTO bookings (parent_id, tutor_id, subject_name, schedule, total_price, status, created_at)
                    VALUES (:parentId, :tutorId, :subjectName, :schedule, :totalPrice, 'ACTIVE', NOW())
                """)
                        .bindBean(booking)
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(Long.class)
                        .one();

                handle.createUpdate("""
                    INSERT INTO platform_revenue (booking_id, service_fee, tutor_amount, created_at)
                    VALUES (:bookingId, :serviceFee, :tutorAmount, NOW())
                """)
                        .bind("bookingId", bookingId)
                        .bind("serviceFee", serviceFee)
                        .bind("tutorAmount", tutorAmount)
                        .execute();

                handle.createUpdate("""
                    INSERT INTO transactions (user_id, type, amount, status, txn_ref, created_at)
                    VALUES (:userId, 'PAYMENT_FOR_BOOKING', :amount, 'SUCCESS', :ref, NOW())
                """)
                        .bind("userId", booking.getParentId())
                        .bind("amount", totalPrice)
                        .bind("ref", "BOOKING_" + bookingId)
                        .execute();
            });
            return "SUCCESS";
        } catch (Exception e) {
            e.printStackTrace();
            return "ERR_SYSTEM";
        }
    }

    /**
     * THÊM MỚI: Gia sư gửi yêu cầu hoàn thành lớp học lên hệ thống (Chờ phụ huynh duyệt)
     */
    public boolean handleRequestCompleteBooking(long bookingId) {
        return bookingDAO.updateBookingStatus((int) bookingId, "PENDING_COMPLETED");
    }

    /**
     * ĐÃ CẬP NHẬT: Xử lý hoàn thành lớp học & giải ngân tiền (Do Phụ huynh bấm APPROVE kích hoạt)
     */
    public boolean handleCompleteBooking(long bookingId) {
        try {
            DBConnect.get().useTransaction(handle -> {
                // Chấp nhận giải ngân khi trạng thái là ACTIVE, PAID hoặc PENDING_COMPLETED
                var revenueInfo = handle.createQuery("""
                SELECT b.tutor_id, pr.tutor_amount 
                FROM bookings b
                JOIN platform_revenue pr ON b.id = pr.booking_id
                WHERE b.id = :bookingId AND b.status IN ('ACTIVE', 'PAID', 'PENDING_COMPLETED')
            """)
                        .bind("bookingId", bookingId)
                        .mapToMap()
                        .findOne()
                        .orElse(null);

                if (revenueInfo == null) {
                    throw new IllegalStateException("Không tìm thấy thông tin đối soát hoặc trạng thái không hợp lệ!");
                }

                long tutorId = ((Number) revenueInfo.get("tutor_id")).longValue();
                long tutorAmount = ((Number) revenueInfo.get("tutor_amount")).longValue();

                handle.createUpdate("UPDATE bookings SET status = 'COMPLETED' WHERE id = :bookingId")
                        .bind("bookingId", bookingId)
                        .execute();

                handle.createUpdate("""
                UPDATE users 
                SET balance = balance + :tutorAmount 
                WHERE id = (SELECT user_id FROM tutors WHERE id = :tutorId)
            """)
                        .bind("tutorAmount", tutorAmount)
                        .bind("tutorId", tutorId)
                        .execute();

                handle.createUpdate("""
                INSERT INTO transactions (user_id, type, amount, status, txn_ref, created_at)
                VALUES (
                    (SELECT user_id FROM tutors WHERE id = :tutorId), 
                    'REVENUE_FROM_BOOKING', 
                    :amount, 
                    'SUCCESS', 
                    :ref, 
                    NOW()
                )
            """)
                        .bind("tutorId", tutorId)
                        .bind("amount", tutorAmount)
                        .bind("ref", "REVENUE_" + bookingId)
                        .execute();
            });
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean handleDisputeBooking(int bookingId, String reason, String disputeBy, String evidenceUrl) {
        return bookingDAO.disputeBooking(bookingId, reason, disputeBy, evidenceUrl);
    }
    /**
     * Xử lý phụ huynh từ chối kết thúc lớp học, đưa trạng thái về lại ACTIVE
     */
    public boolean handleRejectCompleteBooking(int bookingId) {
        // Khởi tạo hoặc dùng instance bookingDAO có sẵn trong Service của bạn
        return bookingDAO.rejectCompletionRequest(bookingId);
    }
    /**
     * THÊM MỚI: Tự động quét và giải ngân cho các đơn hàng quá hạn phụ huynh phản hồi
     */
    public void scanAndReleaseAutoCompletions() {
        // Cấu hình quá 3 ngày không phản hồi thì tự động giải ngân
        int overdueDays = 3;
        List<Long> overdueIds = bookingDAO.getOverduePendingCompletions(overdueDays);

        if (overdueIds != null && !overdueIds.isEmpty()) {
            System.out.println(">>> [AUTO-SCAN] Phát hiện " + overdueIds.size() + " hợp đồng quá hạn duyệt. Đang tiến hành giải ngân tự động...");

            for (Long bookingId : overdueIds) {
                try {
                    // Tái sử dụng hàm handleCompleteBooking đã chạy Transaction cực kỳ an toàn của bạn
                    boolean success = handleCompleteBooking(bookingId);
                    if (success) {
                        System.out.println(">>> [AUTO-SCAN SUCCESS] Đã tự động hoàn thành và giải ngân cho Booking ID: " + bookingId);
                    } else {
                        System.err.println(">>> [AUTO-SCAN FAILED] Không thể hoàn thành tự động cho Booking ID: " + bookingId);
                    }
                } catch (Exception e) {
                    System.err.println(">>> [AUTO-SCAN ERROR] Lỗi hệ thống khi xử lý Booking ID: " + bookingId);
                    e.printStackTrace();
                }
            }
        }
    }
        public boolean handleTutorDispute(long bookingId, String reason, Part filePart) {
            String evidenceUrl = null;

            // 1. Kiểm tra và tải tệp minh chứng lên Cloudinary nếu có dữ liệu gửi lên
            if (filePart != null && filePart.getSize() > 0) {
                try {
                    // Lấy instance Cloudinary đã được cấu hình từ bộ utils của hệ thống
                    Cloudinary cloudinary = CloudinaryConfig.getCloudinary();

                    // Đọc luồng dữ liệu của file (InputStream) để chuẩn bị upload băm nhỏ trực tiếp
                    try (InputStream is = filePart.getInputStream()) {
                        byte[] fileBytes = is.readAllBytes();

                        // Cấu hình thư mục lưu trữ trên Cloudinary (Ví dụ cho vào thư mục disputes)
                        Map options = ObjectUtils.asMap(
                                "folder", "tutorweb/disputes",
                                "resource_type", "auto" // Tự động nhận diện ảnh (jpg, png) hoặc tài liệu (pdf, docx)
                        );

                        // Tiến hành upload lên Cloud băm dữ liệu từ mảng byte
                        Map uploadResult = cloudinary.uploader().upload(fileBytes, options);

                        // Trích xuất lấy URL tuyệt đối trả về từ Cloudinary
                        if (uploadResult != null && uploadResult.containsKey("secure_url")) {
                            evidenceUrl = (String) uploadResult.get("secure_url");
                        }
                    }
                } catch (Exception e) {
                    System.err.println(">>> [LỖI UPLOAD MINH CHỨNG CLOUDINARY]: " + e.getMessage());
                    e.printStackTrace();
                    // Tùy chọn: Có thể trả về false luôn nếu bắt buộc phải có minh chứng thành công
                }
            }

            // 2. Gọi xuống DAO: Gắn cứng vai trò người khiếu nại 'disputeBy' là 'TUTOR'
            // Đồng thời truyền chính xác ID kiểu long, nội dung lý do và đường dẫn ảnh vừa lấy từ Cloud
            return bookingDAO.disputeBooking(bookingId, reason, "TUTOR", evidenceUrl);
        }
}