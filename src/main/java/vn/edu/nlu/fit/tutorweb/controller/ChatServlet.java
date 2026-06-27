package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.nlu.fit.tutorweb.entity.UserSession;

import java.io.IOException;

@WebServlet("/chat")
public class ChatServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserSession user = session != null ? (UserSession) session.getAttribute("clientUser") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        req.setAttribute("initialBookingId", req.getParameter("bookingId"));
        req.setAttribute("initialTutorId", req.getParameter("tutorId"));
        req.getRequestDispatcher("/views/chat/chat.jsp").forward(req, resp);
    }
}
