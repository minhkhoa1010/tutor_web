package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.nlu.fit.tutorweb.dao.UserAuthDAO;
import vn.edu.nlu.fit.tutorweb.entity.UserSession;

import java.io.IOException;

@WebServlet("/parent/change-password")
public class ChangePasswordServlet extends HttpServlet {
    private final UserAuthDAO authDAO = new UserAuthDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/parent/change-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserSession u = (UserSession) session.getAttribute("clientUser");

        if (u == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // 1. Kiểm tra xác nhận mật khẩu
        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("msgError", "Mật khẩu xác nhận không khớp!");
            response.sendRedirect(request.getContextPath() + "/parent/change-password");
            return;
        }

        // 2. Xác thực mật khẩu cũ (Sử dụng hàm loginWithCredentials có sẵn trong UserAuthDAO)
        // Chúng ta dùng email hoặc username của user đang đăng nhập để kiểm tra
        UserSession authCheck = authDAO.loginWithCredentials(u.getEmail(), oldPassword);

        if (authCheck == null) {
            session.setAttribute("msgError", "Mật khẩu hiện tại không đúng!");
            response.sendRedirect(request.getContextPath() + "/parent/change-password");
            return;
        }

        // 3. Thực hiện đổi mật khẩu
        boolean isSuccess = authDAO.updatePasswordByUserId(u.getId(), newPassword);

        if (isSuccess) {
            session.setAttribute("msgSuccess", "Đổi mật khẩu thành công!");
        } else {
            session.setAttribute("msgError", "Có lỗi xảy ra trong quá trình cập nhật!");
        }

        response.sendRedirect(request.getContextPath() + "/parent/change-password");
    }
}