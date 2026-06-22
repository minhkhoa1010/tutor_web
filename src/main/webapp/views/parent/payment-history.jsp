<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<jsp:include page="/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Lịch sử thanh toán - Gia Sư Bá Đạo"/>
    <jsp:param name="pageCss" value="/assets/css/user-profile.css" />
</jsp:include>

<jsp:include page="/views/common/navbar.jsp" />

<main class="page-main" style="background-color: #f8fafc; padding: 40px 0; font-family: 'Plus Jakarta Sans', sans-serif;">
    <div class="container" style="max-width: 1240px; margin: 0 auto; padding: 0 20px;">

        <div class="breadcrumb" style="margin-bottom: 32px; font-size: 14px; color: #64748b;">
            <a href="${pageContext.request.contextPath}/home" style="color: #64748b; text-decoration: none;">Trang chủ</a>
            <span style="margin: 0 8px; color: #cbd5e1;">/</span>
            <span style="color: #0f172a; font-weight: 500;">Lịch sử thanh toán</span>
        </div>

        <div class="profile-detail-grid" style="display: flex; gap: 24px; align-items: flex-start;">

            <jsp:include page="/views/parent/sidebar.jsp" />

            <section class="profile-content-card" style="flex: 1; background: #fff; padding: 40px; border-radius: 16px; border: 1px solid #f1f5f9; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);">

                <div class="panel-main-header" style="margin-bottom: 32px; border-bottom: 1px solid #f1f5f9; padding-bottom: 24px;">
                    <h3 style="font-size: 24px; font-weight: 800; color: #0f172a; margin: 0 0 8px 0;">Lịch sử thanh toán</h3>
                    <p style="font-size: 14px; color: #64748b; margin: 0;">Tất cả giao dịch nạp tiền và thanh toán của tài khoản bạn.</p>
                </div>

                <c:choose>
                    <c:when test="${empty transactions}">
                        <div style="text-align: center; padding: 60px 20px; color: #94a3b8;">
                            <i class="bi bi-receipt" style="font-size: 48px; display: block; margin-bottom: 16px;"></i>
                            <p style="font-size: 16px; font-weight: 700; color: #0f172a; margin: 0;">Chưa có giao dịch nào</p>
                            <p style="font-size: 14px; margin: 8px 0 24px;">Nạp tiền để bắt đầu thuê gia sư nhé!</p>
                            <a href="${pageContext.request.contextPath}/parent/profile"
                               style="display: inline-block; background: #0f172a; color: #fff; padding: 10px 24px; border-radius: 8px; font-size: 14px; font-weight: 600; text-decoration: none;">
                                Nạp tiền ngay
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="overflow-x: auto; max-height: 480px; overflow-y: auto; padding-right: 4px; border: 1px solid #e2e8f0; border-radius: 12px;">
                            <table style="width: 100%; border-collapse: collapse; margin: 0;">
                                    <%-- Khóa cứng thanh tiêu đề header khi cuộn --%>
                                <thead style="position: sticky; top: 0; z-index: 10; background: #f8fafc;">
                                <tr style="border-bottom: 2px solid #e2e8f0;">
                                    <th style="padding: 12px 16px; text-align: left; font-size: 12px; font-weight: 600; color: #64748b; text-transform: uppercase; letter-spacing: 0.05em;">Mã giao dịch</th>
                                    <th style="padding: 12px 16px; text-align: left; font-size: 12px; font-weight: 600; color: #64748b; text-transform: uppercase; letter-spacing: 0.05em;">Loại</th>
                                    <th style="padding: 12px 16px; text-align: right; font-size: 12px; font-weight: 600; color: #64748b; text-transform: uppercase; letter-spacing: 0.05em;">Số tiền</th>
                                    <th style="padding: 12px 16px; text-align: center; font-size: 12px; font-weight: 600; color: #64748b; text-transform: uppercase; letter-spacing: 0.05em;">Trạng thái</th>
                                    <th style="padding: 12px 16px; text-align: right; font-size: 12px; font-weight: 600; color: #64748b; text-transform: uppercase; letter-spacing: 0.05em;">Thời gian</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="txn" items="${transactions}" varStatus="s">
                                    <tr style="border-bottom: 1px solid #f1f5f9; transition: background 0.15s;"
                                        onmouseover="this.style.background='#f8fafc'"
                                        onmouseout="this.style.background='transparent'">

                                            <%-- Giữ nguyên logic các ô dữ liệu (td) của ông bên dưới --%>
                                        <td style="padding: 16px; font-size: 12px; font-family: monospace; color: #64748b;">
                    <span style="background: #f1f5f9; padding: 3px 8px; border-radius: 6px;">
                            ${txn.txnRef}
                    </span>
                                        </td>
                                        <td style="padding: 16px;">
                                            <c:set var="isIncome" value="${txn.type == 'DEPOSIT' || txn.type == 'RECEIVE_FROM_BOOKING'}"/>
                                            <span style="display:inline-flex; align-items:center; gap:6px; font-size:13px; font-weight:600; color:#0f172a;">
                        <i class="bi ${isIncome ? 'bi-arrow-down-circle-fill' : 'bi-arrow-up-circle-fill'}" style="font-size:16px; color:${isIncome ? '#10b981' : '#f59e0b'};"></i>
                        ${txn.typeLabel}
                    </span>
                                        </td>
                                        <td style="padding:16px; text-align:right;">
                                            <c:set var="isIncome2" value="${txn.type == 'DEPOSIT' || txn.type == 'RECEIVE_FROM_BOOKING'}"/>
                                            <span style="font-size:15px; font-weight:700; color:${isIncome2 ? '#10b981' : '#ef4444'};">
                        ${isIncome2 ? '+' : '-'}<fmt:formatNumber value="${txn.amount}" type="number"/>đ
                    </span>
                                        </td>
                                        <td style="padding: 16px; text-align: center;">
                    <span style="font-size: 12px; font-weight: 600; padding: 4px 12px; border-radius: 20px;
                            background: ${txn.status == 'SUCCESS' ? '#d1fae5' : txn.status == 'PENDING' ? '#fef3c7' : '#fee2e2'};
                            color: ${txn.status == 'SUCCESS' ? '#065f46' : txn.status == 'PENDING' ? '#92400e' : '#991b1b'};">
                            ${txn.statusLabel}
                    </span>
                                        </td>
                                        <td style="padding: 16px; text-align: right; font-size: 13px; color: #64748b;">
                                                ${txn.createdAt}
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>

            </section>
        </div>
    </div>
</main>

<jsp:include page="/views/common/footer.jsp" />

