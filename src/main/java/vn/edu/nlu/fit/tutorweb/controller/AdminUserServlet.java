package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.nlu.fit.tutorweb.dao.AdminDAO;
import vn.edu.nlu.fit.tutorweb.dto.AdminUserDTO;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {
        "/admin/users",
        "/admin/users/toggle"
})
public class AdminUserServlet extends HttpServlet {
    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<AdminUserDTO> users = adminDAO.getAllUsersForAdmin();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/views/admin/user-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        request.setCharacterEncoding("UTF-8");

        String idParam = request.getParameter("id");
        String action = request.getParameter("action");

        if (idParam == null || action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        try {
            long userId = Long.parseLong(idParam);

            if (userId == 1) {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=cannot-lock-admin");
                return;
            }

            boolean active = "unlock".equalsIgnoreCase(action);
            adminDAO.updateUserStatus(userId, active);

            response.sendRedirect(request.getContextPath() + "/admin/users?success=updated");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=invalid-id");
        }
    }
}
