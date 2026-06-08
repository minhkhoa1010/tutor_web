package vn.edu.nlu.fit.tutorweb.controller;

import vn.edu.nlu.fit.tutorweb.dao.UserAuthDAO;
import vn.edu.nlu.fit.tutorweb.dao.AdminDAO;
import vn.edu.nlu.fit.tutorweb.entity.UserSession;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/auth")
public class TutorAuthServlet extends HttpServlet {

    private final UserAuthDAO authDAO = new UserAuthDAO();
    private final AdminDAO    adminDAO = new AdminDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("login".equals(action)) {
            String identifier = request.getParameter("identifier");
            String password   = request.getParameter("password");

            UserSession userSession = authDAO.loginWithCredentials(identifier, password);

            if (userSession != null) {
                HttpSession session = request.getSession();
                session.setAttribute("clientUser", userSession);
                redirectUserByRole(userSession, request, response);
            } else {
                request.setAttribute("authError", "Tài khoản hoặc mật khẩu không chính xác.");
                request.getRequestDispatcher("/views/auth/login.jsp")
                        .forward(request, response);
            }
        }
    }
    private void redirectUserByRole(UserSession user,
                                    HttpServletRequest request,
                                    HttpServletResponse response) throws IOException {
        if (user.hasRole("ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
        else if (user.hasRole("TUTOR")) {
            String status = adminDAO.getVerificationStatus(user.getId());
            HttpSession session = request.getSession();

            if ("APPROVED".equals(status)) {
                response.sendRedirect(request.getContextPath() + "/tutor/dashboard");
            }
            else if ("PENDING".equals(status)) {
                // Trường hợp hồ sơ đang chờ duyệt
                session.setAttribute("tutorStatus", "PENDING");
                response.sendRedirect(request.getContextPath() + "/home");
            }
            else if ("REJECTED".equals(status)) {
                // Trường hợp bị từ chối hồ sơ
                session.setAttribute("tutorStatus", "REJECTED");
                // Bạn có thể đá về trang home kèm thông báo, hoặc đá thẳng về trang cập nhật lại hồ sơ
                response.sendRedirect(request.getContextPath() + "/home");
            }
        }
        else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}