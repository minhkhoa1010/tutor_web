package vn.edu.nlu.fit.tutorweb.controller;

import vn.edu.nlu.fit.tutorweb.dao.TutorDAO;
import vn.edu.nlu.fit.tutorweb.entity.TutorSearchResult;
import vn.edu.nlu.fit.tutorweb.entity.UserSession; // Import class UserSession của bạn

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/parent/hired")
public class ParentHiredServlet extends HttpServlet {
    private final TutorDAO tutorDAO = new TutorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserSession user = (UserSession) session.getAttribute("clientUser");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy danh sách
        List<TutorSearchResult> hiredTutors = tutorDAO.getHiredTutorsByParentId(user.getId());

        request.setAttribute("hiredTutors", hiredTutors);
        request.getRequestDispatcher("/views/parent/hired-tutors.jsp").forward(request, response);
    }
}