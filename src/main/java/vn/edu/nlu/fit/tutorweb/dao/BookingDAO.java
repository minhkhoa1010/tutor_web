package vn.edu.nlu.fit.tutorweb.dao;

import org.jdbi.v3.core.Jdbi;
import vn.edu.nlu.fit.tutorweb.db.DBConnect;
import vn.edu.nlu.fit.tutorweb.entity.Booking;

import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    // Đồng bộ khai báo jdbi lên đầu class giống các DAO khác
    private final Jdbi jdbi = DBConnect.get();

    /**
     * 1. LẤY DANH SÁCH GIA SƯ ĐANG THUÊ (ĐÃ CẬP NHẬT QUÉT TOÀN BỘ TRẠNG THÁI ĐỂ PHỤ HUYNH THEO DÕI)
     */
    public List<Booking> getHiredTutorsByParentId(long parentId) {
        String sql = """
    SELECT
        b.id,
        b.parent_id,
        b.tutor_id,
        b.schedule,
        t.teaching_subject AS subjectName,
        b.total_price,
        b.status,
        b.dispute_by,  
        DATE_FORMAT(b.created_at, '%d/%m/%Y') AS createdAt,
        u.fullname AS tutorName,
        u.avatar_url AS portraitUrl,
        DATE_FORMAT(t.birth_date, '%d/%m/%Y') AS dateOfBirth
    FROM bookings b
    JOIN tutors t ON b.tutor_id = t.id
    JOIN users u ON t.user_id = u.id
    WHERE b.parent_id = :parentId
      AND b.status IN ('ACTIVE', 'PAID', 'PENDING_COMPLETED', 'DISPUTED', 'COMPLETED', 'REFUNDED')
    ORDER BY b.id DESC
""";

        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .bind("parentId", parentId)
                        .mapToBean(Booking.class)
                        .list()
        );
    }

    /**
     * 2. TRUY VẤN KIỂM TRA TRÙNG LỊCH HỌC (Dùng cho logic cũ hoặc check chính xác chuỗi)
     */
    public long countActiveBookingBySchedule(long tutorId, String schedule) {
        String sql = """
            SELECT COUNT(*) 
            FROM bookings 
            WHERE tutor_id = :tutorId 
              AND schedule = :schedule 
              AND status IN ('ACTIVE', 'PAID', 'PENDING_COMPLETED')
        """;
        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .bind("tutorId", tutorId)
                        .bind("schedule", schedule.trim())
                        .mapTo(Long.class)
                        .one()
        );
    }

    /**
     * 3. LẤY SỐ DƯ VÍ CỦA USER THÔ TỪ DATABASE
     */
    public long getUserBalance(long userId) {
        String sql = "SELECT balance FROM users WHERE id = :userId";
        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .bind("userId", userId)
                        .mapTo(Long.class)
                        .findOne()
                        .orElse(0L)
        );
    }

    /**
     * 4. LƯU HỢP ĐỒNG THUÊ GIA SƯ MỚI VÀO DATABASE
     */
    public boolean createBooking(Booking booking) {
        String sql = """
            INSERT INTO bookings (parent_id, tutor_id, subject_name, schedule, total_price, status, created_at)
            VALUES (:parentId, :tutorId, :subjectName, :schedule, :totalPrice, :status, NOW())
        """;
        int rows = jdbi.withHandle(h ->
                h.createUpdate(sql)
                        .bindBean(booking)
                        .execute()
        );
        return rows > 0;
    }

    /**
     * 5. KIỂM TRA PHỤ HUYNH ĐÃ THUÊ GIA SƯ NÀY CHƯA (ĐÃ VÁ LỖI LOGIC ĐẶT TRÙNG)
     */
    public boolean isAlreadyHired(long parentId, long tutorId) {
        String sql = """
            SELECT COUNT(*) FROM bookings
            WHERE parent_id = :parentId
              AND tutor_id  = :tutorId
              AND status    IN ('ACTIVE', 'PAID', 'PENDING_COMPLETED')
        """;
        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .bind("parentId", parentId)
                        .bind("tutorId", tutorId)
                        .mapTo(Long.class)
                        .one() > 0
        );
    }

    /**
     * 6. LẤY DANH SÁCH CÁC NGÀY GIA SƯ ĐÃ BẬN (QUÉT CẢ KHI ĐANG TRANH CHẤP HOẶC CHỜ XÁC NHẬN)
     */
    public List<String> getBusySchedules(long tutorId) {
        String sql = "SELECT schedule FROM bookings WHERE tutor_id = :tutorId AND status IN ('ACTIVE', 'PAID', 'PENDING_COMPLETED')";
        List<String> busyLists = jdbi.withHandle(h ->
                h.createQuery(sql)
                        .bind("tutorId", tutorId)
                        .mapTo(String.class)
                        .list()
        );

        List<String> occupiedDays = new ArrayList<>();
        for (String s : busyLists) {
            if (s != null && !s.isBlank()) {
                String[] days = s.split(",");
                for (String day : days) {
                    String cleanDay = day.trim();
                    if (!cleanDay.isEmpty()) {
                        occupiedDays.add(cleanDay);
                    }
                }
            }
        }
        return occupiedDays;
    }

    /**
     * 7. KIỂM TRA TRÙNG LỊCH CHÉO NÂNG CAO
     */
    public boolean isScheduleClash(long tutorId, String availableSchedules) {
        if (availableSchedules == null || availableSchedules.isBlank() || "Theo thỏa thuận".equalsIgnoreCase(availableSchedules.trim())) {
            return false;
        }

        List<String> busyDays = getBusySchedules(tutorId);
        if (busyDays.isEmpty()) {
            return false;
        }

        String[] incomingDays = availableSchedules.split(",");
        for (String day : incomingDays) {
            String cleanIncomingDay = day.trim();
            if (busyDays.contains(cleanIncomingDay)) {
                return true;
            }
        }
        return false;
    }

    /**
     * 8. CẬP NHẬT TRẠNG THÁI CHUNG (ĐỒNG BỘ JDBI)
     */
    public boolean updateBookingStatus(int bookingId, String status) {
        String sql = "UPDATE bookings SET status = :status WHERE id = :id";
        int rows = jdbi.withHandle(h ->
                h.createUpdate(sql)
                        .bind("status", status)
                        .bind("id", bookingId)
                        .execute()
        );
        return rows > 0;
    }

    /**
     * 9. CẬP NHẬT TRẠNG THÁI KHIẾU NẠI KÈM LÝ DO (ĐỒNG BỘ JDBI)
     */


    /**
     * Chuyển trạng thái hợp đồng sang DISPUTE kèm lý do, vai trò người gửi và tệp minh chứng từ Cloudinary
     */
    public boolean disputeBooking(long bookingId, String reason, String disputeBy, String evidenceUrl) {
        String sql = """
    UPDATE bookings 
    SET status = 'DISPUTED', 
        dispute_reason = :reason, 
        dispute_by = :disputeBy,
        dispute_evidence_url = :evidenceUrl,
        disputed_at = NOW()
    WHERE id = :id
""";

        try {
            int rows = jdbi.withHandle(handle ->
                    handle.createUpdate(sql)
                            .bind("id", bookingId)
                            .bind("reason", reason)
                            .bind("disputeBy", disputeBy)
                            .bind("evidenceUrl", evidenceUrl)
                            .execute()
            );
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    /**
     * LẤY DANH SÁCH LỚP HỌC MỚI / SẮP DIỄN RA CỦA GIA SƯ
     * Mẹo: Aliasing u.fullname thành tutorName để tận dụng thuộc tính có sẵn trong Entity Booking
     */
    public List<Booking> getBookingsByTutorId(long tutorId, int limit) {
        return jdbi.withHandle(h ->
                h.createQuery("""
            SELECT
                b.id, b.parent_id, b.tutor_id, b.subject_name, b.schedule,
                b.total_price, b.status, b.dispute_by, b.dispute_reason,
                DATE_FORMAT(b.created_at, '%d/%m/%Y') AS createdAt,
                u.fullname AS tutorName,
                u.avatar_url AS portraitUrl
            FROM bookings b
            JOIN users u ON b.parent_id = u.id
            WHERE b.tutor_id = :tutorId
            ORDER BY b.id DESC
            LIMIT :limit
        """)
                        .bind("tutorId", tutorId)
                        .bind("limit", limit)
                        .mapToBean(Booking.class)
                        .list()
        );
    }

    /**
     * ĐẾM SỐ LỚP ĐANG DẠY (HOẶC ĐÃ THANH TOÁN) CỦA GIA SƯ
     */
    public int countActiveBookingsByTutorId(long tutorId) {
        String sql = "SELECT COUNT(*) FROM bookings WHERE tutor_id = :tutorId AND status IN ('ACTIVE', 'PAID', 'PENDING_COMPLETED')";
        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .bind("tutorId", tutorId)
                        .mapTo(Integer.class)
                        .one()
        );
    }
    /**
     * LẤY DANH SÁCH ID HỢP ĐỒNG CHỜ DUYỆT QUÁ HẠN X NGÀY
     * (Giả sử bảng bookings của bạn có trường updated_at để check thời gian chuyển trạng thái gần nhất,
     * nếu chưa có bạn có thể dùng tạm created_at hoặc thêm cột updated_at vào DB nhé!)
     */
    public List<Long> getOverduePendingCompletions(int days) {
        String sql = """
        SELECT id FROM bookings 
        WHERE status = 'PENDING_COMPLETED' 
          AND updated_at <= NOW() - INTERVAL :days DAY
    """;
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("days", days)
                        .mapTo(Long.class)
                        .list()
        );
    }
    public void scanAndReleaseAutoDisputes() {
        jdbi.useHandle(handle -> handle.useTransaction(h -> {
            // 1. Lấy ra danh sách các bookings bị gia sư khiếu nại quá 24h chưa có phản hồi ngược lại
            String selectSql = """
            SELECT b.id, b.total_price, t.user_id AS tutorUserId
            FROM bookings b
            JOIN tutors t ON b.tutor_id = t.id
            WHERE b.status = 'DISPUTED' 
              AND b.dispute_by = 'TUTOR'
              AND b.disputed_at <= NOW() - INTERVAL 1 DAY
        """;

            var overdueDisputes = h.createQuery(selectSql)
                    .mapToMap()
                    .list();

            for (var dispute : overdueDisputes) {
                long bookingId = ((Number) dispute.get("id")).longValue();
                long totalPrice = ((Number) dispute.get("total_price")).longValue();
                long tutorUserId = ((Number) dispute.get("tutorUserId")).longValue();

                // 2. Cập nhật trạng thái lớp thành COMPLETED
                h.createUpdate("UPDATE bookings SET status = 'COMPLETED' WHERE id = :id")
                        .bind("id", bookingId)
                        .execute();

                // 3. Giải ngân cộng tiền vào ví tài khoản của Gia sư
                h.createUpdate("UPDATE users SET balance = balance + :amount WHERE id = :userId")
                        .bind("amount", totalPrice)
                        .bind("userId", tutorUserId)
                        .execute();

                System.out.println(">>> [AUTO-RELEASE] Đã tự động giải ngân hợp đồng #" + bookingId + " do phụ huynh quá thời hạn phản hồi.");
            }
        }));
    }
    /**
     * PHỤ HUYNH TỪ CHỐI KẾT THÚC LỚP -> ĐẨY TRẠNG THÁI VỀ LẠI ACTIVE
     */
    public boolean rejectCompletionRequest(long bookingId) {
        String sql = """
        UPDATE bookings 
        SET status = 'ACTIVE' 
        WHERE id = :bookingId AND status = 'PENDING_COMPLETED'
    """;
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("bookingId", bookingId)
                        .execute() > 0
        );
    }
}