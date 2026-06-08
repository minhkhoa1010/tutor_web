package vn.edu.nlu.fit.tutorweb.dao;

import vn.edu.nlu.fit.tutorweb.db.DBConnect;
import vn.edu.nlu.fit.tutorweb.entity.TutorSearchResult;

import java.util.List;

public class TutorDAO {

    public List<TutorSearchResult> getFeaturedTutors(int limit) {
        return DBConnect.get().withHandle(h ->
                h.createQuery("""
            SELECT
                t.id            AS tutorId,
                u.fullname      AS fullName,
                u.avatar_url    AS avatarUrl,
                t.teaching_subject AS teachingSubject,
                t.teaching_area    AS teachingArea,
                t.hourly_rate      AS hourlyRate,
                t.rating_average   AS ratingAverage,
                t.qualification    AS qualification
            FROM tutors t
            JOIN users u ON t.user_id = u.id
            WHERE t.verification_status = 'APPROVED'
            ORDER BY t.rating_average DESC, t.is_featured DESC
            LIMIT :limit
        """)
                        .bind("limit", limit)
                        .mapToBean(TutorSearchResult.class)
                        .list()
        );
    }
}
