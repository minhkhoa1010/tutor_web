package vn.edu.nlu.fit.tutorweb.controller;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.nlu.fit.tutorweb.dao.UserDAO;
import vn.edu.nlu.fit.tutorweb.entity.UserSession;
import vn.edu.nlu.fit.tutorweb.utils.CloudinaryConfig;

import java.io.IOException;
import java.util.Map;

@WebServlet("/profile/upload-avatar")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class UploadAvatarServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        UserSession userSession = (UserSession) session.getAttribute("clientUser");

        // Nhận tham số ẩn để biết sau khi upload xong thì chuyển hướng (redirect) về trang nào
        String redirectUrl = request.getParameter("redirect");
        if (redirectUrl == null || redirectUrl.isEmpty()) {
            redirectUrl = "/parent/profile"; // Mặc định phòng hờ
        }

        if (userSession == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            Part part = request.getPart("avatarFile");
            if (part != null && part.getSize() > 0) {

                // BƯỚC 1: XÓA ẢNH CŨ TRÊN CLOUDINARY
                String oldAvatarUrl = userSession.getAvatarUrl();
                if (oldAvatarUrl != null && !oldAvatarUrl.contains("default-avatar.png") && !oldAvatarUrl.isEmpty()) {
                    try {
                        String publicId = CloudinaryConfig.getPublicIdFromUrl(oldAvatarUrl);
                        if (publicId != null) {
                            CloudinaryConfig.getCloudinary().uploader().destroy(publicId, ObjectUtils.emptyMap());
                            System.out.println("🔥 Đã giải phóng ảnh cũ trên Cloudinary: " + publicId);
                        }
                    } catch (Exception e) {
                        System.err.println("Không xóa được ảnh cũ: " + e.getMessage());
                    }
                }

                // BƯỚC 2: UPLOAD ẢNH MỚI LÊN CLOUDINARY
                Cloudinary cloudinary = CloudinaryConfig.getCloudinary();
                byte[] data = part.getInputStream().readAllBytes();

                Map<?, ?> uploadResult = cloudinary.uploader().upload(data, ObjectUtils.emptyMap());
                String newAvatarUrl = (String) uploadResult.get("secure_url");

                // BƯỚC 3: CẬP NHẬT VÀO DATABASE BẢNG USERS
                boolean isUpdated = userDAO.updateAvatarUrl(userSession.getId(), newAvatarUrl);

                if (isUpdated) {
                    // Đồng bộ ngay lập tức vào Session để thanh Header và Avatar đổi diện mạo luôn
                    userSession.setAvatarUrl(newAvatarUrl);
                    session.setAttribute("clientUser", userSession);
                    session.setAttribute("msgSuccess", "Cập nhật ảnh đại diện mới thành công! 🎉");
                } else {
                    session.setAttribute("msgError", "Lỗi: Không thể lưu đường dẫn ảnh vào cơ sở dữ liệu.");
                }
            } else {
                session.setAttribute("msgError", "Vui lòng chọn một tệp hình ảnh hợp lệ để tải lên.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("msgError", "Hệ thống gặp lỗi khi upload: " + e.getLocalizedMessage());
        }

        // Quay trở lại trang ban đầu (Có thể là trang Gia sư hoặc Phụ huynh tùy biến)
        response.sendRedirect(request.getContextPath() + redirectUrl);
    }
}