<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<jsp:include page="/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Đổi mật khẩu Gia Sư - Gia Sư Bá Đạo"/>
    <jsp:param name="pageCss" value="/assets/css/user-profile.css" />
</jsp:include>

<jsp:include page="/views/common/navbar.jsp" />

<main class="page-main" style="background-color: #f8fafc; padding: 40px 0; font-family: 'Plus Jakarta Sans', sans-serif;">
    <div class="container" style="max-width: 1240px; margin: 0 auto; padding: 0 20px;">

        <div class="breadcrumb" style="margin-bottom: 32px; font-size: 14px; color: #64748b;">
            <a href="${pageContext.request.contextPath}/home" style="color: #64748b; text-decoration: none;">Trang chủ</a>
            <span style="margin: 0 8px; color: #cbd5e1;">/</span>
            <span style="color: #0f172a; font-weight: 500;">Đổi mật khẩu gia sư</span>
        </div>

        <div class="profile-detail-grid" style="display: flex; gap: 24px; align-items: flex-start;">

            <%-- THAY ĐỔI: Gọi đúng Sidebar của phân hệ Gia Sư --%>
            <jsp:include page="/views/tutor/sidebar.jsp" />

            <section class="profile-content-card" style="flex: 1; background: #fff; padding: 40px; border-radius: 16px; border: 1px solid #f1f5f9; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);">
                <div class="panel-main-header" style="margin-bottom: 32px; border-bottom: 1px solid #f1f5f9; padding-bottom: 24px;">
                    <h3 style="font-size: 24px; font-weight: 800; color: #0f172a; margin: 0 0 8px 0;">Đổi mật khẩu</h3>
                    <p style="font-size: 14px; color: #64748b; margin: 0;">Đảm bảo tài khoản gia sư của bạn được an toàn bằng cách sử dụng mật khẩu mạnh.</p>
                </div>

                <%-- Hiển thị thông báo --%>
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

                <%-- THAY ĐỔI: Action dẫn tới đúng endpoint /tutor/change-password --%>
                <form method="POST" action="${pageContext.request.contextPath}/tutor/change-password" id="passwordForm">
                    <div class="form-group" style="margin-bottom: 20px;">
                        <label style="display: block; font-size: 14px; font-weight: 600; color: #334155; margin-bottom: 8px;">Mật khẩu hiện tại</label>
                        <input type="password" name="oldPassword" required style="width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 15px;">
                    </div>

                    <div class="form-group" style="margin-bottom: 20px;">
                        <label style="display: block; font-size: 14px; font-weight: 600; color: #334155; margin-bottom: 8px;">Mật khẩu mới</label>
                        <input type="password" name="newPassword" id="newPassword" required style="width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 15px;">
                    </div>

                    <div class="form-group" style="margin-bottom: 32px;">
                        <label style="display: block; font-size: 14px; font-weight: 600; color: #334155; margin-bottom: 8px;">Xác nhận mật khẩu mới</label>
                        <input type="password" name="confirmPassword" id="confirmPassword" required style="width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 15px;">
                        <span id="passError" style="color: #dc2626; font-size: 13px; margin-top: 8px; display: none;">Mật khẩu xác nhận không khớp!</span>
                    </div>

                    <div style="text-align: left;">
                        <button type="submit" style="background: #10b981; color: #fff; border: none; padding: 12px 24px; border-radius: 8px; font-size: 15px; font-weight: 600; cursor: pointer;">Cập nhật mật khẩu</button>
                    </div>
                </form>
            </section>
        </div>
    </div>
</main>

<jsp:include page="/views/common/footer.jsp" />

<script>
    const passwordForm = document.getElementById('passwordForm');
    const newPassword = document.getElementById('newPassword');
    const confirmPassword = document.getElementById('confirmPassword');
    const passError = document.getElementById('passError');

    passwordForm.addEventListener('submit', function(e) {
        if (newPassword.value !== confirmPassword.value) {
            e.preventDefault();
            passError.style.display = 'block';
            confirmPassword.style.borderColor = '#dc2626';
        } else {
            passError.style.display = 'none';
        }
    });
</script>