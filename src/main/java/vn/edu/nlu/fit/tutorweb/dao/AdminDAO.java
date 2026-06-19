package vn.edu.nlu.fit.tutorweb.dao;

import vn.edu.nlu.fit.tutorweb.db.DBConnect;
import vn.edu.nlu.fit.tutorweb.dto.StudentSearchResult;
import vn.edu.nlu.fit.tutorweb.dto.TutorPending;
import vn.edu.nlu.fit.tutorweb.dto.TutorProfile;
import vn.edu.nlu.fit.tutorweb.entity.WithdrawalRequest;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class AdminDAO {

    // --- Các hàm thống kê đếm giữ nguyên gốc của bạn ---
    public long countTutors() { return DBConnect.get().withHandle(h -> h.createQuery("SELECT COUNT(*) FROM tutors WHERE verification_status='APPROVED'").mapTo(Long.class).one()); }
    public long countStudents() { return DBConnect.get().withHandle(h -> h.createQuery("SELECT COUNT(*) FROM users u JOIN user_roles ur ON u.id = ur.user_id WHERE ur.role_id = 3").mapTo(Long.class).one()); }
    public long countPendingTutors() { return DBConnect.get().withHandle(h -> h.createQuery("SELECT COUNT(*) FROM tutors WHERE verification_status='PENDING'").mapTo(Long.class).one()); }
    public long getMonthlyRevenue() { return DBConnect.get().withHandle(h -> h.createQuery("SELECT COALESCE(SUM(service_fee),0) FROM platform_revenue WHERE MONTH(created_at)=MONTH(CURRENT_DATE()) AND YEAR(created_at)=YEAR(CURRENT_DATE())").mapTo(Long.class).one()); }
    public List<TutorPending> getPendingTutors() { return DBConnect.get().withHandle(h -> h.createQuery("SELECT t.id AS tutor_id, u.id AS user_id, u.fullname AS full_name, u.avatar_url AS avatar_url, t.teaching_subject AS teaching_subject, DATE_FORMAT(u.created_at, '%d/%m/%Y') AS applied_date FROM tutors t JOIN users u ON t.user_id = u.id WHERE t.verification_status = 'PENDING'").mapToBean(TutorPending.class).list()); }
    public int[] getUserGrowthByMonth() { List<Map<String, Object>> rows = DBConnect.get().withHandle(h -> h.createQuery("SELECT MONTH(u.created_at) AS m, COUNT(*) AS total FROM users u JOIN user_roles ur ON u.id = ur.user_id WHERE YEAR(u.created_at) = (SELECT MAX(YEAR(created_at)) FROM users) AND u.is_active = 1 GROUP BY MONTH(u.created_at) ORDER BY m").mapToMap().list()); int[] data = new int[12]; for (int i = 0; i < 12; i++) data[i] = 0; for (Map<String, Object> row : rows) { if (row.get("m") != null && row.get("total") != null) { int month = ((Number) row.get("m")).intValue(); int total = ((Number) row.get("total")).intValue(); if (month >= 1 && month <= 12) { data[month - 1] = total; } } } return data; }

    public TutorProfile getTutorProfileById(long tutorId) {
        return DBConnect.get().withHandle(handle -> {
            String sql = """
    SELECT
        t.id, u.fullname, t.gender, t.qualification, t.hourly_rate,
        t.teaching_subject, t.teaching_grade, t.teaching_area,
        t.experience_summary, t.birth_date, t.school, t.major,
        (SELECT GROUP_CONCAT(ts.slot_name SEPARATOR ', ')
         FROM tutor_schedules tsch
         JOIN time_slots ts ON tsch.time_slot_id = ts.id
         WHERE tsch.tutor_id = t.id) AS available_schedules
    FROM tutors t
    JOIN users u ON t.user_id = u.id
    WHERE t.id = :id
""";
            Map<String, Object> data = handle.createQuery(sql)
                    .bind("id", tutorId)
                    .mapToMap()
                    .findOne()
                    .orElse(null);

            if (data == null) return null;

            List<Map<String, Object>> docs = handle.createQuery("SELECT doc_type, file_url FROM tutor_documents WHERE tutor_id = :id")
                    .bind("id", tutorId).mapToMap().list();

            List<String> degreeUrls = new ArrayList<>();
            List<String> idCardUrls = new ArrayList<>();
            String portraitUrl = null;

            for (Map<String, Object> doc : docs) {
                String type = (String) doc.get("doc_type");
                String url = (String) doc.get("file_url");
                if ("PORTRAIT".equals(type)) portraitUrl = url;
                else if ("DEGREE".equals(type)) degreeUrls.add(url);
                else if (type != null && type.contains("ID_CARD")) idCardUrls.add(url);
            }

            // Gọi đúng Constructor 16 tham số
            TutorProfile profile = new TutorProfile(
                    ((Number) data.get("id")).longValue(),
                    (String) data.get("fullname"),
                    (String) data.get("gender"),
                    (String) data.get("qualification"),

                    data.get("hourly_rate") != null ? ((Number) data.get("hourly_rate")).intValue() : null,
                    null,
                    (String) data.get("teaching_subject"),
                    (String) data.get("teaching_grade"),
                    (String) data.get("teaching_area"),
                    null,
                    portraitUrl,
                    degreeUrls,
                    idCardUrls,
                    // BỔ SUNG THAM SỐ hourlyRate VÀO ĐÂY:
                    data.get("hourly_rate") != null ? ((Number) data.get("hourly_rate")).intValue() : 0,
                    data.get("birth_date") != null ? data.get("birth_date").toString() : null,
                    (String) data.get("school"),
                    (String) data.get("major")
            );

            // Gán các trường dynamic qua Setter
            profile.setExperienceSummary((String) data.get("experience_summary"));
            profile.setAvailableSchedules((String) data.get("available_schedules"));

            return profile;
        });
    }

    public boolean updateTutorStatus(long tutorId, String status) {
        return DBConnect.get().withHandle(h -> h.createUpdate("UPDATE tutors SET verification_status = :status WHERE id = :tutorId").bind("status", status).bind("tutorId", tutorId).execute() > 0);
    }

    public static String getVerificationStatus(long userId) {
        return DBConnect.get().withHandle(h -> h.createQuery("SELECT verification_status FROM tutors WHERE user_id = :userId LIMIT 1").bind("userId", userId).mapTo(String.class).findFirst().orElse(null));
    }

    public TutorProfile getTutorProfileByUserId(long userId) {
        return DBConnect.get().withHandle(handle -> {
            String sql = """
            SELECT t.id, u.fullname, t.gender, t.qualification, 
                   t.hourly_rate, t.teaching_subject, t.teaching_grade, t.teaching_area, 
                   t.experience_summary, -- 🌟 FIX LỖI: Đã bổ sung cột kinh nghiệm tóm tắt vào SQL
                   t.birth_date, t.school, t.major,
                   (SELECT GROUP_CONCAT(ts.slot_name SEPARATOR ', ')
                    FROM tutor_schedules tsch
                    JOIN time_slots ts ON tsch.time_slot_id = ts.id
                    WHERE tsch.tutor_id = t.id) AS available_schedules
            FROM tutors t 
            JOIN users u ON t.user_id = u.id 
            WHERE t.user_id = :id
        """;

            Map<String, Object> data = handle.createQuery(sql)
                    .bind("id", userId)
                    .mapToMap()
                    .findOne()
                    .orElse(null);

            if (data == null) return null;

            List<Map<String, Object>> docs = handle.createQuery("SELECT doc_type, file_url FROM tutor_documents WHERE tutor_id = :id")
                    .bind("id", ((Number) data.get("id")).longValue()).mapToMap().list();
            List<String> degreeUrls = new ArrayList<>(); List<String> idCardUrls = new ArrayList<>(); String portraitUrl = null;
            for (Map<String, Object> doc : docs) {
                String type = (String) doc.get("doc_type"); String url = (String) doc.get("file_url");
                if ("PORTRAIT".equals(type)) portraitUrl = url;
                else if ("DEGREE".equals(type)) degreeUrls.add(url);
                else if (type != null && type.contains("ID_CARD")) idCardUrls.add(url);
            }

            //  (đảm bảo đủ 17 tham số):
            TutorProfile profile = new TutorProfile(
                    ((Number) data.get("id")).longValue(),              // 1. id
                    (String) data.get("fullname"),                     // 2. fullName
                    (String) data.get("gender"),                       // 3. gender
                    (String) data.get("qualification"),                // 4. degreeLevel
                    data.get("hourly_rate") != null ? ((Number) data.get("hourly_rate")).intValue() : null, // 5. minRate
                    null,                                              // 6. maxRate
                    (String) data.get("teaching_subject"),             // 7. subjects
                    (String) data.get("teaching_grade"),               // 8. grades
                    null,                                              // 9. provinceName (để null nếu không có)
                    (String) data.get("teaching_area"),                // 10. districtName
                    portraitUrl,                                       // 11. portraitUrl
                    degreeUrls,                                        // 12. degreeUrls
                    idCardUrls,                                        // 13. idCardUrls
                    data.get("hourly_rate") != null ? ((Number) data.get("hourly_rate")).intValue() : 0, // 14. hourlyRate (BỔ SUNG)
                    data.get("birth_date") != null ? data.get("birth_date").toString() : null,           // 15. birthDate
                    (String) data.get("school"),                       // 16. school
                    (String) data.get("major")                         // 17. major

            );

            // Set chính xác kinh nghiệm giảng dạy và lịch rảnh
            profile.setExperienceSummary((String) data.get("experience_summary"));
            profile.setAvailableSchedules((String) data.get("available_schedules"));

            return profile;
        });
    }

    public List<StudentSearchResult> getAllStudentsForAdmin() { return DBConnect.get().withHandle(h -> h.createQuery("SELECT u.id AS id, u.fullname AS fullname, u.email AS email, u.avatar_url AS avatarUrl, DATE_FORMAT(u.created_at, '%d/%m/%Y %H:%i') AS createdAt, u.is_active AS isActive FROM users u JOIN user_roles ur ON u.id = ur.user_id WHERE ur.role_id = 3 ORDER BY u.id DESC").mapToBean(StudentSearchResult.class).list()); }

    public StudentSearchResult getStudentByIdForAdmin(long studentId) { return DBConnect.get().withHandle(h -> h.createQuery("SELECT u.id AS id, u.fullname AS fullname, u.email AS email, u.avatar_url AS avatarUrl, u.phone AS phone, DATE_FORMAT(u.created_at, '%d/%m/%Y %H:%i') AS createdAt, u.is_active AS isActive FROM users u WHERE u.id = :id").bind("id", studentId).mapToBean(StudentSearchResult.class).findOne().orElse(null)); }
    public List<WithdrawalRequest> getAllPendingWithdrawals() {
        return DBConnect.get().withHandle(h ->
                h.createQuery("""
            SELECT wr.id, wr.user_id, wr.amount, wr.bank_name,
                   wr.bank_account_number, wr.bank_account_name, wr.status,
                   DATE_FORMAT(wr.created_at, '%d/%m/%Y %H:%i') AS createdAt,
                   u.fullname AS userName
            FROM withdrawal_requests wr
            JOIN users u ON wr.user_id = u.id
            WHERE wr.status = 'PENDING'
            ORDER BY wr.created_at DESC
        """)
                        .mapToBean(WithdrawalRequest.class)
                        .list()
        );
    }

    public boolean approveWithdrawal(long withdrawalId) {
        try {
            DBConnect.get().useTransaction(handle -> {
                // Cập nhật trạng thái yêu cầu
                handle.createUpdate("""
                UPDATE withdrawal_requests SET status = 'APPROVED' WHERE id = :id
            """).bind("id", withdrawalId).execute();

                // Cập nhật transaction WITHDRAW thành SUCCESS
                handle.createUpdate("""
                UPDATE transactions SET status = 'SUCCESS'
                WHERE txn_ref = CONCAT('WITHDRAW_',
                    (SELECT UNIX_TIMESTAMP(created_at) * 1000 FROM withdrawal_requests WHERE id = :id))
            """).bind("id", withdrawalId).execute();
            });
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean rejectWithdrawal(long withdrawalId) {
        try {
            DBConnect.get().useTransaction(handle -> {
                // Lấy amount và user_id để hoàn tiền
                var info = handle.createQuery("""
                SELECT user_id, amount FROM withdrawal_requests WHERE id = :id
            """).bind("id", withdrawalId).mapToMap().findOne().orElse(null);

                if (info == null) throw new RuntimeException("Không tìm thấy yêu cầu");

                long userId = ((Number) info.get("user_id")).longValue();
                long amount = ((Number) info.get("amount")).longValue();

                // Hoàn tiền lại cho gia sư
                handle.createUpdate("UPDATE users SET balance = balance + :amount WHERE id = :userId")
                        .bind("amount", amount).bind("userId", userId).execute();

                // Đổi trạng thái
                handle.createUpdate("UPDATE withdrawal_requests SET status = 'REJECTED' WHERE id = :id")
                        .bind("id", withdrawalId).execute();
            });
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    // ==========================================
    // KHU VỰC: QUẢN LÝ THANH TOÁN & RÚT TIỀN
    // ==========================================

    // Lấy danh sách các yêu cầu rút tiền (gồm cả thông tin thẻ ngân hàng lưu tại bảng users)
    public List<Map<String, Object>> getWithdrawalRequests() {
        String sql = """
            SELECT t.id, u.id AS userId, u.fullname, t.amount, 
                   COALESCE(u.bank_name, 'Chưa liên kết') AS bankName, 
                   COALESCE(u.bank_account_number, 'Chưa cập nhật') AS bankAccountNumber, 
                   COALESCE(u.bank_account_name, u.fullname) AS bankAccountName,
                   DATE_FORMAT(t.created_at, '%d/%m/%Y %H:%i') AS createdAt, t.status
            FROM transactions t
            JOIN users u ON t.user_id = u.id
            WHERE t.type IN ('WITHDRAW', 'WITHDRAW_REQUEST')
            ORDER BY t.id DESC
        """;
        return DBConnect.get().withHandle(h -> h.createQuery(sql).mapToMap().list());
    }

    // Xử lý phê duyệt hoặc từ chối lệnh rút tiền
    public boolean updateWithdrawalStatus(long transactionId, String status) {
        return DBConnect.get().withHandle(h -> {
            // 1. Cập nhật trạng thái của dòng transaction thành SUCCESS hoặc FAILED
            int updated = h.createUpdate("UPDATE transactions SET status = :status WHERE id = :id")
                    .bind("status", status)
                    .bind("id", transactionId)
                    .execute();

            // 2. Nếu trạng thái xử lý là TỪ CHỐI (FAILED), hoàn lại tiền vào ví (balance) cho user
            if (updated > 0 && "FAILED".equalsIgnoreCase(status)) {
                h.createUpdate("""
                    UPDATE users u 
                    JOIN transactions t ON u.id = t.user_id 
                    SET u.balance = u.balance + t.amount 
                    WHERE t.id = :id
                """).bind("id", transactionId).execute();
            }
            return updated > 0;
        });
    }

    /// =========================================================================
    // KHU VỰC ĐÃ KIỂM TRA & TỐI ƯU: BIỂU ĐỒ DOANH THU & KHIẾU NẠI (DASHBOARD)
    // =========================================================================

    // 1. Doanh thu theo từng tháng trong năm hiện tại (Dùng cho Bar Chart)
    public List<Map<String, Object>> getMonthlyRevenueReport() {
        String sql = """
            SELECT MONTH(created_at) as m, SUM(service_fee) as total
            FROM platform_revenue
            WHERE YEAR(created_at) = YEAR(CURRENT_DATE())
            GROUP BY MONTH(created_at)
            ORDER BY m ASC
        """;
        return DBConnect.get().withHandle(h -> h.createQuery(sql).mapToMap().list());
    }

    // 2. TỐI ƯU HÓA: Doanh thu theo Môn học trong CHÍNH XÁC tháng/năm hiện tại (Dùng cho Doughnut Chart)
    public List<Map<String, Object>> getRevenueBySubject() {
        String sql = """
            SELECT b.subject_name as subject, SUM(pr.service_fee) as total
            FROM platform_revenue pr
            JOIN bookings b ON pr.booking_id = b.id
            WHERE MONTH(pr.created_at) = MONTH(CURRENT_DATE())
              AND YEAR(pr.created_at) = YEAR(CURRENT_DATE())
            GROUP BY b.subject_name
        """;
        return DBConnect.get().withHandle(h -> h.createQuery(sql).mapToMap().list());
    }

    // =========================================================================
    // KHU VỰC ĐÃ ĐỒNG BỘ: XỬ LÝ KHIẾU NẠI TRỰC TIẾP TỪ BẢNG BOOKINGS
    // =========================================================================

    // 1. Lấy danh sách khiếu nại hiển thị rút gọn ngoài Dashboard (Đã lấy thêm trường bằng chứng và id)
    public List<Map<String, Object>> getReportedTutors() {
        String sql = """
         SELECT
               b.id AS booking_id,
               b.subject_name,
               b.total_price,
               u_tutor.fullname AS tutor_name,
               u_tutor.avatar_url AS avatar_url,
               u_parent.fullname AS parent_name,
               b.dispute_reason AS complaint_reason,
               b.dispute_evidence_url AS dispute_evidence_url,
               b.dispute_by AS dispute_by
           FROM bookings b
           LEFT JOIN tutors t ON b.tutor_id = t.id             -- 1. Nối qua bảng tutors trước
           LEFT JOIN users u_tutor ON t.user_id = u_tutor.id   -- 2. Từ tutors mới nối qua users
           LEFT JOIN users u_parent ON b.parent_id = u_parent.id
           WHERE b.status = 'DISPUTED'
           ORDER BY b.id DESC
           LIMIT 5
    """;

        return DBConnect.get().withHandle(handle -> handle.createQuery(sql).mapToMap().list());
    }


    // 2. Lấy danh sách toàn bộ khiếu nại cho trang /admin/complaints (Bổ sung đầy đủ thông tin)
    public List<Map<String, Object>> getAllComplaints() {
        String sql = """
        SELECT 
            b.id AS booking_id,
            b.status,
            b.dispute_reason,    -- Bắt buộc phải có
            b.dispute_by,        -- Bắt buộc phải có
            b.dispute_evidence_url,
            b.total_price,
            b.created_at,
            u_parent.fullname AS parent_name,
            u_tutor.fullname AS tutor_name,
            u_tutor.avatar_url AS tutor_avatar,
            t.teaching_subject AS subject_name
        FROM bookings b
        JOIN users u_parent ON b.parent_id = u_parent.id
        JOIN tutors t ON b.tutor_id = t.id
        JOIN users u_tutor ON t.user_id = u_tutor.id
        WHERE b.status = 'DISPUTED'
        ORDER BY b.created_at DESC
    """;

        return DBConnect.get().withHandle(handle -> handle.createQuery(sql).mapToMap().list());
    }
    // Kịch bản 1: Chấp nhận khiếu nại - Hoàn tiền cho Phụ huynh
    public boolean acceptComplaint(int bookingId) {
        return DBConnect.get().inTransaction(handle -> {
            // a. Lấy thông tin số tiền và ID phụ huynh từ lớp học
            Map<String, Object> booking = handle.createQuery("SELECT parent_id, total_price FROM bookings WHERE id = :id")
                    .bind("id", bookingId).mapToMap().findOne().orElse(null);

            if (booking == null) return false;

            long parentId = ((Number) booking.get("parent_id")).longValue();
            long totalPrice = ((Number) booking.get("total_price")).longValue();

            // b. Cập nhật trạng thái booking sang REFUNDED
            handle.createUpdate("UPDATE bookings SET status = 'REFUNDED' WHERE id = :id")
                    .bind("id", bookingId).execute();

            // c. Hoàn tiền vào ví Phụ huynh
            handle.createUpdate("UPDATE users SET balance = balance + :amount WHERE id = :id")
                    .bind("amount", totalPrice).bind("id", parentId).execute();

            // d. Ghi nhận lịch sử giao dịch hoàn tiền
            handle.createUpdate("""
                INSERT INTO transactions (user_id, type, amount, status, txn_ref, created_at) 
                VALUES (:userId, 'REFUND', :amount, 'SUCCESS', :ref, NOW())
            """)
                    .bind("userId", parentId)
                    .bind("amount", totalPrice)
                    .bind("ref", "REFUND_BK_" + bookingId)
                    .execute();

            return true;
        });
    }

    // Kịch bản 2: Từ chối khiếu nại - Giải ngân cho Gia sư (gia sư thắng)
    public boolean rejectComplaint(int bookingId) {
        return DBConnect.get().inTransaction(handle -> {
            // a. Lấy tutor_amount từ platform_revenue và user_id của gia sư
            Map<String, Object> info = handle.createQuery("""
                SELECT pr.tutor_amount, t.user_id AS tutor_user_id
                FROM platform_revenue pr
                JOIN bookings b ON pr.booking_id = b.id
                JOIN tutors t ON b.tutor_id = t.id
                WHERE pr.booking_id = :bookingId
            """).bind("bookingId", bookingId).mapToMap().findOne().orElse(null);

            if (info == null) return false;

            long tutorAmount = ((Number) info.get("tutor_amount")).longValue();
            long tutorUserId = ((Number) info.get("tutor_user_id")).longValue();

            // b. Đổi trạng thái booking sang COMPLETED
            handle.createUpdate("UPDATE bookings SET status = 'COMPLETED' WHERE id = :id")
                    .bind("id", bookingId).execute();

            // c. Cộng tiền thực nhận vào ví gia sư
            handle.createUpdate("UPDATE users SET balance = balance + :amount WHERE id = :id")
                    .bind("amount", tutorAmount).bind("id", tutorUserId).execute();

            // d. Ghi lịch sử giao dịch cho gia sư (dùng đúng ENUM REVENUE_FROM_BOOKING)
            handle.createUpdate("""
                INSERT INTO transactions (user_id, type, amount, status, txn_ref, created_at)
                VALUES (:userId, 'REVENUE_FROM_BOOKING', :amount, 'SUCCESS', :ref, NOW())
            """)
                    .bind("userId", tutorUserId)
                    .bind("amount", tutorAmount)
                    .bind("ref", "REVENUE_DISPUTE_BK_" + bookingId)
                    .execute();

            return true;
        });
    }
    // Thêm các hàm này vào cuối file AdminDAO.java của bạn

    /**
     * 1. LẤY DANH SÁCH TẤT CẢ YÊU CẦU RÚT TIỀN (JOIN VỚI BẢNG USERS ĐỂ LẤY TÊN)
     */
    public List<vn.edu.nlu.fit.tutorweb.entity.WithdrawalRequest> getAllWithdrawalRequests() {
        String sql = """
        SELECT w.id, w.user_id AS userId, u.fullname, w.amount, 
               w.bank_name AS bankName, 
               w.bank_account_number AS bankAccountNumber, -- Đã sửa thành bank_account_number
               w.bank_account_name AS bankAccountName,     -- Đã sửa thành bank_account_name
               w.status, 
               DATE_FORMAT(w.created_at, '%d/%m/%Y %H:%i') AS createdAt
        FROM withdrawal_requests w
        JOIN users u ON w.user_id = u.id
        ORDER BY w.created_at DESC
    """;
        return vn.edu.nlu.fit.tutorweb.db.DBConnect.get().withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(vn.edu.nlu.fit.tutorweb.entity.WithdrawalRequest.class)
                        .list()
        );
    }

    /**
     * 2. DUYỆT YÊU CẦU RÚT TIỀN (Chỉ chuyển trạng thái vì tiền đã trừ từ trước)
     */
    public boolean approveWithdrawalRequest(int requestId) {
        return vn.edu.nlu.fit.tutorweb.db.DBConnect.get().withHandle(handle -> {
            int rows = handle.createUpdate("UPDATE withdrawal_requests SET status = 'APPROVED' WHERE id = :id AND status = 'PENDING'")
                    .bind("id", requestId).execute();
            return rows > 0;
        });
    }

    /**
     * 3. TỪ CHỐI YÊU CẦU RÚT TIỀN (Transaction: Hoàn lại tiền vào ví người dùng + Cập nhật trạng thái)
     */
    public boolean rejectWithdrawalRequest(long withdrawalId) {
        try {
            // Đổi từ withHandle sang inTransaction để kích hoạt tính năng Transaction bảo toàn dòng tiền
            return DBConnect.get().inTransaction(handle -> {

                // 1. Lấy số tiền (amount) và mã người dùng (user_id) từ yêu cầu rút tiền
                var info = handle.createQuery("""
                SELECT user_id, amount FROM withdrawal_requests WHERE id = :id AND status = 'PENDING'
            """).bind("id", withdrawalId).mapToMap().findOne().orElse(null);

                if (info == null) return false;

                long userId = ((Number) info.get("user_id")).longValue();
                long amount = ((Number) info.get("amount")).longValue();

                // 2. Hoàn lại số tiền vào ví (balance) cho người dùng
                handle.createUpdate("UPDATE users SET balance = balance + :amount WHERE id = :userId")
                        .bind("amount", amount)
                        .bind("userId", userId)
                        .execute();

                // 3. Cập nhật trạng thái của lệnh rút tiền thành 'REJECTED'
                handle.createUpdate("UPDATE withdrawal_requests SET status = 'REJECTED' WHERE id = :id")
                        .bind("id", withdrawalId)
                        .execute();

                // 4. Ghi nhận lịch sử giao dịch hoàn tiền
                handle.createUpdate("""
                INSERT INTO transactions (user_id, type, amount, status, txn_ref, created_at)
                VALUES (:userId, 'REFUND', :amount, 'SUCCESS', :ref, NOW())
            """)
                        .bind("userId", userId)
                        .bind("amount", amount)
                        .bind("ref", "WD_REJECT_" + withdrawalId)
                        .execute();

                return true; // Tất cả thành công, JDBI sẽ tự động COMMIT
            });
        } catch (Exception e) {
            e.printStackTrace();
            return false; // Có lỗi xảy ra, JDBI tự động ROLLBACK hoàn toàn
        }
    }
}