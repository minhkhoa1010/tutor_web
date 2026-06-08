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

        Cloudinary cloudinary = CloudinaryConfig.getCloudinary();

        // Lấy thông tin profile hiện tại từ DB ĐỂ LẤY URL ẢNH CŨ trước khi bị ghi đè
        TutorProfile oldTutorProfile = adminDAO.getTutorProfileByUserId(userId);

        // 1. Xử lý ảnh ĐẠI DIỆN mới & XÓA ẢNH CŨ
        Part portrait = request.getPart("portrait");
        String newAvatarUrl = null;
        if (portrait != null && portrait.getSize() > 0) {
            // Thực hiện xóa ảnh chân dung cũ trên Cloudinary nếu tồn tại URL cũ
            if (oldTutorProfile != null && oldTutorProfile.getPortraitUrl() != null) {
                deleteFileFromCloudinary(cloudinary, oldTutorProfile.getPortraitUrl());
            }

            // Upload ảnh chân dung mới
            byte[] data = portrait.getInputStream().readAllBytes();
            Map<?, ?> result = cloudinary.uploader().upload(data, ObjectUtils.emptyMap());
            newAvatarUrl = result.get("secure_url").toString();
        }

        // 2. Xử lý ảnh BẰNG CẤP mới & XÓA BẰNG CẤP CŨ
        java.util.List<String> newDegreeUrls = new java.util.ArrayList<>();
        try {
            boolean hasNewDegree = false;
            for (Part part : request.getParts()) {
                if ("degreePhotos".equals(part.getName()) && part.getSize() > 0) {
                    hasNewDegree = true;
                    break;
                }
            }

            // Nếu người dùng thực sự chọn tải lên bằng cấp mới -> Dọn sạch toàn bộ bằng cấp cũ
            if (hasNewDegree && oldTutorProfile != null && oldTutorProfile.getDegreeUrls() != null) {
                for (String oldUrl : oldTutorProfile.getDegreeUrls()) {
                    deleteFileFromCloudinary(cloudinary, oldUrl);
                }
            }

            // Tiến hành upload loạt bằng cấp mới lên Cloudinary
            for (Part part : request.getParts()) {
                if ("degreePhotos".equals(part.getName()) && part.getSize() > 0) {
                    byte[] data = part.getInputStream().readAllBytes();
                    Map<?, ?> result = cloudinary.uploader().upload(data, ObjectUtils.emptyMap());
                    newDegreeUrls.add(result.get("secure_url").toString());
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi hoặc không có tệp bằng cấp mới.");
        }

        // 3. Xử lý ảnh CCCD mới & XÓA CCCD CŨ
        java.util.List<String> newIdCardUrls = new java.util.ArrayList<>();
        try {
            boolean hasNewIdCard = false;
            for (Part part : request.getParts()) {
                if ("citizenPhotos".equals(part.getName()) && part.getSize() > 0) {
                    hasNewIdCard = true;
                    break;
                }
            }

            // Nếu người dùng tải lên CCCD mới -> Xóa ảnh CCCD mặt trước/sau cũ trên Cloudinary
            if (hasNewIdCard && oldTutorProfile != null && oldTutorProfile.getIdCardUrls() != null) {
                for (String oldUrl : oldTutorProfile.getIdCardUrls()) {
                    deleteFileFromCloudinary(cloudinary, oldUrl);
                }
            }

            // Upload loạt ảnh CCCD mới lên Cloudinary
            for (Part part : request.getParts()) {
                if ("citizenPhotos".equals(part.getName()) && part.getSize() > 0) {
                    byte[] data = part.getInputStream().readAllBytes();
                    Map<?, ?> result = cloudinary.uploader().upload(data, ObjectUtils.emptyMap());
                    newIdCardUrls.add(result.get("secure_url").toString());
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi hoặc không có tệp căn cước công dân mới.");
        }

        // Gọi DAO cập nhật dữ liệu xuống MySQL
        boolean isUpdated = registrationDAO.updateTutorProfile(
                userId, tutorId, request, newAvatarUrl, newDegreeUrls, newIdCardUrls, hourlyRate
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

    /**
     * HÀM TIỆN ÍCH: Tự động tách public_id từ URL và gọi lệnh xóa file trên Cloudinary
     */
    private void deleteFileFromCloudinary(Cloudinary cloudinary, String fileUrl) {
        if (fileUrl == null || fileUrl.isBlank() || !fileUrl.contains("cloudinary.com")) {
            return;
        }
        try {
            // Ví dụ: https://res.cloudinary.com/demo/image/upload/v12345/folder/name.png
            // Bóc tách lấy: folder/name
            int uploadIndex = fileUrl.indexOf("/upload/");
            if (uploadIndex != -1) {
                String subStr = fileUrl.substring(uploadIndex + 8); // Cắt bỏ phần đầu đến hết "/upload/"
                int versionIndex = subStr.indexOf("/");

                // Nếu có chuỗi version v123456789/ thì cắt bỏ tiếp
                if (subStr.substring(0, versionIndex).startsWith("v")) {
                    subStr = subStr.substring(versionIndex + 1);
                }

                // Cắt bỏ phần mở rộng định dạng file (.jpg, .png, ...)
                int dotIndex = subStr.lastIndexOf(".");
                if (dotIndex != -1) {
                    String publicId = subStr.substring(0, dotIndex);

                    // Thực thi lệnh xóa trực tiếp trên Cloudinary Cloud
                    Map<?, ?> deleteResult = cloudinary.uploader().destroy(publicId, ObjectUtils.emptyMap());
                    System.out.println(">>> CLOUDINARY DELETE LOG: File " + publicId + " -> " + deleteResult.get("result"));
                }
            }
        } catch (Exception e) {
            System.err.println(">>> KHÔNG THỂ XÓA FILE TRÊN CLOUDINARY: " + fileUrl);
            e.printStackTrace();
        }
    }
}