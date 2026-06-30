    <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
    <!DOCTYPE html>
    <html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Gia Sư – Gia Sư Bá Đạo VN</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-tutor.css">
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" />
    </head>
    <body>
    <div class="admin-wrapper">

        <jsp:include page="/views/admin/common/sidebar.jsp" />

        <div class="main-content">
            <header class="topbar">
                <div class="topbar-brand">
                    <span class="brand-dot"></span>
                    <span class="brand-name">Gia Sư Bá Đạo VN</span>
                </div>
                <div class="topbar-search">
                    <span class="search-icon material-symbols-outlined">search</span>
                    <input type="text" placeholder="Tìm kiếm gia sư bằng tên hoặc môn học...">
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
                        <h1>Danh sách tất cả gia sư</h1>
                        <p>Quản lý thông tin hồ sơ, trạng thái hoạt động và phân quyền dữ liệu gia sư.</p>
                    </div>
                </div>

                <div class="table-section">
                    <table class="data-table tutor-table">
                    <colgroup>
                        <col style="width: 70px;">
                        <col style="width: 190px;">
                        <col style="width: 150px;">
                        <col style="width: 150px;">
                        <col style="width: 210px;">
                        <col style="width: 130px;">
                        <col style="width: 90px;">
                        <col style="width: 140px;">
                        <col style="width: 230px;">
                    </colgroup>
                        <thead>
                        <tr>
                            <th>Ảnh</th>
                            <th>Họ và Tên</th>
                            <th>Trình độ</th>
                            <th>Môn dạy</th>
                            <th>Khu vực</th>
                            <th>Học phí/Buổi</th>
                            <th>Đánh giá</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty allTutors}">
                                <c:forEach items="${allTutors}" var="t">
                                    <tr>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty t.avatarUrl && (t.avatarUrl.startsWith('http://') || t.avatarUrl.startsWith('https://'))}">
                                                    <img class="table-avatar" src="${t.avatarUrl}" alt="Avatar" style="width:40px; height:40px; border-radius:50%; object-fit:cover;" onerror="this.onerror=null; this.src='https://ui-avatars.com/api/?name=${t.fullName}&background=random';">
                                                </c:when>
                                                <c:when test="${not empty t.avatarUrl}">
                                                    <img class="table-avatar" src="${pageContext.request.contextPath}${t.avatarUrl}" alt="Avatar" style="width:40px; height:40px; border-radius:50%; object-fit:cover;" onerror="this.onerror=null; this.src='https://ui-avatars.com/api/?name=${t.fullName}&background=random';">
                                                </c:when>
                                                <c:otherwise>
                                                    <img class="table-avatar" src="https://ui-avatars.com/api/?name=${t.fullName}&background=random" alt="Avatar" style="width:40px; height:40px; border-radius:50%;">
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="name-cell"><strong><c:out value="${t.fullName}"/></strong></td>
                                        <td><c:out value="${t.qualification}"/></td>
                                        <td><span class="subject-tag"><c:out value="${t.teachingSubject}"/></span></td>
                                        <td><c:out value="${t.teachingArea}"/></td>
                                        <td class="price-cell">
                                            <fmt:formatNumber value="${t.hourlyRate}" type="number"/>đ
                                        </td>
                                        <td class="rating-cell">
                                            <strong>${t.ratingAverage > 0 ? t.ratingAverage : '0.0'}</strong> ⭐
                                        </td>

                                        <td class="status-cell">
                                            <c:choose>
                                                <c:when test="${not t.active}">
                                                    <span class="status-pill status-locked">Khóa</span>
                                                </c:when>

                                                <c:when test="${t.verificationStatus eq 'APPROVED'}">
                                                    <span class="status-pill status-approved">Hoạt động</span>
                                                </c:when>

                                                <c:when test="${t.verificationStatus eq 'PENDING'}">
                                                    <span class="status-pill status-pending">Chờ duyệt</span>
                                                </c:when>

                                                <c:otherwise>
                                                    <span class="status-pill status-rejected">Từ chối</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td class="action-cell">
                                            <div class="action-wrap">
                                                <a href="${pageContext.request.contextPath}/admin/tutor-detail?id=${t.tutorId}"
                                                   class="btn-admin-action btn-detail">
                                                    <span class="material-symbols-outlined">visibility</span>
                                                    Chi tiết
                                                </a>

                                                <c:choose>
                                                    <c:when test="${t.active}">
                                                        <form action="${pageContext.request.contextPath}/admin/toggle-tutor-status"
                                                              method="post">
                                                            <input type="hidden" name="id" value="${t.tutorId}">
                                                            <input type="hidden" name="action" value="lock">

                                                            <button type="submit"
                                                                    class="btn-admin-action btn-lock"
                                                                    onclick="return confirm('Bạn chắc chắn muốn khóa tài khoản gia sư này?')">
                                                                <span class="material-symbols-outlined">lock</span>
                                                                Khóa
                                                            </button>
                                                        </form>
                                                    </c:when>

                                                    <c:otherwise>
                                                        <form action="${pageContext.request.contextPath}/admin/toggle-tutor-status"
                                                              method="post">
                                                            <input type="hidden" name="id" value="${t.tutorId}">
                                                            <input type="hidden" name="action" value="unlock">

                                                            <button type="submit"
                                                                    class="btn-admin-action btn-unlock"
                                                                    onclick="return confirm('Bạn chắc chắn muốn mở khóa tài khoản gia sư này?')">
                                                                <span class="material-symbols-outlined">lock_open</span>
                                                                Mở khóa
                                                            </button>
                                                        </form>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="9" style="text-align:center; padding:32px; color:#94a3b8;">
                                        Hệ thống hiện tại chưa có dữ liệu gia sư nào.
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