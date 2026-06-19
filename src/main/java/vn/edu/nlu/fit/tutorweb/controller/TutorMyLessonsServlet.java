package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.nlu.fit.tutorweb.dao.AdminDAO;
import vn.edu.nlu.fit.tutorweb.dao.BookingDAO;
import vn.edu.nlu.fit.tutorweb.dto.TutorProfile;
import vn.edu.nlu.fit.tutorweb.entity.UserSession;
import vn.edu.nlu.fit.tutorweb.service.BookingService;
import java.io.IOException;

@WebServlet("/tutor/my-lessons")
@MultipartConfig( // <--- BẮT BUỘC PHẢI THÊM ANNOTATION NÀY
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class TutorMyLessonsServlet extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();
    private final AdminDAO adminDAO = new AdminDAO();
    private final BookingService bookingService = new BookingService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        UserSession user = session != null ? (UserSession) session.getAttribute("clientUser") : null;

        if (user == null || !user.hasRole("TUTOR")) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        TutorProfile profile = adminDAO.getTutorProfileByUserId(user.getId());
        if (profile == null) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        req.setAttribute("lessons", bookingDAO.getBookingsByTutorId(profile.getId(), 100));
        req.setAttribute("tutorId", profile.getId());
        req.getRequestDispatcher("/views/tutor/my-lessons.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        UserSession user = session != null ? (UserSession) session.getAttribute("clientUser") : null;

        if (user == null || !user.hasRole("TUTOR")) {
            // Nếu là request AJAX khiếu nại thì trả về JSON lỗi, ngược lại redirect về login
            if ("DISPUTE".equals(req.getParameter("action"))) {
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.getWriter().write("{\"status\":\"ERROR\",\"message\":\"Hết phiên đăng nhập. Vui lòng thử lại.\"}");
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        String bookingIdStr = req.getParameter("bookingId");

        // ==========================================
        // TRƯỜNG HỢP 1: XỬ LÝ KHIẾU NẠI (GỬI QUA AJAX FETCH -> TRẢ VỀ JSON)
        // ==========================================
        if ("DISPUTE".equals(action) && bookingIdStr != null) {
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");

            try {
                long bookingId = Long.parseLong(bookingIdStr);
                String reason = req.getParameter("reason");
                Part filePart = req.getPart("evidenceFile"); // Lấy file chứng cứ nếu phụ huynh/gia sư tải lên

                // TODO: Gọi Service xử lý khiếu nại
                boolean ok = bookingService.handleTutorDispute(bookingId, reason, filePart);

                if (ok) {
                    resp.getWriter().write("{\"status\":\"SUCCESS\"}");
                } else {
                    resp.getWriter().write("{\"status\":\"ERROR\",\"message\":\"Không thể cập nhật trạng thái khiếu nại.\"}");
                }
            } catch (Exception e) {
                e.printStackTrace();
                resp.getWriter().write("{\"status\":\"ERROR\",\"message\":\"Lỗi hệ thống: " + e.getMessage() + "\"}");
            }
            return; // BẮT BUỘC RETURN: Không để chạy xuống dòng sendRedirect ở dưới!
        }

        // ==========================================
        // TRƯỜNG HỢP 2: YÊU CẦU HOÀN THÀNH (GỬI QUA FORM TRUYỀN THỐNG -> REDIRECT)
        // ==========================================
        if ("request-complete".equals(action) && bookingIdStr != null) {
            try {
                long bookingId = Long.parseLong(bookingIdStr);
                boolean ok = bookingService.handleRequestCompleteBooking(bookingId);
                if (ok) {
                    session.setAttribute("msgSuccess", "Đã gửi yêu cầu hoàn thành lớp học tới phụ huynh thành công!");
                } else {
                    session.setAttribute("msgError", "Không thể gửi yêu cầu hoàn thành. Vui lòng thử lại.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("msgError", "Dữ liệu mã lớp học không hợp lệ.");
            }
            resp.sendRedirect(req.getContextPath() + "/tutor/my-lessons");
            return;
        }

        // Mặc định nếu không khớp action nào
        resp.sendRedirect(req.getContextPath() + "/tutor/my-lessons");
    }
}