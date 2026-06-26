package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.nlu.fit.tutorweb.db.DBConnect;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {
        "/admin/reports",
        "/admin/reports/export"
})
public class AdminReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/admin/reports/export".equals(path)) {
            exportReport(request, response);
            return;
        }

        loadReportPage(request, response);
    }

    private void loadReportPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        long totalUsers = queryLong("SELECT COUNT(*) FROM users");
        long activeUsers = queryLong("SELECT COUNT(*) FROM users WHERE is_active = 1");
        long totalTutors = queryLong("SELECT COUNT(*) FROM tutors");
        long totalBookings = queryLong("SELECT COUNT(*) FROM bookings");
        long completedBookings = queryLong("SELECT COUNT(*) FROM bookings WHERE status = 'COMPLETED'");

        BigDecimal totalTransactionAmount = queryMoney("""
                SELECT COALESCE(SUM(amount), 0)
                FROM transactions
                WHERE status = 'SUCCESS'
                """);

        BigDecimal monthlyTransactionAmount = queryMoney("""
                SELECT COALESCE(SUM(amount), 0)
                FROM transactions
                WHERE status = 'SUCCESS'
                  AND MONTH(created_at) = MONTH(CURRENT_DATE())
                  AND YEAR(created_at) = YEAR(CURRENT_DATE())
                """);

        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("activeUsers", activeUsers);
        request.setAttribute("totalTutors", totalTutors);
        request.setAttribute("totalBookings", totalBookings);
        request.setAttribute("completedBookings", completedBookings);
        request.setAttribute("totalTransactionAmount", totalTransactionAmount);
        request.setAttribute("monthlyTransactionAmount", monthlyTransactionAmount);

        request.getRequestDispatcher("/views/admin/reports.jsp").forward(request, response);
    }

    private void exportReport(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String type = request.getParameter("type");

        if (type == null || type.isBlank()) {
            type = "users";
        }

        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setContentType("text/csv; charset=UTF-8");

        String fileName = "admin-report-" + type + ".csv";
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

        PrintWriter out = response.getWriter();

        // BOM để Excel đọc tiếng Việt UTF-8 đúng
        out.write('\uFEFF');

        switch (type) {
            case "bookings":
                exportBookings(out);
                break;
            case "revenue":
                exportRevenue(out);
                break;
            case "users":
            default:
                exportUsers(out);
                break;
        }

        out.flush();
    }

    private void exportUsers(PrintWriter out) {
        out.println("ID,Họ tên,Email,SĐT,Vai trò,Trạng thái,Ngày tạo");

        String sql = """
                SELECT
                    u.id AS id,
                    u.fullname AS fullname,
                    u.email AS email,
                    u.phone AS phone,
                    GROUP_CONCAT(r.name ORDER BY r.id SEPARATOR ' | ') AS role_name,
                    CASE WHEN u.is_active = 1 THEN 'Hoạt động' ELSE 'Bị khóa' END AS status,
                    DATE_FORMAT(u.created_at, '%d/%m/%Y %H:%i') AS created_at
                FROM users u
                LEFT JOIN user_roles ur ON u.id = ur.user_id
                LEFT JOIN roles r ON ur.role_id = r.id
                GROUP BY u.id, u.fullname, u.email, u.phone, u.is_active, u.created_at
                ORDER BY u.id DESC
                """;

        List<Map<String, Object>> rows = DBConnect.get().withHandle(handle ->
                handle.createQuery(sql).mapToMap().list()
        );

        for (Map<String, Object> row : rows) {
            out.println(csv(row.get("id")) + "," +
                    csv(row.get("fullname")) + "," +
                    csv(row.get("email")) + "," +
                    csv(row.get("phone")) + "," +
                    csv(row.get("role_name")) + "," +
                    csv(row.get("status")) + "," +
                    csv(row.get("created_at")));
        }
    }

    private void exportBookings(PrintWriter out) {
        out.println("Mã lớp,Môn học,Phụ huynh,Gia sư,Học phí,Trạng thái,Ngày tạo");

        String sql = """
                SELECT
                    b.id AS booking_id,
                    COALESCE(t.teaching_subject, 'Chưa xác định') AS subject_name,
                    u_parent.fullname AS parent_name,
                    u_tutor.fullname AS tutor_name,
                    b.total_price AS total_price,
                    b.status AS status,
                    DATE_FORMAT(b.created_at, '%d/%m/%Y %H:%i') AS created_at
                FROM bookings b
                LEFT JOIN users u_parent ON b.parent_id = u_parent.id
                LEFT JOIN tutors t ON b.tutor_id = t.id
                LEFT JOIN users u_tutor ON t.user_id = u_tutor.id
                ORDER BY b.id DESC
                """;

        List<Map<String, Object>> rows = DBConnect.get().withHandle(handle ->
                handle.createQuery(sql).mapToMap().list()
        );

        for (Map<String, Object> row : rows) {
            out.println(csv(row.get("booking_id")) + "," +
                    csv(row.get("subject_name")) + "," +
                    csv(row.get("parent_name")) + "," +
                    csv(row.get("tutor_name")) + "," +
                    csv(row.get("total_price")) + "," +
                    csv(row.get("status")) + "," +
                    csv(row.get("created_at")));
        }
    }

    private void exportRevenue(PrintWriter out) {
        out.println("Mã giao dịch,User ID,Loại giao dịch,Số tiền,Trạng thái,Mã VNPay,Ngày tạo");

        String sql = """
                SELECT
                    id,
                    user_id,
                    type,
                    amount,
                    status,
                    vnp_txn_ref,
                    DATE_FORMAT(created_at, '%d/%m/%Y %H:%i') AS created_at
                FROM transactions
                ORDER BY id DESC
                """;

        List<Map<String, Object>> rows = DBConnect.get().withHandle(handle ->
                handle.createQuery(sql).mapToMap().list()
        );

        for (Map<String, Object> row : rows) {
            out.println(csv(row.get("id")) + "," +
                    csv(row.get("user_id")) + "," +
                    csv(row.get("type")) + "," +
                    csv(row.get("amount")) + "," +
                    csv(row.get("status")) + "," +
                    csv(row.get("vnp_txn_ref")) + "," +
                    csv(row.get("created_at")));
        }
    }

    private long queryLong(String sql) {
        return DBConnect.get().withHandle(handle ->
                handle.createQuery(sql).mapTo(Long.class).one()
        );
    }

    private BigDecimal queryMoney(String sql) {
        return DBConnect.get().withHandle(handle ->
                handle.createQuery(sql).mapTo(BigDecimal.class).one()
        );
    }

    private String csv(Object value) {
        if (value == null) {
            return "";
        }

        String text = String.valueOf(value)
                .replace("\"", "\"\"")
                .replace("\n", " ")
                .replace("\r", " ");

        return "\"" + text + "\"";
    }
}
