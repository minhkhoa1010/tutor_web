<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Quản Lý Yêu Cầu Rút Tiền – Gia Sư Bá Đạo VN</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" />
</head>
<body>
<div class="admin-wrapper">

  <aside class="sidebar">
    <div class="sidebar-logo">
      <span class="logo-icon material-symbols-outlined">school</span>
      <div>
        <h2>Bá Đạo Admin</h2>
        <span>Quản lý cổng thông tin</span>
      </div>
    </div>
    <nav class="sidebar-nav">
      <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item">
        <span class="nav-icon material-symbols-outlined">dashboard</span>
        <span>Tổng quan</span>
      </a>
      <a href="${pageContext.request.contextPath}/admin/tutors" class="nav-item">
        <span class="nav-icon material-symbols-outlined">school</span>
        <span>Quản lý gia sư</span>
      </a>
      <a href="${pageContext.request.contextPath}/admin/students" class="nav-item">
        <span class="nav-icon material-symbols-outlined">person</span>
        <span>Quản lý học viên</span>
      </a>
      <a href="${pageContext.request.contextPath}/admin/withdrawals" class="nav-item active">
        <span class="nav-icon material-symbols-outlined">payments</span>
        <span>Duyệt rút tiền</span>
      </a>
      <a href="${pageContext.request.contextPath}/admin/settings" class="nav-item">
        <span class="nav-icon material-symbols-outlined">settings</span>
        <span>Cài đặt hệ thống</span>
      </a>
    </nav>
  </aside>

  <div class="main-content" style="padding: 24px; background: #f8fafc; min-height: 100vh; font-family: 'Plus Jakarta Sans', sans-serif;">

    <div class="topbar" style="display: flex; justify-content: space-between; align-items: center; padding-bottom: 20px; border-bottom: 1px solid #e2e8f0; margin-bottom: 32px;">
      <div class="topbar-brand" style="font-size: 18px; font-weight: 700; color: #1e293b; display: flex; align-items: center; gap: 8px;">
        <div class="brand-dot" style="width: 8px; height: 8px; background: #10b981; border-radius: 50%;"></div>
        Hệ thống kế toán & Tài chính công ty
      </div>
      <div style="font-size: 14px; color: #64748b;">
        Tài khoản: <strong>Quản trị viên tối cao</strong>
      </div>
    </div>

    <div style="margin-bottom: 24px;">
      <h1 style="font-size: 26px; font-weight: 800; color: #0f172a; margin: 0 0 6px 0;">Danh sách yêu cầu rút tiền</h1>
      <p style="color: #64748b; font-size: 14px; margin: 0;">Xem xét thông tin ngân hàng, đối chiếu số dư để phê duyệt hoặc từ chối chuyển khoản cho Gia sư/Người dùng.</p>
    </div>

    <div class="table-container" style="background: #fff; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02); overflow: hidden; border: 1px solid #e2e8f0;">
      <table style="width: 100%; border-collapse: collapse; text-align: left; font-size: 14px;">
        <thead>
        <tr style="background: #f8fafc; border-bottom: 1px solid #e2e8f0; color: #475569; font-weight: 600;">
          <th style="padding: 16px;">ID</th>
          <th style="padding: 16px;">Thành viên yêu cầu</th>
          <th style="padding: 16px; text-align: right;">Số tiền yêu cầu</th>
          <th style="padding: 16px;">Thông tin tài khoản nhận tiền</th>
          <th style="padding: 16px;">Ngày tạo</th>
          <th style="padding: 16px; text-align: center;">Trạng thái</th>
          <th style="padding: 16px; text-align: center;">Hành động duyệt</th>
        </tr>
        </thead>
        <tbody>
        <c:choose>
          <c:when test="${empty withdrawalRequests}">
            <tr>
              <td colspan="7" style="text-align: center; padding: 48px; color: #94a3b8;">
                Hiện chưa ghi nhận bất kỳ yêu cầu rút tiền nào từ hệ thống.
              </td>
            </tr>
          </c:when>
          <c:otherwise>
            <c:forEach var="req" items="${withdrawalRequests}">
              <tr style="border-bottom: 1px solid #f1f5f9; transition: background 0.2s;">
                <td style="padding: 16px; font-weight: 600; color: #64748b;">#${req.id}</td>
                <td style="padding: 16px;">
                  <div style="font-weight: 600; color: #1e293b;">${req.fullname}</div>
                  <div style="font-size: 12px; color: #64748b;">ID tài khoản: ${req.userId}</div>
                </td>
                <td style="padding: 16px; text-align: right; font-weight: 700; color: #0f172a; font-size: 15px;">
                  <fmt:formatNumber value="${req.amount}" type="number"/>đ
                </td>
                <td style="padding: 16px; line-height: 1.5;">
                  <div style="color: #0f172a; font-weight: 500;"><strong style="color: #64748b;">NH:</strong> ${req.bankName}</div>
                  <div><strong style="color: #64748b;">STK:</strong> <span style="font-family: monospace; font-size: 14px; font-weight: 600; color: #0f172a;">${req.bankAccountNumber}</span></div>
                  <div style="font-size: 12px; text-transform: uppercase; color: #475569; font-weight: 600;"><strong style="color: #64748b;">Tên:</strong> ${req.bankAccountName}</div>
                </td>
                <td style="padding: 16px; color: #64748b; font-size: 13px;">
                    ${req.createdAt}
                </td>
                <td style="padding: 16px; text-align: center;">
                                    <span style="font-size: 12px; font-weight: 600; padding: 6px 12px; border-radius: 6px;
                                            background: ${req.status == 'APPROVED' ? '#d1fae5' : req.status == 'PENDING' ? '#fef3c7' : '#fee2e2'};
                                            color: ${req.status == 'APPROVED' ? '#065f46' : req.status == 'PENDING' ? '#92400e' : '#991b1b'};">
                                        <c:choose>
                                          <c:when test="${req.status == 'PENDING'}">Đang chờ duyệt</c:when>
                                          <c:when test="${req.status == 'APPROVED'}">Đã duyệt tiền</c:when>
                                          <c:otherwise>Đã từ chối</c:otherwise>
                                        </c:choose>
                                    </span>
                </td>
                <td style="padding: 16px; text-align: center;">
                  <c:choose>
                    <c:when test="${req.status == 'PENDING'}">
                      <div style="display: flex; gap: 8px; justify-content: center;">
                        <a href="${pageContext.request.contextPath}/admin/withdrawals/action?id=${req.id}&status=APPROVE"
                           style="display: flex; align-items: center; gap: 4px; text-decoration: none; padding: 6px 12px; background: #10b981; color: #fff; border-radius: 6px; font-size: 13px; font-weight: 500;"
                           onclick="return confirm('Xác nhận ĐỒNG Ý duyệt và chuyển tiền cho yêu cầu này?')">
                          <span class="material-symbols-outlined" style="font-size: 16px;">check_circle</span> Duyệt
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/withdrawals/action?id=${req.id}&status=REJECT"
                           style="display: flex; align-items: center; gap: 4px; text-decoration: none; padding: 6px 12px; background: #ef4444; color: #fff; border-radius: 6px; font-size: 13px; font-weight: 500;"
                           onclick="return confirm('Bạn có chắc chắn muốn TỪ CHỐI yêu cầu rút tiền này?')">
                          <span class="material-symbols-outlined" style="font-size: 16px;">cancel</span> Từ chối
                        </a>
                      </div>
                    </c:when>
                    <c:otherwise>
                      <span style="font-size: 13px; color: #94a3b8; font-style: italic;">Đã hoàn thành xử lý</span>
                    </c:otherwise>
                  </c:choose>
                </td>
              </tr>
            </c:forEach>
          </c:otherwise>
        </c:choose>
        </tbody>
      </table>
    </div>

    <footer class="page-footer" style="margin-top: 40px; text-align: center; font-size: 13px; color: #94a3b8;">
      © 2026 Gia Sư Bá Đạo VN • Giao diện quản trị hệ thống tài chính kế toán
    </footer>
  </div>
</div>
</body>
</html>