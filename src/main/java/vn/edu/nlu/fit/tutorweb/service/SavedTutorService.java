package vn.edu.nlu.fit.tutorweb.service;

import vn.edu.nlu.fit.tutorweb.dao.SavedTutorDAO;
import vn.edu.nlu.fit.tutorweb.entity.TutorSearchResult;

import java.util.List;

public class SavedTutorService {
    private final SavedTutorDAO savedTutorDAO = new SavedTutorDAO();

    /**
     * Kiểm tra xem phụ huynh đã lưu gia sư này chưa
     */
    public boolean isSaved(long parentId, long tutorId) {
        if (parentId <= 0 || tutorId <= 0) return false;
        return savedTutorDAO.isSaved(parentId, tutorId);
    }

    /**
     * Xử lý Toggle (Nếu đã lưu thì xóa, nếu chưa lưu thì thêm)
     * @return "added" nếu thêm thành công, "removed" nếu xóa thành công, hoặc "error"
     */
    public String toggleSaveTutor(long parentId, long tutorId) {
        if (parentId <= 0 || tutorId <= 0) return "error";

        // Ngăn chặn trường hợp lỗi logic nếu trùng ID (ví dụ gia sư tự lưu chính mình nếu dùng chung bảng)
        // Bạn có thể thêm các điều kiện kiểm tra vai trò (Role) của user tại đây nếu cần

        if (savedTutorDAO.isSaved(parentId, tutorId)) {
            boolean removed = savedTutorDAO.removeSavedTutor(parentId, tutorId);
            return removed ? "removed" : "error";
        } else {
            boolean added = savedTutorDAO.addSavedTutor(parentId, tutorId);
            return added ? "added" : "error";
        }
    }

    public List<TutorSearchResult> getSavedTutorsByParentId(long parentId) {
        return savedTutorDAO.getSavedTutorsByParentId(parentId);
    }

    public List<Long> getSavedTutorIdsByParentId(Long id) {
        if (id == null) return new java.util.ArrayList<>();
        return savedTutorDAO.getSavedTutorIdsByParentId(id);
    }
}