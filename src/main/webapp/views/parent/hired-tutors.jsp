<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<jsp:include page="/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Gia sư đang thuê"/>
    <jsp:param name="pageCss" value="/assets/css/user-profile.css" />
</jsp:include>

<jsp:include page="/views/common/navbar.jsp" />

<main class="page-main" style="background-color: #f8fafc; padding: 40px 0; font-family: 'Plus Jakarta Sans', sans-serif;">
    <div class="container" style="max-width: 1240px; margin: 0 auto; padding: 0 20px;">

        <div class="breadcrumb" style="margin-bottom: 32px; font-size: 14px; color: #64748b;">
            <a href="${pageContext.request.contextPath}/home" style="color: #64748b; text-decoration: none;">Trang chủ</a>
            <span style="margin: 0 8px; color: #cbd5e1;">/</span>
            <span style="color: #0f172a; font-weight: 500;">Gia sư đang thuê</span>
        </div>

        <div class="profile-detail-grid" style="display: flex; gap: 24px;">

            <jsp:include page="/views/parent/sidebar.jsp" />

            <section class="profile-content-card" style="flex: 1; background: #fff; padding: 40px; border-radius: 16px; border: 1px solid #f1f5f9; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);">
                <div class="panel-main-header" style="margin-bottom: 32px; border-bottom: 1px solid #f1f5f9; padding-bottom: 24px;">
                    <h3 style="font-size: 24px; font-weight: 800; color: #0f172a; margin: 0 0 8px 0; letter-spacing: -0.5px;">
                        Gia sư đang thuê
                    </h3>
                    <p style="font-size: 14px; color: #64748b; margin: 0;">Danh sách hợp đồng gia sư của bạn.</p>
                </div>

                <c:choose>
                    <c:when test="${not empty hiredTutors}">
                        <%--
   CẢI TIẾN: Thêm div bọc ngoài khống chế chiều cao tối đa (tầm 2 hàng card gia sư).
   Khi phụ huynh thuê từ 5-6 gia sư trở lên, scrollbar nội bộ sẽ tự xuất hiện mượt mà.
 --%>
                        <div style="max-height: 680px; overflow-y: auto; padding-right: 8px; box-sizing: border-box;">
                            <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 24px;">
                                <c:forEach var="tutor" items="${hiredTutors}">
                                    <div style="border: 1px solid #e2e8f0; border-radius: 16px; padding: 24px; display: flex; flex-direction: column; background: #fff; transition: transform 0.2s, box-shadow 0.2s;">

                                            <%-- Giữ nguyên toàn bộ nội dung Card Gia sư (Avatar, Tên, Chi tiết Booking, Button...) của ông ở đây --%>
                                        <div style="display: flex; align-items: center; gap: 16px; margin-bottom: 20px;">
                                            <img src="${not empty tutor.portraitUrl ? tutor.portraitUrl : pageContext.request.contextPath.concat('/assets/images/default-avatar.png')}" alt="${tutor.tutorName}" style="width: 60px; height: 60px; border-radius: 12px; object-fit: cover; border: 2px solid #f1f5f9;">
                                            <div>
                                                <h4 style="margin: 0; font-size: 16px; color: #0f172a; font-weight: 700;">${tutor.tutorName}</h4>
                                                <span style="display: inline-block; margin-top: 4px; padding: 2px 8px; background: #f1f5f9; border-radius: 6px; font-size: 12px; color: #475569; font-weight: 500;">
                                                        ${tutor.subjectName}
                                                </span>
                                            </div>
                                        </div>

                                        <div style="border-top: 1px solid #f1f5f9; padding-top: 16px; margin-bottom: 20px;">
                                            <div style="font-size: 13px; color: #475569; margin-bottom: 12px;">
                                                <i class="bi bi-cake2" style="color: #64748b; margin-right: 8px;"></i>
                                                <strong>Ngày sinh:</strong> ${not empty tutor.dateOfBirth ? tutor.dateOfBirth : 'Chưa cập nhật'}
                                            </div>
                                            <div style="font-size: 13px; color: #475569; margin-bottom: 12px;">
                                                <i class="bi bi-wallet2" style="color: #64748b; margin-right: 8px;"></i>
                                                <strong>Phí:</strong> ${tutor.totalPrice} VNĐ
                                            </div>
                                            <div style="font-size: 13px; color: #475569;">
                                                <i class="bi bi-calendar3" style="color: #64748b; margin-right: 8px;"></i>
                                                <strong>Thuê lúc:</strong> ${tutor.createdAt}
                                            </div>
                                        </div>

                                        <div style="margin-bottom: 20px;">
                                            <c:choose>
                                                <%-- Nhóm các trạng thái đơn hàng đang trong quá trình xử lý/hoạt động --%>
                                                <c:when test="${tutor.status eq 'ACTIVE' || tutor.status eq 'PAID' || tutor.status eq 'PENDING_COMPLETED' || tutor.status eq 'DISPUTED'}">
        <span style="background: #ccfbf1; color: #0d9488; padding: 6px 12px; border-radius: 6px; font-size: 12px; font-weight: 700; text-transform: uppercase;">
            <i class="fa-solid fa-spinner fa-spin-pulse" style="margin-right: 4px;"></i> Đang thuê
        </span>
                                                </c:when>

                                                <%-- Nhóm đã kết thúc thành công --%>
                                                <c:when test="${tutor.status eq 'COMPLETED'}">
        <span style="background: #f1f5f9; color: #475569; padding: 6px 12px; border-radius: 6px; font-size: 12px; font-weight: 700; text-transform: uppercase;">
            <i class="fa-solid fa-circle-check" style="margin-right: 4px;"></i> Đã hoàn thành
        </span>
                                                </c:when>

                                                <%-- Nhóm đã hoàn tiền (Refunded) --%>
                                                <c:when test="${tutor.status eq 'REFUNDED'}">
        <span style="background: #fee2e2; color: #b91c1c; padding: 6px 12px; border-radius: 6px; font-size: 12px; font-weight: 700; text-transform: uppercase;">
            <i class="fa-solid fa-rotate-left" style="margin-right: 4px;"></i> Đã hoàn tiền
        </span>
                                                </c:when>

                                                <%-- Mặc định cho các trạng thái khác (nếu có) --%>
                                                <c:otherwise>
        <span style="background: #eef2ff; color: #4f46e5; padding: 6px 12px; border-radius: 6px; font-size: 12px; font-weight: 700; text-transform: uppercase;">
                ${tutor.status}
        </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <a href="${pageContext.request.contextPath}/tutor/tutor-detail?id=${tutor.tutorId}" style="text-align: center; background: #0f172a; color: #fff; padding: 12px 0; border-radius: 8px; text-decoration: none; font-size: 14px; font-weight: 600; transition: background 0.3s;">
                                            Xem hồ sơ
                                        </a>

                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="text-align: center; padding: 60px 20px; border: 2px dashed #e2e8f0; border-radius: 16px;">
                            <p style="color: #64748b; font-size: 16px; margin-bottom: 16px;">Bạn chưa thuê gia sư nào.</p>
                            <a href="${pageContext.request.contextPath}/tutors" style="display: inline-block; background: #10b981; color: #fff; padding: 10px 24px; border-radius: 8px; text-decoration: none; font-weight: 600;">
                                Khám phá gia sư ngay →
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>
    </div>
</main>

<jsp:include page="/views/common/footer.jsp" />