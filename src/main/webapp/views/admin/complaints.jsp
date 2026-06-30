<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Khiếu nại – Gia Sư Bá Đạo VN</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" />
</head>
<body>
<div class="admin-wrapper">
    <style>
        /* --- FIX LỖI AVATAR TRÒN & BADGE GỌN GÀNG --- */
        .complaint-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #e2e8f0;
            vertical-align: middle;
        }

        .custom-badge {
            display: inline-block;
            padding: 4px 10px;
            font-size: 12px;
            font-weight: 600;
            border-radius: 6px;
            text-align: center;
        }
        .badge-danger {
            background-color: #fee2e2;
            color: #ef4444;
        }
        .badge-success {
            background-color: #d1fae5;
            color: #10b981;
        }

        /* --- FIX LỖI ICON BỊ LỆCH --- */
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
        .btn-action-view:hover {
            background: #0f172a;
        }
        .btn-action-view .material-symbols-outlined {
            font-size: 18px;
            vertical-align: middle;
        }

        /* --- POPUP MODAL XEM CHI TIẾT THUẦN CSS --- */
        .custom-modal-backdrop {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(15, 23, 42, 0.6);
            z-index: 9999;
            justify-content: center;
            align-items: center;
            backdrop-filter: blur(4px);
        }

        .custom-modal-box {
            background: #ffffff;
            width: 100%;
            max-width: 550px;
            border-radius: 12px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            padding: 24px;
            animation: modalFadeIn 0.3s ease;
        }

        @keyframes modalFadeIn {
            from { transform: translateY(-20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        .modal-header-title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #f1f5f9;
            padding-bottom: 12px;
            margin-bottom: 16px;
        }
        .modal-header-title h3 {
            margin: 0;
            font-size: 18px;
            color: #1e293b;
        }
        .modal-close-btn {
            background: none;
            border: none;
            cursor: pointer;
            color: #94a3b8;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .modal-close-btn:hover { color: #64748b; }

        .modal-body-content .info-group {
            margin-bottom: 14px;
        }
        .modal-body-content .info-label {
            font-size: 12px;
            color: #64748b;
            text-transform: uppercase;
            font-weight: 600;
            margin-bottom: 4px;
        }
        .modal-body-content .info-value {
            font-size: 15px;
            color: #0f172a;
            background: #f8fafc;
            padding: 10px 12px;
            border-radius: 6px;
            border: 1px solid #f1f5f9;
        }
        .modal-footer-actions {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 24px;
            border-top: 1px solid #f1f5f9;
            padding-top: 16px;
        }
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
                <input type="text" placeholder="Tìm kiếm khiếu nại...">
            </div>
        </header>

        <div class="page-body">
            <div class="page-title-row">
                <div>
                    <h1>Trung tâm xử lý Khiếu nại</h1>
                    <p>Giải quyết các tranh chấp, báo cáo vi phạm hợp đồng giảng dạy từ Phụ huynh & Học viên.</p>
                </div>
            </div>

            <%-- ========================================================== --%>
            <%-- ĐOẠN HIỂN THỊ THÔNG BÁO KẾT QUẢ (FLASH MESSAGE) ĐƯỢC CHÈN TẠI ĐÂY --%>
            <%-- ========================================================== --%>
            <c:if test="${not empty msgSuccess}">
                <div class="alert alert-success" style="padding: 12px 16px; background-color: #d1fae5; color: #047857; border: 1px solid #a7f3d0; border-radius: 8px; margin-top: 16px; font-weight: 500; display: inline-flex; align-items: center; gap: 8px; width: 100%; box-sizing: border-box;">
                    <span class="material-symbols-outlined" style="font-size: 20px; color: #10b981;">check_circle</span>
                    <div>${msgSuccess}</div>
                </div>
                <%-- Xóa ngay sau khi hiển thị để khi nhấn F5 hoặc tải lại không bị lặp lại --%>
                <c:remove var="msgSuccess" scope="session" />
            </c:if>

            <c:if test="${not empty msgError}">
                <div class="alert alert-danger" style="padding: 12px 16px; background-color: #fee2e2; color: #b91c1c; border: 1px solid #fca5a5; border-radius: 8px; margin-top: 16px; font-weight: 500; display: inline-flex; align-items: center; gap: 8px; width: 100%; box-sizing: border-box;">
                    <span class="material-symbols-outlined" style="font-size: 20px; color: #ef4444;">error</span>
                    <div>${msgError}</div>
                </div>
                <c:remove var="msgError" scope="session" />
            </c:if>
            <%-- ========================================================== --%>

            <div class="table-section" style="margin-top: 16px;">
                <table class="data-table">
                    <thead>
                    <tr>
                        <th style="width: 120px;">MÃ LỚP (ID)</th>
                        <th>NGƯỜI KHIẾU NẠI</th>
                        <th>BÊN BỊ KHIẾU NẠI</th>
                        <th>LÝ DO VI PHẠM</th>
                        <th style="width: 160px;">THỜI GIAN TẠO</th>
                        <th style="width: 150px; text-align: center;">HÀNH ĐỘNG</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                    <c:when test="${not empty complaints}">
                    <c:forEach items="${complaints}" var="c">
                        <%--                                <div style="color: red; font-size: 10px;">--%>
                        <%--                                    Debug ID: ${c.booking_id} | Ai kiện: ${c.dispute_by}--%>
            </div>
            <tr>

                <td><strong>#BK-${c.booking_id}</strong><br><small>${c.subject_name}</small></td>

                    <%-- Cột Người khiếu nại (Động) --%>
                <td>
                        <span style="font-size: 11px; padding: 2px 6px; border-radius: 4px; background: ${c.dispute_by == 'TUTOR' ? '#dbeafe' : '#fef3c7'}">
                                ${c.dispute_by == 'TUTOR' ? 'Gia sư' : 'Phụ huynh'}
                        </span><br>
                    <strong>${c.dispute_by == 'TUTOR' ? c.tutor_name : c.parent_name}</strong>
                </td>

                    <%-- Cột Bên bị khiếu nại (Động) --%>
                <td>
                        ${c.dispute_by == 'TUTOR' ? 'Phụ huynh' : 'Gia sư'}:
                    <strong>${c.dispute_by == 'TUTOR' ? c.parent_name : c.tutor_name}</strong>
                </td>

                <td><div style="max-width: 320px; color:#ef4444; font-weight:500;">⚠ ${c.dispute_reason}</div></td>
                <td class="date-cell">${c.created_at}</td>

                <td style="text-align: center;">
                    <button type="button" class="btn-action-view btn-trigger-modal"
                            data-id="${c.booking_id}"
                            data-parent="${c.parent_name}"
                            data-tutor="${c.tutor_name}"
                            data-subject="${c.subject_name}"
                            data-reason="${c.dispute_reason}"
                            data-price="<fmt:formatNumber value='${c.total_price}' type='number'/>"
                            data-evidence="${c.dispute_evidence_url}"
                            data-dispute-by="${c.dispute_by}"> <%-- TRUYỀN THÊM TRƯỜNG NÀY --%>
                        <span class="material-symbols-outlined">visibility</span> Xem chi tiết
                    </button>
                </td>
            </tr>
            </c:forEach>
            </c:when>
            </c:choose>
            </tbody>
            </table>
        </div>
    </div>
</div>
</div>

<div id="complaintModal" class="custom-modal-backdrop">
    <div class="custom-modal-box">
        <div class="modal-header-title">
            <h3>Chi tiết khiếu nại</h3>
            <button type="button" class="modal-close-btn" onclick="closeModal()">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>

        <div class="modal-body-content">
            <div class="info-group">
                <div class="info-label">Phụ huynh</div>
                <div class="info-value" id="modalParent"></div>
            </div>
            <div class="info-group">
                <div class="info-label">Gia sư </div>
                <div class="info-value" id="modalTutor"></div>
            </div>
            <div class="info-group">
                <div class="info-label">Lớp học / Môn học</div>
                <div class="info-value" id="modalSubject"></div>
            </div>
            <div class="info-group">
                <div class="info-label">Học phí đang tranh chấp</div>
                <div class="info-value" id="modalPrice" style="font-weight: 600; color: #0f172a;"></div>
            </div>
            <div class="info-group">
                <div class="info-label">Lý do vi phạm</div>
                <div class="info-value" style="color: #ef4444; font-weight: 500;" id="modalReason"></div>
            </div>

            <div class="info-group" id="evidenceSection">
                <div class="info-label">Minh chứng kèm theo</div>
                <div class="info-value" style="background: #eff6ff; border-color: #bfdbfe;">
                    <span class="material-symbols-outlined" style="font-size: 18px; vertical-align: middle; color: #2563eb; margin-right: 4px;">attach_file</span>
                    <a id="modalEvidenceLink" href="#" target="_blank" style="color: #2563eb; text-decoration: none; font-weight: 600;">Xem tệp đính kèm đầy đủ</a>
                </div>
            </div>
        </div>

        <div class="modal-footer-actions">
            <button type="button" onclick="closeModal()" style="background: #f1f5f9; color: #475569; border: none; padding: 8px 16px; border-radius: 6px; cursor: pointer; font-weight: 500; font-size: 13px;">Đóng</button>
            <a id="rejectBtn" href="#" class="custom-badge badge-success" style="padding: 8px 16px; text-decoration: none; font-size: 13px; display: inline-flex; align-items: center; gap: 4px;">
                <span class="material-symbols-outlined" style="font-size: 16px;">layers_clear</span>
                <span id="rejectBtnLabel">Bác đơn</span>
            </a>
            <a id="acceptBtn" href="#" class="custom-badge badge-danger" style="padding: 8px 16px; text-decoration: none; font-size: 13px; display: inline-flex; align-items: center; gap: 4px;">
                <span class="material-symbols-outlined" style="font-size: 16px;">restart_alt</span>
                <span id="acceptBtnLabel">Hoàn tiền</span>
            </a>
        </div>
    </div>
</div>

<script>
    // --- 1. Hàm core xử lý dữ liệu và mở Modal ---
    function openModalWithData(btn) {
        if (!btn) return;

        // Lấy dữ liệu
        const id = btn.getAttribute('data-id');
        const parent = btn.getAttribute('data-parent');
        const tutor = btn.getAttribute('data-tutor');
        const subject = btn.getAttribute('data-subject');
        const reason = btn.getAttribute('data-reason');
        const price = btn.getAttribute('data-price');
        const evidenceUrl = btn.getAttribute('data-evidence');
        const disputeBy = btn.getAttribute('data-dispute-by'); // Nhận giá trị mới

        // Logic hiển thị đúng vai trò
        if (disputeBy === 'TUTOR') {
            document.getElementById('modalParent').innerText = parent + " (Bị khiếu nại)";
            document.getElementById('modalTutor').innerText = tutor + " (Người khiếu nại)";
        } else {
            document.getElementById('modalParent').innerText = parent + " (Người khiếu nại)";
            document.getElementById('modalTutor').innerText = tutor + " (Bị khiếu nại)";
        }

        document.getElementById('modalSubject').innerText = subject;
        document.getElementById('modalReason').innerText = reason;
        document.getElementById('modalPrice').innerText = price + " VNĐ";

        // ... giữ nguyên phần xử lý evidence ...
        const evidenceSection = document.getElementById('evidenceSection');
        const evidenceLink = document.getElementById('modalEvidenceLink');
        if (evidenceUrl && evidenceUrl !== 'null' && evidenceUrl.trim() !== '') {
            evidenceLink.href = evidenceUrl;
            evidenceSection.style.display = 'block';
        } else {
            evidenceSection.style.display = 'none';
        }

        const rejectBtn = document.getElementById('rejectBtn');
        const acceptBtn = document.getElementById('acceptBtn');

        rejectBtn.href = '${pageContext.request.contextPath}/admin/complaints?action=reject&bookingId=' + id;
        acceptBtn.href = '${pageContext.request.contextPath}/admin/complaints?action=accept&bookingId=' + id;

        if (disputeBy === 'TUTOR') {
            // Gia sư là người khiếu nại → muốn lấy tiền
            // Bác đơn = không cho gia sư lấy → phụ huynh thắng → hoàn tiền PH
            // Chấp nhận = đồng ý cho gia sư lấy → gia sư thắng → giải ngân GS
            document.getElementById('rejectBtnLabel').innerText = 'Bác đơn (Phụ huynh thắng → Hoàn tiền PH)';
            document.getElementById('acceptBtnLabel').innerText = 'Chấp nhận (Gia sư thắng → Giải ngân GS)';
            rejectBtn.onclick = () => confirm('PHỤ HUYNH THẮNG: Bác đơn của gia sư, hoàn tiền về ví phụ huynh?');
            acceptBtn.onclick = () => confirm('GIA SƯ THẮNG: Chấp nhận đơn, giải ngân học phí cho gia sư?');
        } else {
            // Phụ huynh là người khiếu nại → muốn lấy tiền về
            // Bác đơn = không cho PH lấy về → gia sư thắng → giải ngân GS
            // Chấp nhận = đồng ý hoàn tiền → phụ huynh thắng → hoàn tiền PH
            document.getElementById('rejectBtnLabel').innerText = 'Bác đơn (Gia sư thắng → Giải ngân GS)';
            document.getElementById('acceptBtnLabel').innerText = 'Hoàn tiền (Phụ huynh thắng → Hoàn tiền PH)';
            rejectBtn.onclick = () => confirm('GIA SƯ THẮNG: Bác đơn của phụ huynh, giải ngân học phí cho gia sư?');
            acceptBtn.onclick = () => confirm('PHỤ HUYNH THẮNG: Chấp nhận đơn, hoàn trả học phí về ví phụ huynh?');
        }

        document.getElementById('complaintModal').style.display = 'flex';
    }

    // --- 2. Lắng nghe click toàn trang (Event Delegation) ---
    document.addEventListener('click', function(e) {
        const btn = e.target.closest('.btn-trigger-modal');
        if (btn) openModalWithData(btn);
    });

    // --- 3. Đóng Modal ---
    function closeModal() {
        document.getElementById('complaintModal').style.display = 'none';
    }

    window.addEventListener('click', function(event) {
        const modal = document.getElementById('complaintModal');
        if (event.target === modal) closeModal();
    });

    // --- 4. TỰ ĐỘNG MỞ KHI VỪA VÀO TRANG (Logic chính) ---
    document.addEventListener("DOMContentLoaded", function () {
        const urlParams = new URLSearchParams(window.location.search);
        const bookingId = urlParams.get('bookingId');

        if (bookingId) {
            console.log("Phát hiện ID từ URL: " + bookingId + ". Đang cố gắng mở...");

            // Thử tìm ngay lập tức
            let targetBtn = document.querySelector('.btn-trigger-modal[data-id="' + bookingId + '"]');

            if (targetBtn) {
                openModalWithData(targetBtn);
            } else {
                // Nếu chưa tìm thấy, chờ 500ms (cho trường hợp bảng load chậm)
                setTimeout(function() {
                    targetBtn = document.querySelector('.btn-trigger-modal[data-id="' + bookingId + '"]');
                    if (targetBtn) {
                        openModalWithData(targetBtn);
                    } else {
                        console.error("Không tìm thấy nút với ID: " + bookingId + ". Có thể item không nằm ở trang hiện tại?");
                    }
                }, 500);
            }
        }
    });
</script>

</body>
</html>