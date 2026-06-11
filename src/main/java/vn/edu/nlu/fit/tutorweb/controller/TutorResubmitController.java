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
import java.sql.Date;
import java.util.Map;

@WebServlet("/tutor/resubmit-profile")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 10 * 1024 * 1024,
        maxRequestSize = 50 * 1024 * 1024
)
public class TutorResubmitController extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();
    private final TutorRegistrationDAO registrationDAO = new TutorRegistrationDAO();

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
            request.getRequestDispatcher("/views/tutor/resubmit-profile.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

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

        // ==========================================
        // 🌟 BỔ SUNG: Thu thập mảng lịch rảnh cập nhật từ Form gửi lên
        // ==========================================
        String[] schedulesArray = request.getParameterValues("schedules");

        Cloudinary cloudinary = CloudinaryConfig.getCloudinary();
        TutorProfile oldTutorProfile = adminDAO.getTutorProfileByUserId(userId);

        // 1. Xử lý ảnh ĐẠI DIỆN mới
        Part portrait = request.getPart("portrait");
        String newAvatarUrl = null;
        if (portrait != null && portrait.getSize() > 0) {
            if (oldTutorProfile != null && oldTutorProfile.getPortraitUrl() != null) {
                deleteFileFromCloudinary(cloudinary, oldTutorProfile.getPortraitUrl());
            }
            byte[] data = portrait.getInputStream().readAllBytes();
            Map<?, ?> result = cloudinary.uploader().upload(data, ObjectUtils.emptyMap());
            newAvatarUrl = result.get("secure_url").toString();
        }

        // 2. Xử lý ảnh BẰNG CẤP mới
        java.util.List<String> newDegreeUrls = new java.util.ArrayList<>();
        try {
            boolean hasNewDegree = false;
            for (Part part : request.getParts()) {
                if ("degreePhotos".equals(part.getName()) && part.getSize() > 0) {
                    hasNewDegree = true;
                    break;
                }
            }
            if (hasNewDegree && oldTutorProfile != null && oldTutorProfile.getDegreeUrls() != null) {
                for (String oldUrl : oldTutorProfile.getDegreeUrls()) {
                    deleteFileFromCloudinary(cloudinary, oldUrl);
                }
            }
            for (Part part : request.getParts()) {
                if ("degreePhotos".equals(part.getName()) && part.getSize() > 0) {
                    byte[] data = part.getInputStream().readAllBytes();
                    Map<?, ?> result = cloudinary.uploader().upload(data, ObjectUtils.emptyMap());
                    newDegreeUrls.add(result.get("secure_url").toString());
                }
            }
        } catch (Exception e) {
            System.out.println("Không có tệp bằng cấp mới.");
        }

        // 3. Xử lý ảnh CCCD mới
        java.util.List<String> newIdCardUrls = new java.util.ArrayList<>();
        try {
            boolean hasNewIdCard = false;
            for (Part part : request.getParts()) {
                if ("citizenPhotos".equals(part.getName()) && part.getSize() > 0) {
                    hasNewIdCard = true;
                    break;
                }
            }
            if (hasNewIdCard && oldTutorProfile != null && oldTutorProfile.getIdCardUrls() != null) {
                for (String oldUrl : oldTutorProfile.getIdCardUrls()) {
                    deleteFileFromCloudinary(cloudinary, oldUrl);
                }
            }
            for (Part part : request.getParts()) {
                if ("citizenPhotos".equals(part.getName()) && part.getSize() > 0) {
                    byte[] data = part.getInputStream().readAllBytes();
                    Map<?, ?> result = cloudinary.uploader().upload(data, ObjectUtils.emptyMap());
                    newIdCardUrls.add(result.get("secure_url").toString());
                }
            }
        } catch (Exception e) {
            System.out.println("Không có tệp CCCD mới.");
        }

        // ==========================================
        // 🌟 BỔ SUNG: Đổi từ lưu chuỗi tĩnh sang gọi hàm xử lý Ngày sinh linh hoạt
        // ==========================================
        Date birthDate = buildBirthDate(request);
        if (birthDate != null) {
            request.setAttribute("birthDateOverride", birthDate);
        }

        // Gọi DAO cập nhật toàn diện thông tin xuống MySQL (Bao gồm cả lịch rảnh và ngày sinh)
        boolean isUpdated = registrationDAO.updateTutorProfile(
                userId, tutorId, request, newAvatarUrl, newDegreeUrls, newIdCardUrls, hourlyRate, schedulesArray
        );

        if (isUpdated) {
            session.setAttribute("tutorStatus", "PENDING");
            response.sendRedirect(request.getContextPath() + "/home");
        } else {
            request.setAttribute("error", "Cập nhật thất bại, hệ thống lưu trữ dữ liệu gặp sự cố!");
            TutorProfile tutor = adminDAO.getTutorProfileByUserId(userId);
            request.setAttribute("tutor", tutor);
            request.getRequestDispatcher("/views/tutor/resubmit-profile.jsp").forward(request, response);
        }
    }

    private Date buildBirthDate(HttpServletRequest request) {
        try {
            // Đọc trực tiếp từ input type="date" mới thay vì ghép 3 selectbox ngày/tháng/năm cũ
            String birthDateStr = request.getParameter("birthDate");
            if (birthDateStr == null || birthDateStr.isBlank()) {
                return null;
            }
            return Date.valueOf(birthDateStr); // Chuyển chuỗi YYYY-MM-DD thẳng sang java.sql.Date
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private void deleteFileFromCloudinary(Cloudinary cloudinary, String fileUrl) {
        if (fileUrl == null || fileUrl.isBlank() || !fileUrl.contains("cloudinary.com")) return;
        try {
            int uploadIndex = fileUrl.indexOf("/upload/");
            if (uploadIndex != -1) {
                String subStr = fileUrl.substring(uploadIndex + 8);
                int versionIndex = subStr.indexOf("/");
                if (subStr.substring(0, versionIndex).startsWith("v")) {
                    subStr = subStr.substring(versionIndex + 1);
                }
                int dotIndex = subStr.lastIndexOf(".");
                if (dotIndex != -1) {
                    String publicId = subStr.substring(0, dotIndex);
                    cloudinary.uploader().destroy(publicId, ObjectUtils.emptyMap());
                }
            }
        } catch (Exception e) {
            System.err.println("Không thể xóa file: " + fileUrl);
        }
    }
}