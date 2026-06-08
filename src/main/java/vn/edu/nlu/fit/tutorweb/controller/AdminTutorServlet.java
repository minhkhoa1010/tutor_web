package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.nlu.fit.tutorweb.dao.AdminDAO;
import vn.edu.nlu.fit.tutorweb.dto.TutorProfile;

import java.io.IOException;

@WebServlet(urlPatterns = {
        "/admin/tutor-detail",
        "/admin/approve-tutor",
        "/admin/reject-tutor"
})
public class AdminTutorServlet extends HttpServlet {
    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        String idParam = request.getParameter("id");

        if (idParam == null || idParam.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        long tutorId = Long.parseLong(idParam);

        switch (path) {
            case "/admin/tutor-detail" -> {
                TutorProfile tutor = adminDAO.getTutorProfileById(tutorId);
                if (tutor != null) {
                    request.setAttribute("tutor", tutor);
                    // SỬA Ở ĐÂY: Trỏ trực tiếp về file JSP giao diện của bạn
                    request.getRequestDispatcher("/views/admin/tutor-detail-admin.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                }
            }
            case "/admin/approve-tutor" -> {
                adminDAO.updateTutorStatus(tutorId, "APPROVED");
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            }
            case "/admin/reject-tutor" -> {
                adminDAO.updateTutorStatus(tutorId, "REJECTED");
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}