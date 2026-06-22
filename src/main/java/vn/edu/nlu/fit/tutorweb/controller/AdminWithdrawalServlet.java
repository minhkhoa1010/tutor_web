package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.nlu.fit.tutorweb.dao.AdminDAO;
import vn.edu.nlu.fit.tutorweb.entity.WithdrawalRequest;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/withdrawals", "/admin/withdrawals/action"})
public class AdminWithdrawalServlet extends HttpServlet {
    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String servletPath = request.getServletPath();
        HttpSession session = request.getSession();

        // TÌNH HUỐNG 1: ĐƯỜNG DẪN XỬ LÝ HÀNH ĐỘNG DUYỆT / TỪ CHỐI
        if ("/admin/withdrawals/action".equals(servletPath)) {
            String idRaw = request.getParameter("id");
            String status = request.getParameter("status");

            if (idRaw != null && status != null) {
                try {
                    int requestId = Integer.parseInt(idRaw);
                    boolean result;

                    if ("APPROVE".equalsIgnoreCase(status)) {
                        result = adminDAO.approveWithdrawalRequest(requestId);
                        if (result) session.setAttribute("msgSuccess", "🎉 Đã phê duyệt yêu cầu rút tiền thành công!");
                        else session.setAttribute("msgError", "Thao tác thất bại hoặc yêu cầu này đã được xử lý trước đó.");
                    } else if ("REJECT".equalsIgnoreCase(status)) {
                        result = adminDAO.rejectWithdrawalRequest(requestId);
                        if (result) session.setAttribute("msgSuccess", "❌ Đã từ chối yêu cầu và hoàn lại tiền vào ví gia sư.");
                        else session.setAttribute("msgError", "Thao tác thất bại.");
                    }
                } catch (NumberFormatException e) {
                    session.setAttribute("msgError", "Định dạng ID yêu cầu không hợp lệ.");
                }
            }
            // Xử lý xong thì redirect về trang danh sách để cập nhật lại bảng dữ liệu mới nhất
            response.sendRedirect(request.getContextPath() + "/admin/withdrawals");
            return;
        }

        // TÌNH HUỐNG 2: ĐƯỜNG DẪN TRANG CHỦ (HIỂN THỊ DANH SÁCH)
        List<WithdrawalRequest> requests = adminDAO.getAllWithdrawalRequests();
        request.setAttribute("withdrawalRequests", requests);

        // Trỏ về đúng vị trí file JSP admin của bạn
        request.getRequestDispatcher("/views/admin/withdrawals.jsp").forward(request, response);
    }
}