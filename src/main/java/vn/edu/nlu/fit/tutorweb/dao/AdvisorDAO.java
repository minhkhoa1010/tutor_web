package vn.edu.nlu.fit.tutorweb.dao;

import org.jdbi.v3.core.Jdbi;
import vn.edu.nlu.fit.tutorweb.db.DBConnect;
import vn.edu.nlu.fit.tutorweb.dto.AdvisorTutorDTO;

import java.util.Arrays;
import java.util.List;

public class AdvisorDAO {
    private final Jdbi jdbi = DBConnect.get();

    public List<AdvisorTutorDTO> findApprovedTutorsForAssistant(int limit) {
        return jdbi.withHandle(handle -> handle.createQuery("""
                SELECT
                    t.id AS id,
                    u.fullname AS name,
                    t.teaching_subject AS subjects,
                    t.teaching_grade AS grades,
                    t.experience_summary AS experience,
                    t.hourly_rate AS hourlyRate,
                    t.rating_average AS rating,
                    t.teaching_area AS location,
                    'NOT_SPECIFIED' AS teachingMode,
                    (
                        SELECT GROUP_CONCAT(ts.slot_name SEPARATOR ', ')
                        FROM tutor_schedules tsch
                        JOIN time_slots ts ON tsch.time_slot_id = ts.id
                        WHERE tsch.tutor_id = t.id
                    ) AS availableSchedulesText
                FROM tutors t
                JOIN users u ON t.user_id = u.id
                WHERE t.verification_status = 'APPROVED'
                ORDER BY
                    CASE WHEN t.rating_average IS NULL THEN 0 ELSE t.rating_average END DESC,
                    t.hourly_rate ASC,
                    t.id DESC
                LIMIT :limit
            """)
                .bind("limit", limit)
                .map((rs, ctx) -> {
                    AdvisorTutorDTO tutor = new AdvisorTutorDTO();
                    tutor.setId(rs.getLong("id"));
                    tutor.setName(rs.getString("name"));
                    tutor.setSubjects(rs.getString("subjects"));
                    tutor.setGrades(rs.getString("grades"));
                    tutor.setExperience(rs.getString("experience"));
                    tutor.setHourlyRate(rs.getObject("hourlyRate") != null ? rs.getInt("hourlyRate") : 0);
                    tutor.setRating(rs.getObject("rating") != null ? rs.getDouble("rating") : 0);
                    tutor.setLocation(rs.getString("location"));
                    tutor.setTeachingMode(rs.getString("teachingMode"));
                    tutor.setAvailableSchedules(splitSchedules(rs.getString("availableSchedulesText")));
                    return tutor;
                })
                .list());
    }

    private List<String> splitSchedules(String schedules) {
        if (schedules == null || schedules.isBlank()) {
            return List.of();
        }
        return Arrays.stream(schedules.split(","))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .toList();
    }
}
