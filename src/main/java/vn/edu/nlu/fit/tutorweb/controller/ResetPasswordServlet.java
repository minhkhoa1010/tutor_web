package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import vn.edu.nlu.fit.tutorweb.dao.UserAuthDAO;

import java.io.IOException;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    private final UserAuthDAO dao =
            new UserAuthDAO();

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        String token =
                req.getParameter("token");

        if(token == null || token.isBlank()){

            req.setAttribute(
                    "error",
                    "Liên kết không hợp lệ."
            );

            req.getRequestDispatcher(
                    "/views/auth/reset-password.jsp"
            ).forward(req, resp);

            return;
        }

        Long userId =
                dao.validateResetToken(token);

        if(userId == null){

            req.setAttribute(
                    "error",
                    "Liên kết đã hết hạn hoặc không tồn tại."
            );

            req.getRequestDispatcher(
                    "/views/auth/reset-password.jsp"
            ).forward(req, resp);

            return;
        }

        req.setAttribute(
                "token",
                token
        );

        req.getRequestDispatcher(
                "/views/auth/reset-password.jsp"
        ).forward(req, resp);
    }

    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        String token =
                req.getParameter("token");

        String password =
                req.getParameter("password");

        String confirmPassword =
                req.getParameter("confirmPassword");

        if(password == null ||
                password.length() < 6){

            req.setAttribute(
                    "error",
                    "Mật khẩu phải có ít nhất 6 ký tự."
            );

            req.setAttribute("token", token);

            req.getRequestDispatcher(
                    "/views/auth/reset-password.jsp"
            ).forward(req, resp);

            return;
        }

        if(!password.equals(confirmPassword)){

            req.setAttribute(
                    "error",
                    "Xác nhận mật khẩu không khớp."
            );

            req.setAttribute("token", token);

            req.getRequestDispatcher(
                    "/views/auth/reset-password.jsp"
            ).forward(req, resp);

            return;
        }

        Long userId =
                dao.validateResetToken(token);

        if(userId == null){

            req.setAttribute(
                    "error",
                    "Liên kết đã hết hạn."
            );

            req.getRequestDispatcher(
                    "/views/auth/reset-password.jsp"
            ).forward(req, resp);

            return;
        }

        dao.updatePasswordByUserId(
                userId,
                password
        );

        dao.markTokenUsed(token);

        req.getSession().setAttribute(
                "successMessage",
                "Đổi mật khẩu thành công. Vui lòng đăng nhập."
        );

        resp.sendRedirect(
                req.getContextPath()
                        + "/login"

        );
    }
}