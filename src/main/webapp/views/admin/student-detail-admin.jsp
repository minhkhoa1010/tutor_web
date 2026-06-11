<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Quản trị viên - Chi tiết hồ sơ học viên ${student.fullname}</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tutor-detail-admin.css">
</head>
<body>

<div class="admin-wrapper">
    <main class="main-content">
        <!-- TOPBAR -->
        <div class="topbar">
            <div class="topbar-brand">
                <div class="brand-dot"></div>
                Quản lý hệ thống học viên
            </div>
            <div class="topbar-links">
                <span class="text-muted">Thông tin tài khoản khách hàng</span>
            </div>
        </div>

        <div class="page-body">

            <!-- TIÊU ĐỀ TRANG -->
            <div class="page-title-row">
                <div>
                    <h1>Hồ Sơ Học Viên Chi Tiết</h1>
                    <p>Hệ thống quản lý thông tin tài khoản và trạng thái hoạt động của học viên.</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/students" class="btn-primary" style="text-decoration: none;">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại Danh sách
                </a>
            </div>

            <div class="tutor-container">

                <!-- PROFILE CARD (CỘT TRÁI) -->
                <aside class="profile-card">
                    <div class="avatar-wrapper">
                        <img src="${not empty student.avatarUrl ? (student.avatarUrl.startsWith('http') ? student.avatarUrl : pageContext.request.contextPath.concat(student.avatarUrl)) : 'https://ui-avatars.com/api/?name='.concat(student.fullname)}"
                             class="avatar-main" alt="Portrait">
                    </div>
                    <h2 class="tutor-name"><c:out value="${student.fullname}"/></h2>
                    <span class="tutor-id-badge">ID HỌC VIÊN: #ST-${student.id}</span>

                    <!-- Badge trạng thái hoạt động -->
                    <div style="margin-top: 12px;">
                        <c:choose>
                            <c:when test="${student.isActive == 1}">
                                <span class="status-banner" style="background: #ecfdf5; color: #10b981; border: 1px solid #a7f3d0; padding: 6px 14px; border-radius: 20px; font-weight: 600; font-size: 13px;">
                                    <i class="fa-solid fa-circle-check"></i> Đang hoạt động
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-banner" style="background: #fef2f2; color: #ef4444; border: 1px solid #fca5a5; padding: 6px 14px; border-radius: 20px; font-weight: 600; font-size: 13px;">
                                    <i class="fa-solid fa-circle-xmark"></i> Đang bị khóa
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </aside>

                <!-- DETAIL CONTENT (CỘT PHẢI) -->
                <div class="detail-content">

                    <!-- SECTION 1: THÔNG TIN TÀI KHOẢN AN TOÀN -->
                    <section class="info-section-card">
                        <h3 class="section-card-title">
                            <i class="fa-solid fa-user"></i> Thông tin tài khoản &amp; Cá nhân
                        </h3>
                        <div class="info-grid-2col">
                            <div class="data-group">
                                <span class="data-label">Họ và tên học viên</span>
                                <span class="data-value" style="font-weight: 600; color: #1e293b;"><c:out value="${student.fullname}"/></span>
                            </div>
                            <div class="data-group">
                                <span class="data-label">Địa chỉ định danh Email</span>
                                <span class="data-value"><c:out value="${student.email}"/></span>
                            </div>
                            <div class="data-group">
                                <span class="data-label">Ngày đăng ký tham gia</span>
                                <span class="data-value">${not empty student.createdAt ? student.createdAt : 'Chưa cập nhật'}</span>
                            </div>
                            <div class="data-group">
                                <span class="data-label">Số điện thoại liên hệ</span>
                                <span class="data-value" style="font-weight: 500; color: #1e293b;">
                                    ${not empty student.phone ? student.phone : 'Chưa cập nhật'}
                                </span>
                            </div>
                        </div>
                    </section>
                    <!-- SECTION 2: Ghi chú hệ thống bổ sung (Không gọi biến DB để tránh crash) -->
                    <section class="info-section-card">
                        <h3 class="section-card-title">
                            <i class="fa-solid fa-circle-info"></i> Nhật ký &amp; Trạng thái hệ thống
                        </h3>
                        <div class="info-grid-2col">
                            <div class="data-group info-grid-full">
                                <span class="data-label">Ghi chú kiểm tra phân quyền</span>

                                <c:choose>
                                    <c:when test="${student.isActive == 1}">
                    <span class="data-value" style="color: #16a34a; font-weight: 500; display: inline-flex; align-items: center; gap: 6px;">
                        <i class="fa-solid fa-circle-check"></i> Tài khoản học viên hợp lệ, được phép tham gia đăng ký lớp học và tìm kiếm thông tin gia sư trực tuyến trên nền tảng.
                    </span>
                                    </c:when>
                                    <c:otherwise>
                    <span class="data-value" style="color: #dc2626; font-weight: 500; display: inline-flex; align-items: center; gap: 6px;">
                        <i class="fa-solid fa-circle-exclamation"></i> Tài khoản này hiện đang bị đóng khóa quyền truy cập do vi phạm chính sách hoặc theo yêu cầu quản trị viên. Mọi quyền tìm lớp và liên hệ đều bị tạm dừng.
                    </span>
                                    </c:otherwise>
                                </c:choose>

                            </div>
                        </div>
                    </section>

                    <!-- ROW HÀNH ĐỘNG BẬT/TẮT TRẠNG THÁI TÀI KHOẢN -->
                    <div class="action-row" style="margin-top: 30px;">
                        <c:choose>
                            <c:when test="${student.isActive == 1}">
                                <a href="${pageContext.request.contextPath}/admin/toggle-student-status?id=${student.id}&action=lock"
                                   class="btn-action btn-reject"
                                   style="text-decoration: none;"
                                   onclick="return confirm('Bạn có chắc chắn muốn khóa tài khoản học viên này?')">
                                    <i class="fa-solid fa-lock"></i> Khóa tài khoản người dùng
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/admin/toggle-student-status?id=${student.id}&action=unlock"
                                   class="btn-action btn-approve"
                                   style="text-decoration: none;"
                                   onclick="return confirm('Bạn có chắc chắn muốn mở khóa cho học viên này?')">
                                    <i class="fa-solid fa-lock-open"></i> Mở khóa tài khoản ngay
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>

                </div>
            </div>

        </div>
    </main>
</div>

</body>
</html>