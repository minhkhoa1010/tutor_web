package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.nlu.fit.tutorweb.dao.AdminDAO;
import vn.edu.nlu.fit.tutorweb.dto.StudentSearchResult;


import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/students")
public class AdminStudentListServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<StudentSearchResult> allStudents = adminDAO.getAllStudentsForAdmin();
        req.setAttribute("allStudents", allStudents);
        req.getRequestDispatcher("/views/admin/student-list.jsp").forward(req, resp);
    }
}