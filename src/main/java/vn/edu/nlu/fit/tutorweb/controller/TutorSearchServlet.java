package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import vn.edu.nlu.fit.tutorweb.dao.TutorDAO;
import vn.edu.nlu.fit.tutorweb.entity.TutorSearchResult;

import java.io.IOException;
import java.util.List;

@WebServlet("/tutors/search")
public class TutorSearchServlet extends HttpServlet {

    private final TutorDAO tutorDAO = new TutorDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // ====== LẤY PARAM TỪ FORM BỘ LỌC ======

        String keyword   = req.getParameter("keyword");
        String subject   = req.getParameter("subject");
        String grade     = req.getParameter("grade");
        String district  = req.getParameter("district");

        String minRate   = req.getParameter("minRate");
        String maxRate   = req.getParameter("maxRate");

        String degree    = req.getParameter("degreeLevel");
        String schedule  = req.getParameter("schedule");

        String sortBy    = req.getParameter("sortBy");
        String gender    = req.getParameter("gender"); // <-- ĐÃ THÊM BIẾN LẤY GIỚI TÍNH

        // ====== XỬ LÝ DEGREE MẢNG ======

        String[] degreeLevels = null;

        if (degree != null && !degree.isBlank()) {
            degreeLevels = new String[]{degree};
        }

        // ====== XỬ LÝ SCHEDULE MẢNG ======

        String[] scheduleSlots = null;

        if (schedule != null && !schedule.isBlank()) {
            scheduleSlots = new String[]{schedule};
        }

        // ====== SEARCH (Đã chèn biến gender vào đúng vị trí sau biến grade) ======

        List<TutorSearchResult> tutors =
                tutorDAO.searchAndFilterTutorsAdvanced(
                        keyword,
                        minRate,
                        maxRate,
                        district,
                        subject,
                        grade,
                        gender, // <-- TRUYỀN THAM SỐ GENDER CHO KHỚP VỚI DAO
                        degreeLevels,
                        scheduleSlots,
                        sortBy
                );

        // ====== KẾT QUẢ DANH SÁCH ======

        req.setAttribute("tutors", tutors);

        // ====== GIỮ LẠI TRẠNG THÁI FILTER TRÊN GIAO DIỆN ======

        req.setAttribute("keyword", keyword);

        req.setAttribute("selectedSubject", subject);
        req.setAttribute("selectedGrade", grade);
        req.setAttribute("selectedDistrict", district);

        req.setAttribute("selectedDegree", degree);
        req.setAttribute("selectedSchedule", schedule);

        req.setAttribute("selectedMinRate", minRate);
        req.setAttribute("selectedMaxRate", maxRate);

        req.setAttribute("selectedSort", sortBy);
        req.setAttribute("selectedGender", gender); // <-- ĐẨY RA REQUEST ĐỂ FORM JSP KHÔNG BỊ RESET

        // ====== LOAD LẠI DỮ LIỆU Ô CHỌN DROPDOWN ======

        req.setAttribute("activeSubjects",
                tutorDAO.getAllDistinctSubjects());

        req.setAttribute("activeAreas",
                tutorDAO.getAllDistinctAreas());

        req.setAttribute("activeGrades",
                tutorDAO.getAllDistinctGrades());

        req.setAttribute("activeDegrees",
                tutorDAO.getAllDistinctDegrees());

        req.setAttribute("activeSchedules",
                tutorDAO.getAllTimeSlots());

        // ====== PAGE INFO ======

        req.setAttribute("pageTitle", "Danh sách gia sư");
        req.setAttribute("pageCss", "/assets/css/list-tutor.css");

        // ====== FORWARD SANG JSP ======

        req.getRequestDispatcher("/views/tutor/list-tutor.jsp")
                .forward(req, resp);
    }
}