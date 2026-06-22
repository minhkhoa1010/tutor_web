<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Học Viên – Gia Sư Bá Đạo VN</title>
    <link class="table-avatar" rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
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

    <a href="${pageContext.request.contextPath}/admin/users" class="nav-item">
        <span class="nav-icon material-symbols-outlined">manage_accounts</span>
        <span>Tài khoản</span>
    </a>

    <a href="${pageContext.request.contextPath}/admin/bookings" class="nav-item">
        <span class="nav-icon material-symbols-outlined">event_note</span>
        <span>Lớp học</span>
    </a>

    <a href="${pageContext.request.contextPath}/admin/payments" class="nav-item">
        <span class="nav-icon material-symbols-outlined">receipt_long</span>
        <span>Thanh toán</span>
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
                <span class="brand-dot"></span>
                <span class="brand-name">Gia Sư Bá Đạo VN</span>
            </div>
            <div class="topbar-search">
                <span class="search-icon material-symbols-outlined">search</span>
                <input type="text" placeholder="Tìm kiếm học viên bằng tên hoặc mã...">
            </div>
            <nav class="topbar-links">
                <a href="#">Trợ giúp</a>
                <a href="#">Báo cáo</a>
            </nav>
            <div class="topbar-actions">
                <button class="icon-btn notif-btn"><span class="material-symbols-outlined">notifications</span><span class="notif-dot"></span></button>
                <button class="icon-btn"><span class="material-symbols-outlined">mail</span></button>
                <img class="avatar-sm"
                     src="${not empty sessionScope.clientUser.avatarUrl ? sessionScope.clientUser.avatarUrl : 'https://ui-avatars.com/api/?name=Admin+User&background=1a2f5a&color=fff'}"
                     alt="Admin"
                     onerror="this.onerror=null; this.src='https://ui-avatars.com/api/?name='+encodeURIComponent('${not empty sessionScope.clientUser.fullname ? sessionScope.clientUser.fullname : 'Admin User'}')+'&background=random';">
            </div>
        </header>

        <div class="page-body">
            <div class="page-title-row">
                <div>
                    <h1>Danh sách học viên</h1>
                    <p>Quản lý tài khoản học viên đăng ký trên hệ thống.</p>
                </div>
            </div>

            <div class="table-section">
                <table class="data-table">
                    <thead>
                    <tr>
                        <th>Mã học viên</th>
                        <th>Ảnh đại diện</th>
                        <th>Họ và Tên</th>
                        <th>Email</th>
                        <th>Ngày tham gia</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty allStudents}">
                            <c:forEach items="${allStudents}" var="s">
                                <tr>
                                    <td>#ST-${s.id}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty s.avatarUrl && (s.avatarUrl.startsWith('http://') || s.avatarUrl.startsWith('https://'))}">
                                                <img class="table-avatar" src="${s.avatarUrl}" alt="Avatar" style="width:40px; height:40px; border-radius:50%; object-fit:cover;" onerror="this.onerror=null; this.src='https://ui-avatars.com/api/?name=${s.fullname}&background=random';">
                                            </c:when>
                                            <c:when test="${not empty s.avatarUrl}">
                                                <img class="table-avatar" src="${pageContext.request.contextPath}${s.avatarUrl}" alt="Avatar" style="width:40px; height:40px; border-radius:50%; object-fit:cover;" onerror="this.onerror=null; this.src='https://ui-avatars.com/api/?name=${s.fullname}&background=random';">
                                            </c:when>
                                            <c:otherwise>
                                                <img class="table-avatar" src="https://ui-avatars.com/api/?name=${s.fullname}&background=random" alt="Avatar" style="width:40px; height:40px; border-radius:50%;">
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="name-cell"><strong><c:out value="${s.fullname}"/></strong></td>
                                    <td><c:out value="${s.email}"/></td>
                                    <td class="date-cell"><c:out value="${s.createdAt}"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${s.isActive == 1}">
                                                <span class="kpi-badge green-badge" style="padding: 4px 8px; font-size: 12px; border-radius:4px;">Hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="kpi-badge red-badge" style="padding: 4px 8px; font-size: 12px; border-radius:4px;">Bị khóa</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="action-cell">
                                        <div style="display: flex; gap: 8px; align-items: center;">
                                            <a href="${pageContext.request.contextPath}/admin/student-detail?id=${s.id}"
                                               class="btn-action btn-view"
                                               style="text-decoration: none; display: inline-flex; align-items: center; gap: 4px; padding: 6px 12px; background: #f1f5f9; color: #1a2f5a; border-radius: 6px; font-size: 13px; font-weight: 500; transition: 0.2s;">
                                                <span class="material-symbols-outlined" style="font-size: 16px;">visibility</span> Chi tiết
                                            </a>

                                            <c:choose>
                                                <%-- TRẠNG THÁI: ĐANG HOẠT ĐỘNG -> HIỂN THỊ NÚT KHÓA --%>
                                                <c:when test="${s.isActive == 1}">
                                                    <a href="${pageContext.request.contextPath}/admin/toggle-student-status?id=${s.id}&action=lock"
                                                       class="btn-action btn-reject"
                                                       style="text-decoration: none; display: inline-flex; align-items: center; gap: 4px; padding: 6px 12px; background: #fef2f2; color: #ef4444; border-radius: 6px; font-size: 13px; font-weight: 500; transition: 0.2s;"
                                                       onclick="return confirm('Bạn có chắc chắn muốn khóa tài khoản học viên này?')">
                                                        <span class="material-symbols-outlined" style="font-size: 16px;">lock</span> Khóa
                                                    </a>
                                                </c:when>

                                                <%-- TRẠNG THÁI: ĐANG BỊ KHÓA -> HIỂN THỊ NÚT MỞ KHÓA --%>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/admin/toggle-student-status?id=${s.id}&action=unlock"
                                                       class="btn-action btn-approve"
                                                       style="text-decoration: none; display: inline-flex; align-items: center; gap: 4px; padding: 6px 12px; background: #ecfdf5; color: #10b981; border-radius: 6px; font-size: 13px; font-weight: 500; transition: 0.2s;"
                                                       onclick="return confirm('Bạn có chắc chắn muốn mở khóa cho học viên này?')">
                                                        <span class="material-symbols-outlined" style="font-size: 16px;">lock_open</span> Mở khóa
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7" style="text-align:center; padding:32px; color:#94a3b8;">
                                    Hệ thống hiện tại chưa có dữ liệu học viên.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>

            <footer class="page-footer" style="margin-top: 40px;">
                © 2026 Gia Sư Bá Đạo VN • Giao diện quản trị hệ thống
            </footer>
        </div>
    </div>
</div>
</body>
</html>