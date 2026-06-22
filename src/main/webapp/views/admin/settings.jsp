<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Cài đặt hệ thống – Gia Sư Bá Đạo VN</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" />
  <style>
    .settings-container { display: grid; grid-template-columns: 280px 1fr; gap: 24px; margin-top: 20px; }
    .settings-tabs { background: #fff; padding: 16px; border-radius: 12px; box-shadow: 0 2px 4px rgba(0,0,0,0.02); height: fit-content; }
    .tab-btn { display: flex; align-items: center; gap: 12px; width: 100%; padding: 12px 16px; border: none; background: none; border-radius: 8px; color: #64748b; font-weight: 500; cursor: pointer; transition: 0.2s; text-align: left; }
    .tab-btn:hover { background: #f1f5f9; color: #1a2f5a; }
    .tab-btn.active { background: #e2e8f0; color: #1a2f5a; font-weight: 600; }
    .settings-content { background: #fff; padding: 28px; border-radius: 12px; box-shadow: 0 2px 4px rgba(0,0,0,0.02); }
    .form-section { display: none; }
    .form-section.active { display: block; }
    .form-section h3 { font-size: 18px; color: #1a2f5a; margin-bottom: 6px; border-bottom: 1px solid #e2e8f0; padding-bottom: 12px; }
    .form-desc { color: #64748b; font-size: 13px; margin-bottom: 20px; }
    .form-group { margin-bottom: 20px; }
    .form-group label { display: block; font-size: 14px; font-weight: 600; color: #334155; margin-bottom: 8px; }
    .form-control { width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 14px; color: #334155; transition: 0.2s; box-sizing: border-box; }
    .form-control:focus { border-color: #1a2f5a; outline: none; box-shadow: 0 0 0 3px rgba(26,47,90,0.1); }
    .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
    .toggle-group { display: flex; align-items: center; justify-content: space-between; padding: 12px 0; border-bottom: 1px dashed #e2e8f0; }
    .toggle-switch { position: relative; display: inline-block; width: 44px; height: 24px; }
    .toggle-switch input { opacity: 0; width: 0; height: 0; }
    .slider { position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0; background-color: #cbd5e1; transition: .3s; border-radius: 24px; }
    .slider:before { position: absolute; content: ""; height: 16px; width: 16px; left: 4px; bottom: 4px; background-color: white; transition: .3s; border-radius: 50%; }
    input:checked + .slider { background-color: #10b981; }
    input:checked + .slider:before { transform: translateX(20px); }
    .btn-save { background: #1a2f5a; color: white; border: none; padding: 12px 24px; border-radius: 6px; font-weight: 600; cursor: pointer; transition: 0.2s; display: flex; align-items: center; gap: 8px; margin-top: 24px; }
    .btn-save:hover { background: #0f1c36; }
    .alert-success { background: #ecfdf5; border-left: 4px solid #10b981; color: #065f46; padding: 12px; border-radius: 4px; margin-bottom: 20px; font-size: 14px; display: flex; align-items: center; gap: 8px; }
  </style>
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
      <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item active">
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
      <a href="${pageContext.request.contextPath}/admin/withdrawals" class="nav-item">
        <span class="nav-icon material-symbols-outlined">payments</span>
        <span>Duyệt rút tiền</span>
      </a>
    </nav>
    <div class="sidebar-bottom">
      <div class="sidebar-user">
        <img src="${not empty sessionScope.clientUser.avatarUrl ? sessionScope.clientUser.avatarUrl : 'https://ui-avatars.com/api/?name=Admin+User&background=1a2f5a&color=fff'}" alt="Admin">
        <div>
          <strong><c:out value="${not empty sessionScope.clientUser.fullname ? sessionScope.clientUser.fullname : 'Admin User'}"/></strong>
          <span>SUPER ADMINISTRATOR</span>
        </div>
      </div>
      <a href="${pageContext.request.contextPath}/admin/settings" class="nav-item settings-item active">
        <span class="nav-icon material-symbols-outlined">settings</span><span>Cài đặt</span>
      </a>
      <a href="${pageContext.request.contextPath}/logout" class="nav-item logout-item">
        <span class="nav-icon material-symbols-outlined">logout</span><span>Đăng xuất</span>
      </a>
    </div>
  </aside>

  <div class="main-content">
    <header class="topbar">
      <div class="topbar-brand"><span class="brand-dot"></span><span class="brand-name">Gia Sư Bá Đạo VN</span></div>
      <div class="topbar-search">
        <span class="search-icon material-symbols-outlined">search</span>
        <input type="text" placeholder="Tìm kiếm cài đặt cấu hình...">
      </div>
      <div class="topbar-actions">
        <button class="icon-btn notif-btn"><span class="material-symbols-outlined">notifications</span></button>
        <img class="avatar-sm" src="${not empty sessionScope.clientUser.avatarUrl ? sessionScope.clientUser.avatarUrl : 'https://ui-avatars.com/api/?name=Admin+User&background=1a2f5a&color=fff'}" alt="Admin">
      </div>
    </header>

    <div class="page-body">
      <div>
        <h1>Cấu hình hệ thống</h1>
        <p>Điều chỉnh các tham số tài chính, quy định kiểm duyệt và thông tin cấu hình nền tảng.</p>
      </div>

      <c:if test="${not empty param.success}">
        <div class="alert-success">
          <span class="material-symbols-outlined">check_circle</span>
          Cập nhật cấu hình hệ thống thành công và đã áp dụng thời gian thực!
        </div>
      </c:if>

      <div class="settings-container">
        <div class="settings-tabs">
          <button class="tab-btn active" onclick="switchTab(event, 'finance-tab')">
            <span class="material-symbols-outlined">payments</span> Cấu hình tài chính
          </button>
          <button class="tab-btn" onclick="switchTab(event, 'moderation-tab')">
            <span class="material-symbols-outlined">gavel</span> Kiểm duyệt & Báo cáo
          </button>
          <button class="tab-btn" onclick="switchTab(event, 'system-tab')">
            <span class="material-symbols-outlined">language</span> Thông tin nền tảng
          </button>
        </div>

        <div class="settings-content">
          <form action="${pageContext.request.contextPath}/admin/settings/save" method="POST">

            <div id="finance-tab" class="form-section active">
              <h3>Cấu hình doanh thu & chiết khấu</h3>
              <p class="form-desc">Quản lý tỷ lệ chia sẻ doanh thu từ các lớp học kết nối thành công.</p>

              <div class="form-group">
                <label>Tỷ lệ chiết khấu hệ thống (%)</label>
                <input type="number" name="commissionRate" class="form-control" value="${not empty commissionRate ? commissionRate : 15}" min="0" max="100">
                <small style="color:#64748b; font-size:12px;">Phần trăm nền tảng sẽ khấu trừ từ học phí của gia sư.</small>
              </div>

              <div class="form-row">
                <div class="form-group">
                  <label>Học phí tối thiểu / giờ (VND)</label>
                  <input type="number" name="minHourlyRate" class="form-control" value="${not empty minHourlyRate ? minHourlyRate : 50000}">
                </div>
                <div class="form-group">
                  <label>Học phí tối đa / giờ (VND)</label>
                  <input type="number" name="maxHourlyRate" class="form-control" value="${not empty maxHourlyRate ? maxHourlyRate : 2000000}">
                </div>
              </div>
            </div>

            <div id="moderation-tab" class="form-section">
              <h3>Cơ chế phê duyệt & Khóa tài khoản</h3>
              <p class="form-desc">Thiết lập các quy tắc tự động hóa kiểm soát nội dung hệ thống.</p>

              <div class="toggle-group">
                <div>
                  <strong>Bắt buộc phê duyệt hồ sơ gia sư</strong>
                  <p style="margin:4px 0 0; font-size:12px; color:#64748b;">Hồ sơ gia sư mới cần phải được duyệt thủ công trước khi hiển thị trên trang chủ.</p>
                </div>
                <label class="toggle-switch">
                  <input type="checkbox" name="requireTutorApproval" value="true" ${requireTutorApproval ? 'checked' : ''}>
                  <span class="slider"></span>
                </label>
              </div>

              <div class="toggle-group" style="margin-top:12px;">
                <div>
                  <strong>Tự động phê duyệt học viên</strong>
                  <p style="margin:4px 0 0; font-size:12px; color:#64748b;">Tài khoản học viên đăng ký mới sẽ tự động kích hoạt không cần qua Admin.</p>
                </div>
                <label class="toggle-switch">
                  <input type="checkbox" name="autoApproveStudent" value="true" ${autoApproveStudent ? 'checked' : ''}>
                  <span class="slider"></span>
                </label>
              </div>

              <div class="form-group" style="margin-top:20px;">
                <label>Giới hạn số lần bị báo cáo (Reports Limit)</label>
                <input type="number" name="maxReportLimit" class="form-control" value="${not empty maxReportLimit ? maxReportLimit : 3}" min="1">
                <small style="color:#64748b; font-size:12px;">Tài khoản gia sư sẽ bị chuyển trạng thái tạm khóa tự động nếu đạt số lượng báo cáo này.</small>
              </div>
            </div>

            <div id="system-tab" class="form-section">
              <h3>Thông tin thương hiệu & Hệ thống</h3>
              <p class="form-desc">Cấu hình các siêu dữ liệu hiển thị bên ngoài và trạng thái hệ thống.</p>

              <div class="form-group">
                <label>Tên website hệ thống</label>
                <input type="text" name="siteName" class="form-control" value="Gia Sư Bá Đạo VN">
              </div>
              <div class="form-row">
                <div class="form-group">
                  <label>Hotline liên hệ</label>
                  <input type="text" name="systemHotline" class="form-control" value="1900 8198">
                </div>
                <div class="form-group">
                  <label>Email hỗ trợ kĩ thuật</label>
                  <input type="email" name="systemEmail" class="form-control" value="support@giasubadao.vn">
                </div>
              </div>
              <div class="toggle-group">
                <div>
                  <strong>Chế độ bảo trì hệ thống (Maintenance Mode)</strong>
                  <p style="margin:4px 0 0; font-size:12px; color:#64748b;">Khi bật, toàn bộ phía người dùng sẽ tạm khóa để nâng cấp dữ liệu.</p>
                </div>
                <label class="toggle-switch">
                  <input type="checkbox" name="maintenanceMode" value="true">
                  <span class="slider"></span>
                </label>
              </div>
            </div>

            <button type="submit" class="btn-save">
              <span class="material-symbols-outlined">save</span> Lưu toàn bộ cấu hình
            </button>
          </form>
        </div>
      </div>

      <footer class="page-footer" style="margin-top: 40px;">
        © 2026 Gia Sư Bá Đạo VN • Giao diện quản trị hệ thống
      </footer>
    </div>
  </div>
</div>

<script>
  function switchTab(evt, tabId) {
    const sections = document.querySelectorAll('.form-section');
    const buttons = document.querySelectorAll('.tab-btn');

    sections.forEach(sec => sec.classList.remove('active'));
    buttons.forEach(btn => btn.classList.remove('active'));

    document.getElementById(tabId).classList.add('active');
    evt.currentTarget.classList.add('active');
  }
</script>
</body>
</html>