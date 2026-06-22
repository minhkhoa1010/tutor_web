<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<%-- 1. Header & Navbar --%>
<jsp:include page="/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Gia sư yêu thích - Gia Sư Bá Đạo"/>
    <jsp:param name="pageCss" value="/assets/css/user-profile.css" />
</jsp:include>

<jsp:include page="/views/common/navbar.jsp" />

<main class="page-main" style="background-color: #f8fafc; padding: 40px 0; font-family: 'Plus Jakarta Sans', sans-serif;">
    <div class="container" style="max-width: 1240px; margin: 0 auto; padding: 0 20px;">

        <%-- Breadcrumb --%>
        <div class="breadcrumb" style="margin-bottom: 32px; font-size: 14px; color: #64748b;">
            <a href="${pageContext.request.contextPath}/home" style="color: #64748b; text-decoration: none;">Trang chủ</a>
            <span style="margin: 0 8px; color: #cbd5e1;">/</span>
            <span style="color: #0f172a; font-weight: 500;">Gia sư yêu thích</span>
        </div>

        <%-- Layout Grid --%>
        <div class="profile-detail-grid" style="display: flex; gap: 24px; align-items: flex-start;">

            <%-- GỌI SIDEBAR ĐỒNG BỘ --%>
            <jsp:include page="/views/parent/sidebar.jsp" />

            <%-- PHẦN NỘI DUNG CHÍNH (Danh sách gia sư đã lưu) --%>
            <section class="profile-content-card" style="flex: 1; background: #fff; padding: 40px; border-radius: 16px; border: 1px solid #f1f5f9; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);">

                <div class="panel-main-header" style="margin-bottom: 32px; border-bottom: 1px solid #f1f5f9; padding-bottom: 24px;">
                    <h3 style="font-size: 24px; font-weight: 800; color: #0f172a; margin: 0 0 8px 0;">Gia sư đã lưu yêu thích</h3>
                    <p style="font-size: 14px; color: #64748b; margin: 0;">Danh sách những gia sư bạn đã đánh dấu quan tâm để dễ dàng theo dõi và kết nối thuê lớp.</p>
                </div>

                <%-- LƯỚI DANH SÁCH GIA SƯ --%>
                <div class="wishlist-container" style="display: flex; flex-direction: column; gap: 16px;">
                    <c:choose>
                        <%-- Trường hợp có dữ liệu gia sư yêu thích --%>
                        <c:when test="${not empty savedTutorsList}">
                            <c:forEach var="tutor" items="${savedTutorsList}">
                                <%-- Sử dụng định danh chuẩn: tutorId --%>
                                <div class="wishlist-item" id="tutor-row-${tutor.tutorId}"
                                     style="display: flex; gap: 20px; align-items: center; padding: 20px; border: 1px solid #e2e8f0; border-radius: 12px; background: #fff; transition: all 0.2s;">

                                        <%-- Avatar gia sư --%>
                                    <div style="width: 80px; height: 80px; border-radius: 50%; overflow: hidden; border: 2px solid #e2e8f0; flex-shrink: 0;
                                            background-image: url('${not empty tutor.avatarUrl ? tutor.avatarUrl : pageContext.request.contextPath.concat('/assets/images/default-avatar.png')}');
                                            background-size: cover; background-position: center;">
                                    </div>

                                        <%-- Thông tin gia sư --%>
                                    <div style="flex: 1;">
                                        <h4 style="font-size: 16px; font-weight: 700; color: #0f172a; margin: 0 0 6px 0;">
                                            <c:out value="${tutor.fullName}"/>
                                            <span style="font-size: 12px; font-weight: 600; color: #0d9488; background: #f0fdf4; padding: 2px 8px; border-radius: 12px; margin-left: 8px;">
                                                <c:out value="${tutor.qualification}"/>
                                            </span>
                                        </h4>
                                        <p style="font-size: 13px; color: #64748b; margin: 0 0 4px 0;">
                                            <i class="bi bi-mortarboard" style="color: #64748b;"></i> Chuyên dạy: <strong><c:out value="${tutor.teachingSubject}"/></strong> (Lớp: <c:out value="${tutor.teachingGrade}"/>)
                                        </p>
                                        <p style="font-size: 13px; color: #64748b; margin: 0;">
                                            <i class="bi bi-geo-alt" style="color: #64748b;"></i> Khu vực: <c:out value="${tutor.teachingArea}"/>
                                        </p>
                                    </div>

                                        <%-- Học phí & Hành động --%>
                                    <div style="text-align: right; display: flex; flex-direction: column; gap: 8px; align-items: flex-end;">
                                        <div style="font-size: 15px; font-weight: 700; color: #0d9488;">
                                            <fmt:formatNumber value="${tutor.hourlyRate}" type="number" groupingUsed="true"/>đ/buổi
                                        </div>

                                        <div style="display: flex; gap: 8px;">
                                                <%-- NÚT XEM CHI TIẾT (Đã đổi tham số id thành tutor.tutorId) --%>
                                            <a href="${pageContext.request.contextPath}/tutor/tutor-detail?id=${tutor.tutorId}"
                                               style="padding: 6px 12px; background: #f1f5f9; color: #334155; border-radius: 6px; font-size: 13px; font-weight: 600; text-decoration: none; border: 1px solid #e2e8f0;">
                                                Xem hồ sơ
                                            </a>

                                                <%-- NÚT HỦY LƯU (Đã đổi thuộc tính thành data-tutor-id="${tutor.tutorId}") --%>
                                            <button class="btn-remove-wishlist" data-tutor-id="${tutor.tutorId}" title="Bỏ lưu"
                                                    style="padding: 6px 10px; background: #fef2f2; color: #dc2626; border: 1px solid #fee2e2; border-radius: 6px; font-size: 14px; cursor: pointer; display: flex; align-items: center; justify-content: center;">
                                                <i class="bi bi-trash3"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>

                        <%-- Trường hợp danh sách trống --%>
                        <c:otherwise>
                            <div style="text-align: center; padding: 48px 0; color: #94a3b8;">
                                <i class="bi bi-heartbreak" style="font-size: 48px; color: #cbd5e1; display: block; margin-bottom: 12px;"></i>
                                Bạn chưa lưu danh sách gia sư yêu thích nào.
                                <a href="${pageContext.request.contextPath}/tutors" style="color: #0d9488; font-weight: 600; text-decoration: none; display: block; margin-top: 8px;">Tìm kiếm gia sư ngay</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>
        </div>
    </div>
</main>

<jsp:include page="/views/common/footer.jsp" />

<%-- XỬ LÝ AJAX HỦY LƯU CHUẨN XÁC --%>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const removeButtons = document.querySelectorAll('.btn-remove-wishlist');

        removeButtons.forEach(button => {
            button.addEventListener('click', function (e) {
                e.preventDefault();

                const tutorId = this.getAttribute('data-tutor-id');
                const targetRow = document.getElementById('tutor-row-' + tutorId);

                if (confirm('Bạn có chắc chắn muốn bỏ lưu gia sư này khỏi danh sách yêu thích?')) {
                    fetch('${pageContext.request.contextPath}/parent/wishlist?tutorId=' + tutorId, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        }
                    })
                        .then(response => {
                            if (!response.ok) throw new Error('Yêu cầu thất bại');
                            return response.json();
                        })
                        .then(data => {
                            // Service trả về chữ thường "removed" chuẩn chỉ
                            if (data.status === 'removed') {
                                alert('Đã xóa gia sư khỏi danh sách yêu thích!');
                                if (targetRow) {
                                    targetRow.style.transition = 'all 0.3s ease';
                                    targetRow.style.opacity = '0';
                                    setTimeout(() => {
                                        targetRow.remove();
                                        if(document.querySelectorAll('.wishlist-item').length === 0) {
                                            window.location.reload();
                                        }
                                    }, 300);
                                } else {
                                    window.location.reload();
                                }
                            } else {
                                alert('Xử lý thất bại, vui lòng thử lại.');
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            alert('Có lỗi xảy ra khi thực hiện tác vụ.');
                        });
                }
            });
        });
    });
</script>