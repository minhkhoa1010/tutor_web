<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý đánh giá – Gia Sư Bá Đạo VN</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-review.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" />
</head>

<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

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
                <input type="text" placeholder="Tìm kiếm đánh giá, gia sư hoặc phụ huynh...">
            </div>

            <nav class="topbar-links">
                <a href="#">Trợ giúp</a>
                <a href="#">Báo cáo</a>
            </nav>

            <div class="topbar-actions">
                <button class="icon-btn notif-btn">
                    <span class="material-symbols-outlined">notifications</span>
                    <span class="notif-dot"></span>
                </button>

                <button class="icon-btn">
                    <span class="material-symbols-outlined">mail</span>
                </button>

                <img class="avatar-sm"
                     src="${not empty sessionScope.clientUser.avatarUrl ? sessionScope.clientUser.avatarUrl : 'https://ui-avatars.com/api/?name=Admin+User&background=1a2f5a&color=fff'}"
                     alt="Admin">
            </div>
        </header>

        <div class="page-body">

            <div class="page-title-row">
                <div>
                    <h1>Quản lý đánh giá</h1>
                    <p>Kiểm duyệt đánh giá của người dùng, ẩn hoặc xóa đánh giá spam.</p>
                </div>
            </div>

            <div class="table-section">
                <div class="table-header">
                    <h3>Danh sách đánh giá</h3>
                    <span class="new-apps-badge">
                        <c:choose>
                            <c:when test="${not empty reviews}">
                                ${reviews.size()} đánh giá
                            </c:when>
                            <c:otherwise>
                                0 đánh giá
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>

                <table class="data-table">
                    <thead>
                    <tr>
                        <th>Mã</th>
                        <th>Phụ huynh</th>
                        <th>Gia sư</th>
                        <th>Môn học</th>
                        <th>Đánh giá</th>
                        <th>Nội dung</th>
                        <th>Ngày tạo</th>
                        <th>Trạng thái</th>
                        <th style="text-align:center;">Hành động</th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:choose>
                        <c:when test="${not empty reviews}">
                            <c:forEach var="r" items="${reviews}">
                                <tr>
                                    <td>#RV-${r.reviewId}</td>

                                    <td>
                                        <strong><c:out value="${r.parentName}"/></strong><br>
                                        <small><c:out value="${r.parentEmail}"/></small>
                                    </td>

                                    <td>
                                        <strong><c:out value="${r.tutorName}"/></strong><br>
                                        <small><c:out value="${r.tutorEmail}"/></small>
                                    </td>

                                    <td>
                                        <span class="subject-tag">
                                            <c:out value="${r.subjectName}"/>
                                        </span>
                                    </td>

                                    <td class="review-rating">
                                        ${r.rating} ⭐
                                    </td>

                                    <td>
                                        <div class="review-comment">
                                            <c:out value="${not empty r.comment ? r.comment : 'Không có nội dung'}"/>
                                        </div>
                                    </td>

                                    <td>
                                        <c:out value="${r.createdAt}"/>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${r.hidden}">
                                                <span class="review-status hidden">Đã ẩn</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="review-status visible">Đang hiển thị</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td style="text-align:center;">
                                        <div class="review-action-wrap">
                                            <c:choose>
                                                <c:when test="${r.hidden}">
                                                    <form action="${ctx}/admin/reviews/action" method="post">
                                                        <input type="hidden" name="id" value="${r.reviewId}">
                                                        <input type="hidden" name="action" value="show">

                                                        <button class="btn-review-action btn-show"
                                                                type="submit"
                                                                onclick="return confirm('Hiện lại đánh giá này?')">
                                                            <span class="material-symbols-outlined">visibility</span>
                                                            Hiện
                                                        </button>
                                                    </form>
                                                </c:when>

                                                <c:otherwise>
                                                    <form action="${ctx}/admin/reviews/action" method="post">
                                                        <input type="hidden" name="id" value="${r.reviewId}">
                                                        <input type="hidden" name="action" value="hide">

                                                        <button class="btn-review-action btn-hide"
                                                                type="submit"
                                                                onclick="return confirm('Ẩn đánh giá này?')">
                                                            <span class="material-symbols-outlined">visibility_off</span>
                                                            Ẩn
                                                        </button>
                                                    </form>
                                                </c:otherwise>
                                            </c:choose>

                                            <form action="${ctx}/admin/reviews/action" method="post">
                                                <input type="hidden" name="id" value="${r.reviewId}">
                                                <input type="hidden" name="action" value="delete">

                                                <button class="btn-review-action btn-delete"
                                                        type="submit"
                                                        onclick="return confirm('Xóa vĩnh viễn đánh giá này?')">
                                                    <span class="material-symbols-outlined">delete</span>
                                                    Xóa
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>

                        <c:otherwise>
                            <tr>
                                <td colspan="9" style="text-align:center; padding:32px; color:#94a3b8;">
                                    Chưa có đánh giá nào.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>

            <footer class="page-footer">
                © 2026 Gia Sư Bá Đạo VN • Giao diện quản trị hệ thống
            </footer>
        </div>
    </div>
</div>

</body>
</html>