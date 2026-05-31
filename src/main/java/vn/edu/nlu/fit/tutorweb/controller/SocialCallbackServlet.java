package vn.edu.nlu.fit.tutorweb.controller;

import com.google.gson.JsonObject;
import vn.edu.nlu.fit.tutorweb.dao.UserAuthDAO;
import vn.edu.nlu.fit.tutorweb.entity.UserSession;
import vn.edu.nlu.fit.tutorweb.helper.SocialAuthHelper;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/oauth2-callback")
public class SocialCallbackServlet extends HttpServlet {
    private final UserAuthDAO authDAO = new UserAuthDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String provider = request.getParameter("provider");
        String code = request.getParameter("code");

        if (code == null || provider == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp?error=oauth_failed");
            return;
        }

        try {
            String socialId = "";
            String email = "";
            String fullname = "";
            String avatarUrl = request.getContextPath() + "/assets/images/default-avatar.png";

            if (provider.equalsIgnoreCase("google")) {
                JsonObject googleData = SocialAuthHelper.getGoogleUserInfo(code);
                socialId = googleData.get("id").getAsString();
                email = googleData.has("email") ? googleData.get("email").getAsString() : socialId + "@google.com";
                fullname = googleData.has("name") ? googleData.get("name").getAsString() : "Google User";
                if (googleData.has("picture")) avatarUrl = googleData.get("picture").getAsString();

            } else if (provider.equalsIgnoreCase("facebook")) {
                JsonObject fbData = SocialAuthHelper.getFacebookUserInfo(code);
                socialId = fbData.get("id").getAsString();
                email = fbData.has("email") ? fbData.get("email").getAsString() : socialId + "@facebook.com";
                fullname = fbData.has("name") ? fbData.get("name").getAsString() : "Facebook User";
                if (fbData.has("picture") && fbData.getAsJsonObject("picture").has("data")) {
                    avatarUrl = fbData.getAsJsonObject("picture").getAsJsonObject("data").get("url").getAsString();
                }
            }

            UserSession userSession = authDAO.loginOrRegisterSocial(provider, socialId, email, fullname, avatarUrl);

            if (userSession != null) {
                HttpSession session = request.getSession();
                session.setAttribute("clientUser", userSession);

                // Điều phối phân quyền actor
                if (userSession.hasRole("ADMIN")) {
                    response.sendRedirect(request.getContextPath() + "/views/admin/dashboard.jsp");
                } else if (userSession.hasRole("TUTOR")) {
                    response.sendRedirect(request.getContextPath() + "/views/tutor/list.jsp");
                } else {
                    response.sendRedirect(request.getContextPath() + "/index.jsp");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp?error=oauth_failed");
            }
        } catch (Exception e) {
            response.setContentType("text/plain;charset=UTF-8");

            e.printStackTrace();

            response.getWriter().println("ERROR:");
            e.printStackTrace(response.getWriter());

        }
    }
}