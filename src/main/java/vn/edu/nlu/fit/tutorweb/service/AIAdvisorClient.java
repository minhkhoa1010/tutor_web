package vn.edu.nlu.fit.tutorweb.service;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import vn.edu.nlu.fit.tutorweb.db.ConfigProperties;

import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.List;
import java.util.Map;

public class AIAdvisorClient {
    private static final String GEMINI_MODEL = "gemini-2.5-flash";
    private static final String OPENAI_MODEL = "gpt-4o-mini";

    private final HttpClient httpClient = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(20))
            .build();
    private final Gson gson = new Gson();

    public String ask(String prompt) throws IOException, InterruptedException {
        String geminiKey = ConfigProperties.get("GEMINI_API_KEY");
        if (geminiKey != null) {
            return callGemini(geminiKey, prompt);
        }

        String openAiKey = env("OPENAI_API_KEY");
        if (openAiKey != null) {
            return callOpenAI(openAiKey, prompt);
        }

        throw new IllegalStateException("Chưa cấu hình API key. Vui lòng đặt biến môi trường GEMINI_API_KEY hoặc OPENAI_API_KEY rồi khởi động lại server.");
    }

    private String callGemini(String apiKey, String prompt) throws IOException, InterruptedException {
        String url = "https://generativelanguage.googleapis.com/v1beta/models/"
                + GEMINI_MODEL
                + ":generateContent?key="
                + URLEncoder.encode(apiKey, StandardCharsets.UTF_8);

        JsonObject textPart = new JsonObject();
        textPart.addProperty("text", prompt);

        JsonObject content = new JsonObject();
        JsonArray parts = new JsonArray();
        parts.add(textPart);
        content.add("parts", parts);

        JsonObject body = new JsonObject();
        JsonArray contents = new JsonArray();
        contents.add(content);
        body.add("contents", contents);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .timeout(Duration.ofSeconds(60))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(gson.toJson(body), StandardCharsets.UTF_8))
                .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
        if (response.statusCode() < 200 || response.statusCode() >= 300) {
            throw new IOException("AI API trả lỗi " + response.statusCode() + ": " + response.body());
        }

        JsonObject root = JsonParser.parseString(response.body()).getAsJsonObject();
        JsonArray candidates = root.getAsJsonArray("candidates");
        if (candidates == null || candidates.isEmpty()) {
            throw new IOException("AI API không trả về nội dung tư vấn.");
        }

        JsonObject firstContent = candidates.get(0).getAsJsonObject().getAsJsonObject("content");
        JsonArray responseParts = firstContent.getAsJsonArray("parts");
        if (responseParts == null || responseParts.isEmpty()) {
            throw new IOException("AI API không trả về phần nội dung hợp lệ.");
        }

        return responseParts.get(0).getAsJsonObject().get("text").getAsString();
    }

    private String callOpenAI(String apiKey, String prompt) throws IOException, InterruptedException {
        Map<String, Object> body = Map.of(
                "model", OPENAI_MODEL,
                "temperature", 0.2,
                "messages", List.of(
                        Map.of("role", "system", "content", "Bạn là AI Advisor của hệ thống Tutor Web. Chỉ trả lời dựa trên dữ liệu được cung cấp."),
                        Map.of("role", "user", "content", prompt)
                )
        );

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create("https://api.openai.com/v1/chat/completions"))
                .timeout(Duration.ofSeconds(60))
                .header("Content-Type", "application/json")
                .header("Authorization", "Bearer " + apiKey)
                .POST(HttpRequest.BodyPublishers.ofString(gson.toJson(body), StandardCharsets.UTF_8))
                .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
        if (response.statusCode() < 200 || response.statusCode() >= 300) {
            throw new IOException("AI API trả lỗi " + response.statusCode() + ": " + response.body());
        }

        JsonObject root = JsonParser.parseString(response.body()).getAsJsonObject();
        JsonArray choices = root.getAsJsonArray("choices");
        if (choices == null || choices.isEmpty()) {
            throw new IOException("AI API không trả về nội dung tư vấn.");
        }
        return choices.get(0).getAsJsonObject()
                .getAsJsonObject("message")
                .get("content")
                .getAsString();
    }

    private String env(String name) {
        String value = System.getenv(name);
        return value == null || value.isBlank() ? null : value.trim();
    }
}
