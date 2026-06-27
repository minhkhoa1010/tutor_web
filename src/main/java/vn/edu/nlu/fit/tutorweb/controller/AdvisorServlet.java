package vn.edu.nlu.fit.tutorweb.controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.nlu.fit.tutorweb.service.AdvisorService;

import java.io.IOException;
import java.util.Map;

@WebServlet("/ai-advisor")
public class AdvisorServlet extends HttpServlet {
    private final AdvisorService advisorService = new AdvisorService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/views/advisor/advisor.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");

        String message = req.getParameter("message");
        if (message == null || message.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write(gson.toJson(Map.of(
                    "success", false,
                    "reply", "Bạn hãy nhập câu hỏi hoặc nhu cầu học tập để AI Assistant hỗ trợ."
            )));
            return;
        }

        try {
            String reply = advisorService.answerAssistant(message.trim());
            resp.getWriter().write(gson.toJson(Map.of("success", true, "reply", reply)));
        } catch (Exception e) {
            resp.getWriter().write(gson.toJson(Map.of(
                    "success", false,
                    "reply", e.getMessage() == null ? "AI Assistant đang gặp lỗi. Vui lòng thử lại sau." : e.getMessage()
            )));
        }
    }
}
