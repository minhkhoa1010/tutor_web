<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<header class="site-header">
    <div class="container navbar">
        <a class="brand" href="${pageContext.request.contextPath}/home">
            <span class="brand-badge"><i class="bi bi-mortarboard-fill"></i></span>
            <span>Gia Sư Bá Đạo</span>
        </a>

        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/home"><i class="bi bi-house-door"></i> Trang chủ</a>
            <a href="${pageContext.request.contextPath}/tutors"><i class="bi bi-search"></i> Tìm gia sư</a>
            <a href="${pageContext.request.contextPath}/policy"><i class="bi bi-journal-text"></i> Hướng dẫn</a>
            <a href="${pageContext.request.contextPath}/lien-he"><i class="bi bi-envelope"></i> Liên hệ</a>

        </nav>

        <c:choose>
            <c:when test="${empty sessionScope.clientUser}">
                <div class="nav-cta">
                    <a class="btn btn-outline" href="${pageContext.request.contextPath}/login"><i class="bi bi-box-arrow-in-right"></i> Đăng nhập</a>
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/register-page">Đăng ký</a>
                </div>
            </c:when>

            <c:otherwise>
                <c:set var="userAvatar" value="${pageContext.request.contextPath}/assets/images/default-avatar.png" />
                <c:if test="${not empty sessionScope.clientUser.avatarUrl}">
                    <c:set var="userAvatar" value="${sessionScope.clientUser.avatarUrl}" />
                </c:if>

                <div class="nav-user-dropdown">
                    <div class="user-trigger">
                        <img class="user-avatar" src="${userAvatar}" alt="Avatar">
                        <span class="user-name">${sessionScope.clientUser.fullname}</span>
                        <span class="user-caret"><i class="bi bi-chevron-down"></i></span>
                    </div>

                    <ul class="dropdown-menu">
                            <%-- PHÂN QUYỀN GIA SƯ (Đã tối ưu & đồng bộ) --%>
                        <c:if test="${sessionScope.clientUser.hasRole('TUTOR')}">
                            <li class="menu-role-tag tutor-tag" style="background: #10b981; color: #fff;"><i class="bi bi-person-badge"></i> GIA SƯ ĐANG DẠY</li>
                            <li class="wallet-nav-item">
                                <div class="wallet-nav-box">
                                    <span><i class="bi bi-wallet2"></i> Ví thu nhập:</span>
                                    <strong class="text-success"><fmt:formatNumber value="${not empty sessionScope.clientUser.balance ? sessionScope.clientUser.balance : 0}" type="number"/> đ</strong>
                                </div>
                                    <%-- Rút tiền dẫn thẳng về trang quản lý ví ổn định --%>
                                <a class="nav-deposit-btn" href="${pageContext.request.contextPath}/tutor/wallet" style="background: #0f172a;"><i class="bi bi-cash-stack"></i> Rút tiền</a>
                            </li>
                            <li><a href="${pageContext.request.contextPath}/tutor/dashboard"><i class="bi bi-speedometer2"></i> Bảng điều khiển</a></li>
                            <li><a href="${pageContext.request.contextPath}/chat" class="chat-nav-link"><i class="bi bi-chat-dots"></i> Tin nhắn <span class="chat-unread-badge" style="display:none;">0</span></a></li>
                            <li><a href="${pageContext.request.contextPath}/tutor/settings?tab=profile"><i class="bi bi-person-vcard"></i> Hồ sơ năng lực</a></li>
                            <li><a href="${pageContext.request.contextPath}/tutor/my-lessons"><i class="bi bi-journal-check"></i> Lớp học nhận dạy</a></li>
                            <li><a href="${pageContext.request.contextPath}/tutor/wallet"><i class="bi bi-credit-card-2-front"></i> Lịch sử thu nhập</a></li>
                            <li><a href="${pageContext.request.contextPath}/tutor/settings?tab=schedule"><i class="bi bi-cash-coin"></i> Thiết lập học phí</a></li>
                            <li><a href="${pageContext.request.contextPath}/tutor/change-password"><i class="bi bi-key"></i> Đổi mật khẩu</a></li>
                        </c:if>

                            <%-- PHÂN QUYỀN PHỤ HUYNH / HỌC VIÊN --%>
                        <c:if test="${sessionScope.clientUser.hasRole('USER')}">
                            <li class="menu-role-tag tutor-tag" style="background: #10b981; color: #fff;"><i class="bi bi-person-badge"></i> PHỤ HUYNH / HỌC VIÊN</li>
                            <li class="wallet-nav-item">
                                <div class="wallet-nav-box">
                                    <span><i class="bi bi-wallet2"></i> Ví thu nhập:</span>
                                    <strong class="text-success"><fmt:formatNumber value="${not empty sessionScope.clientUser.balance ? sessionScope.clientUser.balance : 0}" type="number"/> đ</strong>
                                </div>
                                    <%-- Nạp ví dẫn thẳng về trang quản lý ví ổn định --%>
                                <a class="nav-deposit-btn" href="${pageContext.request.contextPath}/parent/profile" style="background: #0f172a;"><i class="bi bi-cash-stack"></i> Nạp ví</a>
                            </li>

                            <li><a href="${pageContext.request.contextPath}/parent/profile"><i class="bi bi-speedometer2"></i> Bảng điều khiển</a></li>
                            <li><a href="${pageContext.request.contextPath}/chat" class="chat-nav-link"><i class="bi bi-chat-dots"></i> Tin nhắn <span class="chat-unread-badge" style="display:none;">0</span></a></li>
                            <li>
                                <a href="${pageContext.request.contextPath}/parent/cart" class="nav-cart-link">
                                    <span><i class="bi bi-cart3"></i> Giỏ hàng gia sư</span>
                                    <span class="nav-cart-badge">${not empty sessionScope.cartCount ? sessionScope.cartCount : 0}</span>
                                </a>
                            </li>
                            <li><a href="${pageContext.request.contextPath}/parent/wishlist"><i class="bi bi-heart"></i> Gia sư yêu thích</a></li>
                        </c:if>

                            <%-- PHÂN QUYỀN ADMIN --%>
                        <c:if test="${sessionScope.clientUser.hasRole('ADMIN')}">
                            <li class="menu-role-tag admin-tag" style="background: #ef4444; color: #fff;"><i class="bi bi-shield-lock"></i> QUẢN TRỊ VIÊN</li>
                            <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2"></i> Trang quản trị</a></li>
                        </c:if>

                        <li class="dropdown-divider"></li>
                        <li><a class="btn-logout" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a></li>
                    </ul>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</header>

<c:if test="${not empty sessionScope.clientUser}">
    <style>
        .chat-nav-link {
            position: relative;
            display: flex !important;
            align-items: center;
            gap: 6px;
        }

        .chat-unread-badge {
            min-width: 20px;
            height: 20px;
            padding: 0 6px;
            border-radius: 999px;
            background: #dc2626;
            color: #fff;
            font-size: 11px;
            line-height: 20px;
            text-align: center;
            font-weight: 800;
            box-shadow: 0 0 0 2px #fff;
        }

        .chat-unread-badge.pulse {
            animation: chatBadgePulse 0.8s ease-out;
        }

        @keyframes chatBadgePulse {
            0% { transform: scale(1); }
            35% { transform: scale(1.25); }
            100% { transform: scale(1); }
        }
    </style>

    <script>
        window.refreshChatUnreadBadge = async function () {
            try {
                const response = await fetch('${pageContext.request.contextPath}/api/chat/unread-count', {
                    headers: {'Accept': 'application/json'}
                });
                if (!response.ok) return;

                const result = await response.json();
                if (!result.success) return;

                const count = Number(result.count || 0);
                document.querySelectorAll('.chat-unread-badge').forEach(function (badge) {
                    const oldValue = Number(badge.dataset.count || 0);
                    badge.dataset.count = String(count);
                    badge.textContent = count > 99 ? '99+' : String(count);
                    badge.style.display = count > 0 ? 'inline-block' : 'none';

                    if (count > oldValue) {
                        badge.classList.remove('pulse');
                        void badge.offsetWidth;
                        badge.classList.add('pulse');
                    }
                });
            } catch (ignored) {
            }
        };

        document.addEventListener('DOMContentLoaded', function () {
            window.refreshChatUnreadBadge();
            window.setInterval(window.refreshChatUnreadBadge, 15000);
        });
    </script>
</c:if>
