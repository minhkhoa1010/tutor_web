package vn.edu.nlu.fit.tutorweb.controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.nlu.fit.tutorweb.entity.TutorSearchResult;
import vn.edu.nlu.fit.tutorweb.entity.UserSession;
import vn.edu.nlu.fit.tutorweb.service.SavedTutorService;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/parent/wishlist")
public class BookmarkServlet extends HttpServlet {
    private final SavedTutorService savedTutorService = new SavedTutorService();
    private final Gson gson = new Gson();

    /**
     * 1. HÀNH ĐỘNG GET: Khi phụ huynh bấm vào "Gia sư yêu thích" trên Header
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserSession userSession = (UserSession) request.getSession().getAttribute("clientUser");
        if (userSession == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            long parentId = userSession.getId();

            // Lấy danh sách thông tin gia sư đã được phụ huynh lưu từ Service
            // Lưu ý: Kiểu dữ liệu trong List (Tutor hoặc TutorSearchResult) phải khớp với tầng Service của bạn
            List<TutorSearchResult> savedTutors = savedTutorService.getSavedTutorsByParentId(parentId);
            System.out.println("--- DEBUG WISHLIST ---");
            System.out.println("Số lượng gia sư tìm thấy trong DB: " + (savedTutors != null ? savedTutors.size() : 0));

            request.setAttribute("savedTutorsList", savedTutors);
            // Gán dữ liệu vào Request Scope với name "savedTutorsList" để khớp với thẻ <c:forEach> ngoài JSP
            request.setAttribute("savedTutorsList", savedTutors);

        } catch (Exception e) {
            e.printStackTrace();
            // Bạn có thể log lỗi hoặc set một thông báo lỗi nếu cần thiết
        }

        // Forward thẳng ra file hiển thị danh sách
        request.getRequestDispatcher("/views/parent/wishlist.jsp").forward(request, response);
    }

    /**
     * 2. HÀNH ĐỘNG POST: Khi phụ huynh bấm nút Bookmark (Yêu thích) ngoài trang chủ (Ajax)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, String> jsonMap = new HashMap<>();
        UserSession userSession = (UserSession) request.getSession().getAttribute("clientUser");

        if (userSession == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            jsonMap.put("status", "unauthorized");
            response.getWriter().write(gson.toJson(jsonMap));
            return;
        }

        try {
            long parentId = userSession.getId();
            long tutorId = Long.parseLong(request.getParameter("tutorId"));

            // Gọi Service xử lý toggle lưu/hủy lưu
            String result = savedTutorService.toggleSaveTutor(parentId, tutorId);

            if ("error".equals(result)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            }

            jsonMap.put("status", result);
            response.getWriter().write(gson.toJson(jsonMap));

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonMap.put("status", "error");
            response.getWriter().write(gson.toJson(jsonMap));
        }
    }
}