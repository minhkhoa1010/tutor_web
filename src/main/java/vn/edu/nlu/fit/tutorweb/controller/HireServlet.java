package vn.edu.nlu.fit.tutorweb.controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.nlu.fit.tutorweb.dao.TutorDAO;
import vn.edu.nlu.fit.tutorweb.entity.Booking;
import vn.edu.nlu.fit.tutorweb.entity.TutorSearchResult;
import vn.edu.nlu.fit.tutorweb.entity.UserSession;
import vn.edu.nlu.fit.tutorweb.service.BookingService;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/booking/hire")
public class HireServlet extends HttpServlet {

    private final BookingService bookingService = new BookingService();
    private final TutorDAO tutorDAO = new TutorDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");
        Map<String, String> result = new HashMap<>();

        // 1. Xác thực quyền đăng nhập
        UserSession user = (UserSession) req.getSession().getAttribute("clientUser");

        if (user == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            result.put("status", "UNAUTHENTICATED");
            resp.getWriter().write(gson.toJson(result));
            return;
        }

        String tutorIdParam = req.getParameter("tutorId");
        String requestedSchedule = req.getParameter("schedule");

        if (tutorIdParam == null || tutorIdParam.isBlank()) {
            result.put("status", "ERR_INVALID_TUTOR");
            resp.getWriter().write(gson.toJson(result));
            return;
        }

        try {
            long tutorId = Long.parseLong(tutorIdParam.trim());

            // --- BẮT ĐẦU ĐOẠN FIX LỖI GIA SƯ TỰ THUÊ / THUÊ NGƯỜI KHÁC ---

            // 1. Kiểm tra role: Chỉ có Phụ huynh (USER) mới được thuê.
            // Nếu là gia sư thì báo lỗi.
            if (user.hasRole("TUTOR")) {
                result.put("status", "ERR_FORBIDDEN"); // Gia sư không có quyền thuê
                resp.getWriter().write(gson.toJson(result));
                return;
            }

            // 2. Kiểm tra tự thuê chính mình (nếu tutorId truyền vào trùng với id người đang đăng nhập)
            // Lưu ý: Nếu database của bạn lưu ID gia sư và ID user riêng biệt,
            // bạn cần lấy user_id tương ứng của tutor đó ra để so sánh.
            // Đoạn này giả định ID trong booking là ID của User (phụ huynh/gia sư).
            if (user.getId() == tutorId) {
                result.put("status", "ERR_SELF_HIRE"); // Không được tự thuê chính mình
                resp.getWriter().write(gson.toJson(result));
                return;
            }

            // --- KẾT THÚC ĐOẠN FIX LỖI ---

            // 2. Kiểm tra thực thể gia sư tồn tại không
            TutorSearchResult tutor = tutorDAO.getTutorSearchResultById(tutorId);
            if (tutor == null) {
                result.put("status", "ERR_TUTOR_NOT_FOUND");
                resp.getWriter().write(gson.toJson(result));
                return;
            }

            // 3. Đóng gói thông tin cơ bản sang DTO Booking
            Booking booking = new Booking();
            booking.setParentId(user.getId());
            booking.setTutorId(tutorId);
            booking.setSubjectName(tutor.getTeachingSubject());
            booking.setSchedule(requestedSchedule != null ? requestedSchedule.trim() : "");
            booking.setTotalPrice(tutor.getHourlyRate());

            // 4. Ủy thác toàn bộ logic kiểm tra + tính toán dòng tiền
            String status = bookingService.processDirectRentTutor(booking, tutor.getHourlyRate());
            result.put("status", status);

            // 5. Nếu transaction thành công, cập nhật lại bộ nhớ Session ví người dùng
            if ("SUCCESS".equals(status)) {
                user.setBalance(user.getBalance() - booking.getTotalPrice());
                req.getSession().setAttribute("clientUser", user);
            }

            resp.getWriter().write(gson.toJson(result));

        } catch (NumberFormatException e) {
            result.put("status", "ERR_INVALID_TUTOR");
            resp.getWriter().write(gson.toJson(result));
        }
    }
}