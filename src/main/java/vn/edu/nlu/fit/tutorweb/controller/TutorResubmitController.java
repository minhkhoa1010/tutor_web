package vn.edu.nlu.fit.tutorweb.controller;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.nlu.fit.tutorweb.dao.AdminDAO;
import vn.edu.nlu.fit.tutorweb.dao.TutorRegistrationDAO;
import vn.edu.nlu.fit.tutorweb.dto.TutorProfile;
import vn.edu.nlu.fit.tutorweb.entity.UserSession;
import vn.edu.nlu.fit.tutorweb.utils.CloudinaryConfig;

import java.io.IOException;
import java.util.Map;

@WebServlet("/tutor/edit-profile") // Dùng duy nhất 1 URL này
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 10 * 1024 * 1024,
        maxRequestSize = 50 * 1024 * 1024
)
public class TutorProfileController extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();
    private final TutorRegistrationDAO registrationDAO = new TutorRegistrationDAO();

    /**
     * LÀM NHIỆM VỤ CỦA TUTOREDITSERVLET: Lấy dữ liệu cũ và mở trang chỉnh sửa
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserSession user = (UserSession) session.getAttribute("clientUser");

        if (user == null || !user.hasRole("TUTOR")) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }


        TutorProfile tutor = adminDAO.getTutorProfileByUserId(user.getId());

        if (tutor != null) {
            request.setAttribute("tutor", tutor);
            // Mở trang JSP chỉnh sửa
            request.getRequestDispatcher("/views/tutor/resubmit-profile.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    /**
     * LÀM NHIỆM VỤ CỦA TUTORUPDATESERVLET: Tiếp nhận form bấm nút gửi, lưu DB
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserSession user = (UserSession) session.getAttribute("clientUser");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        long tutorId = Long.parseLong(request.getParameter("tutorId"));
        long userId = user.getId();

        String hourlyRateStr = request.getParameter("hourlyRate");
        long hourlyRate = (hourlyRateStr != null && !hourlyRateStr.isBlank()) ? Long.parseLong(hourlyRateStr) : 0L;

        // Xử lý ảnh đại diện mới nếu có nâng tải
        Part portrait = request.getPart("portrait");
        String newAvatarUrl = null;
        if (portrait != null && portrait.getSize() > 0) {
            Cloudinary cloudinary = CloudinaryConfig.getCloudinary();
            byte[] data = portrait.getInputStream().readAllBytes();
            Map<?, ?> result = cloudinary.uploader().upload(data, ObjectUtils.emptyMap());
            newAvatarUrl = result.get("secure_url").toString();
        }

        // Gọi DAO cập nhật dữ liệu và ép trạng thái về PENDING
        boolean isUpdated = registrationDAO.updateTutorProfile(userId, tutorId, request, newAvatarUrl, hourlyRate);

        if (isUpdated) {
            session.setAttribute("tutorStatus", "PENDING");
            response.sendRedirect(request.getContextPath() + "/home");
        } else {
            request.setAttribute("error", "Cập nhật thất bại, vui lòng thử lại!");
            response.sendRedirect(request.getContextPath() + "/tutor/edit-profile");
        }
    }
}