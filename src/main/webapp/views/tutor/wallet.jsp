<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<jsp:include page="/views/common/header.jsp">
  <jsp:param name="pageTitle" value="Quản lý ví & Rút tiền - Gia Sư Bá Đạo"/>
</jsp:include>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<jsp:include page="/views/common/navbar.jsp" />

<%-- Lấy thông tin User hiện tại từ Session --%>
<c:set var="u" value="${sessionScope.clientUser}"/>

<main class="page-main" style="background-color: #f8fafc; padding: 40px 0; font-family: 'Plus Jakarta Sans', sans-serif;">
  <div class="container" style="max-width: 1240px; margin: 0 auto; padding: 0 20px;">

    <%-- Breadcrumb --%>
    <div class="breadcrumb" style="margin-bottom: 32px; font-size: 14px; color: #64748b;">
      <a href="${pageContext.request.contextPath}/home" style="color: #64748b; text-decoration: none;">Trang chủ</a>
      <span style="margin: 0 8px; color: #cbd5e1;">/</span>
      <span style="color: #0f172a; font-weight: 500;">Quản lý ví & Rút tiền</span>
    </div>

    <div class="profile-detail-grid" style="display: flex; gap: 24px; align-items: flex-start;">
      <jsp:include page="/views/tutor/sidebar.jsp"/>
      <%-- LEFT SIDEBAR: Menu điều hướng cho Gia sư --%>
<%--      <aside class="profile-sidebar-card" style="background: #fff; padding: 24px; border-radius: 16px; box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.05); width: 300px; flex-shrink: 0;">--%>
<%--        <div style="text-align: center; margin-bottom: 24px;">--%>
<%--          <img src="${not empty u.avatarUrl ? u.avatarUrl : '/assets/images/default-avatar.png'}"--%>
<%--               alt="${u.fullname}"--%>
<%--               style="width: 84px; height: 84px; border-radius: 50%; object-fit: cover; border: 3px solid #10b981; padding: 2px;">--%>
<%--          <h3 style="margin: 12px 0 4px; font-size: 16px; font-weight: 700; color: #0f172a;">${u.fullname}</h3>--%>
<%--          <span style="font-size: 13px; color: #64748b; background: #f1f5f9; padding: 4px 10px; border-radius: 20px; font-weight: 500;">Gia sư đối tác</span>--%>
<%--        </div>--%>

<%--        <div class="profile-nav-group" style="display: flex; flex-direction: column; gap: 8px;">--%>
<%--          <a href="${pageContext.request.contextPath}/tutor/dashboard" class="profile-nav-btn" style="display: flex; align-items: center; gap: 12px; padding: 12px 16px; border-radius: 8px; color: #475569; text-decoration: none; font-weight: 600; font-size: 14px; transition: all 0.2s;">--%>
<%--            <i class="bi bi-speedometer2" style="font-size: 18px;"></i> Bảng điều khiển--%>
<%--          </a>--%>
<%--          <a href="${pageContext.request.contextPath}/tutor/profile" class="profile-nav-btn" style="display: flex; align-items: center; gap: 12px; padding: 12px 16px; border-radius: 8px; color: #475569; text-decoration: none; font-weight: 600; font-size: 14px; transition: all 0.2s;">--%>
<%--            <i class="bi bi-person-vcard" style="font-size: 18px;"></i> Hồ sơ gia sư--%>
<%--          </a>--%>
<%--          <a href="${pageContext.request.contextPath}/tutor/my-lessons" class="profile-nav-btn" style="display: flex; align-items: center; gap: 12px; padding: 12px 16px; border-radius: 8px; color: #475569; text-decoration: none; font-weight: 600; font-size: 14px; transition: all 0.2s;">--%>
<%--            <i class="bi bi-journal-check" style="font-size: 18px;"></i> Lớp học đang dạy--%>
<%--          </a>--%>
<%--          &lt;%&ndash; Active Tab quản lý ví &ndash;%&gt;--%>
<%--          <a href="${pageContext.request.contextPath}/tutor/wallet" class="profile-nav-btn" style="display: flex; align-items: center; gap: 12px; padding: 12px 16px; border-radius: 8px; background: #0f172a; color: #fff; text-decoration: none; font-weight: 600; font-size: 14px; transition: all 0.2s;">--%>
<%--            <i class="bi bi-credit-card-2-front" style="font-size: 18px;"></i> Quản lý ví & Rút tiền--%>
<%--          </a>--%>
<%--          <a href="${pageContext.request.contextPath}/tutor/settings" class="profile-nav-btn" style="display: flex; align-items: center; gap: 12px; padding: 12px 16px; border-radius: 8px; color: #475569; text-decoration: none; font-weight: 600; font-size: 14px; transition: all 0.2s;">--%>
<%--            <i class="bi bi-cash-coin" style="font-size: 18px;"></i> Cập nhật học phí--%>
<%--          </a>--%>
<%--          <a href="${pageContext.request.contextPath}/tutor/change-password" class="profile-nav-btn" style="display: flex; align-items: center; gap: 12px; padding: 12px 16px; border-radius: 8px; color: #475569; text-decoration: none; font-weight: 600; font-size: 14px; transition: all 0.2s;">--%>
<%--            <i class="bi bi-lock-fill" style="font-size: 18px;"></i> Đổi mật khẩu--%>
<%--          </a>--%>
<%--        </div>--%>
<%--      </aside>--%>

      <%-- RIGHT CONTENT SECTION --%>
      <div style="flex: 1; display: flex; flex-direction: column; gap: 24px;">

        <%-- Alert Message Thông báo trạng thái --%>
        <c:if test="${not empty sessionScope.msgSuccess}">
          <div style="padding: 14px 20px; background: #d1fae5; color: #065f46; border-radius: 12px; font-weight: 600; font-size: 14px; display: flex; align-items: center; gap: 10px;">
            <i class="bi bi-check-circle-fill"></i> ${sessionScope.msgSuccess}
          </div>
          <c:remove var="msgSuccess" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.msgError}">
          <div style="padding: 14px 20px; background: #fee2e2; color: #991b1b; border-radius: 12px; font-weight: 600; font-size: 14px; display: flex; align-items: center; gap: 10px;">
            <i class="bi bi-exclamation-triangle-fill"></i> ${sessionScope.msgError}
          </div>
          <c:remove var="msgError" scope="session"/>
        </c:if>

        <%-- 1. Thẻ tổng quan số dư --%>
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
          <div style="background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%); padding: 24px; border-radius: 16px; color: #fff; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1);">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
              <span style="font-size: 14px; font-weight: 500; color: #94a3b8;">SỐ DƯ KHẢ DỤNG</span>
              <i class="bi bi-wallet2" style="font-size: 24px; color: #10b981;"></i>
            </div>
            <h2 style="font-size: 32px; font-weight: 700; margin: 0 0 8px 0; letter-spacing: -0.5px;">
              <fmt:formatNumber value="${u.balance}" type="number"/>đ
            </h2>
            <p style="margin: 0; font-size: 12px; color: #94a3b8;">Số dư khả dụng dùng để tạo lệnh rút tiền về ngân hàng.</p>
          </div>

          <div style="background: #fff; padding: 24px; border-radius: 16px; border: 1px solid #e2e8f0; display: flex; flex-direction: column; justify-content: center;">
            <span style="font-size: 14px; font-weight: 600; color: #64748b; margin-bottom: 8px;">LƯU Ý RÚT TIỀN</span>
            <ul style="margin: 0; padding-left: 18px; font-size: 13px; color: #475569; line-height: 1.6;">
              <li>Hạn mức rút tối thiểu: <strong style="color: #0f172a;">50,000đ</strong> / giao dịch.</li>
              <li>Yêu cầu sẽ được Ban quản trị duyệt trong vòng <strong style="color: #0f172a;">24h làm việc</strong>.</li>
              <li>Đảm bảo thông tin số tài khoản khớp đúng tên cá nhân của bạn.</li>
            </ul>
          </div>
        </div>

        <%-- 2. Form gửi yêu cầu rút tiền --%>
        <section style="background: #fff; padding: 28px; border-radius: 16px; box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.05); border: 1px solid #e2e8f0;">
          <h3 style="font-size: 18px; font-weight: 700; color: #0f172a; margin: 0 0 20px 0; display: flex; align-items: center; gap: 10px;">
            <i class="bi bi-arrow-up-right-circle" style="color: #10b981;"></i> Tạo lệnh rút tiền mới
          </h3>

          <form action="${pageContext.request.contextPath}/tutor/wallet/withdraw" method="POST" id="withdrawForm">
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 16px;">
              <div>
                <label style="display: block; font-size: 13px; font-weight: 600; color: #334155; margin-bottom: 6px;">Số tiền muốn rút (VNĐ) <span style="color: #ef4444;">*</span></label>
                <input type="number" name="amount" id="withdrawAmount" min="50000" max="${u.balance}" required placeholder="VD: 500000"
                       style="width: 100%; padding: 11px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; font-weight: 500; outline: none;">
              </div>
              <div>
                <label style="display: block; font-size: 13px; font-weight: 600; color: #334155; margin-bottom: 6px;">Tên ngân hàng nhận <span style="color: #ef4444;">*</span></label>
                <input type="text" name="bankName" required placeholder="VD: Vietcombank, Techcombank..."
                       style="width: 100%; padding: 11px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; font-weight: 500; outline: none;">
              </div>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 20px;">
              <div>
                <label style="display: block; font-size: 13px; font-weight: 600; color: #334155; margin-bottom: 6px;">Số tài khoản ngân hàng <span style="color: #ef4444;">*</span></label>
                <input type="text" name="bankAccountNumber" required placeholder="Nhập số tài khoản"
                       style="width: 100%; padding: 11px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; font-weight: 500; outline: none;">
              </div>
              <div>
                <label style="display: block; font-size: 13px; font-weight: 600; color: #334155; margin-bottom: 6px;">Tên chủ tài khoản (Viết hoa không dấu) <span style="color: #ef4444;">*</span></label>
                <input type="text" name="bankAccountName" required placeholder="VD: NGUYEN VAN A"
                       style="width: 100%; padding: 11px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; font-weight: 500; outline: none; text-transform: uppercase;">
              </div>
            </div>

            <div style="text-align: right;">
              <button type="submit" style="background: #0f172a; color: #fff; border: none; padding: 12px 24px; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; display: inline-flex; align-items: center; gap: 8px; transition: background 0.2s;">
                <i class="bi bi-send-check"></i> Gửi yêu cầu rút tiền
              </button>
            </div>
          </form>
        </section>

        <%-- 3. KHU VỰC LỊCH SỬ BIẾN ĐỘNG (Phân Tab Nhận Tiền và Rút Tiền) --%>
        <section style="background: #fff; border-radius: 16px; box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.05); border: 1px solid #e2e8f0; overflow: hidden;">

          <%-- Đầu Tab điều hướng --%>
          <div style="display: flex; background: #f8fafc; border-bottom: 1px solid #e2e8f0; padding: 0 16px;">
            <button class="tab-link active" onclick="openHistoryTab(event, 'incomeTab')"
                    style="padding: 16px 20px; border: none; background: none; font-size: 14px; font-weight: 600; color: #0f172a; border-bottom: 2px solid #0f172a; cursor: pointer; display: flex; align-items: center; gap: 8px;">
              <i class="bi bi-graph-up-arrow" style="color: #10b981;"></i> Lịch sử nhận tiền (Thu nhập)
            </button>
            <button class="tab-link" onclick="openHistoryTab(event, 'withdrawTab')"
                    style="padding: 16px 20px; border: none; background: none; font-size: 14px; font-weight: 600; color: #64748b; border-bottom: 2px solid transparent; cursor: pointer; display: flex; align-items: center; gap: 8px;">
              <i class="bi bi-reply-all" style="color: #ef4444;"></i> Lịch sử rút tiền
            </button>
          </div>

          <%-- TAB 1: LỊCH SỬ NHẬN TIỀN (Dữ liệu từ bảng transactions) --%>
          <div id="incomeTab" class="tab-content-panel" style="display: block; padding: 16px;">
            <div style="overflow-x: auto;">
              <table style="width: 100%; border-collapse: collapse; text-align: left; font-size: 14px;">
                <thead>
                <tr style="border-bottom: 2px solid #f1f5f9; color: #64748b; font-weight: 600;">
                  <th style="padding: 14px 16px;">Mã GD</th>
                  <th style="padding: 14px 16px;">Nội dung nhận tiền</th>
                  <th style="padding: 14px 16px; text-align: right;">Số tiền</th>
                  <th style="padding: 14px 16px; text-align: center;">Trạng thái</th>
                  <th style="padding: 14px 16px; text-align: right;">Thời gian</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                  <c:when test="${not empty incomeTransactions}">
                    <c:forEach var="txn" items="${incomeTransactions}">
                      <tr style="border-bottom: 1px solid #f1f5f9; hover:background-color: #f8fafc;">
                        <td style="padding: 14px 16px; font-weight: 600; color: #475569;">#${txn.id}</td>
                        <td style="padding: 14px 16px; color: #0f172a; font-weight: 500;">
                            ${not empty txn.txnRef ? txn.txnRef : 'Nhận thù lao giảng dạy lớp học'}
                        </td>
                        <td style="padding: 14px 16px; text-align: right; font-weight: 700; color: #10b981;">
                          +<fmt:formatNumber value="${txn.amount}" type="number"/>đ
                        </td>
                        <td style="padding: 14px 16px; text-align: center;">
                                                        <span style="font-size: 12px; font-weight: 600; padding: 4px 12px; border-radius: 20px; background: #d1fae5; color: #065f46;">
                                                            Thành công
                                                        </span>
                        </td>
                        <td style="padding: 14px 16px; text-align: right; color: #64748b; font-size: 13px;">
                            ${txn.createdAt}
                        </td>
                      </tr>
                    </c:forEach>
                  </c:when>
                  <c:otherwise>
                    <tr>
                      <td colspan="5" style="text-align: center; padding: 40px; color: #94a3b8;">
                        <i class="bi bi-inbox" style="font-size: 28px; display: block; margin-bottom: 8px;"></i>
                        Bạn chưa nhận khoản học phí nào từ hệ thống.
                      </td>
                    </tr>
                  </c:otherwise>
                </c:choose>
                </tbody>
              </table>
            </div>
          </div>

          <%-- TAB 2: LỊCH SỬ RÚT TIỀN (Dữ liệu từ bảng withdrawal_requests) --%>
          <div id="withdrawTab" class="tab-content-panel" style="display: none; padding: 16px;">
            <div style="overflow-x: auto;">
              <table style="width: 100%; border-collapse: collapse; text-align: left; font-size: 14px;">
                <thead>
                <tr style="border-bottom: 2px solid #f1f5f9; color: #64748b; font-weight: 600;">
                  <th style="padding: 14px 16px;">Mã yêu cầu</th>
                  <th style="padding: 14px 16px;">Thông tin ngân hàng nhận</th>
                  <th style="padding: 14px 16px; text-align: right;">Số tiền rút</th>
                  <th style="padding: 14px 16px; text-align: center;">Trạng thái duyệt</th>
                  <th style="padding: 14px 16px; text-align: right;">Ngày tạo lệnh</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                  <c:when test="${not empty withdrawalRequests}">
                    <c:forEach var="req" items="${withdrawalRequests}">
                      <tr style="border-bottom: 1px solid #f1f5f9;">
                        <td style="padding: 14px 16px; font-weight: 600; color: #475569;">#${req.id}</td>
                        <td style="padding: 14px 16px; color: #0f172a; font-size: 13px; line-height: 1.4;">
                          <strong>${req.bankName}</strong><br>
                          <span style="color: #64748b;">STK: ${req.bankAccountNumber}</span><br>
                          <span style="color: #64748b; text-transform: uppercase;">Tên: ${req.bankAccountName}</span>
                        </td>
                        <td style="padding: 14px 16px; text-align: right; font-weight: 700; color: #ef4444;">
                          -<fmt:formatNumber value="${req.amount}" type="number"/>đ
                        </td>
                        <td style="padding: 14px 16px; text-align: center;">
                          <c:choose>
                            <c:when test="${req.status == 'PENDING'}">
                                                                <span style="font-size: 12px; font-weight: 600; padding: 4px 12px; border-radius: 20px; background: #fef3c7; color: #92400e;">
                                                                    Đang chờ duyệt
                                                                </span>
                            </c:when>
                            <c:when test="${req.status == 'APPROVED'}">
                                                                <span style="font-size: 12px; font-weight: 600; padding: 4px 12px; border-radius: 20px; background: #d1fae5; color: #065f46;">
                                                                    Đã giải ngân
                                                                </span>
                            </c:when>
                            <c:otherwise>
                                                                <span style="font-size: 12px; font-weight: 600; padding: 4px 12px; border-radius: 20px; background: #fee2e2; color: #991b1b;">
                                                                    Bị từ chối
                                                                </span>
                            </c:otherwise>
                          </c:choose>
                        </td>
                        <td style="padding: 14px 16px; text-align: right; color: #64748b; font-size: 13px;">
                            ${req.createdAt}
                        </td>
                      </tr>
                    </c:forEach>
                  </c:when>
                  <c:otherwise>
                    <tr>
                      <td colspan="5" style="text-align: center; padding: 40px; color: #94a3b8;">
                        <i class="bi bi-credit-card" style="font-size: 28px; display: block; margin-bottom: 8px;"></i>
                        Bạn chưa thực hiện lệnh rút tiền nào.
                      </td>
                    </tr>
                  </c:otherwise>
                </c:choose>
                </tbody>
              </table>
            </div>
          </div>

        </section>
      </div>
    </div>
  </div>
</main>

<jsp:include page="/views/common/footer.jsp" />

<%-- JAVASCRIPT XỬ LÝ PHÂN TAB VÀ THAO TÁC RÚT TIỀN --%>
<script>
  // Hàm hoán đổi Tab lịch sử mượt mà
  function openHistoryTab(evt, tabId) {
    var i, tabContent, tabLinks;

    tabContent = document.getElementsByClassName("tab-content-panel");
    for (i = 0; i < tabContent.length; i++) {
      tabContent[i].style.display = "none";
    }

    tabLinks = document.getElementsByClassName("tab-link");
    for (i = 0; i < tabLinks.length; i++) {
      tabLinks[i].style.color = "#64748b";
      tabLinks[i].style.borderBottomColor = "transparent";
    }

    document.getElementById(tabId).style.display = "block";
    evt.currentTarget.style.color = "#0f172a";
    evt.currentTarget.style.borderBottomColor = "#0f172a";
  }

  // Chặn rút tiền lố số dư khả dụng ngay ở Client-side
  document.getElementById('withdrawForm').addEventListener('submit', function(e) {
    var currentBalance = ${u.balance};
    var amountInput = document.getElementById('withdrawAmount').value;
    var amount = parseInt(amountInput);

    if (amount < 50000) {
      e.preventDefault();
      alert('❌ Số tiền rút tối thiểu phải là 50,000đ!');
      return;
    }

    if (amount > currentBalance) {
      e.preventDefault();
      alert('❌ Số dư tài khoản không đủ để thực hiện lệnh rút này!');
      return;
    }

    if (!confirm('Bạn có chắc chắn muốn gửi yêu cầu rút số tiền ' + amount.toLocaleString('vi-VN') + 'đ về tài khoản ngân hàng này?')) {
      e.preventDefault();
    }
  });
</script>