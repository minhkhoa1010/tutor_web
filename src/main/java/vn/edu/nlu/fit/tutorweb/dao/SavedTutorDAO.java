package vn.edu.nlu.fit.tutorweb.dao;

import org.jdbi.v3.core.Jdbi;
import vn.edu.nlu.fit.tutorweb.db.DBConnect;
import vn.edu.nlu.fit.tutorweb.entity.TutorSearchResult;

import java.util.List;

public class SavedTutorDAO {
    private final Jdbi jdbi = DBConnect.get();

    // 1. Kiểm tra xem phụ huynh đã lưu gia sư này chưa
    public boolean isSaved(long parentId, long tutorId) {
        String sql = "SELECT COUNT(*) FROM saved_tutors WHERE parent_id = :parentId AND tutor_id = :tutorId";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("parentId", parentId)
                        .bind("tutorId", tutorId)
                        .mapTo(Long.class)
                        .one() > 0
        );
    }

    // 2. Thêm gia sư vào danh sách yêu thích
    public boolean addSavedTutor(long parentId, long tutorId) {
        String sql = "INSERT INTO saved_tutors (parent_id, tutor_id, saved_at) VALUES (:parentId, :tutorId, NOW())";
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("parentId", parentId)
                        .bind("tutorId", tutorId)
                        .execute() > 0
        );
    }

    // 3. Xóa gia sư khỏi danh sách yêu thích
    public boolean removeSavedTutor(long parentId, long tutorId) {
        String sql = "DELETE FROM saved_tutors WHERE parent_id = :parentId AND tutor_id = :tutorId";
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("parentId", parentId)
                        .bind("tutorId", tutorId)
                        .execute() > 0
        );
    }
    // 4. Lấy danh sách gia sư đã lưu của một phụ huynh
    public List<TutorSearchResult> getSavedTutorsByParentId(long parentId) {
        // ĐÃ SỬA: Đổi t.id AS id thành t.id AS tutorId để khớp chính xác với class TutorSearchResult
        String sql = "SELECT t.id AS tutorId, " +
                "u.fullname AS fullName, " +
                "u.avatar_url AS avatarUrl, " +
                "t.qualification AS qualification, " +
                "t.teaching_subject AS teachingSubject, " +
                "t.teaching_grade AS teachingGrade, " +
                "t.hourly_rate AS hourlyRate, " +
                "t.teaching_area AS teachingArea " +
                "FROM saved_tutors st " +
                "JOIN tutors t ON st.tutor_id = t.id " +
                "JOIN users u ON t.user_id = u.id " +
                "WHERE st.parent_id = :parentId " +
                "ORDER BY st.saved_at DESC"; // Gia sư nào mới lưu sẽ đẩy lên đầu

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("parentId", parentId)
                        .mapToBean(TutorSearchResult.class) // Tự động mapping các alias camelCase sang thuộc tính của DTO/Entity
                        .list()
        );
    }


    public List<Long> getSavedTutorIdsByParentId(long parentId) {
        String sql = "SELECT tutor_id FROM saved_tutors WHERE parent_id = :parentId";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("parentId", parentId)
                        .mapTo(Long.class) // Chỉ map riêng cột tutor_id thành kiểu Long
                        .list()
        );
    }
}