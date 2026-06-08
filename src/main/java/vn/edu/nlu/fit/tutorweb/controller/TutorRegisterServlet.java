package vn.edu.nlu.fit.tutorweb.controller;


import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import vn.edu.nlu.fit.tutorweb.dao.TutorRegistrationDAO;
import vn.edu.nlu.fit.tutorweb.utils.CloudinaryConfig;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet("/register-tutor")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 10 * 1024 * 1024, maxRequestSize = 50 * 1024 * 1024)
public class TutorRegisterServlet extends HttpServlet {

    private final TutorRegistrationDAO dao = new TutorRegistrationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String hourlyRateStr = request.getParameter("hourlyRate");
        long hourlyRate = (hourlyRateStr != null && !hourlyRateStr.isBlank()) ? Long.parseLong(hourlyRateStr) : 0L;
        if (!password.equals(confirmPassword)) {
            request.setAttribute("authError", "Mật khẩu xác nhận không khớp");

            request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
            return;
        }

        Cloudinary cloudinary = CloudinaryConfig.getCloudinary();

        List<String> degreeUrls = new ArrayList<>();
        List<String> citizenUrls = new ArrayList<>();

        // avatar
        Part portrait = request.getPart("portrait");

        if (portrait == null || portrait.getSize() == 0) {
            request.setAttribute("authError", "Vui lòng tải ảnh thẻ");

            request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
            return;
        }

        String avatarUrl = uploadToCloudinary(cloudinary, portrait);

        // bằng cấp
        for (Part p : request.getParts()) {

            if ("degreePhotos".equals(p.getName()) && p.getSize() > 0) {

                degreeUrls.add(uploadToCloudinary(cloudinary, p));
            }

            if ("citizenPhotos".equals(p.getName()) && p.getSize() > 0) {

                citizenUrls.add(uploadToCloudinary(cloudinary, p));
            }
        }

        if (degreeUrls.isEmpty() || citizenUrls.isEmpty()) {
            request.setAttribute("authError", "Vui lòng tải đủ ảnh bằng cấp và CCCD");

            request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
            return;
        }
        String[] gradesArray = request.getParameterValues("grades");
        String gradesStr = (gradesArray != null) ? String.join(", ", gradesArray) : "";
        boolean success = dao.registerTutor(request, avatarUrl, degreeUrls, citizenUrls, hourlyRate);
        System.out.println("=== DEBUG REGISTER TUTOR ===");
        System.out.println("avatarUrl = " + avatarUrl);
        System.out.println("degreeUrls = " + degreeUrls);
        System.out.println("citizenUrls = " + citizenUrls);
        if (success) {
            // Về trang chủ, không vào list.jsp
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp?registered=pending");
        } else {
            request.setAttribute("authError", "Không thể tạo hồ sơ gia sư");
            request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
        }
    }

    private String uploadToCloudinary(Cloudinary cloudinary, Part part) throws IOException {

        byte[] data = part.getInputStream().readAllBytes();

        Map<?, ?> result = cloudinary.uploader().upload(data, ObjectUtils.emptyMap());

        return result.get("secure_url").toString();
    }
}
