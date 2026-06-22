package vn.edu.nlu.fit.tutorweb.controller;

import vn.edu.nlu.fit.tutorweb.db.ConfigProperties; // 1. ĐỔI IMPORT TỪ DBProperties SANG ConfigProperties
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/social-login")
public class SocialLoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String provider = request.getParameter("provider");

        if (provider == null || provider.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        String redirectUrl = "";
        try {
            if (provider.equalsIgnoreCase("google")) {
                // 2. ĐỔI THÀNH ConfigProperties.get()
                String clientId = ConfigProperties.get("google.client.id");
                String redirectUri = ConfigProperties.get("google.redirect.uri");

                if (clientId == null || redirectUri == null) {
                    throw new NullPointerException("Cấu hình google.client.id hoặc google.redirect.uri trong config.properties bị rỗng!");
                }

                redirectUrl = "https://accounts.google.com/o/oauth2/v2/auth?scope=email%20profile"
                        + "&redirect_uri=" + URLEncoder.encode(redirectUri, StandardCharsets.UTF_8)
                        + "&response_type=code&client_id=" + clientId;

            } else if (provider.equalsIgnoreCase("facebook")) {
                // 3. ĐỔI THÀNH ConfigProperties.get()
                String clientId = ConfigProperties.get("facebook.client.id");
                String redirectUri = ConfigProperties.get("facebook.redirect.uri");

                if (clientId == null || redirectUri == null) {
                    throw new NullPointerException("Cấu hình facebook.client.id hoặc facebook.redirect.uri trong config.properties bị rỗng!");
                }

                redirectUrl = "https://www.facebook.com/v19.0/dialog/oauth?client_id=" + clientId
                        + "&redirect_uri=" + URLEncoder.encode(redirectUri, StandardCharsets.UTF_8)
                        + "&scope=email,public_profile";
            }

            response.sendRedirect(redirectUrl);

        } catch (NullPointerException e) {
            e.printStackTrace();
            request.setAttribute("authError", "Hệ thống chưa cấu hình đầy đủ cổng đăng nhập mạng xã hội: " + e.getMessage());
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
        }
    }
}