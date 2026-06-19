package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.nlu.fit.tutorweb.dao.ContactDAO;
import vn.edu.nlu.fit.tutorweb.entity.Contact;

import java.io.IOException;

@WebServlet(urlPatterns = {"/lien-he", "/submit-contact"})
public class ContactServlet extends HttpServlet {
    private final ContactDAO contactDAO = new ContactDAO();

    // 1. Hiển thị giao diện trang liên hệ
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/views/pages/contact.jsp").forward(req, resp);
    }

    // 2. Tiếp nhận và xử lý dữ liệu form gửi lên
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String message = req.getParameter("message");

        String subject = "Yêu cầu hỗ trợ hệ thống";

        Contact contact = new Contact(fullName, email, phone, subject, message);
        boolean success = contactDAO.insertContact(contact);

        if (success) {
            req.setAttribute("status", "success");
            req.setAttribute("toastMessage", "Gửi yêu cầu thành công! Chúng tôi sẽ phản hồi sớm.");
        } else {
            req.setAttribute("status", "fail");
            req.setAttribute("toastMessage", "Có lỗi xảy ra. Vui lòng kiểm tra lại hệ thống!");
        }

        // ĐÃ FIX: Chuyển đổi 'req.servletResponse()' thành 'resp' để hết bị gạch lỗi compile
        req.getRequestDispatcher("/views/pages/contact.jsp").forward(req, resp);
    }
}