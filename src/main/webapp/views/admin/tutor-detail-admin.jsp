<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Quản trị viên - Chi tiết hồ sơ ${tutor.fullName}</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tutor-detail-admin.css">
</head>
<body>

<div class="admin-wrapper">
    <main class="main-content">
        <div class="topbar">
            <div class="topbar-brand">
                <div class="brand-dot"></div>
                Quản lý hệ thống gia sư
            </div>
            <div class="topbar-links">
                <span class="text-muted">Hồ sơ xét duyệt trực tuyến</span>
            </div>
        </div>

        <div class="page-body">

            <div class="page-title-row">
                <div>
                    <h1>Duyệt Hồ Sơ Chi Tiết</h1>
                    <p>Hệ thống đánh giá và phê duyệt hồ sơ năng lực gia sư đăng ký.</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-primary">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại Dashboard
                </a>
            </div>

            <div class="tutor-container">

                <aside class="profile-card">
                    <div class="avatar-wrapper">
                        <img src="${not empty tutor.portraitUrl ? tutor.portraitUrl : 'https://via.placeholder.com/150'}"
                             class="avatar-main" alt="Portrait">
                    </div>
                    <h2 class="tutor-name">${tutor.fullName}</h2>
                    <span class="tutor-id-badge">ID GIA SƯ: #${tutor.id}</span>
                    <div>
                        <span class="status-banner">
                            <i class="fa-solid fa-spinner fa-spin"></i> Chờ kiểm tra
                        </span>
                    </div>
                </aside>

                <div class="detail-content">

                    <section class="info-section-card">
                        <h3 class="section-card-title">
                            <i class="fa-solid fa-user"></i> Thông tin cá nhân
                        </h3>
                        <div class="info-grid-2col">
                            <div class="data-group">
                                <span class="data-label">Giới tính</span>
                                <span class="data-value">${tutor.genderLabel}</span>
                            </div>
                            <div class="data-group">
                                <span class="data-label">Ngày sinh</span>
                                <span class="data-value">${not empty tutor.birthDate ? tutor.birthDate : 'Chưa cập nhật'}</span>
                            </div>
                            <div class="data-group">
                                <span class="data-label">Trường đào tạo</span>
                                <span class="data-value">${not empty tutor.school ? tutor.school : 'Chưa cập nhật'}</span>
                            </div>
                            <div class="data-group">
                                <span class="data-label">Chuyên ngành đào tạo</span>
                                <span class="data-value">${not empty tutor.major ? tutor.major : 'Chưa cập nhật'}</span>
                            </div>
                        </div>
                    </section>

                    <section class="info-section-card">
                        <h3 class="section-card-title">
                            <i class="fa-solid fa-graduation-cap"></i> Thông tin đăng ký lớp &amp; học phí
                        </h3>

                        <div class="info-grid-2col">
                            <div class="data-group">
                                <span class="data-label">Trình độ chuyên môn hiện tại</span>
                                <span class="data-value">${not empty tutor.degreeLevel ? tutor.degreeLevel : 'Chưa cập nhật'}</span>
                            </div>
                            <div class="data-group">
                                <span class="data-label">Học phí đề xuất mong muốn</span>
                                <span class="data-value text-price">${tutor.rateLabel}</span>
                            </div>
                            <div class="data-group info-grid-full">
                                <span class="data-label">Môn học phụ trách giảng dạy</span>
                                <div style="margin-top: 6px;">
                                    <span class="subject-badge">${tutor.subjectsLabel}</span>
                                </div>
                            </div>
                            <div class="data-group info-grid-full">
                                <span class="data-label">Các khối lớp học nhận dạy</span>
                                <span class="data-value">${not empty tutor.grades ? tutor.grades : 'Chưa đăng ký/Chưa cập nhật'}</span>
                            </div>
                            <div class="data-group info-grid-full">
                                <span class="data-label">Khu vực phân phối (Quận / Huyện)</span>
                                <span class="data-value">
                                    <i class="fa-solid fa-map-location-dot" style="color: #64748b; margin-right: 4px;"></i>
                                    ${tutor.areaLabel}
                                </span>
                            </div>
                        </div>
                    </section>

                    <section class="info-section-card">
                        <h3 class="section-card-title">
                            <i class="fa-solid fa-calendar-days"></i> Lịch biểu giảng dạy đăng ký (Thời gian rảnh)
                        </h3>
                        <div style="margin-top: 12px; display: flex; flex-wrap: wrap; gap: 8px;">
                            <c:choose>
                                <%-- FIX LỖI: Đổi từ kiểm tra tutor.availableSchedules sang danh sách scheduleList vừa gửi sang --%>
                                <c:when test="${not empty scheduleList}">
                                    <c:forEach var="schedule" items="${scheduleList}">
                    <span style="display: inline-flex; align-items: center; gap: 6px; padding: 6px 14px; background-color: #f0fdf4; color: #15803d; border: 1px solid #bbf7d0; border-radius: 6px; font-size: 13px; font-weight: 500;">
                        <i class="fa-solid fa-clock" style="font-size: 11px;"></i> ${schedule}
                    </span>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #94a3b8; font-style: italic; font-size: 13px;">Gia sư này chưa đăng ký khung thời gian biểu rảnh rỗi.</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </section>
                    <section class="info-section-card">
                        <h3 class="section-card-title">
                            <i class="fa-solid fa-file-shield"></i> Tài liệu &amp; Giấy tờ pháp lý đối chiếu
                        </h3>

                        <div class="doc-sub-title"><i class="fa-solid fa-certificate"></i> Bằng cấp / Chứng chỉ nghiệp vụ:</div>
                        <div class="doc-gallery">
                            <c:forEach var="url" items="${tutor.degreeUrls}">
                                <div class="doc-thumb-wrapper">
                                    <a href="${url}" target="_blank">
                                        <img src="${url}" class="doc-img" title="Nhấp để xem ảnh gốc">
                                    </a>
                                </div>
                            </c:forEach>
                            <c:if test="${empty tutor.degreeUrls}">
                                <div class="empty-doc-text">Hệ thống chưa ghi nhận tệp đính kèm bằng cấp nào từ tài khoản này.</div>
                            </c:if>
                        </div>

                        <div class="doc-sub-title"><i class="fa-solid fa-id-card"></i> Ảnh Căn cước công dân xác thực danh tính:</div>
                        <div class="doc-gallery">
                            <c:forEach var="url" items="${tutor.idCardUrls}">
                                <div class="doc-thumb-wrapper">
                                    <a href="${url}" target="_blank">
                                        <img src="${url}" class="doc-img" title="Nhấp để xem ảnh gốc">
                                    </a>
                                </div>
                            </c:forEach>
                            <c:if test="${empty tutor.idCardUrls}">
                                <div class="empty-doc-text">Hệ thống chưa ghi nhận dữ liệu ảnh căn cước công dân.</div>
                            </c:if>
                        </div>
                    </section>

                    <div class="action-row">
                        <a href="${pageContext.request.contextPath}/admin/approve-tutor?id=${tutor.id}" class="btn-action btn-approve">
                            <i class="fa-solid fa-circle-check"></i> Phê duyệt hồ sơ
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/reject-tutor?id=${tutor.id}" class="btn-action btn-reject">
                            <i class="fa-solid fa-circle-xmark"></i> Từ chối hồ sơ
                        </a>
                    </div>

                </div>
            </div>

        </div>
    </main>
</div>

</body>
</html>