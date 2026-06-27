package vn.edu.nlu.fit.tutorweb.dao;

import org.jdbi.v3.core.Jdbi;
import vn.edu.nlu.fit.tutorweb.db.DBConnect;
import vn.edu.nlu.fit.tutorweb.dto.ChatAttachmentPayload;
import vn.edu.nlu.fit.tutorweb.entity.ChatConversation;
import vn.edu.nlu.fit.tutorweb.entity.ChatMessage;

import java.util.List;
import java.util.Optional;

public class ChatDAO {
    private final Jdbi jdbi = DBConnect.get();

    public ChatDAO() {
        ensureSchema();
    }

    private void ensureSchema() {
        jdbi.useHandle(h -> {
            h.execute("""
                CREATE TABLE IF NOT EXISTS conversations (
                    id BIGINT NOT NULL AUTO_INCREMENT,
                    booking_id BIGINT NULL,
                    conversation_type VARCHAR(20) NOT NULL DEFAULT 'DIRECT',
                    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
                    last_message_id BIGINT NULL,
                    last_message_at TIMESTAMP NULL DEFAULT NULL,
                    created_by BIGINT NOT NULL,
                    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                    PRIMARY KEY (id),
                    UNIQUE KEY uk_conversations_booking (booking_id),
                    KEY idx_conversations_last_message_at (last_message_at),
                    CONSTRAINT fk_conversations_booking FOREIGN KEY (booking_id) REFERENCES bookings(id),
                    CONSTRAINT fk_conversations_created_by FOREIGN KEY (created_by) REFERENCES users(id)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci
            """);

            h.execute("""
                CREATE TABLE IF NOT EXISTS conversation_members (
                    id BIGINT NOT NULL AUTO_INCREMENT,
                    conversation_id BIGINT NOT NULL,
                    user_id BIGINT NOT NULL,
                    role_in_conversation VARCHAR(20) NOT NULL,
                    joined_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                    left_at TIMESTAMP NULL DEFAULT NULL,
                    is_muted TINYINT(1) NOT NULL DEFAULT 0,
                    is_deleted TINYINT(1) NOT NULL DEFAULT 0,
                    deleted_at TIMESTAMP NULL DEFAULT NULL,
                    last_read_message_id BIGINT NULL,
                    last_read_at TIMESTAMP NULL DEFAULT NULL,
                    PRIMARY KEY (id),
                    UNIQUE KEY uk_conversation_member (conversation_id, user_id),
                    KEY idx_conversation_members_user (user_id),
                    CONSTRAINT fk_cm_conversation FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE,
                    CONSTRAINT fk_cm_user FOREIGN KEY (user_id) REFERENCES users(id)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci
            """);

            h.execute("""
                CREATE TABLE IF NOT EXISTS messages (
                    id BIGINT NOT NULL AUTO_INCREMENT,
                    conversation_id BIGINT NOT NULL,
                    sender_id BIGINT NOT NULL,
                    client_message_id VARCHAR(100) NULL,
                    message_type VARCHAR(20) NOT NULL DEFAULT 'TEXT',
                    content TEXT NULL,
                    status VARCHAR(20) NOT NULL DEFAULT 'SENT',
                    sent_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                    recalled_at TIMESTAMP NULL DEFAULT NULL,
                    deleted_at TIMESTAMP NULL DEFAULT NULL,
                    PRIMARY KEY (id),
                    UNIQUE KEY uk_sender_client_message (sender_id, client_message_id),
                    KEY idx_messages_conversation_id (conversation_id, id),
                    CONSTRAINT fk_messages_conversation FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE,
                    CONSTRAINT fk_messages_sender FOREIGN KEY (sender_id) REFERENCES users(id)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci
            """);

            h.execute("""
                CREATE TABLE IF NOT EXISTS message_attachments (
                    id BIGINT NOT NULL AUTO_INCREMENT,
                    message_id BIGINT NOT NULL,
                    file_name VARCHAR(255) NOT NULL,
                    file_url VARCHAR(500) NOT NULL,
                    file_type VARCHAR(100) NOT NULL,
                    file_size BIGINT NOT NULL,
                    attachment_type VARCHAR(20) NOT NULL,
                    storage_provider VARCHAR(50) NOT NULL DEFAULT 'LOCAL',
                    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                    PRIMARY KEY (id),
                    KEY idx_attachments_message (message_id),
                    CONSTRAINT fk_attachments_message FOREIGN KEY (message_id) REFERENCES messages(id) ON DELETE CASCADE
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci
            """);

            h.execute("""
                CREATE TABLE IF NOT EXISTS message_status (
                    id BIGINT NOT NULL AUTO_INCREMENT,
                    message_id BIGINT NOT NULL,
                    user_id BIGINT NOT NULL,
                    status VARCHAR(20) NOT NULL DEFAULT 'DELIVERED',
                    delivered_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
                    read_at TIMESTAMP NULL DEFAULT NULL,
                    PRIMARY KEY (id),
                    UNIQUE KEY uk_message_status_user (message_id, user_id),
                    KEY idx_message_status_user (user_id, status),
                    CONSTRAINT fk_status_message FOREIGN KEY (message_id) REFERENCES messages(id) ON DELETE CASCADE,
                    CONSTRAINT fk_status_user FOREIGN KEY (user_id) REFERENCES users(id)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci
            """);

            h.execute("""
                CREATE TABLE IF NOT EXISTS notifications (
                    id BIGINT NOT NULL AUTO_INCREMENT,
                    user_id BIGINT NOT NULL,
                    conversation_id BIGINT NULL,
                    message_id BIGINT NULL,
                    type VARCHAR(30) NOT NULL,
                    title VARCHAR(255) NOT NULL,
                    content TEXT NULL,
                    is_read TINYINT(1) NOT NULL DEFAULT 0,
                    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                    read_at TIMESTAMP NULL DEFAULT NULL,
                    PRIMARY KEY (id),
                    KEY idx_notifications_user (user_id, is_read),
                    CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES users(id)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci
            """);

            h.execute("""
                CREATE TABLE IF NOT EXISTS user_blocks (
                    id BIGINT NOT NULL AUTO_INCREMENT,
                    blocker_id BIGINT NOT NULL,
                    blocked_id BIGINT NOT NULL,
                    reason VARCHAR(255) NULL,
                    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                    PRIMARY KEY (id),
                    UNIQUE KEY uk_user_block (blocker_id, blocked_id),
                    CONSTRAINT fk_blocks_blocker FOREIGN KEY (blocker_id) REFERENCES users(id),
                    CONSTRAINT fk_blocks_blocked FOREIGN KEY (blocked_id) REFERENCES users(id)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci
            """);
        });
    }

    public Optional<Long> findAllowedBookingId(long userId, Long bookingId, Long tutorId) {
        if (bookingId != null) {
            String sql = """
                SELECT b.id
                FROM bookings b
                JOIN tutors t ON b.tutor_id = t.id
                WHERE b.id = :bookingId
                  AND b.status IN ('ACTIVE', 'PAID', 'PENDING_COMPLETED', 'DISPUTED', 'COMPLETED')
                  AND (b.parent_id = :userId OR t.user_id = :userId)
                LIMIT 1
            """;
            return jdbi.withHandle(h -> h.createQuery(sql)
                    .bind("bookingId", bookingId)
                    .bind("userId", userId)
                    .mapTo(Long.class)
                    .findOne());
        }

        if (tutorId != null) {
            String sql = """
                SELECT b.id
                FROM bookings b
                JOIN tutors t ON b.tutor_id = t.id
                WHERE b.parent_id = :userId
                  AND b.tutor_id = :tutorId
                  AND b.status IN ('ACTIVE', 'PAID', 'PENDING_COMPLETED', 'DISPUTED', 'COMPLETED')
                ORDER BY FIELD(b.status, 'ACTIVE', 'PAID', 'PENDING_COMPLETED', 'DISPUTED', 'COMPLETED'), b.id DESC
                LIMIT 1
            """;
            return jdbi.withHandle(h -> h.createQuery(sql)
                    .bind("userId", userId)
                    .bind("tutorId", tutorId)
                    .mapTo(Long.class)
                    .findOne());
        }

        return Optional.empty();
    }

    public long createOrGetConversation(long bookingId, long createdBy) {
        return jdbi.inTransaction(h -> {
            Optional<Long> existing = h.createQuery("SELECT id FROM conversations WHERE booking_id = :bookingId")
                    .bind("bookingId", bookingId)
                    .mapTo(Long.class)
                    .findOne();
            if (existing.isPresent()) {
                h.createUpdate("""
                    UPDATE conversation_members
                    SET is_deleted = 0, deleted_at = NULL
                    WHERE conversation_id = :conversationId AND user_id = :userId
                """).bind("conversationId", existing.get()).bind("userId", createdBy).execute();
                return existing.get();
            }

            h.createUpdate("""
                INSERT INTO conversations (booking_id, conversation_type, status, created_by)
                VALUES (:bookingId, 'DIRECT', 'ACTIVE', :createdBy)
            """).bind("bookingId", bookingId).bind("createdBy", createdBy).execute();

            long conversationId = h.createQuery("SELECT LAST_INSERT_ID()")
                    .mapTo(Long.class)
                    .one();

            long[] booking = h.createQuery("""
                SELECT b.parent_id AS parentId, t.user_id AS tutorUserId
                FROM bookings b
                JOIN tutors t ON b.tutor_id = t.id
                WHERE b.id = :bookingId
            """).bind("bookingId", bookingId)
                    .map((rs, ctx) -> new long[]{rs.getLong("parentId"), rs.getLong("tutorUserId")})
                    .one();

            long parentId = booking[0];
            long tutorUserId = booking[1];

            h.createUpdate("""
                INSERT INTO conversation_members (conversation_id, user_id, role_in_conversation)
                VALUES (:conversationId, :userId, :role)
            """).bind("conversationId", conversationId).bind("userId", parentId).bind("role", "PARENT").execute();

            h.createUpdate("""
                INSERT INTO conversation_members (conversation_id, user_id, role_in_conversation)
                VALUES (:conversationId, :userId, :role)
            """).bind("conversationId", conversationId).bind("userId", tutorUserId).bind("role", "TUTOR").execute();

            return conversationId;
        });
    }

    public boolean isConversationMember(long conversationId, long userId) {
        return jdbi.withHandle(h -> h.createQuery("""
            SELECT COUNT(*)
            FROM conversation_members
            WHERE conversation_id = :conversationId AND user_id = :userId
        """).bind("conversationId", conversationId).bind("userId", userId).mapTo(Integer.class).one() > 0);
    }

    public List<Long> listMemberUserIds(long conversationId) {
        return jdbi.withHandle(h -> h.createQuery("""
            SELECT user_id
            FROM conversation_members
            WHERE conversation_id = :conversationId
        """).bind("conversationId", conversationId).mapTo(Long.class).list());
    }

    public boolean isBlocked(long conversationId, long senderId) {
        return jdbi.withHandle(h -> h.createQuery("""
            SELECT COUNT(*)
            FROM conversation_members cm
            JOIN user_blocks ub
              ON (ub.blocker_id = cm.user_id AND ub.blocked_id = :senderId)
              OR (ub.blocker_id = :senderId AND ub.blocked_id = cm.user_id)
            WHERE cm.conversation_id = :conversationId
              AND cm.user_id <> :senderId
        """).bind("conversationId", conversationId).bind("senderId", senderId).mapTo(Integer.class).one() > 0);
    }

    public List<ChatConversation> listConversations(long userId, String keyword) {
        String like = keyword == null || keyword.isBlank() ? null : "%" + keyword.trim() + "%";
        String sql = """
            SELECT
                c.id,
                c.booking_id AS bookingId,
                c.status,
                other_u.id AS otherUserId,
                other_u.fullname AS otherFullname,
                other_u.avatar_url AS otherAvatarUrl,
                other_cm.role_in_conversation AS otherRole,
                b.subject_name AS subjectName,
                CASE
                    WHEN lm.status = 'RECALLED' THEN 'Tin nhắn đã được thu hồi'
                    WHEN lm.message_type = 'IMAGE' THEN 'Đã gửi hình ảnh'
                    WHEN lm.message_type = 'FILE' THEN 'Đã gửi tài liệu'
                    ELSE lm.content
                END AS lastMessage,
                lm.message_type AS lastMessageType,
                DATE_FORMAT(c.last_message_at, '%H:%i %d/%m/%Y') AS lastMessageAt,
                COALESCE((
                    SELECT COUNT(*)
                    FROM messages unread_m
                    WHERE unread_m.conversation_id = c.id
                      AND unread_m.sender_id <> :userId
                      AND unread_m.status = 'SENT'
                      AND unread_m.id > COALESCE(my_cm.last_read_message_id, 0)
                ), 0) AS unreadCount
            FROM conversations c
            JOIN conversation_members my_cm ON my_cm.conversation_id = c.id AND my_cm.user_id = :userId
            JOIN conversation_members other_cm ON other_cm.conversation_id = c.id AND other_cm.user_id <> :userId
            JOIN users other_u ON other_u.id = other_cm.user_id
            LEFT JOIN bookings b ON b.id = c.booking_id
            LEFT JOIN messages lm ON lm.id = c.last_message_id
            WHERE my_cm.is_deleted = 0
              AND (:keyword IS NULL OR other_u.fullname LIKE :keyword OR b.subject_name LIKE :keyword OR lm.content LIKE :keyword)
            ORDER BY COALESCE(c.last_message_at, c.created_at) DESC
        """;

        return jdbi.withHandle(h -> h.createQuery(sql)
                .bind("userId", userId)
                .bind("keyword", like)
                .mapToBean(ChatConversation.class)
                .list());
    }

    public List<ChatMessage> listMessages(long conversationId, long userId, Long afterId) {
        String sql = """
            SELECT
                m.id,
                m.conversation_id AS conversationId,
                m.sender_id AS senderId,
                u.fullname AS senderName,
                u.avatar_url AS senderAvatarUrl,
                m.message_type AS messageType,
                CASE WHEN m.status = 'RECALLED' THEN NULL ELSE m.content END AS content,
                m.status,
                DATE_FORMAT(m.sent_at, '%H:%i %d/%m/%Y') AS sentAt,
                a.id AS attachmentId,
                a.file_name AS fileName,
                a.file_url AS fileUrl,
                a.file_type AS fileType,
                a.file_size AS fileSize,
                a.attachment_type AS attachmentType,
                CASE WHEN m.sender_id = :userId THEN TRUE ELSE FALSE END AS mine
            FROM messages m
            JOIN users u ON u.id = m.sender_id
            LEFT JOIN message_attachments a ON a.message_id = m.id
            WHERE m.conversation_id = :conversationId
              AND m.deleted_at IS NULL
              AND (:afterId IS NULL OR m.id > :afterId)
            ORDER BY m.id ASC
            LIMIT 80
        """;

        return jdbi.withHandle(h -> h.createQuery(sql)
                .bind("conversationId", conversationId)
                .bind("userId", userId)
                .bind("afterId", afterId)
                .mapToBean(ChatMessage.class)
                .list());
    }

    public ChatMessage sendMessage(long conversationId, long senderId, String clientMessageId, String messageType,
                                   String content, ChatAttachmentPayload attachment) {
        return jdbi.inTransaction(h -> {
            Optional<Long> existing = Optional.empty();
            if (clientMessageId != null && !clientMessageId.isBlank()) {
                existing = h.createQuery("""
                    SELECT id FROM messages WHERE sender_id = :senderId AND client_message_id = :clientMessageId
                """).bind("senderId", senderId).bind("clientMessageId", clientMessageId).mapTo(Long.class).findOne();
            }
            if (existing.isPresent()) {
                long existingId = existing.get();
                return listMessages(conversationId, senderId, existingId - 1).stream()
                        .filter(m -> m.getId() == existingId)
                        .findFirst()
                        .orElseThrow();
            }

            h.createUpdate("""
                INSERT INTO messages (conversation_id, sender_id, client_message_id, message_type, content, status)
                VALUES (:conversationId, :senderId, :clientMessageId, :messageType, :content, 'SENT')
            """)
                    .bind("conversationId", conversationId)
                    .bind("senderId", senderId)
                    .bind("clientMessageId", clientMessageId)
                    .bind("messageType", messageType)
                    .bind("content", content)
                    .execute();

            long messageId = h.createQuery("SELECT LAST_INSERT_ID()").mapTo(Long.class).one();

            if (attachment != null && attachment.getFileUrl() != null && !attachment.getFileUrl().isBlank()) {
                h.createUpdate("""
                    INSERT INTO message_attachments
                        (message_id, file_name, file_url, file_type, file_size, attachment_type, storage_provider)
                    VALUES
                        (:messageId, :fileName, :fileUrl, :fileType, :fileSize, :attachmentType, 'LOCAL')
                """)
                        .bind("messageId", messageId)
                        .bind("fileName", attachment.getFileName())
                        .bind("fileUrl", attachment.getFileUrl())
                        .bind("fileType", attachment.getFileType())
                        .bind("fileSize", attachment.getFileSize())
                        .bind("attachmentType", attachment.getAttachmentType())
                        .execute();
            }

            h.createUpdate("""
                UPDATE conversations
                SET last_message_id = :messageId, last_message_at = NOW(), updated_at = NOW()
                WHERE id = :conversationId
            """).bind("messageId", messageId).bind("conversationId", conversationId).execute();

            List<Long> receivers = h.createQuery("""
                SELECT user_id FROM conversation_members
                WHERE conversation_id = :conversationId AND user_id <> :senderId
            """).bind("conversationId", conversationId).bind("senderId", senderId).mapTo(Long.class).list();

            for (Long receiverId : receivers) {
                h.createUpdate("""
                    INSERT INTO message_status (message_id, user_id, status, delivered_at)
                    VALUES (:messageId, :userId, 'DELIVERED', NOW())
                """).bind("messageId", messageId).bind("userId", receiverId).execute();

                h.createUpdate("""
                    INSERT INTO notifications (user_id, conversation_id, message_id, type, title, content)
                    VALUES (:userId, :conversationId, :messageId, 'NEW_MESSAGE', 'Tin nhắn mới', :content)
                """).bind("userId", receiverId)
                        .bind("conversationId", conversationId)
                        .bind("messageId", messageId)
                        .bind("content", content == null || content.isBlank() ? "Bạn có tin nhắn mới" : content)
                        .execute();
            }

            return h.createQuery("""
                SELECT
                    m.id,
                    m.conversation_id AS conversationId,
                    m.sender_id AS senderId,
                    u.fullname AS senderName,
                    u.avatar_url AS senderAvatarUrl,
                    m.message_type AS messageType,
                    m.content,
                    m.status,
                    DATE_FORMAT(m.sent_at, '%H:%i %d/%m/%Y') AS sentAt,
                    a.id AS attachmentId,
                    a.file_name AS fileName,
                    a.file_url AS fileUrl,
                    a.file_type AS fileType,
                    a.file_size AS fileSize,
                    a.attachment_type AS attachmentType,
                    TRUE AS mine
                FROM messages m
                JOIN users u ON u.id = m.sender_id
                LEFT JOIN message_attachments a ON a.message_id = m.id
                WHERE m.id = :messageId
            """).bind("messageId", messageId).mapToBean(ChatMessage.class).one();
        });
    }

    public void markRead(long conversationId, long userId, long lastReadMessageId) {
        jdbi.useHandle(h -> {
            h.createUpdate("""
                UPDATE conversation_members
                SET last_read_message_id = GREATEST(COALESCE(last_read_message_id, 0), :lastReadMessageId),
                    last_read_at = NOW()
                WHERE conversation_id = :conversationId AND user_id = :userId
            """).bind("conversationId", conversationId)
                    .bind("userId", userId)
                    .bind("lastReadMessageId", lastReadMessageId)
                    .execute();

            h.createUpdate("""
                UPDATE message_status ms
                JOIN messages m ON m.id = ms.message_id
                SET ms.status = 'READ', ms.read_at = NOW()
                WHERE m.conversation_id = :conversationId
                  AND ms.user_id = :userId
                  AND m.id <= :lastReadMessageId
            """).bind("conversationId", conversationId)
                    .bind("userId", userId)
                    .bind("lastReadMessageId", lastReadMessageId)
                    .execute();

            h.createUpdate("""
                UPDATE notifications
                SET is_read = 1, read_at = NOW()
                WHERE user_id = :userId AND conversation_id = :conversationId
            """).bind("userId", userId).bind("conversationId", conversationId).execute();
        });
    }

    public boolean recallMessage(long messageId, long senderId) {
        return jdbi.withHandle(h -> h.createUpdate("""
            UPDATE messages
            SET status = 'RECALLED', content = NULL, recalled_at = NOW()
            WHERE id = :messageId
              AND sender_id = :senderId
              AND status = 'SENT'
              AND sent_at >= NOW() - INTERVAL 5 MINUTE
        """).bind("messageId", messageId).bind("senderId", senderId).execute() > 0);
    }

    public void deleteConversationForUser(long conversationId, long userId) {
        jdbi.useHandle(h -> h.createUpdate("""
            UPDATE conversation_members
            SET is_deleted = 1, deleted_at = NOW()
            WHERE conversation_id = :conversationId AND user_id = :userId
        """).bind("conversationId", conversationId).bind("userId", userId).execute());
    }
}
