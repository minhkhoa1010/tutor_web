package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.nlu.fit.tutorweb.dao.AdminDAO;
import vn.edu.nlu.fit.tutorweb.dto.AdminBookingDTO;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {
        "/admin/bookings",
        "/admin/bookings/action"
})
public class AdminBookingServlet extends HttpServlet {
    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<AdminBookingDTO> bookings = adminDAO.getAllBookingsForAdmin();
        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("/views/admin/booking-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        request.setCharacterEncoding("UTF-8");

        String idParam = request.getParameter("id");
        String action = request.getParameter("action");

        if (idParam == null || idParam.isBlank() || action == null || action.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/admin/bookings?error=missing-data");
            return;
        }

        try {
            long bookingId = Long.parseLong(idParam);
            String newStatus;

            switch (action) {
                case "approve":
                    newStatus = "ACTIVE";
                    break;

                case "reject":
                    newStatus = "REJECTED";
                    break;

                case "cancel":
                    newStatus = "CANCELLED";
                    break;

                default:
                    response.sendRedirect(request.getContextPath() + "/admin/bookings?error=invalid-action");
                    return;
            }

            boolean updated = adminDAO.updateBookingStatusByAdmin(bookingId, newStatus);

            if (updated) {
                response.sendRedirect(request.getContextPath() + "/admin/bookings?success=updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/bookings?error=update-failed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/bookings?error=invalid-id");
        }
    }
}