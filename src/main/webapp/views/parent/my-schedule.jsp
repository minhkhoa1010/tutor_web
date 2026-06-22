<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<jsp:include page="/views/common/header.jsp">
  <jsp:param name="pageTitle" value="Lịch học của tôi"/>
  <jsp:param name="pageCss" value="/assets/css/user-profile.css"/>
</jsp:include>

<jsp:include page="/views/common/navbar.jsp"/>

<main class="page-main" style="background:#f8fafc; padding:40px 0;">
  <div class="container" style="max-width:1240px; margin:0 auto; padding:0 20px;">

    <div class="breadcrumb" style="margin-bottom:32px;">
      <a href="${pageContext.request.contextPath}/home" style="color: #64748b; text-decoration: none;">Trang chủ</a> / <span style="color: #0f172a; font-weight: 500;">Lịch học của tôi</span>
    </div>

    <div class="profile-detail-grid" style="display:flex; gap:24px; align-items:flex-start;">

      <jsp:include page="/views/parent/sidebar.jsp"/>

      <section class="profile-content-card" style="flex:1; background:#fff; padding:40px; border-radius:16px; border:1px solid #f1f5f9;">

        <div class="panel-main-header" style="margin-bottom:32px; border-bottom:1px solid #f1f5f9; padding-bottom:24px;">
          <h3 style="font-size:24px; font-weight:800; margin:0 0 8px 0;">Lịch học của tôi</h3>
          <p style="color:#64748b;">Theo dõi toàn bộ lịch học và thời khóa biểu đã đăng ký.</p>
        </div>

        <c:choose>
          <c:when test="${empty schedules}">
            <div style="text-align:center; padding:80px 20px;">
              <i class="bi bi-calendar-x" style="font-size:64px; color:#cbd5e1;"></i>
              <h4 style="margin: 16px 0 8px 0; font-weight: 700;">Chưa có lịch học nào</h4>
              <p style="color:#64748b; margin-bottom: 24px;">Bạn chưa thuê gia sư nào.</p>
              <a href="${pageContext.request.contextPath}/tutors" style="background:#0f172a; color:#fff; padding:10px 20px; border-radius:8px; text-decoration:none; font-weight:600;">Tìm gia sư ngay</a>
            </div>
          </c:when>

          <c:otherwise>

            <%-- ===== THỜI KHÓA BIỂU TUẦN NÀY ===== --%>
            <div style="margin-bottom: 40px; border: 1px solid #e2e8f0; border-radius: 16px; padding: 24px; background: #fff;">
              <h4 style="font-size: 18px; font-weight: 700; color: #1e293b; margin: 0 0 16px 0; display: flex; align-items: center; gap: 8px;">
                <i class="bi bi-calendar3" style="color: #2563eb;"></i> Thời khóa biểu tuần này
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
                          <c:forEach var="b" items="${schedules}">
                            <c:if test="${(b.status == 'ACTIVE' || b.status == 'PAID') && fn:contains(b.schedule, slotKey)}">
                              <div style="background: linear-gradient(135deg, #eff6ff, #dbeafe); border-left: 4px solid #2563eb; border-radius: 6px; padding: 6px; font-size: 11px; color: #1e3a8a; height: 100%; display: flex; flex-direction: column; justify-content: space-between; box-shadow: 0 2px 4px rgba(0,0,0,0.02); overflow: hidden;"
                                   title="Gia sư: ${b.tutorName} - Môn: ${b.subjectName}">
                                <div style="display: flex; align-items: center; gap: 4px; margin-bottom: 2px;">
                                  <img src="${b.portraitUrl}" style="width: 18px; height: 18px; border-radius: 50%; object-fit: cover; border: 1px solid #2563eb;">
                                  <span style="font-weight: 700; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 75px;">${b.tutorName}</span>
                                </div>
                                <span style="background: #2563eb; color: white; padding: 1px 4px; border-radius: 4px; font-size: 10px; font-weight: 600; display: inline-block; width: fit-content; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 100%;">
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

            <%-- ===== DANH SÁCH LỚP CHI TIẾT ===== --%>
            <h4 style="font-size: 18px; font-weight: 700; color: #1e293b; margin: 0 0 16px 0; display: flex; align-items: center; gap: 8px;">
              <i class="bi bi-list-stars" style="color: #10b981;"></i> Danh sách lớp chi tiết
            </h4>

            <div style="display: flex; flex-direction: column; gap: 16px; width: 100%; max-height: 520px; overflow-y: auto; padding-right: 6px; box-sizing: border-box;">
              <c:forEach var="b" items="${schedules}">
                <div style="display: flex; gap: 20px; align-items: center; padding: 24px; border: 1px solid #e2e8f0; border-radius: 14px; background: #fff; box-shadow: 0 1px 3px rgba(0,0,0,0.02); width: 100%; box-sizing: border-box;">

                  <img src="${b.portraitUrl}" style="width: 75px; height: 75px; border-radius: 50%; object-fit: cover; border: 1px solid #f1f5f9; flex-shrink: 0;">

                  <div style="flex: 1; min-width: 0;">
                    <h4 style="margin: 0 0 6px 0; font-size: 16px; font-weight: 700; color: #1e293b; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${b.tutorName}</h4>
                    <div style="font-size: 13px; color: #64748b; margin-bottom: 4px;">
                      Môn học: <strong style="color: #334155;">${b.subjectName}</strong>
                    </div>
                    <div style="font-size: 12px; color: #94a3b8;">Ngày thuê: ${b.createdAt}</div>
                  </div>

                  <div style="width: 280px; flex-shrink: 0;">
                    <div style="font-size: 12px; color: #64748b; margin-bottom: 6px; font-weight: 500;">Lịch học cụ thể</div>
                    <div style="background: #eff6ff; color: #2563eb; padding: 8px 12px; border-radius: 8px; font-size: 13px; font-weight: 600; line-height: 1.4;">${b.schedule}</div>
                  </div>

                  <div style="width: 160px; text-align: right; flex-shrink: 0; display: flex; flex-direction: column; gap: 8px; align-items: flex-end;">
                    <div style="font-size: 18px; font-weight: 800; color: #10b981;">
                      <fmt:formatNumber value="${b.totalPrice}" type="number"/> đ
                    </div>

                    <div style="display: flex; flex-direction: column; gap: 6px; width: 100%; align-items: flex-end;">
                      <c:choose>

                        <%-- ĐANG HỌC (ACTIVE hoặc PAID) --%>
                        <c:when test="${b.status == 'ACTIVE' || b.status == 'PAID'}">
                          <span style="background: #dcfce7; color: #166534; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; margin-bottom: 2px; display: inline-block;">
                            Đang học
                          </span>
                          <div style="display: flex; gap: 6px;">
                            <button onclick="handleParentAction('${b.id}', 'COMPLETE_DIRECT')"
                                    style="background: #0f172a; color: white; border: none; padding: 6px 14px; border-radius: 6px; font-size: 12px; cursor: pointer; font-weight: 600; transition: all 0.2s;">
                              Kết thúc lớp
                            </button>
                            <button onclick="openDisputeModal('${b.id}')"
                                    style="background: #ef4444; color: white; border: none; padding: 6px 14px; border-radius: 6px; font-size: 12px; cursor: pointer; font-weight: 600; transition: all 0.2s;">
                              Khiếu nại
                            </button>
                          </div>
                        </c:when>

                        <%-- GIA SƯ YÊU CẦU KẾT THÚC --%>
                        <c:when test="${b.status == 'PENDING_COMPLETED'}">
                          <span style="background: #fef3c7; color: #d97706; padding: 4px 12px; border-radius: 20px; font-size: 11px; font-weight: 600; text-align: right; display: inline-block; margin-bottom: 2px;">
                            Gia sư yêu cầu kết thúc
                          </span>
                          <div style="display: flex; gap: 6px;">
                            <button onclick="handleParentAction('${b.id}', 'APPROVE')"
                                    style="background: #10b981; color: white; border: none; padding: 6px 12px; border-radius: 6px; font-size: 12px; cursor: pointer; font-weight: 600;">
                              Đồng ý
                            </button>
                            <button onclick="handleParentAction('${b.id}', 'REJECT_COMPLETE')"
                                    style="background: #f97316; color: white; border: none; padding: 6px 12px; border-radius: 6px; font-size: 12px; cursor: pointer; font-weight: 600;">
                              Từ chối
                            </button>
                            <button onclick="openDisputeModal('${b.id}')"
                                    style="background: #ef4444; color: white; border: none; padding: 6px 12px; border-radius: 6px; font-size: 12px; cursor: pointer; font-weight: 600;">
                              Khiếu nại
                            </button>
                          </div>
                        </c:when>

                        <%-- ĐANG TRANH CHẤP --%>
                        <c:when test="${b.status == 'DISPUTED'}">
                          <c:choose>
                            <c:when test="${b.disputeBy == 'TUTOR'}">
                              <%-- Gia sư chủ động khiếu nại: cho PH phản hồi trong 24h --%>
                              <div style="display: flex; flex-direction: column; gap: 6px; align-items: flex-end; width: 100%;">
                                <span style="background: #fff7ed; color: #c2410c; padding: 6px 12px; border-radius: 8px; font-size: 11px; font-weight: 600; border: 1px solid #fed7aa; line-height: 1.4; text-align: left; max-width: 220px;">
                                  ⚠️ Gia sư đang khiếu nại lớp học này! Nếu bạn không "Khiếu nại phản hồi" trong vòng 24h, hệ thống sẽ tự động giải ngân cho gia sư.
                                </span>
                                <button onclick="openDisputeModal('${b.id}')"
                                        style="background: #ef4444; color: white; border: none; padding: 6px 14px; border-radius: 6px; font-size: 12px; cursor: pointer; font-weight: 600; transition: all 0.2s;">
                                  Khiếu nại phản hồi
                                </button>
                              </div>
                            </c:when>
                            <c:otherwise>
                              <%-- Phụ huynh đã khiếu nại, chờ admin xử lý --%>
                              <span style="background: #fee2e2; color: #991b1b; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; border: 1px solid #fca5a5; display: inline-block;">
                                ⚠️ Đang chờ Admin xử lý
                              </span>
                            </c:otherwise>
                          </c:choose>
                        </c:when>

                        <%-- HOÀN THÀNH (gia sư đã nhận tiền) --%>
                        <c:when test="${b.status == 'COMPLETED'}">
                          <span style="background: #dbeafe; color: #1e40af; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600;">
                            Hoàn thành
                          </span>
                        </c:when>

                        <%-- ĐÃ HOÀN TIỀN (phụ huynh thắng khiếu nại) --%>
                        <c:when test="${b.status == 'REFUNDED'}">
                          <span style="background: #f0fdf4; color: #15803d; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; border: 1px solid #bbf7d0; display: inline-block;">
                            ✅ Đã hoàn tiền
                          </span>
                        </c:when>

                      </c:choose>
                    </div>
                  </div>

                </div>
              </c:forEach>
            </div>

          </c:otherwise>
        </c:choose>

      </section>
    </div>
  </div>
</main>

<%-- ===== MODAL KHIẾU NẠI ===== --%>
<div id="disputeModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 9999; justify-content: center; align-items: center;">
  <div style="background: #fff; padding: 28px; border-radius: 16px; width: 100%; max-width: 480px; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1); box-sizing: border-box; position: relative;">
    <h3 style="margin: 0 0 12px 0; font-size: 18px; font-weight: 700; color: #0f172a;">Gửi khiếu nại lớp học</h3>
    <p style="margin: 0 0 20px 0; font-size: 13px; color: #64748b; line-height: 1.5;">
      Vui lòng cung cấp lý do chi tiết kèm theo tệp minh chứng (hình ảnh/tài liệu). Ban quản trị sẽ kiểm tra và phân xử trong vòng 24h.
    </p>

    <input type="hidden" id="modalBookingId" value="">

    <div style="margin-bottom: 20px;">
      <label style="display: block; font-size: 13px; font-weight: 600; color: #334155; margin-bottom: 8px;">Lý do khiếu nại <span style="color: #ef4444;">*</span></label>
      <textarea id="disputeReason" rows="4" placeholder="Nhập chi tiết lý do khiếu nại tại đây..."
                style="width: 100%; padding: 12px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; font-family: inherit; box-sizing: border-box; resize: none; outline: none;"></textarea>
    </div>

    <div style="margin-bottom: 24px;">
      <label style="display: block; font-size: 13px; font-weight: 600; color: #334155; margin-bottom: 8px;">Tài liệu / Ảnh minh chứng (PDF, Word, PNG, JPG):</label>
      <input type="file" id="disputeFile" accept=".png, .jpg, .jpeg, .pdf, .docx, .doc"
             style="width: 100%; padding: 8px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 13px; background: #fff; box-sizing: border-box; outline: none;">
      <small style="display: block; color: #64748b; margin-top: 6px; font-size: 11px; line-height: 1.4;">* Lưu ý: Tệp đính kèm giúp Ban quản trị xác minh và giải quyết hoàn tiền chính xác hơn.</small>
    </div>

    <div style="display: flex; gap: 12px; justify-content: flex-end;">
      <button onclick="closeDisputeModal()"
              style="background: #f1f5f9; color: #475569; border: none; padding: 10px 18px; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer;">
        Hủy bỏ
      </button>
      <button onclick="submitDispute()"
              style="background: #ef4444; color: white; border: none; padding: 10px 18px; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer;">
        Gửi khiếu nại
      </button>
    </div>
  </div>
</div>

<script>
  function handleParentAction(bookingId, actionType) {
    let confirmMsg = "";
    if (actionType === 'COMPLETE_DIRECT') {
      confirmMsg = "Bạn muốn kết thúc lớp học này? Lịch dạy của gia sư sẽ được giải phóng hoàn toàn.";
    } else if (actionType === 'APPROVE') {
      confirmMsg = "Bạn đồng ý xác nhận lớp học đã hoàn thành? Hệ thống sẽ chuyển tiền cho gia sư.";
    } else if (actionType === 'REJECT_COMPLETE') {
      confirmMsg = "Bạn muốn TỪ CHỐI yêu cầu kết thúc? Lớp học sẽ quay lại trạng thái Đang học để tiếp tục giảng dạy.";
    }
    if (confirm(confirmMsg)) {
      executePostAction(bookingId, actionType, '');
    }
  }

  function openDisputeModal(bookingId) {
    document.getElementById('modalBookingId').value = bookingId;
    document.getElementById('disputeReason').value = '';
    document.getElementById('disputeFile').value = '';
    document.getElementById('disputeModal').style.display = 'flex';
  }

  function closeDisputeModal() {
    document.getElementById('disputeModal').style.display = 'none';
  }

  function submitDispute() {
    let bookingId = document.getElementById('modalBookingId').value;
    let reason = document.getElementById('disputeReason').value.trim();
    let fileInput = document.getElementById('disputeFile');

    if (reason === '') {
      alert('Vui lòng nhập lý do khiếu nại trước khi gửi!');
      return;
    }

    let isConfirmed = confirm('Bạn có chắc chắn muốn gửi đơn khiếu nại này cùng với tệp minh chứng không?\nHành động này sẽ gửi tới Ban quản trị và không thể hoàn tác.');
    if (isConfirmed) {
      let formData = new FormData();
      formData.append('bookingId', bookingId);
      formData.append('action', 'DISPUTE');
      formData.append('reason', reason);
      if (fileInput.files.length > 0) {
        formData.append('evidenceFile', fileInput.files[0]);
      }
      closeDisputeModal();
      executeMultipartPostAction(formData);
    }
  }

  function executePostAction(bookingId, action, reason) {
    fetch('${pageContext.request.contextPath}/booking/parent-action', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: 'bookingId=' + bookingId + '&action=' + action + '&reason=' + encodeURIComponent(reason)
    })
            .then(res => res.json())
            .then(data => {
              if (data.status === 'SUCCESS') {
                alert('🎉 Thao tác thành công!');
                window.location.reload();
              } else {
                alert('❌ Có lỗi xảy ra: ' + data.message);
              }
            })
            .catch(err => {
              console.error("Lỗi gửi yêu cầu:", err);
              alert('Đã xảy ra lỗi kết nối với hệ thống.');
            });
  }

  function executeMultipartPostAction(formData) {
    fetch('${pageContext.request.contextPath}/booking/parent-action', {
      method: 'POST',
      body: formData
    })
            .then(res => res.json())
            .then(data => {
              if (data.status === 'SUCCESS') {
                alert('🎉 Gửi đơn khiếu nại thành công! Ban quản trị sẽ tiến hành xác minh.');
                window.location.reload();
              } else {
                alert('❌ Có lỗi xảy ra: ' + data.message);
              }
            })
            .catch(err => {
              console.error("Lỗi gửi tệp minh chứng:", err);
              alert('❌ Không thể kết nối tới máy chủ lúc này. Vui lòng thử lại sau!');
            });
  }
</script>

<jsp:include page="/views/common/footer.jsp"/>
