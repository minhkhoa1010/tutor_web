<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Quản lý và Duyệt Rút Tiền – Gia Sư Bá Đạo VN</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" />
  <style>
    /* --- BADGE TRẠNG THÁI --- */
    .custom-badge {
      display: inline-block;
      padding: 4px 10px;
      font-size: 12px;
      font-weight: 600;
      border-radius: 6px;
      text-align: center;
    }
    .badge-warning { background-color: #fef3c7; color: #d97706; }
    .badge-success { background-color: #d1fae5; color: #10b981; }
    .badge-danger { background-color: #fee2e2; color: #ef4444; }

    /* --- NÚT HÀNH ĐỘNG VÀ FIX ICON LỆCH --- */
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

    /* --- POPUP MODAL --- */
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
    .modal-close-btn { background: none; border: none; cursor: pointer; color: #94a3b8; display: flex; align-items: center; }
    .modal-close-btn:hover { color: #64748b; }
    .modal-body-content .info-group { margin-bottom: 14px; }
    .modal-body-content .info-label { font-size: 12px; color: #64748b; text-transform: uppercase; font-weight: 600; margin-bottom: 4px; }
    .modal-body-content .info-value { font-size: 15px; color: #0f172a; background: #f8fafc; padding: 10px 12px; border-radius: 6px; border: 1px solid #f1f5f9; }
    .modal-footer-actions { display: flex; justify-content: flex-end; gap: 12px; margin-top: 24px; border-top: 1px solid #f1f5f9; padding-top: 16px; }
  </style>
</head>
<body>
<div class="admin-wrapper">

  <aside class="sidebar">
    <div class="sidebar-logo">
      <span class="logo-icon material-symbols-outlined">school</span>
      <div>
        <h2>Bá Đạo Admin</h2>
        <span>Quản lý hệ thống</span>
      </div>
    </div>
    <nav class="sidebar-nav">
      <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item">
        <span class="nav-icon material-symbols-outlined">dashboard</span>
        <span>Tổng quan</span>
      </a>
      <a href="${pageContext.request.contextPath}/admin/tutors" class="nav-item">
        <span class="nav-icon material-symbols-outlined">school</span>
        <span>Gia sư</span>
      </a>
      <a href="${pageContext.request.contextPath}/admin/students" class="nav-item">
        <span class="nav-icon material-symbols-outlined">group</span>
        <span>Học viên</span>
      </a>
      <a href="${pageContext.request.contextPath}/admin/complaints" class="nav-item">
        <span class="nav-icon material-symbols-outlined">gavel</span>
        <span>Xử lý khiếu nại</span>
      </a>
      <a href="${pageContext.request.contextPath}/admin/quan-ly-lien-he" class="nav-item">
        <span class="nav-icon material-symbols-outlined">contact_support</span>
        <span>Yêu cầu liên hệ</span>
      </a>
      <a href="${pageContext.request.contextPath}/admin/withdrawals" class="nav-item active">
        <span class="nav-icon material-symbols-outlined">payments</span><span>Duyệt rút tiền</span>
      </a>
    </nav>
    <div class="sidebar-bottom">
      <div class="sidebar-user">
        <img src="${not empty sessionScope.clientUser.avatarUrl ? sessionScope.clientUser.avatarUrl : 'https://ui-avatars.com/api/?name=Admin+User&background=1a2f5a&color=fff'}"
             alt="Admin"
             onerror="this.onerror=null; this.src='https://ui-avatars.com/api/?name='+encodeURIComponent('${not empty sessionScope.clientUser.fullname ? sessionScope.clientUser.fullname : 'Admin User'}')+'&background=random';">
        <div>
          <strong><c:out value="${not empty sessionScope.clientUser.fullname ? sessionScope.clientUser.fullname : 'Admin User'}"/></strong>
          <span>SUPER ADMINISTRATOR</span>
        </div>
      </div>
      <a href="${pageContext.request.contextPath}/admin/settings" class="nav-item settings-item">
        <span class="nav-icon material-symbols-outlined">settings</span>
        <span>Cài đặt</span>
      </a>
      <a href="${pageContext.request.contextPath}/logout" class="nav-item logout-item">
        <span class="nav-icon material-symbols-outlined">logout</span>
        <span>Đăng xuất</span>
      </a>
    </div>
  </aside>

  <div class="main-content">
    <header class="topbar">
      <div class="topbar-brand">
        <span class="brand-dot"></span><span class="brand-name">Gia Sư Bá Đạo VN</span>
      </div>
    </header>

    <div class="page-body">
      <div class="page-title-row">
        <div>
          <h1>Quản lý và Duyệt Rút Tiền</h1>
          <p>Xét duyệt và xử lý các yêu cầu rút số dư khả dụng từ ví tiền của Gia sư.</p>
        </div>
      </div>

      <c:if test="${not empty sessionScope.msgSuccess}">
        <div class="alert alert-success" style="padding: 12px 16px; background-color: #d1fae5; color: #047857; border: 1px solid #a7f3d0; border-radius: 8px; margin-top: 16px; display: inline-flex; align-items: center; gap: 8px; width: 100%; box-sizing: border-box;">
          <span class="material-symbols-outlined" style="color: #10b981;">check_circle</span>
          <div>${sessionScope.msgSuccess}</div>
        </div>
        <c:remove var="msgSuccess" scope="session" />
      </c:if>
      <c:if test="${not empty sessionScope.msgError}">
        <div class="alert alert-danger" style="padding: 12px 16px; background-color: #fee2e2; color: #b91c1c; border: 1px solid #fca5a5; border-radius: 8px; margin-top: 16px; display: inline-flex; align-items: center; gap: 8px; width: 100%; box-sizing: border-box;">
          <span class="material-symbols-outlined" style="color: #ef4444;">error</span>
          <div>${sessionScope.msgError}</div>
        </div>
        <c:remove var="msgError" scope="session" />
      </c:if>

      <div class="table-section" style="margin-top: 16px;">
        <table class="data-table">
          <thead>
          <tr>
            <th>MÃ ĐƠN</th>
            <th>THÀNH VIÊN</th>
            <th>SỐ TIỀN RÚT</th>
            <th>THÔNG TIN NGÂN HÀNG</th>
            <th>THỜI GIAN TẠO</th>
            <th style="text-align: center;">TRẠNG THÁI</th>
            <th style="text-align: center;">HÀNH ĐỘNG</th>
          </tr>
          </thead>
          <tbody>
          <c:choose>
            <c:when test="${not empty withdrawalRequests}">
              <c:forEach items="${withdrawalRequests}" var="w">
                <tr>
                  <td><strong>#WD-${w.id}</strong></td>
                  <td>
                    <strong>
                      <c:choose>
                        <c:when test="${not empty w.fullname}">${w.fullname}</c:when>
                        <c:otherwise>Thành viên #${w.userId}</c:otherwise>
                      </c:choose>
                    </strong>
                  </td>
                  <td style="font-weight: 600; color: #0f172a;">
                    <fmt:formatNumber value="${w.amount}" type="number"/> đ
                  </td>
                  <td>
                    <span style="font-size: 13px; font-weight: 500;">${w.bankName}</span><br>
                    <small style="color: #64748b;">STK: ${w.bankAccountNumber}</small>
                  </td>
                  <td class="date-cell">${w.createdAt}</td>
                  <td style="text-align: center;">
                    <c:choose>
                      <c:when test="${w.status == 'PENDING'}">
                        <span class="custom-badge badge-warning">Chờ duyệt</span>
                      </c:when>
                      <c:when test="${w.status == 'APPROVED'}">
                        <span class="custom-badge badge-success">Đã duyệt</span>
                      </c:when>
                      <c:otherwise>
                        <span class="custom-badge badge-danger">Từ chối</span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td style="text-align: center;">
                    <button type="button" class="btn-action-view btn-trigger-modal"
                            data-id="${w.id}"
                            data-user="<c:choose><c:when test='${not empty w.fullname}'>${w.fullname}</c:when><c:otherwise>Thành viên #${w.userId}</c:otherwise></c:choose>"
                            data-amount="<fmt:formatNumber value='${w.amount}' type='number'/> đ"
                            data-bankname="${w.bankName}"
                            data-accnum="${w.bankAccountNumber}"
                            data-accname="${w.bankAccountName}"
                            data-status="${w.status}">
                      <span class="material-symbols-outlined">visibility</span> Xem chi tiết
                    </button>
                  </td>
                </tr>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <tr>
                <td colspan="7" style="text-align: center; color: #94a3b8; padding: 24px;">Không có yêu cầu rút tiền nào cần xử lý.</td>
              </tr>
            </c:otherwise>
          </c:choose>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<div id="withdrawalModal" class="custom-modal-backdrop">
  <div class="custom-modal-box">
    <div class="modal-header-title">
      <h3>Chi tiết yêu cầu rút tiền</h3>
      <button type="button" class="modal-close-btn" onclick="closeModal()">
        <span class="material-symbols-outlined">close</span>
      </button>
    </div>

    <div class="modal-body-content">
      <div class="info-group"><div class="info-label">Người yêu cầu</div><div class="info-value" id="modalUser"></div></div>
      <div class="info-group"><div class="info-label">Số tiền rút</div><div class="info-value" id="modalAmount" style="font-weight: 700; background: #f0fdf4;"></div></div>
      <div class="info-group"><div class="info-label">Ngân hàng hưởng thụ</div><div class="info-value" id="modalBankName"></div></div>
      <div class="info-group"><div class="info-label">Số tài khoản</div><div class="info-value" id="modalAccNum" style="font-family: monospace; font-size: 16px; font-weight: 600;"></div></div>
      <div class="info-group"><div class="info-label">Tên chủ tài khoản</div><div class="info-value" id="modalAccName" style="text-transform: uppercase; font-weight: 600;"></div></div>
      <div class="info-group"><div class="info-label">Trạng thái hiện tại</div><div id="modalStatusWrapper" style="margin-top: 4px;"></div></div>
    </div>

    <div class="modal-footer-actions">
      <button type="button" onclick="closeModal()" style="background: #f1f5f9; color: #475569; border: none; padding: 8px 16px; border-radius: 6px; cursor: pointer; font-weight: 500;">Đóng</button>
      <a id="rejectBtn" href="#" class="custom-badge badge-danger" style="padding: 10px 18px; text-decoration: none; font-size: 13px; display: inline-flex; align-items: center; gap: 4px; border-radius: 6px;">
        <span class="material-symbols-outlined" style="font-size: 16px;">cancel</span> Từ chối
      </a>
      <a id="approveBtn" href="#" class="custom-badge badge-success" style="padding: 10px 18px; text-decoration: none; font-size: 13px; display: inline-flex; align-items: center; gap: 4px; border-radius: 6px;">
        <span class="material-symbols-outlined" style="font-size: 16px;">check_circle</span> Duyệt chi
      </a>
    </div>
  </div>
</div>

<script>
  document.addEventListener("DOMContentLoaded", function () {
    const modal = document.getElementById("withdrawalModal");
    const buttons = document.querySelectorAll(".btn-trigger-modal");

    buttons.forEach(button => {
      button.addEventListener("click", function () {
        const id = this.getAttribute("data-id");
        const user = this.getAttribute("data-user");
        const amount = this.getAttribute("data-amount");
        const bankName = this.getAttribute("data-bankname");
        const accNum = this.getAttribute("data-accnum");
        const accName = this.getAttribute("data-accname");
        const status = this.getAttribute("data-status");

        document.getElementById("modalUser").innerText = user;
        document.getElementById("modalAmount").innerText = amount;
        document.getElementById("modalBankName").innerText = bankName;
        document.getElementById("modalAccNum").innerText = accNum;
        document.getElementById("modalAccName").innerText = accName;

        const statusWrapper = document.getElementById("modalStatusWrapper");
        const approveBtn = document.getElementById("approveBtn");
        const rejectBtn = document.getElementById("rejectBtn");

        if (status === "PENDING") {
          statusWrapper.innerHTML = '<span class="custom-badge badge-warning">Chờ duyệt hành động</span>';
          // ĐÃ ĐỔI ĐƯỜNG DẪN URL THEO ĐÚNG PATTERN /admin/withdrawals/action CỦA SERVLET
          approveBtn.href = "${pageContext.request.contextPath}/admin/withdrawals/action?id=" + id + "&status=APPROVE";
          rejectBtn.href = "${pageContext.request.contextPath}/admin/withdrawals/action?id=" + id + "&status=REJECT";
          approveBtn.style.display = "inline-flex";
          rejectBtn.style.display = "inline-flex";
        } else if (status === "APPROVED") {
          statusWrapper.innerHTML = '<span class="custom-badge badge-success">Giao dịch thành công</span>';
          approveBtn.style.display = "none";
          rejectBtn.style.display = "none";
        } else {
          statusWrapper.innerHTML = '<span class="custom-badge badge-danger">Yêu cầu đã bị từ chối</span>';
          approveBtn.style.display = "none";
          rejectBtn.style.display = "none";
        }
        modal.style.display = "flex";
      });
    });
  });

  function closeModal() { document.getElementById("withdrawalModal").style.display = "none"; }
  window.onclick = function(event) {
    const modal = document.getElementById("withdrawalModal");
    if (event.target === modal) modal.style.display = "none";
  }
</script>
</body>
</html>