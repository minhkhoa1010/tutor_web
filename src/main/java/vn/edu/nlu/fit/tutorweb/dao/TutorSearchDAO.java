package vn.edu.nlu.fit.tutorweb.dao;

import vn.edu.nlu.fit.tutorweb.db.DBConnect;
import vn.edu.nlu.fit.tutorweb.dto.TutorProfile;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TutorSearchDAO {
    public List<TutorProfile> search(String keyword,
                                     Long subjectId,
                                     Long gradeId,
                                     Long provinceId,
                                     Long districtId,
                                     Long scheduleId,
                                     String gender,
                                     String degreeLevel,
                                     String teachingMode,
                                     Integer minRate,
                                     Integer maxRate) {
        StringBuilder sql = new StringBuilder();

        // 1. Đồng bộ lại các trường SELECT theo đúng cấu trúc bảng tutors mới
        sql.append("SELECT ")
                .append("t.id, u.fullname AS full_name, t.gender, t.qualification, t.hourly_rate, ")
                .append("t.teaching_subject, t.teaching_area, t.birth_date, t.school, t.major, ")
                // Giữ lại các trường GROUP_CONCAT nếu hệ thống của bạn có bảng liên kết tương ứng
                .append("GROUP_CONCAT(DISTINCT s.name ORDER BY s.name SEPARATOR ', ') AS subjects, ")
                .append("GROUP_CONCAT(DISTINCT g.name ORDER BY g.name SEPARATOR ', ') AS grades, ")
                .append("p.name AS province_name, d.name AS district_name ")
                .append("FROM tutors t ") // Chuyển từ tutor_profiles sang tutors
                .append("JOIN users u ON u.id = t.user_id ")
                .append("LEFT JOIN tutor_subjects ts ON ts.tutor_id = t.user_id ")
                .append("LEFT JOIN subjects s ON s.id = ts.subject_id ")
                .append("LEFT JOIN tutor_grades tg ON tg.tutor_id = t.user_id ")
                .append("LEFT JOIN grades g ON g.id = tg.grade_id ")
                .append("LEFT JOIN tutor_areas ta ON ta.tutor_id = t.user_id ")
                .append("LEFT JOIN districts d ON d.id = ta.district_id ")
                .append("LEFT JOIN provinces p ON p.id = d.province_id ")
                .append("LEFT JOIN tutor_schedules tsc ON tsc.tutor_id = t.user_id ")
                .append("LEFT JOIN schedule_slots ss ON ss.id = tsc.schedule_id ")
                .append("WHERE t.verification_status = 'APPROVED' AND u.is_active = 1 "); // Cập nhật điều kiện trạng thái của bạn

        Map<String, Object> params = new HashMap<>();
        if (keyword != null) {
            sql.append("AND (u.fullname LIKE :kw OR t.qualification LIKE :kw) ");
            params.put("kw", "%" + keyword + "%");
        }
        if (subjectId != null) {
            sql.append("AND ts.subject_id = :subjectId ");
            params.put("subjectId", subjectId);
        }
        if (gradeId != null) {
            sql.append("AND tg.grade_id = :gradeId ");
            params.put("gradeId", gradeId);
        }
        if (provinceId != null) {
            sql.append("AND p.id = :provinceId ");
            params.put("provinceId", provinceId);
        }
        if (districtId != null) {
            sql.append("AND d.id = :districtId ");
            params.put("districtId", districtId);
        }
        if (scheduleId != null) {
            sql.append("AND tsc.schedule_id = :scheduleId ");
            params.put("scheduleId", scheduleId);
        }
        if (gender != null) {
            sql.append("AND t.gender = :gender ");
            params.put("gender", gender);
        }
        if (degreeLevel != null) {
            sql.append("AND t.qualification = :degreeLevel "); // Hoặc cột tương đương trình độ của bạn
            params.put("degreeLevel", degreeLevel);
        }
        if (minRate != null) {
            sql.append("AND t.hourly_rate >= :minRate ");
            params.put("minRate", minRate);
        }
        if (maxRate != null) {
            sql.append("AND t.hourly_rate <= :maxRate ");
            params.put("maxRate", maxRate);
        }

        // Đảm bảo GROUP BY đầy đủ các cột đơn xuất hiện ở SELECT để tránh lỗi toán tử nghiêm ngặt SQL
        sql.append("GROUP BY t.id, u.fullname, t.gender, t.qualification, t.hourly_rate, ")
                .append("t.teaching_subject, t.teaching_area, t.birth_date, t.school, t.major, p.name, d.name ");

        return DBConnect.get().withHandle(handle -> {
            var jdbiQuery = handle.createQuery(sql.toString());
            params.forEach(jdbiQuery::bind);
            return jdbiQuery.map((rs, ctx) -> new TutorProfile(
                    rs.getLong("id"),
                    rs.getString("full_name"),
                    rs.getString("gender"),
                    rs.getString("qualification"),
                    rs.getObject("hourly_rate") != null ? rs.getInt("hourly_rate") : null, // minRate
                    null, // maxRate
                    rs.getString("teaching_subject"), // lấy dữ liệu thô hoặc rs.getString("subjects") tùy bạn logic
                    rs.getString("grades"), // Đổ dữ liệu chuỗi lớp học tìm kiếm được vào đây
                    rs.getString("teaching_area"), // provinceName
                    null, // districtName
                    null, // portraitUrl
                    null, // degreeUrls
                    null, // idCardUrls

                    // ==========================================================
                    // 3 THAM SỐ CUỐI ĐỂ KHỚP 100% VỚI CONSTRUCTOR TUTORPROFILE
                    // ==========================================================
                    rs.getDate("birth_date") != null ? rs.getDate("birth_date").toString() : null,
                    rs.getString("school"),
                    rs.getString("major")
            )).list();
        });
    }
}