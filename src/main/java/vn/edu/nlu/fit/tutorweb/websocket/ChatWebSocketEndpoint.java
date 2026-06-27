package vn.edu.nlu.fit.tutorweb.websocket;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import jakarta.servlet.http.HttpSession;
import jakarta.websocket.CloseReason;
import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;
import vn.edu.nlu.fit.tutorweb.entity.UserSession;

import java.io.IOException;
import java.time.Instant;
import java.util.Map;

@ServerEndpoint(value = "/ws/chat", configurator = ChatEndpointConfigurator.class)
public class ChatWebSocketEndpoint {
    private static final Gson GSON = new Gson();
    private static final String USER_ID_KEY = "chat.userId";

    @OnOpen
    public void onOpen(Session socketSession) throws IOException {
        HttpSession httpSession = (HttpSession) socketSession.getUserProperties().get(HttpSession.class.getName());
        UserSession user = httpSession != null ? (UserSession) httpSession.getAttribute("clientUser") : null;
        if (user == null) {
            socketSession.close(new CloseReason(CloseReason.CloseCodes.VIOLATED_POLICY, "UNAUTHORIZED"));
            return;
        }

        socketSession.getUserProperties().put(USER_ID_KEY, user.getId());
        ChatSocketHub.register(user.getId(), socketSession);
        socketSession.getBasicRemote().sendText(GSON.toJson(Map.of(
                "event", "CONNECTED",
                "userId", user.getId(),
                "serverTime", Instant.now().toString()
        )));
    }

    @OnMessage
    public void onMessage(String rawMessage, Session socketSession) throws IOException {
        JsonObject message;
        try {
            message = JsonParser.parseString(rawMessage).getAsJsonObject();
        } catch (Exception e) {
            sendError(socketSession, "Payload WebSocket không hợp lệ.");
            return;
        }

        String event = message.has("event") ? message.get("event").getAsString() : "";
        if ("PING".equalsIgnoreCase(event)) {
            socketSession.getBasicRemote().sendText(GSON.toJson(Map.of(
                    "event", "PONG",
                    "serverTime", Instant.now().toString()
            )));
            return;
        }

        if ("TYPING".equalsIgnoreCase(event) || "STOP_TYPING".equalsIgnoreCase(event)) {
            socketSession.getBasicRemote().sendText(GSON.toJson(Map.of("event", event.toUpperCase(), "accepted", true)));
            return;
        }

        sendError(socketSession, "Event WebSocket chưa được hỗ trợ: " + event);
    }

    @OnClose
    public void onClose(Session socketSession) {
        unregister(socketSession);
    }

    @OnError
    public void onError(Session socketSession, Throwable throwable) {
        unregister(socketSession);
    }

    private void unregister(Session socketSession) {
        Object userId = socketSession.getUserProperties().get(USER_ID_KEY);
        if (userId instanceof Long id) {
            ChatSocketHub.unregister(id, socketSession);
        }
    }

    private void sendError(Session socketSession, String message) throws IOException {
        if (socketSession.isOpen()) {
            socketSession.getBasicRemote().sendText(GSON.toJson(Map.of("event", "ERROR", "message", message)));
        }
    }
}
