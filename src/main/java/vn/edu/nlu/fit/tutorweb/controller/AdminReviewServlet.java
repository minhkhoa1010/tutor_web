package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.nlu.fit.tutorweb.dao.AdminDAO;
import vn.edu.nlu.fit.tutorweb.dto.AdminReviewDTO;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {
        "/admin/reviews",
        "/admin/reviews/action"
})
public class AdminReviewServlet extends HttpServlet {
    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<AdminReviewDTO> reviews = adminDAO.getAllReviewsForAdmin();

        request.setAttribute("reviews", reviews);
        request.getRequestDispatcher("/views/admin/review-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        request.setCharacterEncoding("UTF-8");

        String idParam = request.getParameter("id");
        String action = request.getParameter("action");

        if (idParam == null || idParam.isBlank() || action == null || action.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/admin/reviews?error=missing-data");
            return;
        }

        try {
            long reviewId = Long.parseLong(idParam);

            boolean success;

            switch (action) {
                case "hide":
                    success = adminDAO.updateReviewHiddenStatus(reviewId, true);
                    break;

                case "show":
                    success = adminDAO.updateReviewHiddenStatus(reviewId, false);
                    break;

                case "delete":
                    success = adminDAO.deleteReviewByAdmin(reviewId);
                    break;

                default:
                    response.sendRedirect(request.getContextPath() + "/admin/reviews?error=invalid-action");
                    return;
            }

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/reviews?success=updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/reviews?error=update-failed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/reviews?error=invalid-id");
        }
    }
}