<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<c:set var="pageTitle" value="Đăng nhập hệ thống - Gia Sư Bá Đạo" scope="request"/>

<jsp:include page="/views/common/header.jsp"/>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css">

<jsp:include page="/views/common/navbar.jsp" />

<main class="login-shell">

  <div class="login-card">
    <h1 class="login-brand">Gia Sư Bá Đạo</h1>
    <p class="login-sub">Chào mừng bạn trở lại với học viện</p>
    <c:if test="${not empty sessionScope.successMessage}">
      <div style="
            background:#ecfdf5;
            color:#059669;
            padding:12px;
            border-radius:8px;
            margin-bottom:16px;
    ">
          ${sessionScope.successMessage}
      </div>

      <c:remove var="successMessage" scope="session"/>
    </c:if>
    <%-- Hiển thị lỗi nếu sai mật khẩu hoặc tài khoản bị khóa --%>
    <c:if test="${not empty authError}">
      <div style="background: #fee2e2; color: #ef4444; padding: 10px; border-radius: 10px; font-size: 13px; text-align: left; margin-bottom: 10px;">
        ⚠️ ${authError}
      </div>
    </c:if>
    <c:if test="${param.error == 'oauth_failed'}">
      <div style="background: #fee2e2; color: #ef4444; padding: 10px; border-radius: 10px; font-size: 13px; text-align: left; margin-bottom: 10px;">
        ⚠️ Lỗi xác thực từ nhà cung cấp bên thứ ba.
      </div>
    </c:if>

    <form class="login-form" method="post" action="${pageContext.request.contextPath}/auth">
      <input type="hidden" name="action" value="login">

      <div class="form-group">
        <label class="label">Email hoặc Tên đăng nhập</label>
        <div class="input-wrap">
          <span class="input-icon">👤</span>
          <input class="input-field" type="text" name="identifier" placeholder="Username hoặc email..." required>
        </div>
      </div>

      <div class="form-group">
        <label class="label">Mật khẩu</label>
        <div class="input-wrap">
          <span class="input-icon">🔒</span>
          <input class="input-field" type="password" name="password" placeholder="••••••••" required>
        </div>
      </div>

      <div class="login-meta">
        <label class="remember">
          <input type="checkbox" name="remember">
          <span>Ghi nhớ đăng nhập</span>
        </label>
        <div style="text-align:right;margin-top:10px;">
          <a href="${pageContext.request.contextPath}/forgot-password"
             style="
           color:#0d9488;
           text-decoration:none;
           font-size:14px;
           font-weight:500;
       ">
            Quên mật khẩu?
          </a>
        </div>
      </div>

      <button class="btn-login" type="submit">Đăng nhập</button>
    </form>

    <div class="divider"><span>HOẶC TIẾP TỤC VỚI</span></div>

    <div class="social-row">
      <a class="social-btn google" href="${pageContext.request.contextPath}/social-login?provider=google">
        Google
      </a>
      <a class="social-btn facebook" href="${pageContext.request.contextPath}/social-login?provider=facebook">
        Facebook
      </a>
    </div>

    <div class="login-footer">
      Bạn chưa có tài khoản? <a href="${pageContext.request.contextPath}/views/auth/register.jsp">Tạo tài khoản ngay</a>
    </div>
  </div>
</main>

<jsp:include page="/views/common/footer.jsp" />