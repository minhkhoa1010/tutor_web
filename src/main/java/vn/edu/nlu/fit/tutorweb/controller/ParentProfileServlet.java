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



@WebServlet("/parent/profile")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class ParentProfileController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserSession userSession = (UserSession) session.getAttribute("clientUser");

        if (userSession == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // GỌI HÀM TỪ DAO (An toàn và sạch code)
        String phone = userDAO.getPhoneByUserId(userSession.getId());

        request.setAttribute("userPhone", phone);
        request.getRequestDispatcher("/views/parent/profile.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        UserSession userSession = (UserSession) session.getAttribute("clientUser");

        if (userSession == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String actionType = request.getParameter("actionType");

        // 1. TRƯỜNG HỢP: UPLOAD AVATAR LÊN CLOUDINARY
        if ("updateAvatar".equals(actionType)) {
            try {
                Part part = request.getPart("avatarFile");
                if (part != null && part.getSize() > 0) {

                    // --- BƯỚC 1: XÓA ẢNH CŨ (NẾU CÓ) ---
                    String oldAvatarUrl = userSession.getAvatarUrl();
                    if (oldAvatarUrl != null && !oldAvatarUrl.contains("default-avatar.png") && !oldAvatarUrl.isEmpty()) {
                        try {
                            String publicId = extractPublicId(oldAvatarUrl);
                            CloudinaryConfig.getCloudinary().uploader().destroy(publicId, ObjectUtils.emptyMap());
                        } catch (Exception e) {
                            System.err.println("Không xóa được ảnh cũ trên Cloudinary: " + e.getMessage());
                        }
                    }

                    // --- BƯỚC 2: UPLOAD ẢNH MỚI ---
                    Cloudinary cloudinary = CloudinaryConfig.getCloudinary();
                    byte[] data = part.getInputStream().readAllBytes();
                    Map<?, ?> uploadResult = cloudinary.uploader().upload(data, ObjectUtils.emptyMap());
                    String avatarUrl = (String) uploadResult.get("secure_url");

                    // --- BƯỚC 3: CẬP NHẬT DATABASE ---
                    if (userDAO.updateAvatarUrl(userSession.getId(), avatarUrl)) {
                        userSession.setAvatarUrl(avatarUrl);
                        session.setAttribute("clientUser", userSession);
                        session.setAttribute("msgSuccess", "Cập nhật ảnh đại diện thành công!");
                    } else {
                        session.setAttribute("msgError", "Lỗi cập nhật CSDL.");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("msgError", "Lỗi upload ảnh: " + e.getLocalizedMessage());
            }
        }

        // 2. TRƯỜNG HỢP: CẬP NHẬT THÔNG TIN CHỮ (FULLNAME, PHONE, USERNAME, EMAIL)
        else if ("updateTextInfo".equals(actionType)) {
            String fullname = request.getParameter("fullname");
            String phone = request.getParameter("phone");
            String username = request.getParameter("username");
            String email = request.getParameter("email");

            // Validate cơ bản
            if (fullname == null || fullname.trim().isEmpty() || username == null || username.trim().isEmpty() || email == null || email.trim().isEmpty()) {
                session.setAttribute("msgError", "Thông tin bắt buộc không được để trống!");
            } else {
                try {
                    long userId = userSession.getId();
                    fullname = fullname.trim();
                    phone = (phone != null) ? phone.trim() : "";
                    username = username.trim().toLowerCase();
                    email = email.trim().toLowerCase();

                    // Kiểm tra trùng lặp
                    if (userDAO.isUsernameExisted(username, userId)) {
                        session.setAttribute("msgError", "Username này đã có người sử dụng!");
                    } else if (userDAO.isEmailExisted(email, userId)) {
                        session.setAttribute("msgError", "Email này đã được đăng ký bởi tài khoản khác!");
                    } else if (!phone.isEmpty() && userDAO.isPhoneExisted(phone, userId)) {
                        session.setAttribute("msgError", "Số điện thoại này đã tồn tại!");
                    } else {
                        // Thực hiện update
                        boolean success = userDAO.updateFullProfile(userId, fullname, phone, username, email);
                        if (success) {
                            userSession.setFullname(fullname);
                            userSession.setPhone(phone);
                            userSession.setUsername(username);
                            userSession.setEmail(email);
                            session.setAttribute("clientUser", userSession);
                            session.setAttribute("msgSuccess", "Cập nhật thành công!");
                        }else {
                            session.setAttribute("msgError", "Cập nhật thất bại, vui lòng thử lại.");
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    session.setAttribute("msgError", "Lỗi hệ thống: " + e.getLocalizedMessage());
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/parent/profile");
    }

    // Phương thức hỗ trợ để lấy PublicID từ URL
    private String extractPublicId(String url) {
        if (url == null || url.isEmpty()) return null;
        try {
            // Ví dụ URL: .../upload/v123456/sample_image.jpg
            // Ta cần lấy "sample_image"
            String[] parts = url.split("/");
            String filename = parts[parts.length - 1]; // "sample_image.jpg"
            return filename.substring(0, filename.lastIndexOf('.')); // "sample_image"
        } catch (Exception e) {
            return null;
        }
    }
}