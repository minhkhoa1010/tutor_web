package vn.edu.nlu.fit.tutorweb.service;

import vn.edu.nlu.fit.tutorweb.dao.ChatDAO;
import vn.edu.nlu.fit.tutorweb.dto.ChatAttachmentPayload;
import vn.edu.nlu.fit.tutorweb.entity.ChatConversation;
import vn.edu.nlu.fit.tutorweb.entity.ChatMessage;

import java.util.List;

public class ChatService {
    private final ChatDAO chatDAO = new ChatDAO();

    public long createOrGetConversation(long userId, Long bookingId, Long tutorId) {
        long allowedBookingId = chatDAO.findAllowedBookingId(userId, bookingId, tutorId)
                .orElseThrow(() -> new IllegalArgumentException("Bạn chỉ có thể nhắn tin với gia sư đã kết nối."));
        return chatDAO.createOrGetConversation(allowedBookingId, userId);
    }

    public List<ChatConversation> listConversations(long userId, String keyword) {
        return chatDAO.listConversations(userId, keyword);
    }

    public List<ChatMessage> listMessages(long conversationId, long userId, Long afterId) {
        ensureMember(conversationId, userId);
        List<ChatMessage> messages = chatDAO.listMessages(conversationId, userId, afterId);
        if (!messages.isEmpty()) {
            chatDAO.markRead(conversationId, userId, messages.get(messages.size() - 1).getId());
        }
        return messages;
    }

    public ChatMessage sendMessage(long conversationId, long senderId, String clientMessageId, String messageType,
                                   String content, ChatAttachmentPayload attachment) {
        ensureMember(conversationId, senderId);
        if (chatDAO.isBlocked(conversationId, senderId)) {
            throw new IllegalArgumentException("Bạn không thể gửi tin nhắn vì một trong hai bên đã chặn cuộc trò chuyện.");
        }

        boolean hasText = content != null && !content.trim().isEmpty();
        boolean hasFile = attachment != null && attachment.getFileUrl() != null && !attachment.getFileUrl().isBlank();
        if (!hasText && !hasFile) {
            throw new IllegalArgumentException("Nội dung tin nhắn không được để trống.");
        }

        String normalizedType = normalizeMessageType(messageType, attachment);
        String normalizedContent = hasText ? content.trim() : null;
        return chatDAO.sendMessage(conversationId, senderId, clientMessageId, normalizedType, normalizedContent, attachment);
    }

    public void markRead(long conversationId, long userId, long lastReadMessageId) {
        ensureMember(conversationId, userId);
        chatDAO.markRead(conversationId, userId, lastReadMessageId);
    }

    public boolean recallMessage(long messageId, long senderId) {
        return chatDAO.recallMessage(messageId, senderId);
    }

    public List<Long> listMemberUserIds(long conversationId, long userId) {
        ensureMember(conversationId, userId);
        return chatDAO.listMemberUserIds(conversationId);
    }

    public void deleteConversation(long conversationId, long userId) {
        ensureMember(conversationId, userId);
        chatDAO.deleteConversationForUser(conversationId, userId);
    }

    private void ensureMember(long conversationId, long userId) {
        if (!chatDAO.isConversationMember(conversationId, userId)) {
            throw new SecurityException("Bạn không có quyền truy cập cuộc trò chuyện này.");
        }
    }

    private String normalizeMessageType(String messageType, ChatAttachmentPayload attachment) {
        if (attachment != null && attachment.getAttachmentType() != null) {
            if ("IMAGE".equalsIgnoreCase(attachment.getAttachmentType())) {
                return "IMAGE";
            }
            return "FILE";
        }
        if (messageType == null || messageType.isBlank()) {
            return "TEXT";
        }
        String type = messageType.trim().toUpperCase();
        return switch (type) {
            case "IMAGE", "FILE" -> type;
            default -> "TEXT";
        };
    }
}
