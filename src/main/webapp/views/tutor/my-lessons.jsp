<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<jsp:include page="/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Lớp học đang dạy - Gia Sư Bá Đạo"/>
</jsp:include>
<jsp:include page="/views/common/navbar.jsp"/>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<main class="page-main" style="background:#f8fafc; padding:40px 0; font-family:'Plus Jakarta Sans',sans-serif;">
    <div class="container" style="max-width:1240px; margin:0 auto; padding:0 20px;">
        <div style="display:flex; gap:24px; align-items:flex-start;">

            <jsp:include page="/views/tutor/sidebar.jsp"/>

            <section style="flex:1; background:#fff; padding:32px; border-radius:16px;
                        border:1px solid #e2e8f0; box-shadow:0 1px 3px rgba(0,0,0,0.04);">

                <%-- Alert messages --%>
                <c:if test="${not empty sessionScope.msgSuccess}">
                    <div style="background:#d1fae5; color:#065f46; padding:14px 18px; border-radius:10px;
                            margin-bottom:20px; font-weight:600; display:flex; align-items:center; gap:8px;">
                        <i class="bi bi-check-circle-fill"></i> ${sessionScope.msgSuccess}
                    </div>
                    <c:remove var="msgSuccess" scope="session"/>
                </c:if>
                <c:if test="${not empty sessionScope.msgError}">
                    <div style="background:#fee2e2; color:#991b1b; padding:14px 18px; border-radius:10px;
                            margin-bottom:20px; font-weight:600; display:flex; align-items:center; gap:8px;">
                        <i class="bi bi-exclamation-triangle-fill"></i> ${sessionScope.msgError}
                    </div>
                    <c:remove var="msgError" scope="session"/>
                </c:if>

                <c:choose>
                    <c:when test="${empty lessons}">
                        <div style="text-align:center; padding:60px 20px; color:#94a3b8;">
                            <i class="bi bi-calendar-x" style="font-size:48px; display:block; margin-bottom:16px;"></i>
                            <p style="font-size:16px; font-weight:700; color:#1e293b; margin:0;">Chưa có lớp học nào</p>
                        </div>
                    </c:when>
                    <c:otherwise>

                        <%-- PHẦN 1: THỜI KHÓA BIỂU TUẦN NÀY --%>
                        <div style="margin-bottom: 40px; border: 1px solid #e2e8f0; border-radius: 16px; padding: 24px; background: #fff;">
                            <h4 style="font-size: 18px; font-weight: 700; color: #1e293b; margin: 0 0 16px 0; display: flex; align-items: center; gap: 8px;">
                                <i class="bi bi-calendar3" style="color: #10b981;"></i> Thời khóa biểu dạy học tuần này
                            </h4>
                            <div style="overflow-x: auto;">
                                <table style="width: 100%; border-collapse: separate; border-spacing: 6px; table-layout: fixed; min-width: 800px;">
                                    <thead>
                                    <tr>
                                        <th style="background: #0f172a; color: white; text-align: center; padding: 12px; font-weight: 600; border-radius: 8px; font-size: 14px; width: 10%;">Buổi</th>
                                        <th style="background: #0f172a; color: white; text-align: center; padding: 12px; font-weight: 600; border-radius: 8px; font-size: 14px;">Thứ 2</th>
                                        <th style="background: #0f172a; color: white; text-align: center; padding: 12px; font-weight: 600; border-radius: 8px; font-size: 14px;">Thứ 3</th>
                                        <th style="background: #0f172a; color: white; text-align: center; padding: 12px; font-weight: 600; border-radius: 8px; font-size: 14px;">Thứ 4</th>
                                        <th style="background: #0f172a; color: white; text-align: center; padding: 12px; font-weight: 600; border-radius: 8px; font-size: 14px;">Thứ 5</th>
                                        <th style="background: #0f172a; color: white; text-align: center; padding: 12px; font-weight: 600; border-radius: 8px; font-size: 14px;">Thứ 6</th>
                                        <th style="background: #0f172a; color: white; text-align: center; padding: 12px; font-weight: 600; border-radius: 8px; font-size: 14px;">Thứ 7</th>
                                        <th style="background: #0f172a; color: white; text-align: center; padding: 12px; font-weight: 600; border-radius: 8px; font-size: 14px;">Chủ Nhật</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:set var="periods" value="${fn:split('Sáng,Chiều,Tối', ',')}" />
                                    <c:set var="days" value="${fn:split('Thứ 2,Thứ 3,Thứ 4,Thứ 5,Thứ 6,Thứ 7,Chủ Nhật', ',')}" />
                                    <c:forEach var="period" items="${periods}">
                                        <tr>
                                            <td style="background: #f8fafc; font-weight: 700; color: #475569; text-align: center; vertical-align: middle; border: 1px solid #e2e8f0; border-radius: 8px; font-size: 13px; height: 95px;">
                                                    ${period}
                                            </td>
                                            <c:forEach var="day" items="${days}">
                                                <c:set var="slotKey" value="${period} ${day}" />
                                                <td style="background: #fff; border: 1px dashed #cbd5e1; border-radius: 8px; vertical-align: top; padding: 6px; position: relative;">
                                                    <c:forEach var="b" items="${lessons}">
                                                        <c:if test="${(b.status == 'ACTIVE' || b.status == 'PAID' || b.status == 'PENDING_COMPLETED') && fn:contains(b.schedule, slotKey)}">
                                                            <div style="background: linear-gradient(135deg, #eafaf1, #d1fae5); border-left: 4px solid #10b981; border-radius: 6px; padding: 6px; font-size: 11px; color: #065f46; height: 100%; display: flex; flex-direction: column; justify-content: space-between; box-shadow: 0 2px 4px rgba(0,0,0,0.02); overflow: hidden;"
                                                                 title="Phụ huynh: ${b.tutorName} - Môn: ${b.subjectName}">
                                                                <div style="display: flex; align-items: center; gap: 4px; margin-bottom: 2px;">
                                                                    <img src="${not empty b.portraitUrl ? b.portraitUrl : pageContext.request.contextPath.concat('/assets/images/default-avatar.png')}"
                                                                         style="width: 18px; height: 18px; border-radius: 50%; object-fit: cover; border: 1px solid #10b981;">
                                                                    <span style="font-weight: 700; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 75px;">${b.tutorName}</span>
                                                                </div>
                                                                <span style="background: #10b981; color: white; padding: 1px 4px; border-radius: 4px; font-size: 10px; font-weight: 600; display: inline-block; width: fit-content; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 100%;">
                                                                        ${b.subjectName}
                                                                </span>
                                                            </div>
                                                        </c:if>
                                                    </c:forEach>
                                                </td>
                                            </c:forEach>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <%-- PHẦN 2: DANH SÁCH LỚP HỌC CHI TIẾT --%>
                        <h2 style="font-size:22px; font-weight:800; color:#0f172a; margin:0 0 24px;">
                            <i class="bi bi-list-stars" style="color:#10b981; margin-right:8px;"></i>
                            Danh sách lớp học chi tiết
                        </h2>

                        <div style="max-height: 480px; overflow-y: auto; padding-right: 6px; border: 1px solid #f1f5f9; border-radius: 12px; box-sizing: border-box;">
                            <table style="width:100%; border-collapse:collapse; font-size:14px; background: #fff;">
                                <thead style="position: sticky; top: 0; z-index: 10; background: #f8fafc;">
                                <tr style="border-bottom:2px solid #e2e8f0; color:#64748b; font-size:12px; font-weight:700; text-transform:uppercase; letter-spacing:0.05em;">
                                    <th style="padding:14px 16px; text-align:left;">Phụ huynh</th>
                                    <th style="padding:14px 16px;">Môn học</th>
                                    <th style="padding:14px 16px;">Lịch học</th>
                                    <th style="padding:14px 16px; text-align:right;">Học phí</th>
                                    <th style="padding:14px 16px; text-align:center;">Trạng thái</th>
                                    <th style="padding:14px 16px; text-align:center;">Thao tác</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="lesson" items="${lessons}">
                                    <tr style="border-bottom:1px solid #f1f5f9; transition:background 0.15s;"
                                        onmouseover="this.style.background='#f8fafc'"
                                        onmouseout="this.style.background='transparent'">

                                        <td style="padding:16px; display:flex; align-items:center; gap:10px;">
                                            <img src="${not empty lesson.portraitUrl ? lesson.portraitUrl : pageContext.request.contextPath.concat('/assets/images/default-avatar.png')}"
                                                 style="width:36px; height:36px; border-radius:50%; object-fit:cover; border:1px solid #e2e8f0; flex-shrink:0;">
                                            <span style="font-weight:600; color:#0f172a;">
                                                <c:out value="${lesson.tutorName}"/>
                                            </span>
                                        </td>

                                        <td style="padding:16px; text-align:center;">
                                            <span style="background:#f1f5f9; padding:4px 10px; border-radius:6px; font-size:12px; font-weight:600; color:#334155;">
                                                <c:out value="${lesson.subjectName}"/>
                                            </span>
                                        </td>

                                        <td style="padding:16px; color:#475569; font-size:12px; max-width:200px;">
                                            <c:out value="${lesson.schedule}"/>
                                        </td>

                                        <td style="padding:16px; text-align:right; font-weight:700; color:#10b981;">
                                            +<fmt:formatNumber value="${lesson.totalPrice}" type="number"/>đ
                                        </td>

                                            <%-- CỘT TRẠNG THÁI --%>
                                        <td style="padding:16px; text-align:center;">

                                                <%-- ĐANG DẠY --%>
                                            <c:if test="${lesson.status == 'ACTIVE' || lesson.status == 'PAID'}">
                                                <span style="background:#dcfce7; color:#166534; padding:4px 10px; border-radius:20px; font-size:12px; font-weight:600;">
                                                    <i class="bi bi-play-circle-fill"></i> Đang dạy
                                                </span>
                                            </c:if>

                                                <%-- CHỜ PHỤ HUYNH XÁC NHẬN --%>
                                            <c:if test="${lesson.status == 'PENDING_COMPLETED'}">
                                                <span style="background:#fef3c7; color:#d97706; padding:4px 10px; border-radius:20px; font-size:12px; font-weight:600;">
                                                    <i class="bi bi-hourglass-split"></i> Chờ PH xác nhận
                                                </span>
                                            </c:if>

                                                <%-- ĐANG TRANH CHẤP --%>
                                            <c:if test="${lesson.status == 'DISPUTED'}">
                                                <div style="display: flex; flex-direction: column; gap: 2px; align-items: center;">
                                                    <span style="background:#fee2e2; color:#991b1b; padding:4px 10px; border-radius:20px; font-size:12px; font-weight:600;">
                                                        <i class="bi bi-flag-fill"></i> Đang khiếu nại
                                                    </span>
                                                    <small style="color: #64748b; font-size: 10px; font-weight: 500;">
                                                        (Khởi tạo bởi: ${lesson.disputeBy == 'TUTOR' ? 'Bạn (Chờ 24h)' : 'Phụ huynh'})
                                                    </small>
                                                </div>
                                            </c:if>

                                                <%-- ĐÃ HOÀN THÀNH - GIA SƯ NHẬN TIỀN --%>
                                            <c:if test="${lesson.status == 'COMPLETED'}">
                                                <span style="background:#dbeafe; color:#1e40af; padding:4px 10px; border-radius:20px; font-size:12px; font-weight:600;">
                                                    <i class="bi bi-check-all"></i> Đã thanh toán
                                                </span>
                                            </c:if>

                                                <%-- ĐÃ HOÀN TIỀN - PHỤ HUYNH THẮNG KHIẾU NẠI --%>
                                            <c:if test="${lesson.status == 'REFUNDED'}">
                                                <span style="background:#f1f5f9; color:#64748b; padding:4px 10px; border-radius:20px; font-size:12px; font-weight:600; border:1px solid #e2e8f0;">
                                                    <i class="bi bi-arrow-counterclockwise"></i> Đã hoàn tiền PH
                                                </span>
                                            </c:if>

                                        </td>

                                            <%-- CỘT THAO TÁC --%>
                                        <td style="padding:16px; text-align:center;">

                                                <%-- Nút yêu cầu hoàn thành: chỉ hiện khi đang dạy --%>
                                            <c:if test="${lesson.status == 'ACTIVE' || lesson.status == 'PAID'}">
                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/tutor/my-lessons"
                                                      style="display:inline;"
                                                      onsubmit="return confirm('Gửi yêu cầu hoàn thành lớp học này tới Phụ huynh để xác nhận giải ngân?')">
                                                    <input type="hidden" name="action" value="request-complete">
                                                    <input type="hidden" name="bookingId" value="${lesson.id}">
                                                    <button type="submit"
                                                            style="background:#10b981; color:#fff; border:none; padding:7px 14px; border-radius:8px; font-size:12px; font-weight:600; cursor:pointer; white-space:nowrap; display:inline-flex; align-items:center; gap:4px;">
                                                        <i class="bi bi-send-check-fill"></i> Yêu cầu hoàn thành
                                                    </button>
                                                </form>
                                            </c:if>

                                                <%-- Nút khiếu nại: hiện khi chờ PH xác nhận --%>
                                            <c:if test="${lesson.status == 'PENDING_COMPLETED'}">
                                                <button type="button" onclick="openTutorDisputeModal('${lesson.id}')"
                                                        style="background:#ef4444; color:white; border:none; padding:6px 12px; border-radius:6px; font-size:12px; cursor:pointer; font-weight:600; display:inline-flex; align-items:center; gap:4px;">
                                                    <i class="bi bi-exclamation-triangle"></i> Khiếu nại lớp
                                                </button>
                                            </c:if>

                                                <%-- Không có thao tác cho COMPLETED / REFUNDED / DISPUTED --%>
                                            <c:if test="${lesson.status == 'COMPLETED' || lesson.status == 'REFUNDED' || lesson.status == 'DISPUTED'}">
                                                <span style="color:#cbd5e1; font-size:12px;">—</span>
                                            </c:if>

                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>

                    </c:otherwise>
                </c:choose>
            </section>
        </div>
    </div>
</main>

<%-- MODAL KHIẾU NẠI CỦA GIA SƯ --%>
<div id="tutorDisputeModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 9999; justify-content: center; align-items: center;">
    <div style="background: #fff; padding: 28px; border-radius: 16px; width: 100%; max-width: 480px; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1); box-sizing: border-box;">
        <h3 style="margin: 0 0 12px 0; font-size: 18px; font-weight: 700; color: #0f172a;">Gửi khiếu nại lớp học (Gia sư)</h3>
        <p style="margin: 0 0 20px 0; font-size: 13px; color: #64748b; line-height: 1.5;">
            Nếu bạn đã dạy xong nhưng phụ huynh không đồng ý xác nhận, hãy gửi khiếu nại kèm minh chứng. Nếu phụ huynh không phản hồi trong 24h, hệ thống sẽ tự động giải ngân cho bạn.
        </p>

        <input type="hidden" id="tutorModalBookingId" value="">

        <div style="margin-bottom: 20px;">
            <label style="display: block; font-size: 13px; font-weight: 600; color: #334155; margin-bottom: 8px;">Lý do khiếu nại <span style="color: #ef4444;">*</span></label>
            <textarea id="tutorDisputeReason" rows="4" placeholder="Nhập chi tiết nội dung khiếu nại..."
                      style="width: 100%; padding: 12px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; box-sizing: border-box; resize: none; outline: none;"></textarea>
        </div>

        <div style="margin-bottom: 24px;">
            <label style="display: block; font-size: 13px; font-weight: 600; color: #334155; margin-bottom: 8px;">Tệp ảnh / tài liệu minh chứng:</label>
            <input type="file" id="tutorDisputeFile" accept=".png, .jpg, .jpeg, .pdf, .docx, .doc"
                   style="width: 100%; padding: 8px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 13px; background: #fff; box-sizing: border-box;">
        </div>

        <div style="display: flex; gap: 12px; justify-content: flex-end;">
            <button onclick="closeTutorDisputeModal()"
                    style="background: #f1f5f9; color: #475569; border: none; padding: 10px 18px; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer;">
                Hủy bỏ
            </button>
            <button onclick="submitTutorDispute()"
                    style="background: #ef4444; color: white; border: none; padding: 10px 18px; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer;">
                Gửi khiếu nại
            </button>
        </div>
    </div>
</div>

<script>
    function openTutorDisputeModal(bookingId) {
        document.getElementById('tutorModalBookingId').value = bookingId;
        document.getElementById('tutorDisputeReason').value = '';
        document.getElementById('tutorDisputeFile').value = '';
        document.getElementById('tutorDisputeModal').style.display = 'flex';
    }

    function closeTutorDisputeModal() {
        document.getElementById('tutorDisputeModal').style.display = 'none';
    }

    function submitTutorDispute() {
        const bookingId = document.getElementById('tutorModalBookingId').value;
        const reason = document.getElementById('tutorDisputeReason').value.trim();
        const fileInput = document.getElementById('tutorDisputeFile');

        if (reason === '') {
            alert('Vui lòng điền lý do khiếu nại!');
            return;
        }

        if (confirm('Bạn có chắc chắn muốn gửi đơn khiếu nại lớp học này lên Ban quản trị?')) {
            const formData = new FormData();
            formData.append('bookingId', bookingId);
            formData.append('action', 'DISPUTE');  <%-- Chỉ append 1 lần --%>
            formData.append('reason', reason);
            if (fileInput.files.length > 0) {
                formData.append('evidenceFile', fileInput.files[0]);
            }

            closeTutorDisputeModal();

            fetch('${pageContext.request.contextPath}/tutor/my-lessons', {
                method: 'POST',
                body: formData
            })
                .then(res => res.json())
                .then(data => {
                    if (data.status === 'SUCCESS') {
                        alert('🎉 Gửi khiếu nại thành công! Phụ huynh có 24 giờ để phản hồi.');
                        window.location.reload();
                    } else {
                        alert('❌ Thao tác thất bại: ' + data.message);
                    }
                })
                .catch(err => {
                    console.error(err);
                    alert('❌ Lỗi kết nối hệ thống.');
                });
        }
    }
</script>

<jsp:include page="/views/common/footer.jsp"/>