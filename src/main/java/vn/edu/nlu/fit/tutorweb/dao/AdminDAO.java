package vn.edu.nlu.fit.tutorweb.dao;

import vn.edu.nlu.fit.tutorweb.db.DBConnect;
import vn.edu.nlu.fit.tutorweb.dto.StudentSearchResult;
import vn.edu.nlu.fit.tutorweb.dto.TutorPending;
import vn.edu.nlu.fit.tutorweb.dto.TutorProfile;
import org.jdbi.v3.core.statement.Query;
import org.jdbi.v3.core.statement.Update;
import vn.edu.nlu.fit.tutorweb.entity.UserSession;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class AdminDAO {

    public long countTutors() {
        return DBConnect.get().withHandle(h ->
                h.createQuery("""
                    SELECT COUNT(*)
                    FROM tutors
                    WHERE verification_status='APPROVED'
                """)
                        .mapTo(Long.class)
                        .one()
        );
    }

    public long countStudents() {
        return DBConnect.get().withHandle(h ->
                h.createQuery("""
                    SELECT COUNT(*)
                    FROM users u
                    JOIN user_roles ur
                        ON u.id = ur.user_id
                    WHERE ur.role_id = 3
                """)
                        .mapTo(Long.class)
                        .one()
        );
    }

    public long countPendingTutors() {
        return DBConnect.get().withHandle(h ->
                h.createQuery("""
                    SELECT COUNT(*)
                    FROM tutors
                    WHERE verification_status='PENDING'
                """)
                        .mapTo(Long.class)
                        .one()
        );
    }

    public long getMonthlyRevenue() {
        return DBConnect.get().withHandle(h ->
                h.createQuery("""
                    SELECT COALESCE(SUM(service_fee),0)
                    FROM platform_revenue
                    WHERE MONTH(created_at)=MONTH(CURRENT_DATE())
                    AND YEAR(created_at)=YEAR(CURRENT_DATE())
                """)
                        .mapTo(Long.class)
                        .one()
        );
    }

    public List<TutorPending> getPendingTutors() {
        List<TutorPending> list = DBConnect.get().withHandle(h ->
                h.createQuery("""
            SELECT
                t.id AS tutor_id,
                u.id AS user_id,
                u.fullname AS full_name,
                u.avatar_url AS avatar_url,
                t.teaching_subject AS teaching_subject,
                DATE_FORMAT(u.created_at, '%d/%m/%Y') AS applied_date
            FROM tutors t
            JOIN users u ON t.user_id = u.id
            WHERE t.verification_status = 'PENDING'
        """)
                        .mapToBean(TutorPending.class)
                        .list()
        );
        System.out.println("DEBUG - Pending tutors size: " + list.size());
        return list;
    }

    public int[] getUserGrowthByMonth() {
        List<Map<String, Object>> rows = DBConnect.get().withHandle(h ->
                h.createQuery("""
        SELECT MONTH(u.created_at) AS m, COUNT(*) AS total
        FROM users u
        JOIN user_roles ur ON u.id = ur.user_id
        WHERE YEAR(u.created_at) = (SELECT MAX(YEAR(created_at)) FROM users)
        AND u.is_active = 1
        GROUP BY MONTH(u.created_at)
        ORDER BY m
    """)
                        .mapToMap()
                        .list()
        );

        int[] data = new int[12];
        for (int i = 0; i < 12; i++) data[i] = 0;

        for (Map<String, Object> row : rows) {
            if (row.get("m") != null && row.get("total") != null) {
                int month = ((Number) row.get("m")).intValue();
                int total = ((Number) row.get("total")).intValue();
                if (month >= 1 && month <= 12) {
                    data[month - 1] = total;
                }
            }
        }
        return data;
    }

    public TutorProfile getTutorProfileById(long tutorId) {
        return DBConnect.get().withHandle(handle -> {
            // 1. ĐÃ CẬP NHẬT: Thêm chính xác cột t.teaching_grade vào câu SELECT SQL
            String sql = """
                SELECT t.id, u.fullname, t.gender, t.qualification, 
                       t.hourly_rate, t.teaching_subject, t.teaching_grade, t.teaching_area, 
                       t.birth_date, t.school, t.major 
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

            // 2. Lấy danh sách tài liệu hình ảnh liên quan
            List<Map<String, Object>> docs = handle.createQuery("""
                SELECT doc_type, file_url 
                FROM tutor_documents 
                WHERE tutor_id = :id
            """)
                    .bind("id", tutorId)
                    .mapToMap()
                    .list();

            // 3. Phân loại tài liệu hình ảnh
            List<String> degreeUrls = new ArrayList<>();
            List<String> idCardUrls = new ArrayList<>();
            String portraitUrl = null;

            for (Map<String, Object> doc : docs) {
                String type = (String) doc.get("doc_type");
                String url = (String) doc.get("file_url");
                if ("PORTRAIT".equals(type)) {
                    portraitUrl = url;
                } else if ("DEGREE".equals(type)) {
                    degreeUrls.add(url);
                } else if (type != null && type.contains("ID_CARD")) {
                    idCardUrls.add(url);
                }
            }

            // 4. Khởi tạo đối tượng TutorProfile khớp 100% với Constructor của bạn
            return new TutorProfile(
                    ((Number) data.get("id")).longValue(),
                    (String) data.get("fullname"),
                    (String) data.get("gender"),
                    (String) data.get("qualification"),

                    // minRate (hourly_rate từ DB)
                    data.get("hourly_rate") != null ? ((Number) data.get("hourly_rate")).intValue() : null,
                    null, // maxRate

                    (String) data.get("teaching_subject"),

                    // ĐÃ CẬP NHẬT: Đổ chuỗi lớp học đăng ký từ database thay vì để null như cũ
                    (String) data.get("teaching_grade"),

                    (String) data.get("teaching_area"), // Tạm gán vào provinceName để AreaLabel đọc
                    null, // districtName

                    portraitUrl,
                    degreeUrls,
                    idCardUrls,

                    // 3 trường bổ sung ở cuối Constructor
                    data.get("birth_date") != null ? data.get("birth_date").toString() : null,
                    (String) data.get("school"),
                    (String) data.get("major")
            );
        });
    }

    public boolean updateTutorStatus(long tutorId, String status) {
        return DBConnect.get().withHandle(h ->
                h.createUpdate("""
                UPDATE tutors 
                SET verification_status = :status 
                WHERE id = :tutorId
            """)
                        .bind("status", status)
                        .bind("tutorId", tutorId)
                        .execute() > 0
        );
    }

    public static String getVerificationStatus(long userId) {
        return DBConnect.get().withHandle(h ->
                h.createQuery("""
        SELECT verification_status
        FROM tutors
        WHERE user_id = :userId
        LIMIT 1
    """)
                        .bind("userId", userId)
                        .mapTo(String.class)
                        .findFirst()
                        .orElse(null)
        );
    }
    // Thêm hàm này vào AdminDAO.java để phục vụ riêng cho Gia sư tự sửa hồ sơ
    public TutorProfile getTutorProfileByUserId(long userId) {
        return DBConnect.get().withHandle(handle -> {
            String sql = """
            SELECT t.id, u.fullname, t.gender, t.qualification, 
                   t.hourly_rate, t.teaching_subject, t.teaching_grade, t.teaching_area, 
                   t.birth_date, t.school, t.major 
            FROM tutors t 
            JOIN users u ON t.user_id = u.id 
            WHERE t.user_id = :id -- SỬA Ở ĐÂY: Tìm theo user_id tài khoản
        """;

            Map<String, Object> data = handle.createQuery(sql)
                    .bind("id", userId)
                    .mapToMap()
                    .findOne()
                    .orElse(null);

            if (data == null) return null;

            // Giữ nguyên đoạn lấy docs và phân loại của hàm cũ...
            List<Map<String, Object>> docs = handle.createQuery("SELECT doc_type, file_url FROM tutor_documents WHERE tutor_id = :id")
                    .bind("id", ((Number) data.get("id")).longValue()).mapToMap().list();
            List<String> degreeUrls = new ArrayList<>(); List<String> idCardUrls = new ArrayList<>(); String portraitUrl = null;
            for (Map<String, Object> doc : docs) {
                String type = (String) doc.get("doc_type"); String url = (String) doc.get("file_url");
                if ("PORTRAIT".equals(type)) portraitUrl = url;
                else if ("DEGREE".equals(type)) degreeUrls.add(url);
                else if (type != null && type.contains("ID_CARD")) idCardUrls.add(url);
            }

            return new TutorProfile(
                    ((Number) data.get("id")).longValue(),
                    (String) data.get("fullname"), (String) data.get("gender"), (String) data.get("qualification"),
                    data.get("hourly_rate") != null ? ((Number) data.get("hourly_rate")).intValue() : null, null,
                    (String) data.get("teaching_subject"), (String) data.get("teaching_grade"), (String) data.get("teaching_area"), null,
                    portraitUrl, degreeUrls, idCardUrls,
                    data.get("birth_date") != null ? data.get("birth_date").toString() : null, (String) data.get("school"), (String) data.get("major")
            );
        });
    }


    public List<StudentSearchResult> getAllStudentsForAdmin() {
        return DBConnect.get().withHandle(h ->
                h.createQuery("""
                    SELECT 
                        u.id         AS id,
                        u.fullname   AS fullname,
                        u.email      AS email,
                        u.avatar_url AS avatarUrl,
                        DATE_FORMAT(u.created_at, '%d/%m/%Y %H:%i') AS createdAt,
                        u.is_active  AS isActive
                    FROM users u
                    JOIN user_roles ur ON u.id = ur.user_id
                    WHERE ur.role_id = 3
                    ORDER BY u.id DESC
                """)
                        .mapToBean(StudentSearchResult.class)
                        .list()
        );
    }

    /**
     * Hàm bổ sung: Lấy chi tiết 1 học viên duy nhất bằng ID phục vụ trang Detail
     */
    public StudentSearchResult getStudentByIdForAdmin(long studentId) {
        return DBConnect.get().withHandle(h ->
                h.createQuery("""
                SELECT 
                    u.id         AS id,
                    u.fullname   AS fullname,
                    u.email      AS email,
                    u.avatar_url AS avatarUrl,
                    u.phone      AS phone,
                    DATE_FORMAT(u.created_at, '%d/%m/%Y %H:%i') AS createdAt,
                    u.is_active  AS isActive
                FROM users u
                WHERE u.id = :id
            """)
                        .bind("id", studentId)
                        .mapToBean(StudentSearchResult.class)
                        .findOne()
                        .orElse(null)
        );
    }
}