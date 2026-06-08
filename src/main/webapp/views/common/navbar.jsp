<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<header class="site-header">
    <div class="container navbar">
        <%-- Trỏ về Servlet /home thay vì dấu gạch chéo trống hoặc index.jsp --%>
        <a class="brand" href="${pageContext.request.contextPath}/home">
            <span class="brand-badge">GS</span>
            <span>Gia Sư Bá Đạo</span>
        </a>
        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
            <a href="${pageContext.request.contextPath}/tutors">Tìm gia sư</a>
            <a href="#">Lớp mới</a>
            <a href="${pageContext.request.contextPath}/views/auth/register.jsp">Trở thành gia sư</a>
            <a href="${pageContext.request.contextPath}/views/contact/index.jsp">Liên hệ</a>
        </nav>

        <%-- CHECK TRẠNG THÁI ĐĂNG NHẬP --%>
        <c:choose>
            <c:when test="${empty sessionScope.clientUser}">
                <div class="nav-cta">
                    <a class="btn btn-outline" href="${pageContext.request.contextPath}/views/auth/login.jsp">Đăng nhập</a>
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/views/auth/register.jsp">Đăng ký</a>
                </div>
            </c:when>

            <c:otherwise>
                <div class="nav-user-dropdown">
                    <div class="user-trigger">
                        <img class="user-avatar"
                             src="${not empty sessionScope.clientUser.avatarUrl ? sessionScope.clientUser.avatarUrl : pageContext.request.contextPath.concat('/assets/images/default-avatar.png')}"
                             alt="Avatar">
                        <span class="user-name">${sessionScope.clientUser.fullname}</span>
                        <span class="user-caret">▼</span>
                    </div>

                    <ul class="dropdown-menu">
                            <%-- Quản trị viên (ADMIN) --%>
                        <c:if test="${sessionScope.clientUser.hasRole('ADMIN')}">
                            <li class="menu-role-tag admin-tag">ADMIN SYSTEM</li>
                            <li><a href="${pageContext.request.contextPath}/admin/dashboard">📊 Trang quản trị</a></li>
                            <li><a href="#">👥 Quản lý thành viên</a></li>
                            <li><a href="#">✔️ Duyệt hồ sơ gia sư</a></li>
                        </c:if>

                            <%-- Gia Sư (TUTOR) --%>
                        <c:if test="${sessionScope.clientUser.hasRole('TUTOR')}">
                            <li class="menu-role-tag tutor-tag">GIA SƯ ĐANG DẠY</li>
                            <li><a href="${pageContext.request.contextPath}/tutor/dashboard">💼 Trang quản lý lớp</a></li>
                            <li><a href="#">📝 Lớp học đã nhận dạy</a></li>
                            <li><a href="#">💸 Cập nhật học phí</a></li>
                        </c:if>

                            <%-- Học viên / Phụ huynh (USER) --%>
                        <c:if test="${sessionScope.clientUser.hasRole('USER')}">
                            <li class="menu-role-tag user-tag">THÀNH VIÊN</li>
                            <li><a href="#">📌 Hồ sơ cá nhân</a></li>
                            <li><a href="#">📚 Lớp học đã thuê</a></li>
                            <li><a href="#">❤️ Danh sách gia sư lưu</a></li>
                        </c:if>

                        <li class="dropdown-divider"></li>
                        <li><a class="btn-logout" href="${pageContext.request.contextPath}/logout">🚪 Đăng xuất</a></li>
                    </ul>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</header>