package vn.edu.nlu.fit.tutorweb.controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import vn.edu.nlu.fit.tutorweb.dto.ChatAttachmentPayload;
import vn.edu.nlu.fit.tutorweb.entity.UserSession;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

@WebServlet("/api/chat/upload")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 20,
        maxRequestSize = 1024 * 1024 * 25
)
public class ChatUploadServlet extends HttpServlet {
    private static final Set<String> ALLOWED_EXTENSIONS = Set.of(
            "jpg", "jpeg", "png", "webp", "gif", "pdf", "doc", "docx", "ppt", "pptx", "xls", "xlsx", "txt"
    );
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");

        HttpSession session = req.getSession(false);
        UserSession user = session != null ? (UserSession) session.getAttribute("clientUser") : null;
        if (user == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write(gson.toJson(Map.of("success", false, "message", "Vui lòng đăng nhập.")));
            return;
        }

        Part filePart = req.getPart("file");
        if (filePart == null || filePart.getSize() <= 0) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write(gson.toJson(Map.of("success", false, "message", "Vui lòng chọn file.")));
            return;
        }

        String originalName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String extension = getExtension(originalName);
        if (!ALLOWED_EXTENSIONS.contains(extension)) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write(gson.toJson(Map.of("success", false, "message", "Định dạng file không được hỗ trợ.")));
            return;
        }

        String uploadRoot = getServletContext().getRealPath("/uploads/chat");
        File folder = new File(uploadRoot);
        if (!folder.exists() && !folder.mkdirs()) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write(gson.toJson(Map.of("success", false, "message", "Không thể tạo thư mục upload.")));
            return;
        }

        String storedName = System.currentTimeMillis() + "_" + UUID.randomUUID() + "." + extension;
        File target = new File(folder, storedName);
        filePart.write(target.getAbsolutePath());

        String contentType = filePart.getContentType() != null ? filePart.getContentType() : "application/octet-stream";
        ChatAttachmentPayload payload = new ChatAttachmentPayload();
        payload.setFileName(originalName);
        payload.setFileUrl(req.getContextPath() + "/uploads/chat/" + storedName);
        payload.setFileType(contentType);
        payload.setFileSize(filePart.getSize());
        payload.setAttachmentType(contentType.startsWith("image/") ? "IMAGE" : "DOCUMENT");

        resp.getWriter().write(gson.toJson(Map.of("success", true, "data", payload)));
    }

    private String getExtension(String fileName) {
        int index = fileName == null ? -1 : fileName.lastIndexOf('.');
        if (index < 0 || index == fileName.length() - 1) {
            return "";
        }
        return fileName.substring(index + 1).toLowerCase();
    }
}
