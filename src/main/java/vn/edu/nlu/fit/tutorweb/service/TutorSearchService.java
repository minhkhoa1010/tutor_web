package vn.edu.nlu.fit.tutorweb.service;

import jakarta.servlet.http.HttpServletRequest;
import vn.edu.nlu.fit.tutorweb.dao.TutorSearchDAO;

import vn.edu.nlu.fit.tutorweb.entity.TutorProfile;

import java.util.List;

public class TutorSearchService {
    private final TutorSearchDAO tutorSearchDao = new TutorSearchDAO();

    public List<TutorProfile> search(HttpServletRequest request) {
        String keyword = trimToNull(request.getParameter("keyword"));
        Long subjectId = parseLong(request.getParameter("subjectId"));
        Long gradeId = parseLong(request.getParameter("gradeId"));
        Long provinceId = parseLong(request.getParameter("provinceId"));
        Long districtId = parseLong(request.getParameter("districtId"));
        Long scheduleId = parseLong(request.getParameter("scheduleId"));
        String gender = trimToNull(request.getParameter("gender"));
        String degreeLevel = trimToNull(request.getParameter("degreeLevel"));
        String teachingMode = trimToNull(request.getParameter("teachingMode"));
        Integer minRate = parseInt(request.getParameter("minRate"));
        Integer maxRate = parseInt(request.getParameter("maxRate"));

        return tutorSearchDao.search(keyword, subjectId, gradeId, provinceId, districtId,
                scheduleId, gender, degreeLevel, teachingMode, minRate, maxRate);
    }

    private String trimToNull(String value) {
        if (value == null) return null;
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private Long parseLong(String value) {
        try {
            if (value == null || value.isBlank()) return null;
            return Long.parseLong(value.trim());
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    private Integer parseInt(String value) {
        try {
            if (value == null || value.isBlank()) return null;
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException ex) {
            return null;
        }
    }
}
