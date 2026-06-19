<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<jsp:include page="/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Giỏ hàng gia sư - Gia Sư Bá Đạo"/>
</jsp:include>
<jsp:include page="/views/common/navbar.jsp"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<%-- Tính tổng tiền server-side --%>
<c:set var="grandTotal" value="0"/>
<c:if test="${not empty cart && not empty cart.items}">
    <c:forEach var="item" items="${cart.items}">
        <c:set var="grandTotal" value="${grandTotal + item.hourlyRate}"/>
    </c:forEach>
</c:if>

<main class="page-main" style="background:#f1f5f9; padding:40px 0; font-family:'Plus Jakarta Sans',sans-serif;">
    <div class="container" style="max-width:1000px; margin:0 auto; padding:0 16px;">

        <h1 style="font-size:22px; font-weight:700; color:#0f172a; margin-bottom:24px; display:flex; align-items:center; gap:10px;">
            <i class="fa-solid fa-cart-shopping" style="color:#0d9488;"></i>
            Giỏ hàng gia sư
            <span style="background:#0d9488; color:#fff; border-radius:20px; padding:2px 12px; font-size:14px;">
                ${not empty cart ? cart.totalItems : 0}
            </span>
        </h1>

        <c:choose>
            <c:when test="${empty cart || empty cart.items}">
                <div style="background:#fff; border-radius:16px; padding:64px 20px; text-align:center;
                        border:1px solid #e2e8f0; box-shadow:0 1px 3px rgba(0,0,0,0.04);">
                    <i class="fa-solid fa-cart-shopping" style="font-size:48px; color:#cbd5e1; margin-bottom:16px; display:block;"></i>
                    <p style="font-size:18px; font-weight:700; color:#1e293b; margin:0 0 8px;">Giỏ hàng đang trống</p>
                    <p style="color:#94a3b8; font-size:14px; margin:0 0 24px;">Hãy tìm và thêm gia sư phù hợp vào giỏ hàng.</p>
                    <a href="${pageContext.request.contextPath}/tutors"
                       style="background:#0d9488; color:#fff; padding:12px 28px; border-radius:8px;
                          font-weight:600; text-decoration:none; font-size:14px;">
                        Tìm gia sư ngay
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <%-- DANH SÁCH GIA SƯ --%>
                <div style="display:flex; flex-direction:column; gap:12px; margin-bottom:20px;">
                    <c:forEach var="tutor" items="${cart.items}">
                        <div class="cart-card" data-tutor-id="${tutor.tutorId}"
                             style="background:#fff; border-radius:14px; border:1px solid #e2e8f0;
                                padding:20px 24px; display:flex; align-items:center; gap:20px;
                                box-shadow:0 1px 3px rgba(0,0,0,0.04); transition:all 0.2s;">

                                <%-- Avatar --%>
                            <div style="width:64px; height:64px; border-radius:50%; flex-shrink:0;
                                    background-image:url('${not empty tutor.avatarUrl ? tutor.avatarUrl : pageContext.request.contextPath.concat("/assets/images/default-avatar.png")}');
                                    background-size:cover; background-position:center;
                                    border:2px solid #ccfbf1;"></div>

                                        <%-- Thông tin gia sư --%>
                                    <div style="flex:1; min-width:0;">
                                        <div style="display:flex; align-items:center; gap:8px; margin-bottom:6px; flex-wrap:wrap;">
        <span style="font-size:16px; font-weight:700; color:#0f172a;">
            <c:out value="${tutor.fullName}"/>
        </span>
                                            <span style="font-size:11px; font-weight:700; color:#0f766e; background:#ccfbf1;
                 padding:2px 8px; border-radius:4px; text-transform:uppercase;">
            <c:out value="${tutor.qualification}"/>
        </span>
                                        </div>

                                            <%-- Môn học và Lớp --%>
                                        <div style="font-size:13px; color:#475569; margin-bottom:3px;">
                                            <i class="fa-solid fa-book" style="color:#0d9488; margin-right:5px;"></i>
                                            <c:out value="${tutor.teachingSubject}"/>
                                            <c:if test="${not empty tutor.teachingGrade}">
                                                &nbsp;·&nbsp; <c:out value="${tutor.teachingGrade}"/>
                                            </c:if>
                                        </div>

                                            <%-- HIỂN THỊ LỊCH ĐÃ CHỌN TỪ SESSION --%>
                                        <div style="font-size:12px; color:#b45309; background:#fef3c7; padding:4px 10px; border-radius:6px; display:inline-flex; align-items:center; gap:6px; margin-top:4px; margin-bottom:4px; font-weight: 600;">
                                            <i class="fa-regular fa-calendar-check"></i>
                                            Lịch học đã chọn: <c:out value="${not empty tutor.availableSchedules ? tutor.availableSchedules : 'Theo thỏa thuận'}"/>
                                        </div>

                                            <%-- Khu vực dạy --%>
                                        <div style="font-size:13px; color:#64748b;">
                                            <i class="fa-solid fa-location-dot" style="color:#94a3b8; margin-right:5px;"></i>
                                            <c:out value="${not empty tutor.teachingArea ? tutor.teachingArea : 'Toàn thành phố'}"/>
                                        </div>
                                    </div>

                                <%-- Giá --%>
                            <div style="text-align:right; flex-shrink:0; margin-right:8px;">
                                <div style="font-size:18px; font-weight:800; color:#0d9488;">
                                    <fmt:formatNumber value="${tutor.hourlyRate}" type="number"/>đ
                                </div>
                                <div style="font-size:12px; color:#94a3b8;">/ buổi</div>
                            </div>

                                <%-- Nút --%>
                            <div style="display:flex; flex-direction:column; gap:8px; flex-shrink:0;">
                                <a href="${pageContext.request.contextPath}/tutor/tutor-detail?id=${tutor.tutorId}"
                                   style="background:#f1f5f9; color:#334155; border:1px solid #cbd5e1;
                                      padding:8px 14px; border-radius:8px; font-size:13px; font-weight:600;
                                      text-decoration:none; text-align:center; white-space:nowrap;">
                                    Xem hồ sơ
                                </a>
                                <button class="btn-remove-cart" data-tutor-id="${tutor.tutorId}"
                                        style="background:#fff; color:#ef4444; border:1px solid #fecaca;
                                           padding:8px 14px; border-radius:8px; font-size:13px; font-weight:600;
                                           cursor:pointer; white-space:nowrap;">
                                    <i class="fa-solid fa-trash-can"></i> Xoá
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <%-- TỔNG KẾT + THANH TOÁN --%>
                <div style="background:#fff; border-radius:16px; border:1px solid #e2e8f0; padding:24px;
                        box-shadow:0 1px 3px rgba(0,0,0,0.04);">

                        <%-- Thông tin số dư --%>
                    <div style="display:flex; justify-content:space-between; align-items:center;
                            margin-bottom:16px; padding-bottom:16px; border-bottom:1px solid #f1f5f9;">
                        <span style="font-size:14px; color:#64748b;">Số dư ví hiện tại</span>
                        <c:choose>
                            <c:when test="${not empty sessionScope.clientUser}">
                                <strong style="font-size:16px; color:#0d9488;">
                                    <fmt:formatNumber value="${sessionScope.clientUser.balance}" type="number"/>đ
                                </strong>
                            </c:when>
                            <c:otherwise>
                                <strong style="color:#94a3b8;">Chưa đăng nhập</strong>
                            </c:otherwise>
                        </c:choose>
                    </div>

                        <%-- Tổng số gia sư --%>
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
                        <span style="font-size:14px; color:#64748b;">Số gia sư đã chọn</span>
                        <strong style="color:#0f172a;">${cart.totalItems} gia sư</strong>
                    </div>

                        <%-- Tổng tiền --%>
                    <div style="display:flex; justify-content:space-between; align-items:center;
                            margin-bottom:20px; padding-top:12px; border-top:2px dashed #e2e8f0;">
                        <span style="font-size:16px; font-weight:700; color:#0f172a;">Tổng học phí / buổi</span>
                        <span style="font-size:22px; font-weight:800; color:#0d9488;">
                        <fmt:formatNumber value="${grandTotal}" type="number"/>đ
                    </span>
                    </div>

                        <%-- Cảnh báo số dư nếu không đủ --%>
                    <c:if test="${not empty sessionScope.clientUser && sessionScope.clientUser.balance < grandTotal}">
                        <div style="background:#fff7ed; border:1px solid #fed7aa; border-radius:8px; padding:12px 16px;
                                margin-bottom:16px; font-size:13px; color:#9a3412; display:flex; align-items:center; gap:8px;">
                            <i class="fa-solid fa-triangle-exclamation"></i>
                            Số dư không đủ để thanh toán tất cả. Cần thêm
                            <strong><fmt:formatNumber value="${grandTotal - sessionScope.clientUser.balance}" type="number"/>đ</strong>.
                            <a href="${pageContext.request.contextPath}/parent/profile" style="color:#0d9488; font-weight:700; text-decoration:none;">Nạp ví →</a>
                        </div>
                    </c:if>

                        <%-- Nút hành động --%>
                    <div style="display:flex; gap:12px; align-items:center;">
                        <a href="${pageContext.request.contextPath}/tutors"
                           style="flex:1; background:#f1f5f9; color:#475569; border:1px solid #e2e8f0;
                              padding:13px; border-radius:8px; font-size:14px; font-weight:600;
                              text-decoration:none; text-align:center;">
                            <i class="fa-solid fa-plus"></i> Thêm gia sư
                        </a>
                        <button id="btn-checkout-all"
                                style="flex:2; background:#0d9488; color:#fff; border:none; padding:13px;
                                   border-radius:8px; font-size:15px; font-weight:700; cursor:pointer;
                                   display:flex; align-items:center; justify-content:center; gap:8px;
                                   box-shadow:0 4px 6px -1px rgba(13,148,136,0.25); transition:all 0.2s;">
                            <i class="fa-solid fa-bolt"></i>
                            Thanh toán tất cả (<fmt:formatNumber value="${grandTotal}" type="number"/>đ)
                        </button>
                    </div>

                    <p style="text-align:center; font-size:12px; color:#94a3b8; margin:12px 0 0;">
                        Mỗi gia sư sẽ được thanh toán riêng · Tiền trừ trực tiếp từ ví
                    </p>
                </div>

            </c:otherwise>
        </c:choose>

    </div>
</main>

<%-- TOAST CONTAINER --%>
<div id="toast-container" style="position:fixed; bottom:24px; right:24px; z-index:99999; display:flex; flex-direction:column; gap:8px;"></div>

<script>
    // ===== XOÁ 1 GIA SƯ KHỎI GIỎ =====
    document.querySelectorAll('.btn-remove-cart').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var tutorId = this.getAttribute('data-tutor-id');
            var card = document.querySelector('.cart-card[data-tutor-id="' + tutorId + '"]');

            fetch('${pageContext.request.contextPath}/cart/toggle?tutorId=' + tutorId, { method: 'POST' })
                .then(function(res) { return res.json(); })
                .then(function(data) {
                    if (data.status === 'removed' && card) {
                        card.style.opacity = '0';
                        card.style.transform = 'translateX(20px)';
                        card.style.transition = 'all 0.3s ease';
                        setTimeout(function() {
                            card.remove();
                            if (document.querySelectorAll('.cart-card').length === 0) {
                                window.location.reload();
                            }
                        }, 300);
                        showToast('Đã xoá gia sư khỏi giỏ hàng', 'info');
                    }
                })
                .catch(function(e) { console.error(e); });
        });
    });

    // ===== THANH TOÁN TẤT CẢ =====
    var checkoutBtn = document.getElementById('btn-checkout-all');
    if (checkoutBtn) {
        checkoutBtn.addEventListener('click', function() {
            var btn = this;
            btn.disabled = true;
            btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang xử lý...';

            fetch('${pageContext.request.contextPath}/booking/checkout-all', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
            })
                .then(function(res) { return res.json(); })
                .then(function(data) {
                    if (data.status === 'SUCCESS') {
                        showToast('✅ Thanh toán thành công! Đã thuê ' + data.count + ' gia sư.', 'success');

                        // Cập nhật badge giỏ hàng về 0 ngay lập tức
                        var badge = document.querySelector('.nav-cart-badge');
                        if (badge) badge.textContent = '0';

                        // Chuyển hướng người dùng sau khi thông báo hiển thị xong
                        setTimeout(function() {
                            // Bạn nhớ kiểm tra xem là /parent/hired hay /parent/hired-tutors nhé
                            window.location.href = '${pageContext.request.contextPath}/parent/hired';
                        }, 1600);
                    } else if (data.status === 'ERR_INSUFFICIENT_BALANCE') {
                        btn.disabled = false;
                        btn.innerHTML = '<i class="fa-solid fa-bolt"></i> Thanh toán tất cả';
                        showToast('💸 Số dư tài khoản không đủ. Vui lòng nạp thêm tiền!', 'error');
                    } else if (data.status === 'PARTIAL_SUCCESS') {
                        showToast('⚠️ Thanh toán ' + data.count + '/' + data.total + ' gia sư thành công. Một số lớp bị lỗi.', 'warning');
                        setTimeout(function() {
                            window.location.reload();
                        }, 2000);
                    } else {
                        btn.disabled = false;
                        btn.innerHTML = '<i class="fa-solid fa-bolt"></i> Thanh toán tất cả';
                        showToast('❌ Thất bại: ' + (data.message || 'Vui lòng kiểm tra lại hệ thống'), 'error');
                    }
                })
                .catch(function() {
                    btn.disabled = false;
                    btn.innerHTML = '<i class="fa-solid fa-bolt"></i> Thanh toán tất cả';
                    showToast('❌ Lỗi kết nối hệ thống. Vui lòng thử lại.', 'error');
                });
        });
    }

    function showToast(msg, type) {
        var colors = { success:'#0d9488', error:'#ef4444', warning:'#f59e0b', info:'#475569' };
        var toast = document.createElement('div');
        toast.textContent = msg;
        toast.style.cssText = 'background:' + (colors[type]||'#334155') + ';color:#fff;padding:13px 18px;' +
            'border-radius:10px;font-size:14px;font-weight:600;box-shadow:0 4px 12px rgba(0,0,0,0.15);' +
            'max-width:340px;line-height:1.4;transition:opacity 0.3s;';
        document.getElementById('toast-container').appendChild(toast);
        setTimeout(function() {
            toast.style.opacity='0';
            setTimeout(function() { toast.remove(); }, 300);
        }, 3000);
    }


  function showToast(msg, type) {
        var colors = { success:'#0d9488', error:'#ef4444', warning:'#f59e0b', info:'#475569' };
        var toast = document.createElement('div');
        toast.textContent = msg;
        toast.style.cssText = 'background:' + (colors[type]||'#334155') + ';color:#fff;padding:13px 18px;' +
            'border-radius:10px;font-size:14px;font-weight:600;box-shadow:0 4px 12px rgba(0,0,0,0.15);' +
            'max-width:340px;line-height:1.4;transition:opacity 0.3s;';
        document.getElementById('toast-container').appendChild(toast);
        setTimeout(function() { toast.style.opacity='0'; setTimeout(function() { toast.remove(); }, 300); }, 3000);
    }
</script>
<jsp:include page="/views/common/footer.jsp"/>