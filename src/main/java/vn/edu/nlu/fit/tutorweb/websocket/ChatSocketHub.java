package vn.edu.nlu.fit.tutorweb.websocket;

import com.google.gson.Gson;
import jakarta.websocket.Session;
import vn.edu.nlu.fit.tutorweb.entity.ChatMessage;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArraySet;

public final class ChatSocketHub {
    private static final Map<Long, Set<Session>> USER_SESSIONS = new ConcurrentHashMap<>();
    private static final Gson GSON = new Gson();

    private ChatSocketHub() {
    }

    public static void register(long userId, Session session) {
        USER_SESSIONS.computeIfAbsent(userId, ignored -> new CopyOnWriteArraySet<>()).add(session);
    }

    public static void unregister(long userId, Session session) {
        Set<Session> sessions = USER_SESSIONS.get(userId);
        if (sessions == null) return;
        sessions.remove(session);
        if (sessions.isEmpty()) {
            USER_SESSIONS.remove(userId);
        }
    }

    public static boolean isOnline(long userId) {
        Set<Session> sessions = USER_SESSIONS.get(userId);
        return sessions != null && sessions.stream().anyMatch(Session::isOpen);
    }

    public static void broadcastNewMessage(ChatMessage message, List<Long> memberIds) {
        sendToUsers(memberIds, Map.of("event", "NEW_MESSAGE", "data", message));
    }

    public static void broadcastConversationChanged(long conversationId, List<Long> memberIds, String event) {
        sendToUsers(memberIds, Map.of("event", event, "conversationId", conversationId));
    }

    public static void sendToUsers(List<Long> userIds, Object payload) {
        String json = GSON.toJson(payload);
        for (Long userId : userIds) {
            Set<Session> sessions = USER_SESSIONS.get(userId);
            if (sessions == null) continue;
            for (Session session : sessions) {
                send(session, json);
            }
        }
    }

    private static void send(Session session, String json) {
        if (!session.isOpen()) return;
        try {
            session.getBasicRemote().sendText(json);
        } catch (IOException e) {
            try {
                session.close();
            } catch (IOException ignored) {
            }
        }
    }
}
