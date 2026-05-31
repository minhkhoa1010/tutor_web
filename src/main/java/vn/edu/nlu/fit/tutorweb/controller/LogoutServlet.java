package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/logout") // Độc lập đón đường dẫn đăng xuất
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy session hiện tại, không tự động tạo mới nếu không tồn tại
        HttpSession session = request.getSession(false);

        if (session != null) {
            session.removeAttribute("clientUser"); // Xóa dữ liệu định danh
            session.invalidate();                 // Hủy bỏ hoàn toàn phiên làm việc trên Tomcat
        }

        // Điều hướng mượt mà về thẳng trang chủ sau khi dọn dẹp xong dữ liệu
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}