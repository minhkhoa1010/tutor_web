package vn.edu.nlu.fit.tutorweb.dao;

import vn.edu.nlu.fit.tutorweb.db.DBConnect;
import vn.edu.nlu.fit.tutorweb.entity.TutorSearchResult;
import java.util.List;

public class TutorDAO {


    public List<TutorSearchResult> getFeaturedTutors(int limit) {
        return DBConnect.get().withHandle(h ->
                h.createQuery("""
            SELECT 
                t.id AS tutorId,
                u.fullname AS fullName,
                u.avatar_url AS avatarUrl,
                t.qualification AS qualification,
                t.school AS school,
                t.major AS major,
                t.teaching_subject AS teachingSubject,
                t.teaching_grade AS teachingGrade,
                t.teaching_area AS teachingArea,
                t.experience_summary AS experienceSummary,
                t.hourly_rate AS hourlyRate,
                t.rating_average AS ratingAverage,
                -- 🌟 THÊM KHỐI NÀY: Gom nhóm toàn bộ khung giờ thành chuỗi text
                (SELECT GROUP_CONCAT(ts.slot_name SEPARATOR ', ') 
                 FROM tutor_schedules tsch
                 JOIN time_slots ts ON tsch.time_slot_id = ts.id
                 WHERE tsch.tutor_id = t.id) AS availableSchedules
            FROM tutors t
            JOIN users u ON t.user_id = u.id
            WHERE t.verification_status = 'APPROVED'
            LIMIT :limit
        """)
                        .bind("limit", limit)
                        .mapToBean(TutorSearchResult.class)
                        .list()
        );
    }

    public List<TutorSearchResult> getAllTutorsForAdmin() {
        return DBConnect.get().withHandle(h ->
                h.createQuery("""
        SELECT
            t.id            AS tutorId,
            u.fullname      AS fullName,
            u.avatar_url    AS avatarUrl,
            t.teaching_subject AS teachingSubject,
            t.teaching_grade   AS teachingGrade,
            t.teaching_area    AS teachingArea,
            t.hourly_rate      AS hourlyRate,
            t.rating_average   AS ratingAverage,
            t.qualification    AS qualification,
            t.verification_status AS verificationStatus,
            t.school           AS school,
            t.major            AS major,
            t.experience_summary AS experienceSummary
        FROM tutors t
        JOIN users u ON t.user_id = u.id
        ORDER BY t.id DESC
    """)
                        .mapToBean(TutorSearchResult.class)
                        .list()
        );
    }
}