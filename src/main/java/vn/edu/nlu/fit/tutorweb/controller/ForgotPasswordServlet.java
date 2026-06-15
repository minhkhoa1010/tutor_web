package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import vn.edu.nlu.fit.tutorweb.dao.UserAuthDAO;

import java.io.IOException;
import java.util.UUID;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private final UserAuthDAO dao = new UserAuthDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher(
                "/views/auth/forgot-password.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");

        if(email == null || email.trim().isEmpty()){

            req.setAttribute(
                    "error",
                    "Vui lòng nhập email."
            );

            doGet(req, resp);
            return;
        }

        Long userId =
                dao.findUserIdByEmail(email.trim());

        if (userId == null) {

            req.setAttribute(
                    "error",
                    "Email không tồn tại trong hệ thống."
            );

            doGet(req, resp);
            return;
        }

        String token =
                UUID.randomUUID().toString();

        dao.createResetToken(
                userId,
                token
        );

        String resetLink =
                req.getScheme()
                        + "://"
                        + req.getServerName()
                        + ":"
                        + req.getServerPort()
                        + req.getContextPath()
                        + "/reset-password?token="
                        + token;

        System.out.println("================================");
        System.out.println("RESET PASSWORD LINK:");
        System.out.println(resetLink);
        System.out.println("================================");

        req.setAttribute(
                "success",
                "Liên kết đặt lại mật khẩu đã được tạo."
        );

        req.setAttribute(
                "resetLink",
                resetLink
        );

        doGet(req, resp);
    }
}