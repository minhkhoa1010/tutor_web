package vn.edu.nlu.fit.tutorweb.controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.nlu.fit.tutorweb.dto.Cart;
import vn.edu.nlu.fit.tutorweb.entity.Booking;
import vn.edu.nlu.fit.tutorweb.entity.TutorSearchResult;
import vn.edu.nlu.fit.tutorweb.entity.UserSession;
import vn.edu.nlu.fit.tutorweb.service.BookingService;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/booking/checkout-all")
public class CartCheckoutAllServlet extends HttpServlet {

    private final BookingService bookingService = new BookingService();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");
        Map<String, Object> result = new HashMap<>();

        HttpSession session = req.getSession(false);
        UserSession user = session != null
                ? (UserSession) session.getAttribute("clientUser") : null;

        // 1. Xác thực đăng nhập
        if (user == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            result.put("status", "ERR_NOT_LOGGED_IN");
            resp.getWriter().write(gson.toJson(result));
            return;
        }

        // --- FIX: CHẶN QUYỀN GIA SƯ THỰC HIỆN CHECKOUT ---
        if (user.hasRole("TUTOR")) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403 Forbidden
            result.put("status", "ERR_FORBIDDEN");
            result.put("message", "Gia sư không được phép thực hiện thanh toán thuê gia sư khác.");
            resp.getWriter().write(gson.toJson(result));
            return;
        }
        // -------------------------------------------------

        // 2. Kiểm tra giỏ hàng
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.getItems().isEmpty()) {
            result.put("status", "ERR_EMPTY_CART");
            resp.getWriter().write(gson.toJson(result));
            return;
        }

        List<TutorSearchResult> items = cart.getItems();

        // 3. Kiểm tra số dư
        long totalAmount = items.stream()
                .mapToLong(TutorSearchResult::getHourlyRate)
                .sum();

        if (user.getBalance() < totalAmount) {
            result.put("status", "ERR_INSUFFICIENT_BALANCE");
            result.put("required", totalAmount);
            result.put("balance", user.getBalance());
            resp.getWriter().write(gson.toJson(result));
            return;
        }

        int successCount = 0;
        vn.edu.nlu.fit.tutorweb.dao.BookingDAO bookingDAO = new vn.edu.nlu.fit.tutorweb.dao.BookingDAO();

        // 4. Xử lý đặt lịch từng gia sư trong giỏ
        for (TutorSearchResult tutor : items) {

            // Kiểm tra trùng lịch (Concurrency control)
            if (bookingDAO.isScheduleClash(tutor.getTutorId(), tutor.getAvailableSchedules())) {
                System.out.println("Lớp của gia sư ID " + tutor.getTutorId() + " đã bị trùng lịch, bỏ qua!");
                continue;
            }

            Booking booking = new Booking();
            booking.setParentId(user.getId());
            booking.setTutorId(tutor.getTutorId());
            booking.setSubjectName(tutor.getTeachingSubject());
            booking.setSchedule(tutor.getAvailableSchedules() != null
                    ? tutor.getAvailableSchedules() : "Theo thỏa thuận");
            booking.setTotalPrice(tutor.getHourlyRate());
            booking.setStatus("ACTIVE");

            String status = bookingService.processRentTutor(booking);
            if ("SUCCESS".equals(status)) {
                successCount++;
            }
        }

        // 5. Trả về kết quả
        if (successCount == items.size()) {
            user.setBalance(user.getBalance() - totalAmount);
            session.setAttribute("clientUser", user);

            session.removeAttribute("cart");
            session.setAttribute("cartCount", 0);

            result.put("status", "SUCCESS");
            result.put("count", successCount);
        } else if (successCount > 0) {
            // Xử lý PARTIAL_SUCCESS (thanh toán một phần)
            user.setBalance(user.getBalance() - (successCount * (totalAmount / items.size())));
            session.setAttribute("clientUser", user);

            result.put("status", "PARTIAL_SUCCESS");
            result.put("count", successCount);
            result.put("total", items.size());
        } else {
            result.put("status", "ERR_ALL_FAILED");
            result.put("message", "Tất cả gia sư trong giỏ đã bị người khác đặt trùng lịch học!");
        }

        resp.getWriter().write(gson.toJson(result));
    }
}