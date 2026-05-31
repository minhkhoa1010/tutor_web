package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.nlu.fit.tutorweb.service.TutorSearchService;

import java.io.IOException;

@WebServlet(name = "tutorSearchServlet", value = "/tutors/search")
public class TutorSearchServlet extends HttpServlet {
    private final TutorSearchService tutorSearchService = new TutorSearchService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("tutors", tutorSearchService.search(request));
        request.getRequestDispatcher("/views/tutor/list.jsp").forward(request, response);
    }
}
