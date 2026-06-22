package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.nlu.fit.tutorweb.dao.AdminDAO;
import vn.edu.nlu.fit.tutorweb.entity.UserSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/complaints")
public class AdminComplaintsServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();

        String action = req.getParameter("action");
        String bookingIdParam = req.getParameter("bookingId");

        if (action != null && bookingIdParam != null) {
            try {
                int bookingId = Integer.parseInt(bookingIdParam);
                switch (action) {
                    case "accept":
                        adminDAO.acceptComplaint(bookingId);
                        session.setAttribute("msgSuccess", "Đã chấp nhận đơn khiếu nại #BK-" + bookingId + " và hoàn tiền thành công!");
                        break;
                    case "reject":
                        adminDAO.rejectComplaint(bookingId);
                        session.setAttribute("msgSuccess", "Đã bác bỏ đơn khiếu nại #BK-" + bookingId + " thành công!");
                        break;
                }
            } catch (NumberFormatException e) {
                session.setAttribute("msgError", "Mã lớp học (Booking ID) không đúng định dạng.");
                e.printStackTrace();
            } catch (Exception e) {
                // THÊM VÀO ĐÂY: Bắt các lỗi hệ thống/SQL phát sinh từ DAO
                session.setAttribute("msgError", "Xử lý thất bại! Đã xảy ra lỗi hệ thống hoặc lỗi kết nối cơ sở dữ liệu.");
                e.printStackTrace();
            }

            resp.sendRedirect(req.getContextPath() + "/admin/complaints");
            return;
        }

        List<Map<String, Object>> complaints = adminDAO.getAllComplaints();
        req.setAttribute("complaints", complaints);
        req.getRequestDispatcher("/views/admin/complaints.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}