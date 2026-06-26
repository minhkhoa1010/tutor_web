<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Yêu cầu Liên hệ – Gia Sư Bá Đạo VN</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" />
</head>
<body>
<div class="admin-wrapper">
    <style>
        .custom-badge {
            display: inline-block;
            padding: 4px 10px;
            font-size: 12px;
            font-weight: 600;
            border-radius: 6px;
            text-align: center;
        }
        .badge-danger { background-color: #fee2e2; color: #ef4444; }
        .badge-success { background-color: #d1fae5; color: #10b981; }

        .btn-action-view {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            background: #1e293b;
            color: #ffffff;
            border-radius: 6px;
            font-size: 13px;
            text-decoration: none;
            font-weight: 500;
            border: none;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-action-view:hover { background: #0f172a; }
        .btn-action-view .material-symbols-outlined { font-size: 18px; vertical-align: middle; }

        /* --- MODAL DIALOG --- */
        .custom-modal-backdrop {
            display: none;
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background-color: rgba(15, 23, 42, 0.6);
            z-index: 9999;
            justify-content: center; align-items: center;
            backdrop-filter: blur(4px);
        }
        .custom-modal-box {
            background: #ffffff; width: 100%; max-width: 550px;
            border-radius: 12px; padding: 24px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
            animation: modalFadeIn 0.3s ease;
        }
        @keyframes modalFadeIn {
            from { transform: translateY(-20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        .modal-header-title {
            display: flex; justify-content: space-between; align-items: center;
            border-bottom: 1px solid #f1f5f9; padding-bottom: 12px; margin-bottom: 16px;
        }
        .modal-header-title h3 { margin: 0; font-size: 18px; color: #1e293b; }
        .modal-close-btn { background: none; border: none; cursor: pointer; color: #94a3b8; }
        .modal-body-content .info-group { margin-bottom: 14px; }
        .modal-body-content .info-label { font-size: 12px; color: #64748b; font-weight: 600; margin-bottom: 4px; text-transform: uppercase; }
        .modal-body-content .info-value { font-size: 15px; color: #0f172a; background: #f8fafc; padding: 10px 12px; border-radius: 6px; border: 1px solid #f1f5f9; }
        .modal-footer-actions { display: flex; justify-content: flex-end; gap: 12px; margin-top: 24px; border-top: 1px solid #f1f5f9; padding-top: 16px; }
    </style>

   <jsp:include page="/views/admin/common/sidebar.jsp" />

    <div class="main-content">
        <header class="topbar">
            <div class="topbar-brand">
                <span class="brand-dot"></span>
                <span class="brand-name">Gia Sư Bá Đạo VN</span>
            </div>
            <div class="topbar-search">
                <span class="search-icon material-symbols-outlined">search</span>
                <input type="text" placeholder="Tìm kiếm yêu cầu liên hệ...">
            </div>
        </header>

        <div class="page-body">
            <div class="page-title-row">
                <div>
                    <h1>Danh sách Yêu cầu Hỗ trợ & Liên hệ</h1>
                    <p>Tiếp nhận thông tin thắc mắc, góp ý từ khách hàng vãng lai, học viên và gia sư.</p>
                </div>
            </div>

            <div class="table-section" style="margin-top: 16px;">
                <table class="data-table">
                    <thead>
                    <tr>
                        <th style="width: 80px;">MÃ SỐ</th>
                        <th>THÔNG TIN KHÁCH HÀNG</th>
                        <th>TIÊU ĐỀ HỖ TRỢ</th>
                        <th style="width: 140px; text-align: center;">TRẠNG THÁI</th>
                        <th style="width: 160px;">THỜI GIAN GỬI</th>
                        <th style="width: 150px; text-align: center;">HÀNH ĐỘNG</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty contacts}">
                            <c:forEach items="${contacts}" var="c">
                                <tr id="row-${c.id}">
                                    <td><strong>#CT-${c.id}</strong></td>
                                    <td>
                                        <strong>${c.fullname}</strong><br>
                                        <small style="color: #64748b;">✉ ${c.email}</small><br>
                                        <small style="color: #64748b;">📞 ${c.phone}</small>
                                    </td>
                                    <td><div style="max-width: 280px; font-weight: 500; color: #1e293b;">${c.subject}</div></td>
                                    <td style="text-align: center;" id="status-box-${c.id}">
                                        <c:choose>
                                            <c:when test="${c.isRead == 0}">
                                                <span class="custom-badge badge-danger">Chưa xử lý</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="custom-badge badge-success">Đã liên hệ</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="date-cell">
                                        <fmt:formatDate value="${c.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td style="text-align: center;">
                                        <button type="button" class="btn-action-view btn-trigger-modal"
                                                data-id="${c.id}"
                                                data-fullname="${c.fullname}"
                                                data-email="${c.email}"
                                                data-phone="${c.phone}"
                                                data-subject="${c.subject}"
                                                data-message="${c.message}">
                                            <span class="material-symbols-outlined">visibility</span> Xem chi tiết
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="6" style="text-align: center; color: #94a3b8; padding: 24px;">Không có yêu cầu liên hệ nào.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<div id="contactModal" class="custom-modal-backdrop">
    <div class="custom-modal-box">
        <div class="modal-header-title">
            <h3>Chi tiết nội dung liên hệ</h3>
            <button type="button" class="modal-close-btn" onclick="closeModal()">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>

        <div class="modal-body-content">
            <div class="info-group">
                <div class="info-label">Họ và tên</div>
                <div class="info-value" id="modalFullname"></div>
            </div>
            <div class="info-group">
                <div class="info-label">Địa chỉ Email</div>
                <div class="info-value" id="modalEmail" style="font-weight: 600;"></div>
            </div>
            <div class="info-group">
                <div class="info-label">Số điện thoại</div>
                <div class="info-value" id="modalPhone"></div>
            </div>
            <div class="info-group">
                <div class="info-label">Tiêu đề</div>
                <div class="info-value" id="modalSubject"></div>
            </div>
            <div class="info-group">
                <div class="info-label">Nội dung tin nhắn</div>
                <div class="info-value" style="white-space: pre-line; background: #fffbe6; border-color: #ffe58f;" id="modalMessage"></div>
            </div>
        </div>

        <div class="modal-footer-actions">
            <button type="button" onclick="closeModal()" style="background: #f1f5f9; color: #475569; border: none; padding: 8px 16px; border-radius: 6px; cursor: pointer; font-weight: 500; font-size: 13px;">Đóng</button>
            <a id="replyGmailBtn" href="#" class="custom-badge badge-success" style="padding: 10px 18px; text-decoration: none; font-size: 13px; display: inline-flex; align-items: center; gap: 6px;">
                <span class="material-symbols-outlined" style="font-size: 16px;">mail</span>
                <span>Phản hồi qua Gmail</span>
            </a>
        </div>
    </div>
</div>

<script>
    let currentContactId = null;

    function openModalWithData(btn) {
        if (!btn) return;

        currentContactId = btn.getAttribute('data-id');
        const fullname = btn.getAttribute('data-fullname');
        const email = btn.getAttribute('data-email');
        const phone = btn.getAttribute('data-phone') || 'Không cung cấp';
        const subject = btn.getAttribute('data-subject');
        const message = btn.getAttribute('data-message');

        document.getElementById('modalFullname').innerText = fullname;
        document.getElementById('modalEmail').innerText = email;
        document.getElementById('modalPhone').innerText = phone;
        document.getElementById('modalSubject').innerText = subject;
        document.getElementById('modalMessage').innerText = message;

        // Cấu hình mailto tự động sinh nội dung
        const emailSubject = encodeURIComponent("[Gia Sư Bá Đạo] Phản hồi: " + subject);
        const emailBody = encodeURIComponent("Xin chào " + fullname + ",\n\nChúng tôi đã tiếp nhận phản hồi của bạn về việc: '" + message + "'\n\n[Nhập câu trả lời của Admin tại đây]\n\nTrân trọng,\nBan Quản Trị Gia Sư Bá Đạo VN.");

        const replyBtn = document.getElementById('replyGmailBtn');
        replyBtn.href = "mailto:" + email + "?subject=" + emailSubject + "&body=" + emailBody;

        // Thêm sự kiện click để tự động chuyển trạng thái ngầm qua AJAX
        replyBtn.onclick = function() {
            markAsReadInDatabase(currentContactId);
        };

        document.getElementById('contactModal').style.display = 'flex';
    }

    // Hàm gọi AJAX cập nhật trạng thái is_read = 1 không cần load lại trang
    function markAsReadInDatabase(id) {
        const params = new URLSearchParams();
        params.append('id', id);
        params.append('isRead', '1');

        fetch('${pageContext.request.contextPath}/admin/quan-ly-lien-he', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params
        })
            .then(response => response.json())
            .then(data => {
                if(data.status === 'success') {
                    // Đổi badge trạng thái trên table ngay lập tức
                    const statusBox = document.getElementById('status-box-' + id);
                    if(statusBox) {
                        statusBox.innerHTML = '<span class="custom-badge badge-success">Đã liên hệ</span>';
                    }
                }
            })
            .catch(err => console.error("Lỗi cập nhật trạng thái:", err));
    }

    // Lắng nghe click mở modal
    document.addEventListener('click', function(e) {
        const btn = e.target.closest('.btn-trigger-modal');
        if (btn) openModalWithData(btn);
    });

    function closeModal() {
        document.getElementById('contactModal').style.display = 'none';
    }

    window.addEventListener('click', function(event) {
        const modal = document.getElementById('contactModal');
        if (event.target === modal) closeModal();
    });
</script>
</body>
</html>