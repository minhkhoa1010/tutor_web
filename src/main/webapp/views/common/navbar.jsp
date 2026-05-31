<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<header class="site-header">
    <div class="container navbar">
        <a class="brand" href="<%= request.getContextPath() %>/">
            <span class="brand-badge">GS</span>
            <span>Gia Sư Bá Đạo</span>
        </a>
        <nav class="nav-links">
            <a href="<%= request.getContextPath() %>/index.jsp">Trang chủ</a>
            <a href="<%= request.getContextPath() %>/views/tutor/list.jsp">Tìm gia sư</a>
            <a href="<%= request.getContextPath() %>/views/tutor/list.jsp">Lớp mới</a>
            <a href="<%= request.getContextPath() %>/views/auth/register.jsp">Trở thành gia sư</a>
            <a href="<%= request.getContextPath() %>/views/contact/index.jsp">Liên hệ</a>
        </nav>

        <%-- KHÚC ĐIỀU CHỈNH ĐỘNG: CHECK TRẠNG THÁI ĐĂNG NHẬP --%>
        <c:choose>
            <%-- TRƯỜNG HỢP 1: CHƯA ĐĂNG NHẬP (clientUser rỗng) -> Hiện cụm nút Login cũ --%>
            <c:when test="${empty sessionScope.clientUser}">
                <div class="nav-cta">
                    <a class="btn btn-outline" href="<%= request.getContextPath() %>/views/auth/login.jsp">Đăng nhập</a>
                    <a class="btn btn-primary" href="<%= request.getContextPath() %>/views/auth/register.jsp">Đăng ký</a>
                </div>
            </c:when>

            <%-- TRƯỜNG HỢP 2: ĐÃ ĐĂNG NHẬP -> Hiện Avatar + Dropdown Menu phân quyền --%>
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

                            <%-- ACTOR 1: Quản trị viên (ADMIN) --%>
                        <c:if test="${sessionScope.clientUser.hasRole('ADMIN')}">
                            <li class="menu-role-tag admin-tag">ADMIN SYSTEM</li>
                            <li><a href="<%= request.getContextPath() %>/views/admin/dashboard.jsp">📊 Trang quản trị</a></li>
                            <li><a href="#">👥 Quản lý thành viên</a></li>
                            <li><a href="#">✔️ Duyệt hồ sơ gia sư</a></li>
                        </c:if>

                            <%-- ACTOR 2: Gia Sư (TUTOR) --%>
                        <c:if test="${sessionScope.clientUser.hasRole('TUTOR')}">
                            <li class="menu-role-tag tutor-tag">GIA SƯ ĐANG DẠY</li>
                            <li><a href="<%= request.getContextPath() %>/views/tutor/list.jsp">💼 Trang quản lý lớp</a></li>
                            <li><a href="#">📝 Lớp học đã nhận dạy</a></li>
                            <li><a href="#">💸 Cập nhật học phí</a></li>
                        </c:if>

                            <%-- ACTOR 3: Học viên / Phụ huynh (USER) --%>
                        <c:if test="${sessionScope.clientUser.hasRole('USER')}">
                            <li class="menu-role-tag user-tag">THÀNH VIÊN</li>
                            <li><a href="#">📌 Hồ sơ cá nhân</a></li>
                            <li><a href="#">📚 Lớp học đã thuê</a></li>
                            <li><a href="#">❤️ Danh sách gia sư lưu</a></li>
                        </c:if>

                        <li class="dropdown-divider"></li>
                        <li><a class="btn-logout" href="<%= request.getContextPath() %>/logout">🚪 Đăng xuất</a></li>
                    </ul>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</header>