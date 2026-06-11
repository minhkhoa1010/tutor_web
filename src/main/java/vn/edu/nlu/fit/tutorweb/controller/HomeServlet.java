package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import vn.edu.nlu.fit.tutorweb.dao.AdminDAO;
import vn.edu.nlu.fit.tutorweb.dao.TutorDAO;
import vn.edu.nlu.fit.tutorweb.entity.UserSession;
import vn.edu.nlu.fit.tutorweb.entity.TutorSearchResult;

import java.io.IOException;
import java.util.List;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    private final TutorDAO tutorDAO = new TutorDAO();
    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // CHỐNG CACHE: Buộc trình duyệt luôn tải mới, không lưu giao diện cũ khi logout/đổi tài khoản
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
        resp.setHeader("Pragma", "no-cache"); // HTTP 1.0.
        resp.setDateHeader("Expires", 0); // Proxies.

        HttpSession session = req.getSession();
        UserSession user = (UserSession) session.getAttribute("clientUser");

        boolean pendingApproval = false;

        // Chỉ kiểm tra và bật thông báo khi ĐÃ ĐĂNG NHẬP và PHẢI LÀ TUTOR
        if (user != null && user.hasRole("TUTOR")) {
            String status = AdminDAO.getVerificationStatus(user.getId());
            pendingApproval = "PENDING".equalsIgnoreCase(status);
        }

        // Nếu đúng là đang chờ duyệt thì lưu vào session, ngược lại xóa thẳng tay khỏi session
        if (pendingApproval) {
            session.setAttribute("pendingApproval", true);
        } else {
            session.removeAttribute("pendingApproval");
        }

        // ĐỘNG HÓA: Lấy danh sách 4 gia sư tiêu biểu từ cơ sở dữ liệu
        List<TutorSearchResult> featuredTutors = tutorDAO.getFeaturedTutors(4);
        req.setAttribute("featuredTutors", featuredTutors);

        req.setAttribute("pageCss", "/assets/css/home.css");
        req.setAttribute("pageTitle", "Trang chủ - Gia Sư Bá Đạo");

        System.out.println("HOME SERVLET RUNNING - Featured Tutors Loaded: " + (featuredTutors != null ? featuredTutors.size() : 0));
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }
}