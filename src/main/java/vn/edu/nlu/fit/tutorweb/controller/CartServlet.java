package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.nlu.fit.tutorweb.dao.BookingDAO;
import vn.edu.nlu.fit.tutorweb.dao.TutorDAO;
import vn.edu.nlu.fit.tutorweb.dto.Cart;
import vn.edu.nlu.fit.tutorweb.entity.TutorSearchResult;

import java.io.IOException;

@WebServlet("/cart/toggle")
public class CartServlet extends HttpServlet {
    private final TutorDAO tutorDAO = new TutorDAO();
    private final BookingDAO bookingDAO = new BookingDAO(); // Khai báo thêm BookingDAO để check trùng lịch

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        HttpSession session = req.getSession();

        // 1. Kiểm tra trạng thái đăng nhập của client
        if (session.getAttribute("clientUser") == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("{\"status\":\"unauthenticated\"}");
            return;
        }

        String tutorIdParam = req.getParameter("tutorId");
        String scheduleParam = req.getParameter("schedule"); // Nhận chuỗi lịch đã chọn từ Ajax gửi lên (Ví dụ: "Sáng Thứ 2, Chiều Thứ 5")

        if (tutorIdParam == null || tutorIdParam.isBlank()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Thiếu ID gia sư.\"}");
            return;
        }

        try {
            long tutorId = Long.parseLong(tutorIdParam.trim());

            // 2. Khởi tạo hoặc lấy Giỏ hàng từ Session
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null) {
                cart = new Cart();
                session.setAttribute("cart", cart);
            }

            // 3. Logic xử lý Giỏ hàng
            if (cart.getTutorIds().contains(tutorId)) {
                // Nếu gia sư này đã tồn tại trong giỏ -> Thực hiện XÓA khỏi giỏ hàng khi click lại lần 2
                cart.removeItem(tutorId);
                session.setAttribute("cartCount", cart.getTotalItems());
                resp.getWriter().write("{\"status\":\"removed\",\"total\":" + cart.getTotalItems() + "}");
            } else {
                // Nếu chưa có -> Tiến hành THÊM MỚI vào giỏ hàng
                TutorSearchResult tutor = tutorDAO.getTutorSearchResultById(tutorId);

                if (tutor != null) {
                    // Kiểm tra xem phía Client có truyền lịch cụ thể lên hay không
                    if (scheduleParam != null && !scheduleParam.isBlank()) {

                        // Sử dụng hàm kiểm tra trùng lịch chéo nâng cao có sẵn trong BookingDAO của bạn
                        boolean isClashing = bookingDAO.isScheduleClash(tutorId, scheduleParam);
                        if (isClashing) {
                            resp.getWriter().write("{\"status\":\"clash\",\"message\":\"Lịch học bạn chọn vừa có người đặt trước! Vui lòng chọn lịch khác.\"}");
                            return;
                        }

                        // Ghi đè chuỗi lịch được chọn từ popup vào thuộc tính availableSchedules của vật phẩm trong giỏ hàng
                        tutor.setAvailableSchedules(scheduleParam.trim());
                    } else {
                        // Trường hợp bấm thêm vào giỏ nhưng không có dữ liệu lịch học truyền lên
                        resp.getWriter().write("{\"status\":\"require_schedule\",\"message\":\"Vui lòng chọn ít nhất một buổi học!\"}");
                        return;
                    }

                    // Thêm object gia sư kèm lịch học cụ thể vào Cart
                    cart.addItem(tutor);
                    session.setAttribute("cartCount", cart.getTotalItems());
                    resp.getWriter().write("{\"status\":\"added\",\"total\":" + cart.getTotalItems() + "}");
                } else {
                    resp.getWriter().write("{\"status\":\"not_found\"}");
                }
            }

        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Mã gia sư không đúng định dạng.\"}");
        }
    }
}