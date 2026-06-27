<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<jsp:include page="/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Tin nhắn"/>
    <jsp:param name="pageCss" value="/assets/css/chat.css"/>
</jsp:include>

<jsp:include page="/views/common/navbar.jsp"/>

<main class="chat-shell">
    <div class="chat-layout">
        <aside class="chat-sidebar">
            <div class="chat-sidebar-header">
                <h1>Tin nhắn</h1>
                <input id="conversationSearch" class="chat-search" type="search" placeholder="Tìm theo tên hoặc môn học">
            </div>
            <div id="conversationList" class="conversation-list"></div>
        </aside>

        <section class="chat-panel">
            <div id="chatEmpty" class="chat-empty">
                <div>
                    <strong>Chọn một cuộc trò chuyện</strong>
                    <p>Tin nhắn với gia sư hoặc học viên sẽ hiển thị tại đây.</p>
                </div>
            </div>

            <div id="chatRoom" style="display:none; min-height:0; flex:1; flex-direction:column;">
                <header class="chat-header">
                    <img id="chatAvatar" class="conversation-avatar" src="${pageContext.request.contextPath}/assets/images/default-avatar.png" alt="Avatar">
                    <div class="chat-title">
                        <strong id="chatName"></strong>
                        <span id="chatSubject"></span>
                    </div>
                    <div class="chat-actions">
                        <button id="exitChatBtn" class="chat-exit-btn" type="button">Rời chat</button>
                        <button id="deleteConversationBtn" class="chat-delete-btn" type="button">Xóa</button>
                    </div>
                </header>

                <div id="messageList" class="message-list"></div>

                <form id="chatComposer" class="chat-composer">
                    <div id="attachmentPreview" class="attachment-preview">
                        <span id="attachmentName"></span>
                        <button id="removeAttachmentBtn" class="icon-btn" type="button" style="height:30px;">X</button>
                    </div>
                    <div class="composer-row">
                        <button id="pickFileBtn" class="icon-btn" type="button" title="Đính kèm file">
                            <i class="bi bi-paperclip"></i>
                        </button>
                        <textarea id="messageInput" class="message-input" rows="1" maxlength="2000" placeholder="Nhập tin nhắn..."></textarea>
                        <button class="send-btn" type="submit">Gửi</button>
                    </div>
                    <input id="fileInput" type="file" hidden
                           accept=".jpg,.jpeg,.png,.webp,.gif,.pdf,.doc,.docx,.ppt,.pptx,.xls,.xlsx,.txt">
                </form>
            </div>
        </section>
    </div>
</main>

<div id="chatToast" class="chat-toast"></div>

<script>
    const CTX = '${pageContext.request.contextPath}';
    const CURRENT_USER_ID = ${sessionScope.clientUser.id};
    const DEFAULT_AVATAR = CTX + '/assets/images/default-avatar.png';
    const INITIAL_BOOKING_ID = '${empty initialBookingId ? "" : initialBookingId}';
    const INITIAL_TUTOR_ID = '${empty initialTutorId ? "" : initialTutorId}';

    let conversations = [];
    let activeConversationId = null;
    let lastMessageId = 0;
    let pollingTimer = null;
    let selectedAttachment = null;
    let searchTimer = null;
    let chatSocket = null;
    let socketReconnectTimer = null;
    let socketReady = false;

    const conversationList = document.getElementById('conversationList');
    const messageList = document.getElementById('messageList');
    const chatEmpty = document.getElementById('chatEmpty');
    const chatRoom = document.getElementById('chatRoom');
    const chatAvatar = document.getElementById('chatAvatar');
    const chatName = document.getElementById('chatName');
    const chatSubject = document.getElementById('chatSubject');
    const messageInput = document.getElementById('messageInput');
    const fileInput = document.getElementById('fileInput');
    const attachmentPreview = document.getElementById('attachmentPreview');
    const attachmentName = document.getElementById('attachmentName');

    document.addEventListener('DOMContentLoaded', async function () {
        connectChatSocket();
        if (INITIAL_BOOKING_ID || INITIAL_TUTOR_ID) {
            await openInitialConversation();
        }
        await loadConversations();
        if (!activeConversationId && conversations.length > 0) {
            openConversation(conversations[0].id);
        }
    });

    document.getElementById('conversationSearch').addEventListener('input', function () {
        clearTimeout(searchTimer);
        searchTimer = setTimeout(() => loadConversations(this.value), 250);
    });

    document.getElementById('pickFileBtn').addEventListener('click', function () {
        fileInput.click();
    });

    fileInput.addEventListener('change', async function () {
        if (!this.files || !this.files[0]) return;
        await uploadAttachment(this.files[0]);
    });

    document.getElementById('removeAttachmentBtn').addEventListener('click', function () {
        selectedAttachment = null;
        fileInput.value = '';
        attachmentPreview.classList.remove('active');
    });

    document.getElementById('exitChatBtn').addEventListener('click', function () {
        leaveChatPage();
    });

    document.getElementById('deleteConversationBtn').addEventListener('click', async function () {
        if (!activeConversationId || !confirm('Xóa cuộc trò chuyện khỏi danh sách của bạn?')) return;
        const res = await postJson('/api/chat/delete-conversation', {conversationId: activeConversationId});
        if (res.success) {
            activeConversationId = null;
            stopPolling();
            chatRoom.style.display = 'none';
            chatEmpty.style.display = 'grid';
            await loadConversations();
        } else {
            showToast(res.message || 'Không thể xóa cuộc trò chuyện.');
        }
    });

    document.getElementById('chatComposer').addEventListener('submit', async function (event) {
        event.preventDefault();
        await sendMessage();
    });

    messageInput.addEventListener('keydown', function (event) {
        if (event.key === 'Enter' && !event.shiftKey) {
            event.preventDefault();
            document.getElementById('chatComposer').requestSubmit();
        }
    });

    async function openInitialConversation() {
        const payload = {};
        if (INITIAL_BOOKING_ID) payload.bookingId = Number(INITIAL_BOOKING_ID);
        if (INITIAL_TUTOR_ID) payload.tutorId = Number(INITIAL_TUTOR_ID);
        const res = await postJson('/api/chat/conversations', payload);
        if (res.success) {
            activeConversationId = res.conversationId;
        } else {
            showToast(res.message || 'Không thể mở cuộc trò chuyện.');
        }
    }

    async function loadConversations(keyword = '') {
        const url = '/api/chat/conversations' + (keyword ? '?keyword=' + encodeURIComponent(keyword) : '');
        const res = await getJson(url);
        if (!res.success) {
            showToast(res.message || 'Không tải được danh sách tin nhắn.');
            return;
        }
        conversations = res.data || [];
        renderConversations();
    }

    function renderConversations() {
        if (!conversations.length) {
            conversationList.innerHTML = '<div style="padding:18px; color:#64748b;">Chưa có cuộc trò chuyện.</div>';
            return;
        }

        conversationList.innerHTML = conversations.map(c => {
            const active = c.id === activeConversationId ? 'active' : '';
            const avatar = c.otherAvatarUrl || DEFAULT_AVATAR;
            const unread = c.unreadCount > 0 ? '<span class="conversation-unread">' + c.unreadCount + '</span>' : '';
            return '<button class="conversation-item ' + active + '" type="button" data-id="' + c.id + '">' +
                '<img class="conversation-avatar" src="' + escapeAttr(avatar) + '" alt="Avatar" onerror="this.src=\'' + DEFAULT_AVATAR + '\'">' +
                '<div style="min-width:0;">' +
                    '<div class="conversation-name">' + escapeHtml(c.otherFullname || 'Người dùng') + '</div>' +
                    '<div class="conversation-subject">' + escapeHtml(c.subjectName || 'Trao đổi học tập') + '</div>' +
                    '<div class="conversation-meta">' + escapeHtml(c.lastMessage || 'Chưa có tin nhắn') + '</div>' +
                '</div>' +
                '<div style="display:flex; flex-direction:column; align-items:flex-end; gap:8px;">' +
                    '<span class="conversation-meta">' + escapeHtml(c.lastMessageAt || '') + '</span>' + unread +
                '</div>' +
            '</button>';
        }).join('');

        conversationList.querySelectorAll('.conversation-item').forEach(btn => {
            btn.addEventListener('click', () => openConversation(Number(btn.dataset.id)));
        });
    }

    async function openConversation(conversationId) {
        activeConversationId = conversationId;
        lastMessageId = 0;
        messageList.innerHTML = '';
        const conversation = conversations.find(c => c.id === conversationId);
        if (conversation) {
            chatAvatar.src = conversation.otherAvatarUrl || DEFAULT_AVATAR;
            chatName.textContent = conversation.otherFullname || 'Người dùng';
            chatSubject.textContent = conversation.subjectName || 'Trao đổi học tập';
        }
        chatEmpty.style.display = 'none';
        chatRoom.style.display = 'flex';
        renderConversations();
        await loadMessages(false);
        if (!socketReady) {
            startPolling();
        }
    }

    async function loadMessages(appendOnly) {
        if (!activeConversationId) return;
        const after = appendOnly && lastMessageId ? '&afterId=' + lastMessageId : '';
        const res = await getJson('/api/chat/messages?conversationId=' + activeConversationId + after);
        if (!res.success) {
            showToast(res.message || 'Không tải được tin nhắn.');
            return;
        }

        const messages = res.data || [];
        if (!appendOnly) {
            messageList.innerHTML = '';
        }
        messages.forEach(renderMessage);
        if (messages.length) {
            lastMessageId = Math.max(...messages.map(m => m.id), lastMessageId);
            scrollToBottom();
            await loadConversations(document.getElementById('conversationSearch').value);
            refreshUnreadBadgeIfAvailable();
        }
    }

    function renderMessage(message) {
        const row = document.createElement('div');
        row.className = 'message-row' + (message.mine ? ' mine' : '');
        row.dataset.id = message.id;

        const avatar = document.createElement('img');
        avatar.className = 'message-avatar';
        avatar.src = message.senderAvatarUrl || DEFAULT_AVATAR;
        avatar.onerror = function () { this.src = DEFAULT_AVATAR; };

        const bubble = document.createElement('div');
        bubble.className = 'message-bubble';

        if (message.status === 'RECALLED') {
            bubble.appendChild(document.createTextNode('Tin nhắn đã được thu hồi'));
        } else {
            if (message.content) {
                const text = document.createElement('div');
                text.textContent = message.content;
                bubble.appendChild(text);
            }
            if (message.fileUrl) {
                if (message.attachmentType === 'IMAGE') {
                    const img = document.createElement('img');
                    img.className = 'message-image';
                    img.src = message.fileUrl;
                    img.alt = message.fileName || 'Hình ảnh';
                    bubble.appendChild(img);
                } else {
                    const link = document.createElement('a');
                    link.className = 'message-file';
                    link.href = message.fileUrl;
                    link.target = '_blank';
                    link.rel = 'noopener';
                    link.innerHTML = '<i class="bi bi-file-earmark-arrow-down"></i><span></span>';
                    link.querySelector('span').textContent = message.fileName || 'Tải tài liệu';
                    bubble.appendChild(link);
                }
            }
        }

        const time = document.createElement('div');
        time.className = 'message-time';
        time.textContent = message.sentAt || '';
        bubble.appendChild(time);

        if (message.mine && message.status === 'SENT') {
            const recall = document.createElement('button');
            recall.className = 'recall-btn';
            recall.type = 'button';
            recall.textContent = 'Thu hồi';
            recall.addEventListener('click', () => recallMessage(message.id));
            bubble.appendChild(recall);
        }

        if (!message.mine) row.appendChild(avatar);
        row.appendChild(bubble);
        messageList.appendChild(row);
    }

    async function sendMessage() {
        if (!activeConversationId) return;
        const content = messageInput.value.trim();
        if (!content && !selectedAttachment) return;

        const payload = {
            conversationId: activeConversationId,
            clientMessageId: crypto.randomUUID ? crypto.randomUUID() : String(Date.now()) + Math.random(),
            messageType: selectedAttachment ? selectedAttachment.attachmentType : 'TEXT',
            content: content,
            attachment: selectedAttachment
        };

        const res = await postJson('/api/chat/messages', payload);
        if (res.success) {
            messageInput.value = '';
            selectedAttachment = null;
            fileInput.value = '';
            attachmentPreview.classList.remove('active');
            if (!document.querySelector('.message-row[data-id="' + res.data.id + '"]')) {
                renderMessage(res.data);
            }
            lastMessageId = Math.max(lastMessageId, res.data.id);
            scrollToBottom();
            await loadConversations(document.getElementById('conversationSearch').value);
            refreshUnreadBadgeIfAvailable();
        } else {
            showToast(res.message || 'Gửi tin nhắn thất bại.');
        }
    }

    async function uploadAttachment(file) {
        const formData = new FormData();
        formData.append('file', file);
        const response = await fetch(CTX + '/api/chat/upload', {method: 'POST', body: formData});
        const res = await response.json();
        if (res.success) {
            selectedAttachment = res.data;
            attachmentName.textContent = selectedAttachment.fileName;
            attachmentPreview.classList.add('active');
        } else {
            fileInput.value = '';
            showToast(res.message || 'Upload file thất bại.');
        }
    }

    async function recallMessage(messageId) {
        const res = await postJson('/api/chat/recall', {messageId, conversationId: activeConversationId});
        if (res.success) {
            await loadMessages(false);
            await loadConversations(document.getElementById('conversationSearch').value);
        } else {
            showToast(res.message || 'Không thể thu hồi tin nhắn.');
        }
    }

    function startPolling() {
        stopPolling();
        pollingTimer = setInterval(() => loadMessages(true), 2500);
    }

    function connectChatSocket() {
        if (!window.WebSocket) {
            startPolling();
            return;
        }

        const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
        const socketUrl = protocol + '//' + window.location.host + CTX + '/ws/chat';

        try {
            chatSocket = new WebSocket(socketUrl);
        } catch (error) {
            socketReady = false;
            startPolling();
            scheduleSocketReconnect();
            return;
        }

        chatSocket.onopen = function () {
            socketReady = true;
            stopPolling();
            if (socketReconnectTimer) {
                clearTimeout(socketReconnectTimer);
                socketReconnectTimer = null;
            }
            chatSocket.send(JSON.stringify({event: 'PING'}));
        };

        chatSocket.onmessage = function (event) {
            handleSocketEvent(event.data);
        };

        chatSocket.onclose = function () {
            socketReady = false;
            if (activeConversationId) {
                startPolling();
            }
            scheduleSocketReconnect();
        };

        chatSocket.onerror = function () {
            socketReady = false;
        };
    }

    function scheduleSocketReconnect() {
        if (socketReconnectTimer) return;
        socketReconnectTimer = setTimeout(function () {
            socketReconnectTimer = null;
            connectChatSocket();
        }, 3000);
    }

    async function handleSocketEvent(rawData) {
        let payload;
        try {
            payload = JSON.parse(rawData);
        } catch (error) {
            return;
        }

        if (payload.event === 'CONNECTED' || payload.event === 'PONG') {
            return;
        }

        if (payload.event === 'NEW_MESSAGE') {
            const message = payload.data;
            if (!message || document.querySelector('.message-row[data-id="' + message.id + '"]')) {
                return;
            }

            if (message.conversationId === activeConversationId) {
                message.mine = Number(message.senderId) === Number(CURRENT_USER_ID);
                renderMessage(message);
                lastMessageId = Math.max(lastMessageId, message.id);
                scrollToBottom();
                await postJson('/api/chat/read', {
                    conversationId: activeConversationId,
                    lastReadMessageId: lastMessageId
                });
            } else {
                showToast('Bạn có tin nhắn mới.');
            }
            await loadConversations(document.getElementById('conversationSearch').value);
            refreshUnreadBadgeIfAvailable();
            return;
        }

        if (payload.event === 'MESSAGE_RECALLED' || payload.event === 'READ_MESSAGE' || payload.event === 'CONVERSATION_CHANGED') {
            if (payload.conversationId === activeConversationId) {
                await loadMessages(false);
            }
            await loadConversations(document.getElementById('conversationSearch').value);
            refreshUnreadBadgeIfAvailable();
            return;
        }

        if (payload.event === 'ERROR' && payload.message) {
            showToast(payload.message);
        }
    }

    function stopPolling() {
        if (pollingTimer) {
            clearInterval(pollingTimer);
            pollingTimer = null;
        }
    }

    async function getJson(url) {
        const response = await fetch(CTX + url, {headers: {'Accept': 'application/json'}});
        return response.json();
    }

    async function postJson(url, payload) {
        const response = await fetch(CTX + url, {
            method: 'POST',
            headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
            body: JSON.stringify(payload)
        });
        return response.json();
    }

    function scrollToBottom() {
        messageList.scrollTop = messageList.scrollHeight;
    }

    function leaveChatPage() {
        stopPolling();
        if (chatSocket && chatSocket.readyState === WebSocket.OPEN) {
            chatSocket.close();
        }

        if (document.referrer) {
            try {
                const referrer = new URL(document.referrer);
                if (referrer.origin === window.location.origin && referrer.href !== window.location.href) {
                    window.history.back();
                    return;
                }
            } catch (ignored) {
            }
        }

        window.location.href = CTX + '/home';
    }

    function showToast(message) {
        const toast = document.getElementById('chatToast');
        toast.textContent = message;
        toast.classList.add('show');
        setTimeout(() => toast.classList.remove('show'), 3200);
    }

    function refreshUnreadBadgeIfAvailable() {
        if (typeof window.refreshChatUnreadBadge === 'function') {
            window.refreshChatUnreadBadge();
        }
    }

    function escapeHtml(value) {
        return String(value || '').replace(/[&<>"']/g, ch => ({
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#039;'
        }[ch]));
    }

    function escapeAttr(value) {
        return escapeHtml(value).replace(/`/g, '&#096;');
    }
</script>

<jsp:include page="/views/common/footer.jsp"/>
