<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<%-- 1. Header & Navbar --%>
<jsp:include page="/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Hồ sơ cá nhân - Gia Sư Bá Đạo"/>
    <jsp:param name="pageCss" value="/assets/css/user-profile.css" />
</jsp:include>

<jsp:include page="/views/common/navbar.jsp" />

<%-- 2. Lấy thông tin User --%>
<c:set var="u" value="${sessionScope.clientUser}"/>

<main class="page-main" style="background-color: #f8fafc; padding: 40px 0; font-family: 'Plus Jakarta Sans', sans-serif;">
    <div class="container" style="max-width: 1240px; margin: 0 auto; padding: 0 20px;">

        <%-- Breadcrumb --%>
        <div class="breadcrumb" style="margin-bottom: 32px; font-size: 14px; color: #64748b;">
            <a href="${pageContext.request.contextPath}/home" style="color: #64748b; text-decoration: none;">Trang chủ</a>
            <span style="margin: 0 8px; color: #cbd5e1;">/</span>
            <span style="color: #0f172a; font-weight: 500;">Hồ sơ cá nhân</span>
        </div>

        <%-- Layout Grid --%>
        <div class="profile-detail-grid" style="display: flex; gap: 24px; align-items: flex-start;">

            <%-- GỌI SIDEBAR ĐÃ TÁCH RỜI --%>
            <jsp:include page="/views/parent/sidebar.jsp" />

            <%-- PHẦN NỘI DUNG CHÍNH (Profile Form) --%>
            <section class="profile-content-card" style="flex: 1; background: #fff; padding: 40px; border-radius: 16px; border: 1px solid #f1f5f9; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);">

                <div class="panel-main-header" style="margin-bottom: 32px; border-bottom: 1px solid #f1f5f9; padding-bottom: 24px;">
                    <h3 style="font-size: 24px; font-weight: 800; color: #0f172a; margin: 0 0 8px 0;">Thông tin cá nhân</h3>
                    <p style="font-size: 14px; color: #64748b; margin: 0;">Cập nhật thông tin tài khoản để giúp ghi nhớ thông tin đăng nhập và kết nối tiện lợi hơn.</p>
                </div>

                <%-- Hiển thị thông báo (nếu có) --%>
                <c:if test="${not empty sessionScope.msgSuccess}">
                    <div style="padding: 12px 16px; background-color: #f0fdf4; color: #16a34a; border-radius: 8px; margin-bottom: 20px; font-size: 14px; font-weight: 600;">
                            ${sessionScope.msgSuccess}
                    </div>
                    <c:remove var="msgSuccess" scope="session"/>
                </c:if>
                <c:if test="${not empty sessionScope.msgError}">
                    <div style="padding: 12px 16px; background-color: #fef2f2; color: #dc2626; border-radius: 8px; margin-bottom: 20px; font-size: 14px; font-weight: 600;">
                            ${sessionScope.msgError}
                    </div>
                    <c:remove var="msgError" scope="session"/>
                </c:if>

                <%-- Form cập nhật thông tin --%>
                <form method="POST" action="${pageContext.request.contextPath}/parent/profile">
                    <input type="hidden" name="actionType" value="updateTextInfo">

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px;">
                        <div class="form-group">
                            <label style="display: block; font-size: 14px; font-weight: 600; color: #334155; margin-bottom: 8px;">Họ và tên</label>
                            <input type="text" name="fullname" value="${u.fullname}" required style="width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 15px;">
                        </div>
                        <div class="form-group">
                            <label style="display: block; font-size: 14px; font-weight: 600; color: #334155; margin-bottom: 8px;">Số điện thoại</label>
                            <input type="tel" name="phone" value="${u.phone}" pattern="[0-9]{10,11}" title="Số điện thoại phải từ 10-11 chữ số" style="width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 15px;">
                        </div>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 24px;">
                        <div class="form-group">
                            <label style="display: block; font-size: 14px; font-weight: 600; color: #334155; margin-bottom: 8px;">Tên đăng nhập (Username)</label>
                            <input type="text" name="username" value="${u.username}" required style="width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 15px;">
                        </div>
                        <div class="form-group">
                            <label style="display: block; font-size: 14px; font-weight: 600; color: #334155; margin-bottom: 8px;">Địa chỉ Email</label>
                            <input type="email" name="email" value="${u.email}" required style="width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 15px;">
                        </div>
                    </div>

                    <div style="text-align: left;">
                        <button type="submit" style="background: #0f172a; color: #fff; border: none; padding: 12px 24px; border-radius: 8px; font-size: 15px; font-weight: 600; cursor: pointer;">Lưu thay đổi</button>
                    </div>
                </form>
            </section>
        </div>
    </div>
</main>

<jsp:include page="/views/common/footer.jsp" />