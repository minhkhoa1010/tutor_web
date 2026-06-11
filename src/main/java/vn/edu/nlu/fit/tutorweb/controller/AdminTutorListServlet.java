package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.nlu.fit.tutorweb.dao.TutorDAO;
import vn.edu.nlu.fit.tutorweb.entity.TutorSearchResult;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/tutors")
public class AdminTutorListServlet extends HttpServlet {

    private final TutorDAO tutorDAO = new TutorDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Lấy toàn bộ danh sách gia sư
        List<TutorSearchResult> allTutors = tutorDAO.getAllTutorsForAdmin();

        // Đẩy dữ liệu sang tầng hiển thị JSP
        req.setAttribute("allTutors", allTutors);

        // Hướng file sang trang quản lý danh sách gia sư
        req.getRequestDispatcher("/views/admin/tutor-list.jsp").forward(req, resp);
    }
}