package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.nlu.fit.tutorweb.dao.AdminDAO;
import vn.edu.nlu.fit.tutorweb.dao.BookingDAO;
import vn.edu.nlu.fit.tutorweb.entity.Booking;
import vn.edu.nlu.fit.tutorweb.dto.TutorProfile;
import vn.edu.nlu.fit.tutorweb.entity.UserSession;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/tutor/dashboard")
public class TutorDashboardServlet extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();
    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserSession user = (session != null) ? (UserSession) session.getAttribute("clientUser") : null;

        // Kiểm tra quyền hạn bảo mật
        if (user == null || !user.hasRole("TUTOR")) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 1. Tìm thông tin chi tiết Tutor dựa vào userId của tài khoản đang đăng nhập
        TutorProfile profile = adminDAO.getTutorProfileByUserId(user.getId());
        if (profile == null) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        long tutorId = profile.getId();

        // 2. Truy vấn dữ liệu từ cơ sở dữ liệu dựa trên tutorId thực tế
        int activeClasses = bookingDAO.countActiveBookingsByTutorId(tutorId);
        List<Booking> allTutorBookings = bookingDAO.getBookingsByTutorId(tutorId, 10);

        // Phân tách danh sách: Ca dạy chính thức và Thông báo ca dạy mới (Trạng thái PENDING)
        List<Booking> upcomingLessons = allTutorBookings.stream()
                .filter(b -> !"PENDING".equalsIgnoreCase(b.getStatus()))
                .collect(Collectors.toList());

        List<Booking> pendingLessons = allTutorBookings.stream()
                .filter(b -> "PENDING".equalsIgnoreCase(b.getStatus()))
                .collect(Collectors.toList());

        // 3. Đẩy dữ liệu ra thuộc tính Request scope để hiển thị
        req.setAttribute("activeClassesCount", activeClasses);
        req.setAttribute("totalBookingsCount", allTutorBookings.size());
        req.setAttribute("upcomingLessons", upcomingLessons);
        req.setAttribute("pendingLessons", pendingLessons);

        // Điều hướng sang trang hiển thị JSP
        req.getRequestDispatcher("/views/tutor/tutor-dashboard.jsp").forward(req, resp);
    }
}