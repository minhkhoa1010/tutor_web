package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.nlu.fit.tutorweb.dao.UserAuthDAO;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserAuthDAO authDAO = new UserAuthDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!password.equals(confirmPassword)) {
            request.setAttribute("authError",
                    "Mật khẩu xác nhận không khớp");

            request.getRequestDispatcher(
                            "/views/auth/register.jsp")
                    .forward(request, response);
            return;
        }

        boolean success = authDAO.register(
                email,
                phone,
                fullname,
                password
        );

        if (success) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/views/auth/login.jsp?register=success"
            );
        } else {
            request.setAttribute("authError",
                    "Email hoặc SĐT đã tồn tại");

            request.getRequestDispatcher(
                            "/views/auth/register.jsp")
                    .forward(request, response);
        }
    }
}