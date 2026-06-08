package vn.edu.nlu.fit.tutorweb.controller; // Chỉnh lại package theo đúng project của bạn

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.nlu.fit.tutorweb.dao.AdminDAO;
import vn.edu.nlu.fit.tutorweb.dto.TutorPending;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();

    @Override

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. Đổi sang kiểu 'long' để hết sạch lỗi gạch đỏ ở IDE
        long tutors = adminDAO.countTutors();
        long students = adminDAO.countStudents();
        long pending = adminDAO.countPendingTutors();
        long revenue = adminDAO.getMonthlyRevenue(); // Hoặc giữ double tùy thuộc vào hàm trong DAO của bạn

        List<TutorPending> pendingTutors = adminDAO.getPendingTutors();

        // 2. Lấy dữ liệu mảng tăng trưởng (giữ nguyên int[] vì hàm trả về mảng số nguyên)
        int[] g = adminDAO.getUserGrowthByMonth();
        if (g == null || g.length < 12) {
            g = new int[]{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
        }

        String chartJson = String.format("[%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d]",
                g[0], g[1], g[2], g[3], g[4], g[5], g[6], g[7], g[8], g[9], g[10], g[11]);

        // 3. Đẩy dữ liệu sang JSP (Tên biến khớp 100% với dashboard.jsp)
        req.setAttribute("totalTutors", tutors);
        req.setAttribute("totalStudents", students);
        req.setAttribute("pendingCount", pending);
        req.setAttribute("monthlyRevenue", revenue);
        req.setAttribute("pendingTutors", pendingTutors);
        req.setAttribute("chartJson", chartJson);

        // 4. Forward sang trang giao diện
        req.getRequestDispatcher("/views/admin/dashboard.jsp").forward(req, resp);
    }
}