package vn.edu.nlu.fit.tutorweb.api;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.google.gson.Gson;
import vn.edu.nlu.fit.tutorweb.dao.BookingDAO;
import vn.edu.nlu.fit.tutorweb.dao.TutorDAO;
import vn.edu.nlu.fit.tutorweb.entity.TutorSearchResult;
import vn.edu.nlu.fit.tutorweb.entity.UserSession; // Đảm bảo import đúng thực thể Session của bạn

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/api/tutor/schedules")
public class TutorScheduleAPI extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();
    private final TutorDAO tutorDAO = new TutorDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");

        String tutorIdParam = req.getParameter("tutorId");
        // Lấy session user để kiểm tra lịch của chính họ
        Object userObj = req.getSession().getAttribute("clientUser");

        if (tutorIdParam == null || tutorIdParam.isBlank() || userObj == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Yêu cầu không hợp lệ hoặc phiên đăng nhập hết hạn.\"}");
            return;
        }

        try {
            long tutorId = Long.parseLong(tutorIdParam.trim());

            // 1. LẤY TOÀN BỘ LỊCH RẢNH GỐC CỦA GIA SƯ (Tách từ chuỗi GROUP_CONCAT)
            TutorSearchResult tutor = tutorDAO.getTutorSearchResultById(tutorId);
            List<String> allSchedules = new ArrayList<>();
            if (tutor != null && tutor.getAvailableSchedules() != null && !tutor.getAvailableSchedules().isBlank()) {
                String[] parts = tutor.getAvailableSchedules().split(",");
                for (String p : parts) {
                    if (!p.trim().isEmpty()) allSchedules.add(p.trim());
                }
            }

            // 2. LẤY LỊCH ĐÃ BỊ THUÊ (ACTIVE / PAID từ BookingDAO)
            List<String> busySchedules = bookingDAO.getBusySchedules(tutorId);

            // 3. LẤY LỊCH CỦA RIÊNG USER NÀY (Đã bận và thuộc về Parent hiện tại)
            // Bạn có thể dùng hàm này của BookingDAO hoặc lọc từ danh sách hoạt động của Parent
            List<String> myOwnedSchedules = new ArrayList<>();

            // Giả định bạn lấy được parentId từ user session object của bạn
            // long parentId = ((UserSession) userObj).getId();
            // myOwnedSchedules = bookingDAO.getSchedulesByParentAndTutor(parentId, tutorId);

            // Đóng gói dữ liệu trả về cho phía JavaScript xử lý giao diện Popup
            Map<String, Object> result = new HashMap<>();
            result.put("all", allSchedules);
            result.put("busy", busySchedules);
            result.put("owned", myOwnedSchedules); // Nếu chưa làm hàm này thì mảng tạm thời rỗng, không lo crash

            String json = new Gson().toJson(result);
            resp.getWriter().write(json);

        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Mã gia sư không đúng định dạng.\"}");
        }
    }
}