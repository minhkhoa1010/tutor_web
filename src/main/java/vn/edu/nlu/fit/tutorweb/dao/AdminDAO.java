package vn.edu.nlu.fit.tutorweb.dao;

import vn.edu.nlu.fit.tutorweb.db.DBConnect;
import vn.edu.nlu.fit.tutorweb.dto.StudentSearchResult;
import vn.edu.nlu.fit.tutorweb.dto.TutorPending;
import vn.edu.nlu.fit.tutorweb.dto.TutorProfile;

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

            // 🌟 FIX LỖI: Khởi tạo khớp đúng chuẩn 16 tham số của Constructor hiện tại
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
                    data.get("birth_date") != null ? data.get("birth_date").toString() : null,
                    (String) data.get("school"),
                    (String) data.get("major")
            );

            // Set chính xác kinh nghiệm giảng dạy và lịch rảnh
            profile.setExperienceSummary((String) data.get("experience_summary"));
            profile.setAvailableSchedules((String) data.get("available_schedules"));

            return profile;
        });
    }

    public List<StudentSearchResult> getAllStudentsForAdmin() { return DBConnect.get().withHandle(h -> h.createQuery("SELECT u.id AS id, u.fullname AS fullname, u.email AS email, u.avatar_url AS avatarUrl, DATE_FORMAT(u.created_at, '%d/%m/%Y %H:%i') AS createdAt, u.is_active AS isActive FROM users u JOIN user_roles ur ON u.id = ur.user_id WHERE ur.role_id = 3 ORDER BY u.id DESC").mapToBean(StudentSearchResult.class).list()); }
    public StudentSearchResult getStudentByIdForAdmin(long studentId) { return DBConnect.get().withHandle(h -> h.createQuery("SELECT u.id AS id, u.fullname AS fullname, u.email AS email, u.avatar_url AS avatarUrl, u.phone AS phone, DATE_FORMAT(u.created_at, '%d/%m/%Y %H:%i') AS createdAt, u.is_active AS isActive FROM users u WHERE u.id = :id").bind("id", studentId).mapToBean(StudentSearchResult.class).findOne().orElse(null)); }
}