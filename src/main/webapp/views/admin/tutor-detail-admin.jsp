<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Chi tiết gia sư - ${tutor.fullName}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-light">

<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h1 class="h3 mb-0 text-dark fw-bold">Hồ Sơ Chi Tiết Gia Sư</h1>
            <p class="text-muted mb-0">Hệ thống xét duyệt thông tin năng lực gia sư đăng ký.</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-secondary shadow-sm">
            <i class="fa-solid fa-arrow-left"></i> Quay lại Dashboard
        </a>
    </div>

    <div class="row">
        <div class="col-lg-4 mb-4">
            <div class="card shadow-sm border-0 text-center py-4">
                <div class="card-body">
                    <img src="${not empty tutor.portraitUrl ? tutor.portraitUrl : 'https://via.placeholder.com/150'}"
                         class="rounded-circle img-thumbnail mb-3 shadow-sm"
                         style="width: 160px; height: 160px; object-fit: cover;">

                    <h4 class="fw-bold mb-1">${tutor.fullName}</h4>
                    <p class="text-muted small mb-3">ID Gia Sư: <span class="badge bg-dark">#${tutor.id}</span></p>
                    <span class="badge bg-warning text-dark px-3 py-2 rounded-pill fw-bold">
                        <i class="fa-solid fa-spinner fa-spin me-1"></i> Hồ sơ chờ duyệt
                    </span>
                </div>
            </div>
        </div>

        <div class="col-lg-8">
            <div class="card shadow-sm border-0 mb-4">
                <div class="card-body p-4">
                    <h5 class="card-title fw-bold text-primary mb-4">
                        <i class="fa-solid fa-address-card me-2"></i>Thông tin đăng ký giảng dạy
                    </h5>
                    <div class="row g-3">
                        <div class="col-sm-6">
                            <span class="text-muted d-block small">Giới tính</span>
                            <span class="fw-semibold text-dark">${tutor.genderLabel}</span>
                        </div>
                        <div class="col-sm-6">
                            <span class="text-muted d-block small">Trình độ / Bằng cấp tối đa</span>
                            <span class="fw-semibold text-dark">${not empty tutor.degreeLevel ? tutor.degreeLevel : 'Chưa cập nhật'}</span>
                        </div>
                        <div class="col-sm-6">
                            <span class="text-muted d-block small">Mức học phí mong muốn</span>
                            <span class="fw-bold text-danger">${tutor.rateLabel}</span>
                        </div>
                        <div class="col-sm-6">
                            <span class="text-muted d-block small">Môn học phụ trách</span>
                            <span class="badge bg-info text-dark p-2">${tutor.subjectsLabel}</span>
                        </div>
                        <div class="col-sm-6">
                            <span class="text-muted d-block small">Lớp học đăng ký dạy</span>
                            <span class="fw-semibold text-dark">${not empty tutor.grades ? tutor.grades : 'Chưa đăng ký lớp'}</span>
                        </div>
                        <div class="col-sm-6">
                            <span class="text-muted d-block small">Khu vực dạy (Quận/Huyện, Tỉnh/TP)</span>
                            <span class="fw-semibold text-dark">
                                <i class="fa-solid fa-map-location-dot text-muted me-1"></i>${tutor.areaLabel}
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card shadow-sm border-0 mb-4">
                <div class="card-body p-4">
                    <h5 class="card-title fw-bold text-success mb-4">
                        <i class="fa-solid fa-file-invoice me-2"></i>Hồ sơ năng lực đính kèm
                    </h5>

                    <div class="mb-4">
                        <h6 class="fw-bold text-secondary mb-2"><i class="fa-solid fa-graduation-cap me-1"></i> Ảnh bằng cấp / Chứng chỉ:</h6>
                        <div class="row g-2">
                            <c:forEach var="url" items="${tutor.degreeUrls}">
                                <div class="col-6 col-sm-4">
                                    <a href="${url}" target="_blank">
                                        <img src="${url}" class="img-fluid rounded img-thumbnail" style="height: 120px; width:100%; object-fit: cover;" title="Click để phóng to ảnh">
                                    </a>
                                </div>
                            </c:forEach>
                            <c:if test="${empty tutor.degreeUrls}">
                                <div class="text-muted small ps-2 italic">Không có tài liệu bằng cấp đính kèm.</div>
                            </c:if>
                        </div>
                    </div>

                    <div>
                        <h6 class="fw-bold text-secondary mb-2"><i class="fa-solid fa-id-card me-1"></i> Ảnh Căn cước công dân (Mặt trước & Mặt sau):</h6>
                        <div class="row g-2">
                            <c:forEach var="url" items="${tutor.idCardUrls}">
                                <div class="col-6 col-sm-4">
                                    <a href="${url}" target="_blank">
                                        <img src="${url}" class="img-fluid rounded img-thumbnail" style="height: 120px; width:100%; object-fit: cover;">
                                    </a>
                                </div>
                            </c:forEach>
                            <c:if test="${empty tutor.idCardUrls}">
                                <div class="text-muted small ps-2 italic">Không có ảnh căn cước đối chiếu.</div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

            <div class="d-flex gap-3 mb-5">
                <a href="${pageContext.request.contextPath}/admin/approve-tutor?id=${tutor.id}"
                   class="btn btn-success btn-lg flex-fill py-2.5 fw-bold shadow-sm">
                    <i class="fa-solid fa-circle-check me-1"></i> Phê Duyệt Hồ Sơ
                </a>
                <a href="${pageContext.request.contextPath}/admin/reject-tutor?id=${tutor.id}"
                   class="btn btn-danger btn-lg flex-fill py-2.5 fw-bold shadow-sm">
                    <i class="fa-solid fa-circle-xmark me-1"></i> Từ Chối Yêu Cầu
                </a>
            </div>

        </div>
    </div>
</div>

</body>
</html>