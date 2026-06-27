<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<jsp:include page="/views/common/header.jsp">
    <jsp:param name="pageTitle" value="AI Assistant - Tutor Web"/>
    <jsp:param name="pageCss" value="/assets/css/advisor.css"/>
</jsp:include>

<jsp:include page="/views/common/navbar.jsp"/>

<main class="advisor-page">
    <div class="advisor-container">
        <section class="advisor-hero">
            <div class="advisor-hero-main">
                <h1>AI Assistant Tutor Web</h1>
                <p>
                    Hỏi nhanh về cách chọn gia sư, lộ trình học, đặt lịch, thanh toán, ví, booking,
                    lịch học, đánh giá hoặc cách sử dụng website. Bạn không cần đăng nhập để hỏi trợ lý.
                </p>
            </div>

            <aside class="advisor-tips">
                <strong>Có thể hỏi ví dụ:</strong>
                <ul>
                    <li>Tôi cần tìm gia sư Toán lớp 12, ngân sách 200k.</li>
                    <li>Làm sao để đăng ký làm gia sư?</li>
                    <li>Quy trình đặt lịch và thanh toán thế nào?</li>
                    <li>Tôi muốn học IELTS online 3 buổi mỗi tuần.</li>
                </ul>
            </aside>
        </section>

        <section class="advisor-chat">
            <header class="advisor-chat-header">
                <div class="advisor-chat-title">
                    <div class="advisor-bot-avatar">AI</div>
                    <div>
                        <strong>Trợ lý Tutor Web</strong>
                        <span>Chỉ hỗ trợ nghiệp vụ và tư vấn trong hệ thống Tutor Web</span>
                    </div>
                </div>
                <span class="advisor-status">Sẵn sàng hỗ trợ</span>
            </header>

            <div id="advisorMessages" class="advisor-messages">
                <div class="advisor-message bot">
                    <div class="advisor-bubble">Xin chào, mình là AI Assistant của Tutor Web. Bạn cần tư vấn chọn gia sư hay cần hướng dẫn sử dụng chức năng nào?</div>
                </div>
            </div>

            <div class="advisor-suggestions">
                <button class="advisor-chip" type="button">Tư vấn gia sư Toán lớp 12</button>
                <button class="advisor-chip" type="button">Hướng dẫn đặt lịch học</button>
                <button class="advisor-chip" type="button">Quy trình đăng ký gia sư</button>
                <button class="advisor-chip" type="button">Hướng dẫn thanh toán và ví</button>
            </div>

            <form id="advisorForm" class="advisor-composer">
                <textarea id="advisorInput" class="advisor-input" rows="1" maxlength="2000"
                          placeholder="Nhập câu hỏi của bạn..."></textarea>
                <button id="advisorSend" class="advisor-send" type="submit">Gửi</button>
            </form>
        </section>
    </div>
</main>

<script>
    const advisorMessages = document.getElementById('advisorMessages');
    const advisorForm = document.getElementById('advisorForm');
    const advisorInput = document.getElementById('advisorInput');
    const advisorSend = document.getElementById('advisorSend');

    document.querySelectorAll('.advisor-chip').forEach(function (chip) {
        chip.addEventListener('click', function () {
            advisorInput.value = chip.textContent.trim();
            advisorInput.focus();
        });
    });

    advisorInput.addEventListener('keydown', function (event) {
        if (event.key === 'Enter' && !event.shiftKey) {
            event.preventDefault();
            advisorForm.requestSubmit();
        }
    });

    advisorForm.addEventListener('submit', async function (event) {
        event.preventDefault();
        const message = advisorInput.value.trim();
        if (!message) return;

        appendMessage('user', message);
        advisorInput.value = '';
        advisorSend.disabled = true;
        const typingNode = appendMessage('bot', 'Đang phân tích câu hỏi...');

        try {
            const formData = new URLSearchParams();
            formData.append('message', message);

            const response = await fetch('${pageContext.request.contextPath}/ai-advisor', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
                    'Accept': 'application/json'
                },
                body: formData.toString()
            });

            const result = await response.json();
            typingNode.querySelector('.advisor-bubble').textContent = result.reply || 'AI Assistant chưa có phản hồi phù hợp.';
        } catch (error) {
            typingNode.querySelector('.advisor-bubble').textContent = 'Không thể kết nối AI Assistant. Vui lòng thử lại sau.';
        } finally {
            advisorSend.disabled = false;
            advisorInput.focus();
            scrollToBottom();
        }
    });

    function appendMessage(type, text) {
        const row = document.createElement('div');
        row.className = 'advisor-message ' + (type === 'user' ? 'user' : 'bot');

        const bubble = document.createElement('div');
        bubble.className = 'advisor-bubble';
        bubble.textContent = text;

        row.appendChild(bubble);
        advisorMessages.appendChild(row);
        scrollToBottom();
        return row;
    }

    function scrollToBottom() {
        advisorMessages.scrollTop = advisorMessages.scrollHeight;
    }
</script>

<jsp:include page="/views/common/footer.jsp"/>
