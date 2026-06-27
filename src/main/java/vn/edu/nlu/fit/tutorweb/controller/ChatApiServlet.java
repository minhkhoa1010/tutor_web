package vn.edu.nlu.fit.tutorweb.controller;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.nlu.fit.tutorweb.dto.ChatAttachmentPayload;
import vn.edu.nlu.fit.tutorweb.entity.UserSession;
import vn.edu.nlu.fit.tutorweb.service.ChatService;
import vn.edu.nlu.fit.tutorweb.websocket.ChatSocketHub;

import java.io.IOException;
import java.util.Map;

@WebServlet("/api/chat/*")
public class ChatApiServlet extends HttpServlet {
    private final Gson gson = new Gson();
    private final ChatService chatService = new ChatService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserSession user = currentUser(req, resp);
        if (user == null) return;

        try {
            String path = path(req);
            if ("/conversations".equals(path)) {
                writeJson(resp, Map.of("success", true, "data",
                        chatService.listConversations(user.getId(), req.getParameter("keyword"))));
                return;
            }

            if ("/messages".equals(path)) {
                long conversationId = parseLong(req.getParameter("conversationId"), "conversationId");
                Long afterId = optionalLong(req.getParameter("afterId"));
                writeJson(resp, Map.of("success", true, "data",
                        chatService.listMessages(conversationId, user.getId(), afterId)));
                return;
            }

            error(resp, HttpServletResponse.SC_NOT_FOUND, "API không tồn tại.");
        } catch (Exception e) {
            handleError(resp, e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        UserSession user = currentUser(req, resp);
        if (user == null) return;

        try {
            String path = path(req);
            if ("/conversations".equals(path)) {
                ConversationRequest body = readBody(req, ConversationRequest.class);
                long conversationId = chatService.createOrGetConversation(user.getId(), body.bookingId, body.tutorId);
                writeJson(resp, Map.of("success", true, "conversationId", conversationId));
                return;
            }

            if ("/messages".equals(path)) {
                SendMessageRequest body = readBody(req, SendMessageRequest.class);
                var message = chatService.sendMessage(
                        body.conversationId,
                        user.getId(),
                        body.clientMessageId,
                        body.messageType,
                        body.content,
                        body.attachment
                );
                ChatSocketHub.broadcastNewMessage(
                        message,
                        chatService.listMemberUserIds(body.conversationId, user.getId())
                );
                writeJson(resp, Map.of("success", true, "data", message));
                return;
            }

            if ("/read".equals(path)) {
                ReadRequest body = readBody(req, ReadRequest.class);
                chatService.markRead(body.conversationId, user.getId(), body.lastReadMessageId);
                ChatSocketHub.broadcastConversationChanged(
                        body.conversationId,
                        chatService.listMemberUserIds(body.conversationId, user.getId()),
                        "READ_MESSAGE"
                );
                writeJson(resp, Map.of("success", true));
                return;
            }

            if ("/recall".equals(path)) {
                RecallRequest body = readBody(req, RecallRequest.class);
                boolean ok = chatService.recallMessage(body.messageId, user.getId());
                if (ok && body.conversationId > 0) {
                    ChatSocketHub.broadcastConversationChanged(
                            body.conversationId,
                            chatService.listMemberUserIds(body.conversationId, user.getId()),
                            "MESSAGE_RECALLED"
                    );
                }
                writeJson(resp, Map.of("success", ok, "message", ok ? "Đã thu hồi tin nhắn." : "Chỉ được thu hồi tin nhắn của bạn trong 5 phút."));
                return;
            }

            if ("/delete-conversation".equals(path)) {
                DeleteConversationRequest body = readBody(req, DeleteConversationRequest.class);
                chatService.deleteConversation(body.conversationId, user.getId());
                ChatSocketHub.broadcastConversationChanged(
                        body.conversationId,
                        chatService.listMemberUserIds(body.conversationId, user.getId()),
                        "CONVERSATION_CHANGED"
                );
                writeJson(resp, Map.of("success", true));
                return;
            }

            error(resp, HttpServletResponse.SC_NOT_FOUND, "API không tồn tại.");
        } catch (Exception e) {
            handleError(resp, e);
        }
    }

    private UserSession currentUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        UserSession user = session != null ? (UserSession) session.getAttribute("clientUser") : null;
        if (user == null) {
            error(resp, HttpServletResponse.SC_UNAUTHORIZED, "Vui lòng đăng nhập.");
            return null;
        }
        return user;
    }

    private String path(HttpServletRequest req) {
        String path = req.getPathInfo();
        return path == null ? "" : path;
    }

    private <T> T readBody(HttpServletRequest req, Class<T> type) throws IOException {
        try {
            return gson.fromJson(req.getReader(), type);
        } catch (JsonSyntaxException e) {
            throw new IllegalArgumentException("Dữ liệu gửi lên không hợp lệ.");
        }
    }

    private Long optionalLong(String value) {
        if (value == null || value.isBlank()) return null;
        return Long.parseLong(value);
    }

    private long parseLong(String value, String field) {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException("Thiếu " + field + ".");
        }
        return Long.parseLong(value);
    }

    private void writeJson(HttpServletResponse resp, Object data) throws IOException {
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");
        resp.getWriter().write(gson.toJson(data));
    }

    private void error(HttpServletResponse resp, int status, String message) throws IOException {
        resp.setStatus(status);
        writeJson(resp, Map.of("success", false, "message", message));
    }

    private void handleError(HttpServletResponse resp, Exception e) throws IOException {
        int status = e instanceof SecurityException ? HttpServletResponse.SC_FORBIDDEN : HttpServletResponse.SC_BAD_REQUEST;
        error(resp, status, e.getMessage() == null ? "Có lỗi xảy ra." : e.getMessage());
    }

    private static class ConversationRequest {
        Long bookingId;
        Long tutorId;
    }

    private static class SendMessageRequest {
        long conversationId;
        String clientMessageId;
        String messageType;
        String content;
        ChatAttachmentPayload attachment;
    }

    private static class ReadRequest {
        long conversationId;
        long lastReadMessageId;
    }

    private static class RecallRequest {
        long messageId;
        long conversationId;
    }

    private static class DeleteConversationRequest {
        long conversationId;
    }
}
