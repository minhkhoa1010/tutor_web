<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<jsp:include page="/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Yêu cầu rút tiền - Gia Sư Bá Đạo"/>
    <jsp:param name="pageCss" value="/assets/css/user-profile.css" />
</jsp:include>

<jsp:include page="/views/common/navbar.jsp" />

<c:set var="u" value="${sessionScope.clientUser}"/>

<main class="page-main" style="background-color: #f8fafc; padding: 40px 0; font-family: 'Plus Jakarta Sans', sans-serif;">
    <div class="container" style="max-width: 1240px; margin: 0 auto; padding: 0 20px;">

        <div class="breadcrumb" style="margin-bottom: 32px; font-size: 14px; color: #64748b;">
            <a href="${pageContext.request.contextPath}/home" style="color: #64748b; text-decoration: none;">Trang chủ</a>
            <span style="margin: 0 8px; color: #cbd5e1;">/</span>
            <a href="${pageContext.request.contextPath}/wallet/history" style="color: #64748b; text-decoration: none;">Ví điện tử</a>
            <span style="margin: 0 8px; color: #cbd5e1;">/</span>
            <span style="color: #0f172a; font-weight: 500;">Rút tiền</span>
        </div>

        <div class="profile-detail-grid" style="display: flex; gap: 24px; align-items: flex-start;">

            <jsp:include page="/views/tutor/sidebar.jsp"/>
            <section class="profile-content-main" style="flex: 1; background: #fff; padding: 32px; border-radius: 16px; box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.05);">

                <div style="margin-bottom: 24px;">
                    <h1 style="font-size: 24px; font-weight: 700; color: #0f172a; margin: 0 0 8px 0;">Yêu cầu rút tiền về ngân hàng</h1>
                    <p style="color: #64748b; font-size: 14px; margin: 0;">Tiền sẽ được kiểm duyệt và chuyển vào tài khoản ngân hàng của bạn trong vòng 24h làm việc.</p>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div style="background: #fee2e2; color: #991b1b; padding: 12px 16px; border-radius: 8px; font-size: 14px; margin-bottom: 20px; font-weight: 500;">
                            ${errorMessage}
                    </div>
                </c:if>

                <div style="background: #f8fafc; border: 1px solid #e2e8f0; padding: 16px 20px; border-radius: 12px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px;">
                    <span style="font-size: 15px; color: #475569; font-weight: 500;">Số dư khả dụng hiện tại:</span>
                    <span style="font-size: 20px; font-weight: 700; color: #10b981;" id="availableBalanceText">
                        <fmt:formatNumber value="${not empty u.balance ? u.balance : 0}" type="number"/>đ
                    </span>
                    <input type="hidden" id="rawBalance" value="${not empty u.balance ? u.balance : 0}">
                </div>

                <form id="withdrawForm" action="${pageContext.request.contextPath}/wallet/withdraw" method="POST" style="max-width: 600px;">

                    <div style="margin-bottom: 20px;">
                        <label style="display: block; font-size: 14px; font-weight: 600; color: #334155; margin-bottom: 8px;">Số tiền rút (VNĐ) <span style="color: red;">*</span></label>
                        <input type="number" name="amount" id="withdrawAmount" placeholder="Ví dụ: 200000" required
                               style="width: 100%; padding: 12px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 15px; outline: none; transition: border 0.2s;">
                        <span id="amountError" style="color: #dc2626; font-size: 13px; margin-top: 6px; display: none; font-weight: 500;"></span>
                    </div>

                    <div style="margin-bottom: 20px;">
                        <label style="display: block; font-size: 14px; font-weight: 600; color: #334155; margin-bottom: 8px;">Ngân hàng nhận <span style="color: red;">*</span></label>
                        <select name="bank_name" required style="width: 100%; padding: 12px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 15px; background: #fff; outline: none;">
                            <option value="">-- Chọn ngân hàng nhận tiền --</option>
                            <option value="Vietcombank">Vietcombank (Ngoại thương Việt Nam)</option>
                            <option value="Techcombank">Techcombank (Kỹ thương)</option>
                            <option value="MBBank">MBBank (Quân đội)</option>
                            <option value="VietinBank">VietinBank (Công thương Việt Nam)</option>
                            <option value="BIDV">BIDV (Đầu tư và Phát triển)</option>
                            <option value="Agribank">Agribank (Nông nghiệp & PTNT)</option>
                            <option value="TPBank">TPBank (Tiên Phong)</option>
                        </select>
                    </div>

                    <div style="margin-bottom: 20px;">
                        <label style="display: block; font-size: 14px; font-weight: 600; color: #334155; margin-bottom: 8px;">Số tài khoản ngân hàng <span style="color: red;">*</span></label>
                        <input type="text" name="bank_account_number" placeholder="Nhập số tài khoản" required
                               style="width: 100%; padding: 12px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 15px; outline: none;">
                    </div>

                    <div style="margin-bottom: 28px;">
                        <label style="display: block; font-size: 14px; font-weight: 600; color: #334155; margin-bottom: 8px;">Tên chủ tài khoản (Viết hoa không dấu) <span style="color: red;">*</span></label>
                        <input type="text" name="bank_account_name" placeholder="Ví dụ: NGUYEN VAN A" required
                               style="width: 100%; padding: 12px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 15px; outline: none; text-transform: uppercase;">
                    </div>

                    <div style="display: flex; gap: 16px;">
                        <button type="submit" style="background: #10b981; color: #fff; border: none; padding: 14px 28px; border-radius: 8px; font-size: 15px; font-weight: 600; cursor: pointer; transition: background 0.2s;">
                            Gửi yêu cầu rút tiền
                        </button>
                        <a href="${pageContext.request.contextPath}/wallet/history" style="background: #f1f5f9; color: #475569; padding: 14px 24px; border-radius: 8px; font-size: 15px; font-weight: 600; text-decoration: none; text-align: center; line-height: normal;">
                            Hủy bỏ
                        </a>
                    </div>
                </form>
            </section>
        </div>
    </div>
</main>

<jsp:include page="/views/common/footer.jsp" />

<script>
    document.getElementById('withdrawForm').addEventListener('submit', function(e) {
        const balance = parseFloat(document.getElementById('rawBalance').value) || 0;
        const amountInput = document.getElementById('withdrawAmount');
        const amount = parseFloat(amountInput.value) || 0;
        const errorSpan = document.getElementById('amountError');

        let hasError = false;
        errorSpan.style.display = 'none';

        if (amount < 50000) {
            e.preventDefault();
            errorSpan.textContent = "❌ Số tiền rút tối thiểu cho mỗi giao dịch là 50,000đ.";
            errorSpan.style.display = 'block';
            amountInput.focus();
            hasError = true;
        } else if (amount > balance) {
            e.preventDefault();
            errorSpan.textContent = "❌ Tài khoản của bạn không đủ số dư để thực hiện giao dịch này.";
            errorSpan.style.display = 'block';
            amountInput.focus();
            hasError = true;
        }
    });
</script>