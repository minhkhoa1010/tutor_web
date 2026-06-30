package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.nlu.fit.tutorweb.dao.AdminDAO;
import vn.edu.nlu.fit.tutorweb.db.DBConnect; // Đảm bảo import đúng lớp DBConnect của bạn
import vn.edu.nlu.fit.tutorweb.dto.TutorProfile;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {
        "/admin/tutor-detail",
        "/admin/approve-tutor",
        "/admin/reject-tutor",
        "/admin/toggle-tutor-status"
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
            // khóa/mở khóa tutor
            case "/admin/toggle-tutor-status" -> {
                String action = request.getParameter("action");

                if (action != null) {
                    int newStatus = "unlock".equalsIgnoreCase(action) ? 1 : 0;

                    DBConnect.get().withHandle(handle ->
                            handle.createUpdate("""
                        UPDATE users u
                        JOIN tutors t ON t.user_id = u.id
                        SET u.is_active = :status
                        WHERE t.id = :tutorId
                        """)
                                    .bind("status", newStatus)
                                    .bind("tutorId", tutorId)
                                    .execute()
                    );
                }

                response.sendRedirect(request.getContextPath() + "/admin/tutors");
            }


            case "/admin/tutor-detail" -> {
                TutorProfile tutor = adminDAO.getTutorProfileById(tutorId);
                if (tutor != null) {

                    // FIX LỖI: Truy vấn trực tiếp danh sách khung giờ từ Database dựa theo tutorId
                    // Nếu DB của bạn bảng 'time_slots' có cột tên khung giờ (ví dụ: name, slot_name, hoặc slot_code), hãy JOIN để lấy chuỗi chữ hiển thị.
                    // Ở đây mình lấy ra chuỗi hiển thị tương ứng từ id trong bảng trung gian.
                    List<String> scheduleList = DBConnect.get().withHandle(h ->
                            h.createQuery("""
                            SELECT ts.slot_name 
                            FROM tutor_schedules tsch
                            JOIN time_slots ts ON tsch.time_slot_id = ts.id
                            WHERE tsch.tutor_id = :tutorId
                        """)
                                    .bind("tutorId", tutorId)
                                    .mapTo(String.class)
                                    .list()
                    );

                    // Đẩy danh sách chuỗi lịch rảnh này sang phía JSP
                    request.setAttribute("tutor", tutor);
                    request.setAttribute("scheduleList", scheduleList);

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