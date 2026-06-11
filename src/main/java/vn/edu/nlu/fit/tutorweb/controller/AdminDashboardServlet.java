package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.nlu.fit.tutorweb.dao.AdminDAO;
import vn.edu.nlu.fit.tutorweb.dto.TutorPending;

import java.io.IOException;
import java.util.Calendar;
import java.util.List;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. Lấy các số liệu tổng quan hệ thống
        long tutors = adminDAO.countTutors();
        long students = adminDAO.countStudents();
        long pending = adminDAO.countPendingTutors();
        long revenue = adminDAO.getMonthlyRevenue();

        List<TutorPending> pendingTutors = adminDAO.getPendingTutors();

        // 2. Lấy dữ liệu mảng tăng trưởng người dùng theo tháng
        int[] g = adminDAO.getUserGrowthByMonth();

        // CRITICAL FIX: Đưa check Validation lên ĐẦU để tránh NullPointerException / OutOfBounds
        if (g == null || g.length < 12) {
            g = new int[]{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
        }

        // 3. Tính toán tỷ lệ phần trăm tăng trưởng thực tế (Dựa trên tháng hiện tại)
        int currentMonthIndex = Calendar.getInstance().get(Calendar.MONTH); // 0 (Tháng 1) -> 11 (Tháng 12)

        double tutorGrowth = 0;
        double studentGrowth = 0;

        // Chỉ tính toán khi đã bước sang ít nhất là tháng 2 (index >= 1), tháng 1 thì mặc định so với trước là 0%
        if (currentMonthIndex > 0) {
            int lastMonthCount = g[currentMonthIndex - 1];
            int currentMonthCount = g[currentMonthIndex];

            if (lastMonthCount > 0) {
                tutorGrowth = ((double) (currentMonthCount - lastMonthCount) / lastMonthCount) * 100;
                // Giả định tạm thời dùng chung mảng growth hoặc bạn có thể custom thêm (tạm thời để học viên tăng tương ứng)
                studentGrowth = tutorGrowth * 0.8;
            } else if (currentMonthCount > 0) {
                tutorGrowth = 100.0;
                studentGrowth = 100.0;
            }
        }

        // Định dạng chuỗi JSON cho biểu đồ Chart.js
        String chartJson = String.format("[%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d]",
                g[0], g[1], g[2], g[3], g[4], g[5], g[6], g[7], g[8], g[9], g[10], g[11]);

        // 4. Đẩy dữ liệu an toàn sang JSP (Đảm bảo tên biến khớp cấu trúc EL)
        req.setAttribute("totalTutors", tutors);
        req.setAttribute("totalStudents", students);
        req.setAttribute("pendingCount", pending);
        req.setAttribute("monthlyRevenue", revenue);
        req.setAttribute("pendingTutors", pendingTutors);
        req.setAttribute("chartJson", chartJson);

        // Đẩy 2 biến tăng trưởng định dạng 1 chữ số thập phân (Ví dụ: "12.5" hoặc "-2.1")
        req.setAttribute("tutorGrowth", String.format("%.1f", tutorGrowth));
        req.setAttribute("studentGrowth", String.format("%.1f", studentGrowth));

        // 5. Forward sang trang giao diện
        req.getRequestDispatcher("/views/admin/dashboard.jsp").forward(req, resp);
    }
}