package vn.edu.nlu.fit.tutorweb.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.nlu.fit.tutorweb.dao.AdminDAO;
import vn.edu.nlu.fit.tutorweb.db.DBConnect;
import vn.edu.nlu.fit.tutorweb.dto.StudentSearchResult;

import java.io.IOException;

@WebServlet(urlPatterns = {
        "/admin/student-detail",
        "/admin/toggle-student-status"
})
public class AdminStudentServlet extends HttpServlet {
    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        // Kiểm tra ID param bắt buộc cho tất cả các hành động chi tiết/khóa tài khoản
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/admin/students");
            return;
        }

        try {
            long studentId = Long.parseLong(idParam);

            switch (path) {
                case "/admin/student-detail" -> {
                    StudentSearchResult student = adminDAO.getStudentByIdForAdmin(studentId);
                    if (student != null) {
                        request.setAttribute("student", student);
                        request.getRequestDispatcher("/views/admin/student-detail-admin.jsp").forward(request, response);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/admin/students");
                    }
                }

                case "/admin/toggle-student-status" -> {
                    String action = request.getParameter("action");
                    if (action != null) {
                        // 1: Hoạt động (unlock), 0: Khóa (lock)
                        int newStatus = "unlock".equalsIgnoreCase(action) ? 1 : 0;

                        DBConnect.get().withHandle(handle ->
                                handle.createUpdate("UPDATE users SET is_active = :status WHERE id = :id")
                                        .bind("status", newStatus)
                                        .bind("id", studentId)
                                        .execute()
                        );
                    }
                    // Sau khi xử lý trạng thái xong, redirect ngược về Servlet danh sách của bạn
                    response.sendRedirect(request.getContextPath() + "/admin/students");
                }
            }
        } catch (NumberFormatException e) {
            // Ngăn chặn lỗi ép kiểu nếu idParam bị truyền lung tung (ví dụ: ?id=abc)
            response.sendRedirect(request.getContextPath() + "/admin/students");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}