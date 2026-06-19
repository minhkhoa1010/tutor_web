package vn.edu.nlu.fit.tutorweb.service;

import vn.edu.nlu.fit.tutorweb.dao.TutorDAO;
import vn.edu.nlu.fit.tutorweb.dto.TutorProfile;
import vn.edu.nlu.fit.tutorweb.entity.Review;
import vn.edu.nlu.fit.tutorweb.entity.TutorSearchResult;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.stream.Collectors;

public class TutorService {
    private final TutorDAO tutorDAO = new TutorDAO();

    // ==========================================
    // 1. PHỤC VỤ TRANG TUTOR DETAIL & TRANG CHỦ
    // ==========================================

    public TutorProfile getTutorProfile(long tutorId) {
        return TutorDAO.getTutorDetailForClient(tutorId);
    }

    public List<Review> getReviews(long tutorId) {
        return tutorDAO.getReviewsByTutorId(tutorId);
    }

    public List<TutorSearchResult> getFeaturedTutors(int limit) {
        return tutorDAO.getFeaturedTutors(limit);
    }

    // ==========================================
    // 2. PHỤC VỤ TRANG TÌM KIẾM (ADVANCED SEARCH)
    // ==========================================

    public List<TutorSearchResult> searchTutors(String keyword, String minRate, String maxRate,
                                                String district, String subject, String grade,
                                                String gender, String[] degrees, String[] slots, String sortBy) {
        return tutorDAO.searchAndFilterTutorsAdvanced(keyword, minRate, maxRate, district,
                subject, grade, gender, degrees, slots, sortBy);
    }

    public Map<String, List<String>> getSearchFilters() {
        Map<String, List<String>> filters = new HashMap<>();
        filters.put("subjects", tutorDAO.getAllDistinctSubjects());
        filters.put("areas", tutorDAO.getAllDistinctAreas());
        filters.put("grades", tutorDAO.getAllDistinctGrades());
        filters.put("degrees", tutorDAO.getAllDistinctDegrees());
        filters.put("slots", tutorDAO.getAllTimeSlots());
        return filters;
    }

    // ==========================================
    // 3. BỔ SUNG: PHỤC VỤ TÍNH NĂNG TUTOR SETTINGS
    // ==========================================

    /**
     * Lấy toàn bộ khung giờ hệ thống đang hỗ trợ
     */
    public List<String> getAllSlots() {
        return tutorDAO.getAllTimeSlots();
    }

    /**
     * Chuyển chuỗi Schedule từ DB (Dạng: "Sáng Thứ 2, Chiều Thứ 3") thành List<String> để tầng JSP so khớp checkbox
     */
    public List<String> getActiveSlotsForTutor(TutorProfile profile) {
        if (profile != null && profile.getAvailableSchedules() != null) {
            return Arrays.stream(profile.getAvailableSchedules().split(","))
                    .map(String::trim)
                    .collect(Collectors.toList());
        }
        return new ArrayList<>();
    }

    /**
     * Cập nhật thông tin hồ sơ năng lực
     */
    public void updateProfile(long tutorId, String school, String major, String experienceSummary) {
        tutorDAO.updateTutorProfile(tutorId, school, major, experienceSummary);
    }

    /**
     * Cập nhật thiết lập học phí (Có validation cơ bản)
     */
    public void updateTuition(long tutorId, int hourlyRate) {
        if (hourlyRate < 0) {
            throw new IllegalArgumentException("Học phí không được phép là số âm!");
        }
        tutorDAO.updateHourlyRate(tutorId, hourlyRate);
    }

    /**
     * Cập nhật danh sách lịch trống dạy
     */
    public void updateSchedule(long tutorId, String[] selectedSlots) {
        List<String> slotsList = selectedSlots != null ? Arrays.asList(selectedSlots) : new ArrayList<>();

        try {
            tutorDAO.updateTutorSchedules(tutorId, slotsList);
        } catch (RuntimeException e) {
            // Ném lại lỗi để Servlet biết đường xử lý
            throw e;
        }
    }
    public Long getTutorIdByUserId(long userId) {
        return tutorDAO.getTutorIdByUserId(userId);
    }
}