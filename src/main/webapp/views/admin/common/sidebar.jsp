<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="uri" value="${requestScope['jakarta.servlet.forward.request_uri']}" />
<c:if test="${empty uri}">
    <c:set var="uri" value="${pageContext.request.requestURI}" />
</c:if>>

<aside class="sidebar">
    <div class="sidebar-logo">
        <span class="logo-icon material-symbols-outlined">school</span>
        <div>
            <h2>Bá Đạo Admin</h2>
            <span>Quản lý cổng thông tin</span>
        </div>
    </div>

    <nav class="sidebar-nav">

        <a href="${ctx}/admin/dashboard"
           class="nav-item ${fn:contains(uri, '/admin/dashboard') ? 'active' : ''}">
            <span class="nav-icon material-symbols-outlined">dashboard</span>
            <span>Tổng quan</span>
        </a>

        <a href="${ctx}/admin/tutors"
           class="nav-item ${fn:contains(uri, '/admin/tutors') ? 'active' : ''}">
            <span class="nav-icon material-symbols-outlined">school</span>
            <span>Gia sư</span>
        </a>

        <a href="${ctx}/admin/students"
           class="nav-item ${fn:contains(uri, '/admin/students') ? 'active' : ''}">
            <span class="nav-icon material-symbols-outlined">group</span>
            <span>Học viên</span>
        </a>

        <a href="${ctx}/admin/bookings"
           class="nav-item ${fn:contains(uri, '/admin/bookings') ? 'active' : ''}">
            <span class="nav-icon material-symbols-outlined">event_note</span>
            <span>Lớp học</span>
        </a>

        <a href="${ctx}/admin/complaints"
           class="nav-item ${fn:contains(uri, '/admin/complaints') ? 'active' : ''}">
            <span class="nav-icon material-symbols-outlined">gavel</span>
            <span>Xử lý khiếu nại</span>
        </a>

        <a href="${ctx}/admin/reviews"
           class="nav-item ${fn:contains(uri, '/admin/reviews') ? 'active' : ''}">
            <span class="nav-icon material-symbols-outlined">rate_review</span>
            <span>Đánh giá</span>
        </a>

        <a href="${ctx}/admin/quan-ly-lien-he"
           class="nav-item ${fn:contains(uri, '/admin/quan-ly-lien-he') ? 'active' : ''}">
            <span class="nav-icon material-symbols-outlined">contact_support</span>
            <span>Yêu cầu liên hệ</span>
        </a>

        <a href="${ctx}/admin/withdrawals"
           class="nav-item ${fn:contains(uri, '/admin/withdrawals') ? 'active' : ''}">
            <span class="nav-icon material-symbols-outlined">payments</span>
            <span>Duyệt rút tiền</span>
        </a>

    </nav>

    <div class="sidebar-bottom">
        <div class="sidebar-user">
            <img src="${not empty sessionScope.clientUser.avatarUrl
                        ? sessionScope.clientUser.avatarUrl
                        : 'https://ui-avatars.com/api/?name=Admin+User&background=1a2f5a&color=fff'}"
                 alt="Admin">

            <div>
                <strong>
                    <c:out value="${not empty sessionScope.clientUser.fullname
                                    ? sessionScope.clientUser.fullname
                                    : 'Quản Trị Viên Hệ Thống'}"/>
                </strong>
                <span>SUPER ADMINISTRATOR</span>
            </div>
        </div>

        <a href="${ctx}/admin/settings"
           class="nav-item settings-item ${fn:contains(uri, '/admin/settings') ? 'active' : ''}">
            <span class="nav-icon material-symbols-outlined">settings</span>
            <span>Cài đặt</span>
        </a>

        <a href="${ctx}/logout" class="nav-item logout-item">
            <span class="nav-icon material-symbols-outlined">logout</span>
            <span>Đăng xuất</span>
        </a>
    </div>
</aside>