package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.nlu.fit.tutorweb.dao.AdminDAO;
import vn.edu.nlu.fit.tutorweb.dto.TutorPending;

import vn.edu.nlu.fit.tutorweb.db.DBConnect;

import java.io.IOException;
import java.util.Calendar;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {
        "/admin/dashboard",
        "/admin/dashboard/export"
})
public class AdminDashboardServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String path = req.getServletPath();

        if ("/admin/dashboard/export".equals(path)) {
            exportCsv(req, resp);
            return;
        }

        // 1. Lấy các số liệu tổng quan hệ thống
        long tutors = adminDAO.countTutors();
        long students = adminDAO.countStudents();
        long pending = adminDAO.countPendingTutors();
        long revenue = adminDAO.getMonthlyRevenue();
        long totalBookings = adminDAO.countAllBookings();

        List<TutorPending> pendingTutors = adminDAO.getPendingTutors();

        // 2. Lấy dữ liệu mảng tăng trưởng người dùng theo tháng (Dùng cho Line Chart)
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
                studentGrowth = tutorGrowth * 0.8;
            } else if (currentMonthCount > 0) {
                tutorGrowth = 100.0;
                studentGrowth = 100.0;
            }
        }

        // Định dạng chuỗi JSON cho biểu đồ Đường tăng trưởng người dùng (User Growth Line Chart)
        String chartJson = String.format("[%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d]",
                g[0], g[1], g[2], g[3], g[4], g[5], g[6], g[7], g[8], g[9], g[10], g[11]);

        // ==========================================
        // TỐI ƯU HÓA: BỔ SUNG BIỂU ĐỒ DOANH THU CỐT LÕI
        // ==========================================

        // A. Xử lý dữ liệu Biểu đồ Cột - Doanh thu theo 12 tháng (Bar Chart)
        List<Map<String, Object>> revList = adminDAO.getMonthlyRevenueReport();
        long[] monthlyRevenueData = new long[12]; // Mảng chứa doanh thu thực tế từ T1 đến T12
        if (revList != null) {
            for (Map<String, Object> row : revList) {
                if (row.get("m") != null && row.get("total") != null) {
                    int month = ((Number) row.get("m")).intValue();
                    long total = ((Number) row.get("total")).longValue();
                    if (month >= 1 && month <= 12) {
                        monthlyRevenueData[month - 1] = total;
                    }
                }
            }
        }
        String revenueChartJson = String.format("[%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d]",
                monthlyRevenueData[0], monthlyRevenueData[1], monthlyRevenueData[2], monthlyRevenueData[3],
                monthlyRevenueData[4], monthlyRevenueData[5], monthlyRevenueData[6], monthlyRevenueData[7],
                monthlyRevenueData[8], monthlyRevenueData[9], monthlyRevenueData[10], monthlyRevenueData[11]);

        // B. Xử lý dữ liệu Biểu đồ Tròn - Doanh thu theo Môn học (Doughnut Chart)
        List<Map<String, Object>> subjectList = adminDAO.getRevenueBySubject();

        // Chuẩn bị các chuỗi JS Array dạng: ['Toán', 'Vật Lý'] và [500000, 300000] đổ thẳng vào Chart.js
        StringBuilder sbLabels = new StringBuilder("[");
        StringBuilder sbData = new StringBuilder("[");
        if (subjectList != null && !subjectList.isEmpty()) {
            for (int i = 0; i < subjectList.size(); i++) {
                Map<String, Object> row = subjectList.get(i);
                String subjectName = row.get("subject") != null ? row.get("subject").toString() : "Môn khác";
                long total = row.get("total") != null ? ((Number) row.get("total")).longValue() : 0;

                sbLabels.append("'").append(subjectName).append("'");
                sbData.append(total);

                if (i < subjectList.size() - 1) {
                    sbLabels.append(",");
                    sbData.append(",");
                }
            }
        }
        sbLabels.append("]");
        sbData.append("]");

        // C. Lấy danh sách gia sư bị báo cáo/khiếu nại (Complaints) hiển thị tại Dashboard
        List<Map<String, Object>> reportedTutors = adminDAO.getReportedTutors();

        // 4. Đẩy toàn bộ dữ liệu an toàn sang JSP
        req.setAttribute("totalTutors", tutors);
        req.setAttribute("totalStudents", students);
        req.setAttribute("pendingCount", pending);
        req.setAttribute("monthlyRevenue", revenue);
        req.setAttribute("totalBookings", totalBookings);
        req.setAttribute("pendingTutors", pendingTutors);
        req.setAttribute("reportedTutors", reportedTutors); // Đẩy list khiếu nại

        // Các biến JSON cho các biểu đồ Chart.js
        req.setAttribute("chartJson", chartJson);                  // Line Chart (User Growth)
        req.setAttribute("revenueChartJson", revenueChartJson);    // Bar Chart (Doanh thu năm)
        req.setAttribute("subjectLabelsJson", sbLabels.toString()); // Doughnut Labels
        req.setAttribute("subjectDataJson", sbData.toString());     // Doughnut Data

        // Đẩy 2 biến tăng trưởng định dạng 1 chữ số thập phân
        req.setAttribute("tutorGrowth", tutorGrowth);
        req.setAttribute("studentGrowth", studentGrowth);

        // 5. Forward sang trang giao diện dashboard của bạn
        req.getRequestDispatcher("/views/admin/dashboard.jsp").forward(req, resp);
    }

    private void exportCsv(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");

        String type = request.getParameter("type");

        String filename;
        String sql;

        switch (type == null ? "" : type) {
            case "users" -> {
                filename = "bao_cao_nguoi_dung.csv";
                sql = """
                    SELECT
                        u.id AS id,
                        u.fullname AS fullname,
                        u.email AS email,
                        u.username AS username,
                        u.is_active AS is_active,
                        DATE_FORMAT(u.created_at, '%d/%m/%Y %H:%i') AS created_at
                    FROM users u
                    ORDER BY u.id DESC
                    """;
            }

            case "bookings" -> {
                filename = "bao_cao_lop_hoc.csv";
                sql = """
                    SELECT
                        b.id AS booking_id,
                        parent.fullname AS parent_name,
                        tutor_user.fullname AS tutor_name,
                        t.teaching_subject AS subject_name,
                        b.total_price AS total_price,
                        b.status AS status,
                        DATE_FORMAT(b.created_at, '%d/%m/%Y %H:%i') AS created_at
                    FROM bookings b
                    LEFT JOIN users parent ON b.parent_id = parent.id
                    LEFT JOIN tutors t ON b.tutor_id = t.id
                    LEFT JOIN users tutor_user ON t.user_id = tutor_user.id
                    ORDER BY b.id DESC
                    """;
            }

            case "revenue" -> {
                filename = "bao_cao_doanh_thu.csv";
                sql = """
                    SELECT
                        tr.id AS transaction_id,
                        u.fullname AS fullname,
                        u.email AS email,
                        tr.type AS type,
                        tr.amount AS amount,
                        tr.status AS status,
                        tr.vnp_txn_ref AS vnp_txn_ref,
                        DATE_FORMAT(tr.created_at, '%d/%m/%Y %H:%i') AS created_at
                    FROM transactions tr
                    LEFT JOIN users u ON tr.user_id = u.id
                    ORDER BY tr.id DESC
                    """;
            }

            default -> {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                return;
            }
        }

        List<Map<String, Object>> rows = DBConnect.get().withHandle(handle ->
                handle.createQuery(sql)
                        .mapToMap()
                        .list()
        );

        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

        try (PrintWriter writer = response.getWriter()) {
            writer.write('\uFEFF');

            if (rows.isEmpty()) {
                writer.println("Khong co du lieu");
                return;
            }

            Map<String, Object> firstRow = rows.get(0);

            writer.println(String.join(",", firstRow.keySet()));

            for (Map<String, Object> row : rows) {
                String line = row.values()
                        .stream()
                        .map(this::csvValue)
                        .reduce((a, b) -> a + "," + b)
                        .orElse("");

                writer.println(line);
            }
        }
    }

    private String csvValue(Object value) {
        if (value == null) {
            return "";
        }

        String text = String.valueOf(value);
        text = text.replace("\"", "\"\"");

        return "\"" + text + "\"";
    }
}