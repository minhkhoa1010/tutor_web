package vn.edu.nlu.fit.tutorweb.service;

import com.google.gson.Gson;
import vn.edu.nlu.fit.tutorweb.dao.AdvisorDAO;
import vn.edu.nlu.fit.tutorweb.dto.AdvisorTutorDTO;

import java.util.List;

public class AdvisorService {
    private static final int MAX_CHAT_TUTORS = 30;

    private final AdvisorDAO advisorDAO = new AdvisorDAO();
    private final AIAdvisorClient aiClient = new AIAdvisorClient();
    private final Gson gson = new Gson();

    public String answerAssistant(String userMessage) throws Exception {
        if (userMessage == null || userMessage.isBlank()) {
            return "Bạn hãy nhập câu hỏi hoặc nhu cầu học tập để mình hỗ trợ.";
        }

        List<AdvisorTutorDTO> tutors = advisorDAO.findApprovedTutorsForAssistant(MAX_CHAT_TUTORS);
        return aiClient.ask(buildAssistantPrompt(userMessage.trim(), tutors));
    }

    private String buildAssistantPrompt(String userMessage, List<AdvisorTutorDTO> tutors) {
        return """
            Bạn là AI Assistant của hệ thống Tutor Web.

            Bạn chỉ hỗ trợ các nghiệp vụ liên quan đến hệ thống Tutor Web, bao gồm:
            - Tư vấn chọn gia sư.
            - Gợi ý lộ trình học.
            - Giải đáp quy trình đăng ký gia sư.
            - Hướng dẫn đặt lịch học.
            - Hướng dẫn thanh toán.
            - Giải đáp về ví, booking, lịch học, đánh giá.
            - Hướng dẫn sử dụng các chức năng của website.

            Nếu người dùng hỏi ngoài phạm vi hệ thống, ví dụ hỏi kiến thức chung, lập trình, tin tức, thể thao, giải trí, hãy lịch sự thông báo rằng bạn chỉ hỗ trợ các nghiệp vụ của Tutor Web và mời họ đặt câu hỏi liên quan đến việc học hoặc sử dụng hệ thống.

            Không tự bịa thông tin về gia sư hoặc dữ liệu hệ thống. Chỉ sử dụng dữ liệu được cung cấp.

            Quy tắc trả lời:
            - Trả lời bằng tiếng Việt tự nhiên, lịch sự, ngắn gọn.
            - Nếu người dùng muốn tư vấn chọn gia sư nhưng thiếu thông tin quan trọng, hãy hỏi thêm từng ý cần thiết.
            - Nếu có đủ dữ liệu, đề xuất tối đa 3 gia sư trong JSON được cung cấp.
            - Khi đề xuất gia sư, nêu tên, học phí, môn dạy, rating, lịch rảnh và lý do phù hợp.
            - Nếu dữ liệu không có gia sư phù hợp, hãy đề xuất điều chỉnh ngân sách, lịch học, khu vực hoặc hình thức học.
            - Trường teachingMode = NOT_SPECIFIED nghĩa là database chưa lưu hình thức dạy, không được khẳng định gia sư chắc chắn dạy online/offline.
            - Không trả markdown bảng phức tạp; ưu tiên đoạn ngắn và bullet dễ đọc.

            Dữ liệu gia sư hiện có trong hệ thống, chỉ được dùng danh sách này:
            %s

            Câu hỏi của người dùng:
            %s
            """.formatted(gson.toJson(tutors), userMessage);
    }
}
