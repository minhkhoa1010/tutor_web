<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<c:set var="u" value="${sessionScope.clientUser}"/>

<aside class="profile-sidebar-card"
       style="background: #fff; padding: 24px; border-radius: 16px; box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.05); width: 300px;">
    <form method="POST" action="${pageContext.request.contextPath}/parent/profile" enctype="multipart/form-data"
          style="text-align: center;">
        <input type="hidden" name="actionType" value="updateAvatar">
        <div class="profile-avatar-container"
             style="position: relative; width: 120px; height: 120px; margin: 0 auto 16px; border-radius: 50%; border: 3px solid #10b981; padding: 2px;">
            <c:choose>
                <c:when test="${not empty u.avatarUrl}">
                    <img src="${u.avatarUrl}" alt="${u.fullname}" id="avatarPreview" class="profile-avatar-img"
                         style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">
                </c:when>
                <c:otherwise>
                    <img src="${pageContext.request.contextPath}/assets/images/default-avatar.png" id="avatarPreview"
                         alt="Avatar Mặc Định" class="profile-avatar-img"
                         style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">
                </c:otherwise>
            </c:choose>
            <label for="avatarFile"
                   style="position: absolute; bottom: 0px; right: 0px; background: #0f172a; color: #fff; width: 34px; height: 34px; border-radius: 50%; display: flex; align-items: center; justify-content: center; cursor: pointer; border: 3px solid #fff; box-shadow: 0 2px 4px rgba(0,0,0,0.3); z-index: 10;">
                <svg style="width: 18px; height: 18px;" fill="none" stroke="currentColor" stroke-width="2"
                     viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round"
                          d="M6.827 6.175A2.31 2.31 0 015.186 7.23c-.38.054-.757.112-1.134.175C2.999 7.58 2.25 8.507 2.25 9.574V18a2.25 2.25 0 002.25 2.25h15A2.25 2.25 0 0021.75 18V9.574c0-1.067-.75-1.994-1.802-2.169a47.865 47.865 0 00-1.134-.175 2.31 2.31 0 01-1.64-1.055l-.822-1.316a2.192 2.192 0 00-1.736-1.039 48.774 48.774 0 00-5.232 0 2.192 2.192 0 00-1.736 1.039l-.821 1.316z"></path>
                    <path stroke-linecap="round" stroke-linejoin="round"
                          d="M16.5 12.75a4.5 4.5 0 11-9 0 4.5 4.5 0 019 0zM18.75 10.5h.008v.008h-.008V10.5z"></path>
                </svg>
            </label>
            <input type="file" id="avatarFile" name="avatarFile" accept="image/*" class="hidden-file-input"
                   onchange="previewAndSubmitAvatar(this)" style="display:none;">
        </div>
        <div id="uploadSubmitArea" style="display: none; margin-bottom: 16px;">
            <button type="submit"
                    style="background-color: #10b981; color: white; border: none; padding: 4px 12px; font-size: 12px; border-radius: 6px; cursor: pointer; font-weight: 600;">
                Xác nhận đổi ảnh
            </button>
        </div>
    </form>

    <h2 style="font-size: 18px; font-weight: 700; color: #0f172a; margin: 0 0 4px 0; text-align: center;">${not empty u.fullname ? u.fullname : u.username}</h2>
    <p style="font-size: 14px; color: #64748b; margin: 0 0 24px 0; text-align: center;">${u.email}</p>

    <div style="background: #f1f5f9; padding: 20px; border-radius: 16px; margin-bottom: 24px; box-shadow: inset 0 1px 2px rgba(0,0,0,0.02);">
        <div style="font-size: 12px; text-transform: uppercase; letter-spacing: 0.05em; color: #64748b; font-weight: 700; margin-bottom: 6px;">
            Số dư hiện tại
        </div>

        <div style="font-size: 28px; font-weight: 800; color: #0f172a; margin-bottom: 16px; display: flex; align-items: baseline; gap: 2px;">
            <span class="price-format" style="line-height: 1;">${not empty u.balance ? u.balance : 0}</span>
            <span style="font-size: 16px; font-weight: 600; color: #475569;">đ</span>
        </div>

        <form action="${pageContext.request.contextPath}/parent/momo-payment" method="POST" style="margin-top: 4px;">
            <div style="margin-bottom: 12px;">
                <label for="amount"
                       style="display: block; font-size: 12px; font-weight: 600; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 8px;">
                    Nhập số tiền cần nạp (VND)
                </label>

                <input type="number" name="amount" id="amount"
                       placeholder="Nhập số tiền..."
                       min="10000" required
                       style="width: 100%; height: 44px; border: 1.5px solid #e2e8f0; border-radius: 10px; padding: 0 14px; font-size: 16px; font-weight: 700; color: #0f172a; background: #f8fafc; box-sizing: border-box; outline: none; transition: all 0.2s ease;"
                       onfocus="this.style.borderColor='#a50064'; this.style.background='#fff'; this.style.boxShadow='0 0 0 3px rgba(165,0,100,0.08)'"
                       onblur="this.style.borderColor='#e2e8f0'; this.style.background='#f8fafc'; this.style.boxShadow='none'">

                <div style="font-size: 11px; color: #94a3b8; margin-top: 5px; display: flex; align-items: center; gap: 4px;">
                    <i class="bi bi-info-circle-fill" style="font-size: 10px;"></i> Tối thiểu 10.000 đ
                </div>
            </div>
            <button type="submit"
                    style="width: 100%; height: 44px; display: flex; align-items: center; justify-content: center; gap: 8px; background: linear-gradient(135deg, #a50064 0%, #d4006e 100%); color: #fff; border: none; border-radius: 10px; font-size: 14px; font-weight: 700; cursor: pointer; transition: all 0.2s ease; box-shadow: 0 2px 8px rgba(165,0,100,0.25);"
                    onmouseover="this.style.transform='translateY(-1px)'; this.style.boxShadow='0 4px 16px rgba(165,0,100,0.35)'"
                    onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 2px 8px rgba(165,0,100,0.25)'">
                <svg width="22" height="22" viewBox="0 0 22 22" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <circle cx="11" cy="11" r="11" fill="white"/>
                    <text x="11" y="15" text-anchor="middle" font-size="9" font-weight="800" fill="#a50064"
                          font-family="Arial">MoMo
                    </text>
                </svg>
                Nạp tiền qua MoMo
            </button>
        </form>
    </div>

    <div class="profile-tab-navigation">
        <a href="${pageContext.request.contextPath}/parent/profile" class="profile-nav-btn">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                <circle cx="12" cy="7" r="4"/>
            </svg>
            Hồ sơ cá nhân
        </a>
        <a href="${pageContext.request.contextPath}/parent/hired" class="profile-nav-btn">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polygon points="12 2 2 7 12 12 22 7 12 2"/>
                <polyline points="2 17 12 22 22 17"/>
                <polyline points="2 12 12 17 22 12"/>
            </svg>
            Gia sư đang thuê
        </a>
        <a href="${pageContext.request.contextPath}/chat" class="profile-nav-btn">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M21 15a4 4 0 0 1-4 4H8l-5 3V7a4 4 0 0 1 4-4h10a4 4 0 0 1 4 4z"/>
            </svg>
            Tin nhắn
        </a>
        <a href="${pageContext.request.contextPath}/parent/history" class="profile-nav-btn">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="12" cy="12" r="10"/>
                <polyline points="12 6 12 12 16 14"/>
            </svg>
            Lịch sử thanh toán
        </a>
        <%--        <a href="${pageContext.request.contextPath}/parent/notifications" class="profile-nav-btn">--%>
        <%--            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>--%>
        <%--            Thông báo--%>
        <%--        </a>--%>
        <a href="${pageContext.request.contextPath}/parent/my-schedule"
           class="profile-nav-btn">

            <svg width="20"
                 height="20"
                 viewBox="0 0 24 24"
                 fill="none"
                 stroke="currentColor"
                 stroke-width="2">

                <rect x="3"
                      y="4"
                      width="18"
                      height="18"
                      rx="2"/>

                <line x1="16"
                      y1="2"
                      x2="16"
                      y2="6"/>

                <line x1="8"
                      y1="2"
                      x2="8"
                      y2="6"/>

                <line x1="3"
                      y1="10"
                      x2="21"
                      y2="10"/>

            </svg>

            Lịch học của tôi
        </a>
        <a href="${pageContext.request.contextPath}/parent/change-password" class="profile-nav-btn">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
            </svg>
            Đổi mật khẩu
        </a>
    </div>
</aside>

<script>
    // Định dạng giá tiền cho sidebar
    document.querySelectorAll('.price-format').forEach(function (el) {
        var val = parseFloat(el.textContent);
        if (!isNaN(val)) {
            el.textContent = val.toLocaleString('vi-VN');
        }
    });

    // Active menu dựa trên URL
    document.addEventListener("DOMContentLoaded", function () {
        const currentPath = window.location.pathname;
        document.querySelectorAll('.profile-nav-btn').forEach(link => {
            const linkPath = new URL(link.href).pathname;
            if (linkPath === currentPath) {
                link.classList.add('active');
            }
        });
    });

    // Hàm xử lý preview ảnh khi chọn file
    function previewAndSubmitAvatar(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();

            reader.onload = function (e) {
                // Thay đổi ảnh preview
                document.getElementById('avatarPreview').src = e.target.result;
            }

            reader.readAsDataURL(input.files[0]);

            // Hiện nút "Xác nhận đổi ảnh"
            document.getElementById('uploadSubmitArea').style.display = 'block';
        }
    }
</script>
