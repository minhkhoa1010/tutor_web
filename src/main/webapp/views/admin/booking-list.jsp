<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title> Lớp Học – Gia Sư Bá Đạo VN</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
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
                <input type="text" placeholder="Tìm kiếm lớp học, phụ huynh hoặc gia sư...">
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
                    <h1>lớp học</h1>
                    <p>Xem danh sách lớp học, duyệt/từ chối yêu cầu mở lớp và hủy lớp học.</p>
                </div>
            </div>

            <c:if test="${param.success == 'updated'}">
                <div class="booking-message success">
                    Cập nhật trạng thái lớp học thành công.
                </div>
            </c:if>

            <c:if test="${not empty param.error}">
                <div class="booking-message error">
                    Có lỗi xảy ra khi xử lý lớp học.
                </div>
            </c:if>

            <div class="table-section">
                <div class="table-header">
                    <h3>Danh sách lớp học</h3>
                    <span class="new-apps-badge">
                        <c:choose>
                            <c:when test="${not empty bookings}">
                                ${bookings.size()} lớp học
                            </c:when>
                            <c:otherwise>
                                0 lớp học
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>

                <table class="data-table">
                    <thead>
                    <tr>
                        <th>MÃ LỚP</th>
                        <th>MÔN HỌC</th>
                        <th>PHỤ HUYNH</th>
                        <th>GIA SƯ</th>
                        <th>LỊCH HỌC</th>
                        <th>HỌC PHÍ</th>
                        <th>NGÀY TẠO</th>
                        <th>TRẠNG THÁI</th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:choose>
                        <c:when test="${not empty bookings}">
                            <c:forEach var="b" items="${bookings}">
                                <tr>
                                    <td>
                                        <strong>#BK-${b.bookingId}</strong>
                                    </td>

                                    <td>
                                        <span class="subject-tag">
                                            <c:out value="${b.subjectName}"/>
                                        </span>
                                    </td>

                                    <td>
                                        <div class="booking-user-info">
                                            <strong>
                                                <c:out value="${not empty b.parentName ? b.parentName : 'Chưa xác định'}"/>
                                            </strong>
                                            <small>
                                                <c:out value="${not empty b.parentEmail ? b.parentEmail : 'Không có email'}"/>
                                            </small>
                                        </div>
                                    </td>

                                    <td>
                                        <div class="booking-user-info">
                                            <strong>
                                                <c:out value="${not empty b.tutorName ? b.tutorName : 'Chưa xác định'}"/>
                                            </strong>
                                            <small>
                                                <c:out value="${not empty b.tutorEmail ? b.tutorEmail : 'Không có email'}"/>
                                            </small>
                                        </div>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty b.schedule}">
                                                <c:out value="${b.schedule}"/>
                                            </c:when>
                                            <c:otherwise>
                                                Theo thỏa thuận
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="booking-price">
                                        <fmt:formatNumber value="${b.totalPrice}" type="number"/>đ
                                    </td>

                                    <td>
                                        <c:out value="${b.createdAt}"/>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${b.status == 'PENDING'}">
                                                <span class="booking-status pending">Chờ duyệt</span>
                                            </c:when>

                                            <c:when test="${b.status == 'ACTIVE'}">
                                                <span class="booking-status active">Đang học</span>
                                            </c:when>

                                            <c:when test="${b.status == 'PAID'}">
                                                <span class="booking-status paid">Đã thanh toán</span>
                                            </c:when>

                                            <c:when test="${b.status == 'COMPLETED'}">
                                                <span class="booking-status completed">Hoàn thành</span>
                                            </c:when>

                                            <c:when test="${b.status == 'CANCELLED'}">
                                                <span class="booking-status cancelled">Đã hủy</span>
                                            </c:when>

                                            <c:when test="${b.status == 'REJECTED'}">
                                                <span class="booking-status rejected">Từ chối</span>
                                            </c:when>

                                            <c:otherwise>
                                                <span class="booking-status other">
                                                    <c:out value="${b.status}"/>
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>


                                </tr>
                            </c:forEach>
                        </c:when>

                        <c:otherwise>
                            <tr>
                                <td colspan="8" class="booking-empty">
                                    Chưa có lớp học nào.
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