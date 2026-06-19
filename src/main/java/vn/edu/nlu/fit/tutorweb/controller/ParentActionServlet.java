package vn.edu.nlu.fit.tutorweb.controller;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.nlu.fit.tutorweb.service.BookingService;
import vn.edu.nlu.fit.tutorweb.utils.CloudinaryConfig;

import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

@WebServlet("/booking/parent-action")
// THÊM MỚI: Bắt buộc phải có Annotation này để Servlet chấp nhận và phân tách dữ liệu Multipart (dung lượng tối đa 10MB)
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class ParentActionServlet extends HttpServlet {

    private final BookingService bookingService = new BookingService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        // 1. Kiểm tra session bảo mật của Phụ huynh
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("clientUser") == null) {
            resp.getWriter().write("{\"status\":\"ERR\",\"message\":\"Phiên đăng nhập đã hết hạn!\"}");
            return;
        }

        // 2. Đọc dữ liệu từ Frontend gửi lên (Hỗ trợ đọc dữ liệu từ Multipart form)
        String bookingIdParam = req.getParameter("bookingId");
        String action = req.getParameter("action");
        String reason = req.getParameter("reason");

        // Dự phòng trường hợp một số phiên bản máy chủ Servlet cũ yêu cầu lấy text field từ Part khi dùng mã hóa Multipart
        if (bookingIdParam == null && req.getPart("bookingId") != null) {
            bookingIdParam = new String(req.getPart("bookingId").getInputStream().readAllBytes(), "UTF-8").trim();
            action = new String(req.getPart("action").getInputStream().readAllBytes(), "UTF-8").trim();
            Part reasonPart = req.getPart("reason");
            reason = (reasonPart != null) ? new String(reasonPart.getInputStream().readAllBytes(), "UTF-8").trim() : null;
        }

        if (bookingIdParam == null || action == null) {
            resp.getWriter().write("{\"status\":\"ERR\",\"message\":\"Dữ liệu gửi lên không hợp lệ!\"}");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdParam);
            boolean result = false;

            // 3. Phân nhánh xử lý theo từng loại Action gửi lên
            switch (action) {
                case "COMPLETE_DIRECT":
                case "APPROVE":
                    result = bookingService.handleCompleteBooking(bookingId);
                    break;
                case "REJECT_COMPLETE":
                    result = bookingService.handleRejectCompleteBooking(bookingId);
                    break;
                case "DISPUTE":
                    if (reason == null || reason.trim().isBlank()) {
                        resp.getWriter().write("{\"status\":\"ERR\",\"message\":\"Lý do khiếu nại không được để trống!\"}");
                        return;
                    }

                    String evidenceUrl = null;
                    Part filePart = req.getPart("evidenceFile");

                    // Tiến hành upload file lên Cloudinary nếu phụ huynh có đính kèm tệp
                    if (filePart != null && filePart.getSize() > 0) {
                        try {
                            Cloudinary cloudinary = CloudinaryConfig.getCloudinary();
                            InputStream fileContent = filePart.getInputStream();
                            byte[] fileBytes = fileContent.readAllBytes();

                            // CẤU HÌNH QUAN TRỌNG: "resource_type" -> "auto" cho phép nhận diện cả file ảnh (png, jpg) lẫn văn bản (pdf, docx)
                            Map uploadResult = cloudinary.uploader().upload(fileBytes, ObjectUtils.asMap(
                                    "folder", "tutor_web/complaints",
                                    "resource_type", "auto"
                            ));

                            // Lấy URL tuyệt đối trả về từ Cloudinary để lưu xuống Database
                            if (uploadResult != null && uploadResult.containsKey("secure_url")) {
                                evidenceUrl = (String) uploadResult.get("secure_url");
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            resp.getWriter().write("{\"status\":\"ERR\",\"message\":\"Lỗi tải tệp minh chứng lên Cloudinary: " + e.getMessage() + "\"}");
                            return;
                        }
                    }

                    // Gọi hàm nghiệp vụ cập nhật (Lưu ý: Nhớ bổ sung đối số 'evidenceUrl' vào hàm handleDisputeBooking ở Service của ông nhé!)
                    result = bookingService.handleDisputeBooking(bookingId, reason.trim(), "PARENT", evidenceUrl);
                    break;

                default:
                    resp.getWriter().write("{\"status\":\"ERR\",\"message\":\"Hành động không hỗ trợ!\"}");
                    return;
            }

            // 4. Phản hồi kết quả về cho client dạng JSON
            if (result) {
                resp.getWriter().write("{\"status\":\"SUCCESS\"}");
            } else {
                resp.getWriter().write("{\"status\":\"ERR\",\"message\":\"Cập nhật trạng thái vào cơ sở dữ liệu thất bại!\"}");
            }

        } catch (NumberFormatException e) {
            resp.getWriter().write("{\"status\":\"ERR\",\"message\":\"ID hợp đồng phải là số!\"}");
        }
    }
}