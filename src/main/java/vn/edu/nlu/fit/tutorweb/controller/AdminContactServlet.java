package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.nlu.fit.tutorweb.dao.ContactDAO;
import vn.edu.nlu.fit.tutorweb.entity.Contact;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/quan-ly-lien-he")
public class AdminContactServlet extends HttpServlet {
    private final ContactDAO contactDAO = new ContactDAO();

    // 1. Hiển thị danh sách liên hệ cho Admin
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Contact> contacts = contactDAO.getAllContacts();
        req.setAttribute("contacts", contacts);
        req.getRequestDispatcher("/views/admin/contact-management.jsp").forward(req, resp);
    }

    // 2. API cập nhật trạng thái khi Admin click nút phản hồi qua Gmail
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            long id = Long.parseLong(req.getParameter("id"));
            int isRead = Integer.parseInt(req.getParameter("isRead"));

            boolean success = contactDAO.updateContactStatus(id, isRead);

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            if (success) {
                resp.getWriter().write("{\"status\":\"success\"}");
            } else {
                resp.getWriter().write("{\"status\":\"fail\"}");
            }
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
}