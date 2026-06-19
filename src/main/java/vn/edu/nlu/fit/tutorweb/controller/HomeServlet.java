package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import vn.edu.nlu.fit.tutorweb.dao.AdminDAO;
import vn.edu.nlu.fit.tutorweb.dao.ReviewDAO;
import vn.edu.nlu.fit.tutorweb.dao.TutorDAO;
import vn.edu.nlu.fit.tutorweb.dto.SubjectCard;
import vn.edu.nlu.fit.tutorweb.entity.Review;
import vn.edu.nlu.fit.tutorweb.entity.TutorSearchResult;
import vn.edu.nlu.fit.tutorweb.entity.UserSession;
import vn.edu.nlu.fit.tutorweb.service.SavedTutorService; // Khai báo Import Service mới
import vn.edu.nlu.fit.tutorweb.utils.SubjectUtil;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    private final TutorDAO tutorDAO = new TutorDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();
    private final SavedTutorService savedTutorService = new SavedTutorService(); // Khởi tạo tầng Service xử lý Lưu gia sư

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // chống cache
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);

        HttpSession session = req.getSession();
        UserSession user = (UserSession) session.getAttribute("clientUser");

        // trạng thái xác thực gia sư
        if (user != null && user.hasRole("TUTOR")) {
            String status = AdminDAO.getVerificationStatus(user.getId());
            req.setAttribute("tutorStatus", status);
        }

        session.removeAttribute("pendingApproval");

        /*
         * ==========================
         * SEARCH FILTER DATA
         * ==========================
         */

        // Môn học
        req.setAttribute("activeSubjects",
                tutorDAO.getAllDistinctSubjects());

        // Khu vực
        req.setAttribute("activeAreas",
                tutorDAO.getAllDistinctAreas());

        // Lớp học
        req.setAttribute("activeGrades",
                tutorDAO.getAllDistinctGrades());

        // Trình độ
        req.setAttribute("activeDegrees",
                tutorDAO.getAllDistinctDegrees());

        // Khung giờ
        req.setAttribute("activeSchedules",
                tutorDAO.getAllTimeSlots());

        /*
         * ==========================
         * GIA SƯ TIÊU BIỂU
         * ==========================
         */
        List<TutorSearchResult> featuredTutors =
                tutorDAO.getFeaturedTutors(6);

        req.setAttribute("featuredTutors", featuredTutors);

        /*
         * ==========================
         * ĐỒNG BỘ TRẠNG THÁI BOOKMARK (NEW)
         * ==========================
         */
        List<Long> savedTutorIds = new ArrayList<>();
        if (user != null && user.hasRole("USER")) {
            try {
                // Lấy về danh sách các tutorId mà tài khoản phụ huynh này đã lưu
                savedTutorIds = savedTutorService.getSavedTutorIdsByParentId(user.getId());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        // Đẩy thẳng mảng ID sang index.jsp để thẻ JSTL so sánh bằng phương thức .contains()
        req.setAttribute("savedTutorIds", savedTutorIds);

        /*
         * ==========================
         * SUBJECT CARD
         * ==========================
         */
        List<String> subjects =
                tutorDAO.getAllDistinctSubjects();

        List<SubjectCard> subjectCards = subjects.stream()
                .map(subject -> new SubjectCard(
                        subject,
                        SubjectUtil.getIcon(subject),
                        SubjectUtil.getBgColor(subject)
                ))
                .toList();

        req.setAttribute("subjectCards", subjectCards);

        /*
         * ==========================
         * REVIEW NỔI BẬT
         * ==========================
         */
        List<Review> featuredReviews =
                reviewDAO.getFeaturedReviews(3);

        req.setAttribute("featuredReviews", featuredReviews);

        /*
         * ==========================
         * PAGE INFO
         * ==========================
         */
        req.setAttribute("pageCss", "/assets/css/home.css");
        req.setAttribute("pageTitle", "Trang chủ - Gia Sư Bá Đạo");

        System.out.println(
                "HOME SERVLET => Tutors: "
                        + featuredTutors.size()
                        + " | Subjects: "
                        + subjectCards.size()
                        + " | Reviews: "
                        + featuredReviews.size()
                        + " | SavedIds: "
                        + savedTutorIds.size()
        );

        req.getRequestDispatcher("/index.jsp")
                .forward(req, resp);
    }
}