package vn.edu.nlu.fit.tutorweb.dao;

import vn.edu.nlu.fit.tutorweb.db.DBConnect;
import vn.edu.nlu.fit.tutorweb.entity.Review;

import java.util.List;
import java.util.Map;

public class ReviewDAO {

    public Review findByBookingId(long bookingId) {
        return DBConnect.get().withHandle(h ->
                h.createQuery("""
                    SELECT id, booking_id AS bookingId, parent_id AS parentId,
                           tutor_id AS tutorId, rating, comment,
                           created_at AS createdAt
                    FROM reviews WHERE booking_id = :bookingId LIMIT 1
                """)
                        .bind("bookingId", bookingId)
                        .mapToBean(Review.class)
                        .findOne().orElse(null)
        );
    }

    public Long getCompletedBookingId(long parentId, long tutorId) {
        return DBConnect.get().withHandle(h ->
                h.createQuery("""
                    SELECT id FROM bookings
                    WHERE parent_id = :parentId AND tutor_id = :tutorId
                      AND status = 'COMPLETED'
                    ORDER BY id DESC LIMIT 1
                """)
                        .bind("parentId", parentId).bind("tutorId", tutorId)
                        .mapTo(Long.class).findOne().orElse(null)
        );
    }

    public boolean canReview(long parentId, long tutorId) {
        return getCompletedBookingId(parentId, tutorId) != null;
    }

    public boolean saveOrUpdateReview(long bookingId, int rating, String comment) {
        return DBConnect.get().withHandle(handle -> {
            Map<String, Object> info = handle.createQuery(
                            "SELECT parent_id, tutor_id FROM bookings WHERE id = :id")
                    .bind("id", bookingId).mapToMap().findOne().orElse(null);
            if (info == null) return false;

            long parentId = ((Number) info.get("parent_id")).longValue();
            long tutorId  = ((Number) info.get("tutor_id")).longValue();

            Long existing = handle.createQuery(
                            "SELECT id FROM reviews WHERE booking_id = :bid LIMIT 1")
                    .bind("bid", bookingId).mapTo(Long.class).findOne().orElse(null);

            int affected;
            if (existing == null) {
                affected = handle.createUpdate("""
                    INSERT INTO reviews(booking_id,parent_id,tutor_id,rating,comment,created_at)
                    VALUES(:bookingId,:parentId,:tutorId,:rating,:comment,NOW())
                """)
                        .bind("bookingId", bookingId).bind("parentId", parentId)
                        .bind("tutorId", tutorId).bind("rating", rating)
                        .bind("comment", comment).execute();
            } else {
                affected = handle.createUpdate("""
                    UPDATE reviews SET rating=:rating, comment=:comment, created_at=NOW()
                    WHERE booking_id=:bookingId
                """)
                        .bind("bookingId", bookingId).bind("rating", rating)
                        .bind("comment", comment).execute();
            }
            updateTutorAverageRating(tutorId);
            return affected > 0;
        });
    }

    public void updateTutorAverageRating(long tutorId) {
        DBConnect.get().useHandle(h -> h.createUpdate("""
                UPDATE tutors SET rating_average =
                (SELECT COALESCE(AVG(r.rating),0) FROM reviews r WHERE r.tutor_id=:id)
                WHERE id=:id
            """).bind("id", tutorId).execute());
    }

    public boolean isBookingOwner(long bookingId, long userId) {
        Long c = DBConnect.get().withHandle(h -> h.createQuery(
                        "SELECT COUNT(*) FROM bookings WHERE id=:bid AND parent_id=:uid")
                .bind("bid", bookingId).bind("uid", userId).mapTo(Long.class).one());
        return c != null && c > 0;
    }

    /**
     * Lấy reviews nổi bật cho trang chủ — rating >= 4, có comment, kèm tutorId để link.
     */
    public List<Review> getFeaturedReviews(int limit) {
        return DBConnect.get().withHandle(h ->
                h.createQuery("""
                    SELECT
                        r.id,
                        r.booking_id                           AS bookingId,
                        r.parent_id                            AS parentId,
                        r.tutor_id                             AS tutorId,
                        r.rating,
                        r.comment,
                        DATE_FORMAT(r.created_at,'%d/%m/%Y')  AS createdAt,
                        u.fullname                             AS studentName,
                        t.teaching_subject                     AS teachingSubject
                    FROM reviews r
                    JOIN bookings b ON r.booking_id = b.id
                    JOIN users    u ON r.parent_id  = u.id
                    JOIN tutors   t ON r.tutor_id   = t.id
                    WHERE r.rating >= 4
                      AND r.comment IS NOT NULL AND r.comment != ''
                    ORDER BY r.rating DESC, r.created_at DESC
                    LIMIT :limit
                """)
                        .bind("limit", limit)
                        .map((rs, ctx) -> {
                            Review rv = new Review();
                            rv.setId(rs.getLong("id"));
                            rv.setBookingId(rs.getLong("bookingId"));
                            rv.setParentId(rs.getLong("parentId"));
                            rv.setTutorId(rs.getLong("tutorId"));
                            rv.setRating(rs.getInt("rating"));
                            rv.setComment(rs.getString("comment"));
                            rv.setCreatedAt(rs.getString("createdAt"));
                            rv.setStudentName(rs.getString("studentName"));
                            rv.setTeachingSubject(rs.getString("teachingSubject"));
                            return rv;
                        })
                        .list()
        );
    }
}