package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.nlu.fit.tutorweb.entity.UserSession;
import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*"})
public class AdminSecurityFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        UserSession user = (session != null) ? (UserSession) session.getAttribute("clientUser") : null;

        if (user != null && user.hasRole("ADMIN")) {
            chain.doFilter(request, response);
        } else {
            resp.sendRedirect(req.getContextPath() + "/home");
        }
    }

}