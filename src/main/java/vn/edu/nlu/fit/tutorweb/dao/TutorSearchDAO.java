package vn.edu.nlu.fit.tutorweb.dao;

import vn.edu.nlu.fit.tutorweb.db.DBConnect;
import vn.edu.nlu.fit.tutorweb.entity.TutorProfile;
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
        sql.append("SELECT ")
                .append("u.id, u.full_name, t.gender, t.degree_level, t.min_rate, t.max_rate, ")
                .append("GROUP_CONCAT(DISTINCT s.name ORDER BY s.name SEPARATOR ', ') AS subjects, ")
                .append("GROUP_CONCAT(DISTINCT g.name ORDER BY g.name SEPARATOR ', ') AS grades, ")
                .append("p.name AS province_name, d.name AS district_name ")
                .append("FROM tutor_profiles t ")
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
                .append("WHERE u.role = 'TUTOR' AND u.status = 1 ");

        Map<String, Object> params = new HashMap<>();
        if (keyword != null) {
            sql.append("AND (u.full_name LIKE :kw OR t.bio LIKE :kw) ");
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
            sql.append("AND t.degree_level = :degreeLevel ");
            params.put("degreeLevel", degreeLevel);
        }
        if (teachingMode != null) {
            sql.append("AND (t.teaching_mode = :teachingMode OR t.teaching_mode = 'BOTH') ");
            params.put("teachingMode", teachingMode);
        }
        if (minRate != null) {
            sql.append("AND t.max_rate >= :minRate ");
            params.put("minRate", minRate);
        }
        if (maxRate != null) {
            sql.append("AND t.min_rate <= :maxRate ");
            params.put("maxRate", maxRate);
        }

        sql.append("GROUP BY u.id, u.full_name, t.gender, t.degree_level, t.min_rate, t.max_rate, p.name, d.name ");

        return DBConnect.get().withHandle(handle -> {
            var jdbiQuery = handle.createQuery(sql.toString());
            params.forEach(jdbiQuery::bind);
            return jdbiQuery.map((rs, ctx) -> new TutorProfile(
                    rs.getLong("id"),
                    rs.getString("full_name"),
                    rs.getString("gender"),
                    rs.getString("degree_level"),
                    rs.getObject("min_rate") == null ? null : rs.getInt("min_rate"),
                    rs.getObject("max_rate") == null ? null : rs.getInt("max_rate"),
                    rs.getString("subjects"),
                    rs.getString("grades"),
                    rs.getString("province_name"),
                    rs.getString("district_name")
            )).list();
        });
    }
}
