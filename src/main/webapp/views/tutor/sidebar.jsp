<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<c:set var="u" value="${sessionScope.clientUser}"/>

<aside class="profile-sidebar-card"
       style="background: #fff; padding: 24px; border-radius: 16px; box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.05); width: 300px; flex-shrink: 0;">

  <%-- SỬA: Đổi action hướng sang Servlet dùng chung /profile/upload-avatar --%>
  <form method="POST" action="${pageContext.request.contextPath}/profile/upload-avatar" enctype="multipart/form-data" style="text-align: center;">

    <%-- SỬA: Thêm input ẩn để nhận diện trang hiện tại, tự động quay lại đúng vị trí --%>
    <input type="hidden" name="redirect" id="avatarRedirectUrl" value="/tutor/dashboard">

    <div class="profile-avatar-container"
         style="position: relative; width: 120px; height: 120px; margin: 0 auto 16px; border-radius: 50%; border: 3px solid #10b981; padding: 2px;">
      <c:choose>
        <c:when test="${not empty u.avatarUrl}">
          <img src="${u.avatarUrl}" alt="${u.fullname}" id="avatarPreview" class="profile-avatar-img"
               style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">
        </c:when>
        <c:otherwise>
          <img src="${pageContext.request.contextPath}/assets/images/default-avatar.png" alt="Default" id="avatarPreview" class="profile-avatar-img"
               style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">
        </c:otherwise>
      </c:choose>
      <label for="avatarFile" style="position: absolute; bottom: 0; right: 0; background: #0f172a; color: #fff; width: 32px; height: 32px; border-radius: 50%; display: flex; align-items: center; justify-content: center; cursor: pointer; border: 2px solid #fff; transition: 0.2s;">
        <i class="bi bi-camera-fill" style="font-size: 14px;"></i>
      </label>

      <%-- SỬA: Đổi thuộc tính name="avatar" thành name="avatarFile" để Servlet nhận được đúng Part --%>
      <input type="file" id="avatarFile" name="avatarFile" accept="image/*" style="display: none;" onchange="previewAndSubmitAvatar(this)">
    </div>

    <h3 style="font-size: 18px; font-weight: 700; color: #0f172a; margin: 0 0 4px 0;">${u.fullname}</h3>
    <p style="font-size: 13px; color: #64748b; margin: 0 0 16px 0;">Mã tài khoản: #TUTOR-${u.id}</p>

    <%-- Box thông tin thu nhập tích hợp --%>
    <div style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 12px; padding: 12px; margin-bottom: 24px; text-align: left;">
      <div style="font-size: 12px; color: #64748b; margin-bottom: 4px;"><i class="bi bi-wallet2"></i> Số dư khả dụng:</div>
      <div style="font-size: 18px; font-weight: 800; color: #10b981;">
        <span class="price-format">${not empty u.balance ? u.balance : 0}</span>đ
      </div>
    </div>
  </form>

  <%-- Menu điều hướng cho Gia sư --%>
  <div class="profile-nav-group" style="display: flex; flex-direction: column; gap: 8px;">
    <a href="${pageContext.request.contextPath}/tutor/dashboard" class="profile-nav-btn" style="display: flex; align-items: center; gap: 12px; padding: 12px 16px; border-radius: 8px; color: #475569; text-decoration: none; font-weight: 600; font-size: 14px; transition: all 0.2s;">
      <i class="bi bi-speedometer2" style="font-size: 18px;"></i> Bảng điều khiển
    </a>
    <a href="${pageContext.request.contextPath}/tutor/settings?tab=profile" class="profile-nav-btn" style="display: flex; align-items: center; gap: 12px; padding: 12px 16px; border-radius: 8px; color: #475569; text-decoration: none; font-weight: 600; font-size: 14px; transition: all 0.2s;">
      <i class="bi bi-person-vcard" style="font-size: 18px;"></i> Hồ sơ gia sư
    </a>
    <a href="${pageContext.request.contextPath}/tutor/my-lessons" class="profile-nav-btn" style="display: flex; align-items: center; gap: 12px; padding: 12px 16px; border-radius: 8px; color: #475569; text-decoration: none; font-weight: 600; font-size: 14px; transition: all 0.2s;">
      <i class="bi bi-journal-check" style="font-size: 18px;"></i> Lớp học đang dạy
    </a>
    <a href="${pageContext.request.contextPath}/chat" class="profile-nav-btn" style="display: flex; align-items: center; gap: 12px; padding: 12px 16px; border-radius: 8px; color: #475569; text-decoration: none; font-weight: 600; font-size: 14px; transition: all 0.2s;">
      <i class="bi bi-chat-dots" style="font-size: 18px;"></i> Tin nhắn
    </a>
    <a href="${pageContext.request.contextPath}/tutor/wallet" class="profile-nav-btn" style="display: flex; align-items: center; gap: 12px; padding: 12px 16px; border-radius: 8px; color: #475569; text-decoration: none; font-weight: 600; font-size: 14px; transition: all 0.2s;">
      <i class="bi bi-credit-card-2-front" style="font-size: 18px;"></i> Quản lý ví & Rút tiền
    </a>
    <a href="${pageContext.request.contextPath}/tutor/settings?tab=schedule" class="profile-nav-btn" style="display: flex; align-items: center; gap: 12px; padding: 12px 16px; border-radius: 8px; color: #475569; text-decoration: none; font-weight: 600; font-size: 14px; transition: all 0.2s;">
      <i class="bi bi-cash-coin" style="font-size: 18px;"></i> Cập nhật học phí
    </a>
    <a href="${pageContext.request.contextPath}/tutor/change-password" class="profile-nav-btn" style="display: flex; align-items: center; gap: 12px; padding: 12px 16px; border-radius: 8px; color: #475569; text-decoration: none; font-weight: 600; font-size: 14px; transition: all 0.2s;">
      <i class="bi bi-lock-fill" style="font-size: 18px;"></i> Đổi mật khẩu
    </a>
  </div>
</aside>

<script>
  // Tự động định dạng tiền tệ vi-VN
  document.querySelectorAll('.price-format').forEach(function (el) {
    var val = parseFloat(el.textContent);
    if (!isNaN(val)) {
      el.textContent = val.toLocaleString('vi-VN');
    }
  });

  // Active nhanh menu dựa trên URL hiện tại và xử lý lưu vị trí chuyển hướng
  document.addEventListener("DOMContentLoaded", function () {
    const currentPath = window.location.pathname;
    const currentSearch = window.location.search; // Lấy cả phần query (?tab=profile...) nếu có
    const contextPath = "${pageContext.request.contextPath}";

    // SỬA: Tính toán chính xác vị trí đang đứng của Gia sư kèm tham số URL để trả về đúng Tab
    let relativePath = currentPath + currentSearch;
    if (contextPath && currentPath.startsWith(contextPath)) {
      relativePath = currentPath.substring(contextPath.length) + currentSearch;
    }

    const redirectInput = document.getElementById('avatarRedirectUrl');
    if (redirectInput) {
      redirectInput.value = relativePath;
    }

    // Xử lý active trạng thái màu menu
    document.querySelectorAll('.profile-nav-btn').forEach(link => {
      if(link.href) {
        const linkUrl = new URL(link.href);
        // Kiểm tra khớp cả Pathname lẫn tham số Tab nếu có để active chuẩn xác
        if (linkUrl.pathname === currentPath && (!linkUrl.search || currentSearch.includes(linkUrl.search.split('=')[1]))) {
          link.style.background = '#eafaf1';
          link.style.color = '#10b981';
        }
      }
    });
  });

  // Submit tự động khi chọn ảnh mới
  function previewAndSubmitAvatar(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
        document.getElementById('avatarPreview').src = e.target.result;
      }
      reader.readAsDataURL(input.files[0]);

      // Thực hiện submit form tự động ngay lập tức lên UploadAvatarServlet
      setTimeout(() => { input.form.submit(); }, 400);
    }
  }
</script>
