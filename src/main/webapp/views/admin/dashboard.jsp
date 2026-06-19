<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard – Gia Sư Bá Đạo VN</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        /* --- FIX LỖI AVATAR TRÒN & BADGE GỌN GÀNG --- */
        .complaint-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #e2e8f0;
            vertical-align: middle;
        }

        .custom-badge {
            display: inline-block;
            padding: 4px 10px;
            font-size: 12px;
            font-weight: 600;
            border-radius: 6px;
            text-align: center;
        }
        .badge-danger {
            background-color: #fee2e2;
            color: #ef4444;
        }
        .badge-success {
            background-color: #d1fae5;
            color: #10b981;
        }

        /* --- FIX LỖI ICON BỊ LỆCH --- */
        .btn-action-view {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            background: #1e293b;
            color: #ffffff;
            border-radius: 6px;
            font-size: 13px;
            text-decoration: none;
            font-weight: 500;
            border: none;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-action-view:hover {
            background: #0f172a;
        }
        .btn-action-view .material-symbols-outlined {
            font-size: 18px;
            vertical-align: middle;
        }

        /* --- POPUP MODAL XEM CHI TIẾT THUẦN CSS (SIÊU ĐẸP) --- */
        .custom-modal-backdrop {
            display: none; /* Ẩn mặc định */
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(15, 23, 42, 0.6); /* Phông tối mờ chuẩn UX */
            z-index: 9999;
            justify-content: center;
            align-items: center;
            backdrop-filter: blur(4px);
        }

        .custom-modal-box {
            background: #ffffff;
            width: 100%;
            max-width: 550px;
            border-radius: 12px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            padding: 24px;
            animation: modalFadeIn 0.3s ease;
        }

        @keyframes modalFadeIn {
            from { transform: translateY(-20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        .modal-header-title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #f1f5f9;
            padding-bottom: 12px;
            margin-bottom: 16px;
        }
        .modal-header-title h3 {
            margin: 0;
            font-size: 18px;
            color: #1e293b;
        }
        .modal-close-btn {
            background: none;
            border: none;
            cursor: pointer;
            color: #94a3b8;
        }
        .modal-close-btn:hover { color: #64748b; }

        .modal-body-content .info-group {
            margin-bottom: 14px;
        }
        .modal-body-content .info-label {
            font-size: 12px;
            color: #64748b;
            text-transform: uppercase;
            font-weight: 600;
            margin-bottom: 4px;
        }
        .modal-body-content .info-value {
            font-size: 15px;
            color: #0f172a;
            background: #f8fafc;
            padding: 10px 12px;
            border-radius: 6px;
            border: 1px solid #f1f5f9;
        }
        .modal-footer-actions {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 24px;
            border-top: 1px solid #f1f5f9;
            padding-top: 16px;
        }
        /* Tối ưu hóa layout lưới biểu đồ để tất cả các box bằng nhau đến cuối trang */
        .charts-dashboard-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 24px;
            margin-top: 24px;
        }
        .charts-left-column {
            display: flex;
            flex-direction: column;
            gap: 24px;
        }
        /* Đồng bộ CSS bảng khiếu nại tránh vỡ giao diện hệ thống */
        .complaint-tutor-box {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .complaint-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            border: 1px solid #e2e8f0;
        }
        .evidence-link {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            color: #2563eb;
            text-decoration: none;
            font-weight: 500;
            font-size: 13px;
        }
        .evidence-link:hover {
            text-decoration: underline;
        }
        .no-evidence {
            color: #94a3b8;
            font-style: italic;
            font-size: 13px;
        }
    </style>
</head>
<body>
<div class="admin-wrapper">

    <aside class="sidebar">
        <div class="sidebar-logo">
            <span class="logo-icon material-symbols-outlined">school</span>
            <div>
                <h2>Bá Đạo Admin</h2>
                <span>Quản lý cổng thông tin</span>
            </div>
        </div>

        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item active">
                <span class="nav-icon material-symbols-outlined">dashboard</span>
                <span>Tổng quan</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/tutors" class="nav-item">
                <span class="nav-icon material-symbols-outlined">school</span>
                <span>Gia sư</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/students" class="nav-item">
                <span class="nav-icon material-symbols-outlined">group</span>
                <span>Học viên</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/complaints" class="nav-item">
                <span class="nav-icon material-symbols-outlined">gavel</span>
                <span>Xử lý khiếu nại</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/payments" class="nav-item">
                <span class="nav-icon material-symbols-outlined">payments</span>
                <span>Thanh toán</span>
            </a>
        </nav>

        <div class="sidebar-bottom">
            <div class="sidebar-user">
                <img src="${not empty sessionScope.clientUser.avatarUrl ? sessionScope.clientUser.avatarUrl : 'https://ui-avatars.com/api/?name=Admin+User&background=1a2f5a&color=fff'}"
                     alt="Admin"
                     onerror="this.onerror=null; this.src='https://ui-avatars.com/api/?name='+encodeURIComponent('${not empty sessionScope.clientUser.fullname ? sessionScope.clientUser.fullname : 'Admin User'}')+'&background=random';">
                <div>
                    <strong><c:out value="${not empty sessionScope.clientUser.fullname ? sessionScope.clientUser.fullname : 'Admin User'}"/></strong>
                    <span>SUPER ADMINISTRATOR</span>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/admin/settings" class="nav-item settings-item">
                <span class="nav-icon material-symbols-outlined">settings</span>
                <span>Cài đặt</span>
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="nav-item logout-item">
                <span class="nav-icon material-symbols-outlined">logout</span>
                <span>Đăng xuất</span>
            </a>
        </div>
    </aside>

    <div class="main-content">

        <header class="topbar">
            <div class="topbar-brand">
                <span class="brand-dot"></span>
                <span class="brand-name">Gia Sư Bá Đạo VN</span>
            </div>
            <div class="topbar-search">
                <span class="search-icon material-symbols-outlined">search</span>
                <input type="text" placeholder="Tìm kiếm phân tích hoặc gia sư...">
            </div>
            <nav class="topbar-links">
                <a href="#">Trợ giúp</a>
                <a href="#">Báo cáo</a>
            </nav>
            <div class="topbar-actions">
                <button class="icon-btn notif-btn"><span class="material-symbols-outlined">notifications</span><span class="notif-dot"></span></button>
                <button class="icon-btn"><span class="material-symbols-outlined">mail</span></button>
                <img class="avatar-sm"
                     src="${not empty sessionScope.clientUser.avatarUrl ? sessionScope.clientUser.avatarUrl : 'https://ui-avatars.com/api/?name=Admin+User&background=1a2f5a&color=fff'}"
                     alt="Admin"
                     onerror="this.onerror=null; this.src='https://ui-avatars.com/api/?name='+encodeURIComponent('${not empty sessionScope.clientUser.fullname ? sessionScope.clientUser.fullname : 'Admin User'}')+'&background=random';">
            </div>
        </header>

        <div class="page-body">

            <div class="page-title-row">
                <div>
                    <h1>Tổng quan hệ thống</h1>
                    <p>Chỉ số hiệu suất thời gian thực và doanh thu chiến lược.</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/tutors/new" class="btn-primary" style="text-decoration:none;">
                    + Thêm Gia Sư Mới
                </a>
            </div>

            <div class="kpi-grid">
                <div class="kpi-card">
                    <div class="kpi-top">
                        <div class="kpi-icon blue-icon material-symbols-outlined">school</div>
                        <c:choose>
                            <c:when test="${not empty tutorGrowth && !tutorGrowth.startsWith('-')}">
                                <span class="kpi-badge green-badge">+${tutorGrowth}%</span>
                            </c:when>
                            <c:otherwise>
                                <span class="kpi-badge red-badge">${tutorGrowth}%</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="kpi-label">Tổng gia sư</div>
                    <div class="kpi-value"><c:out value="${not empty totalTutors ? totalTutors : '0'}" /></div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-top">
                        <div class="kpi-icon green-icon material-symbols-outlined">group</div>
                        <c:choose>
                            <c:when test="${not empty studentGrowth && !studentGrowth.startsWith('-')}">
                                <span class="kpi-badge green-badge">+${studentGrowth}%</span>
                            </c:when>
                            <c:otherwise>
                                <span class="kpi-badge red-badge">${studentGrowth}%</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="kpi-label">Tổng học viên</div>
                    <div class="kpi-value"><c:out value="${not empty totalStudents ? totalStudents : '0'}" /></div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-top">
                        <div class="kpi-icon orange-icon material-symbols-outlined">payments</div>
                        <span class="kpi-badge green-badge">Live</span>
                    </div>
                    <div class="kpi-label">Doanh thu tháng này</div>
                    <div class="kpi-value">
                        <fmt:formatNumber value="${not empty monthlyRevenue ? monthlyRevenue : 0}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-top">
                        <div class="kpi-icon purple-icon material-symbols-outlined">menu_book</div>
                        <span class="kpi-badge new-badge">Mới</span>
                    </div>
                    <div class="kpi-label">Hồ sơ chờ duyệt</div>
                    <div class="kpi-value"><c:out value="${not empty pendingCount ? pendingCount : '0'}" /></div>
                </div>
            </div>

            <div class="charts-dashboard-grid">
                <div class="charts-left-column">
                    <div class="chart-box large-chart" style="width: 100%;">
                        <div class="chart-header">
                            <div>
                                <h3>Doanh thu theo thời gian</h3>
                                <p>Dòng tiền phí dịch vụ thực tế thu về theo các tháng trong năm</p>
                            </div>
                            <div class="chart-legend">
                                <span class="legend-dot green"></span> DOANH THU (VNĐ)
                            </div>
                        </div>
                        <div style="position: relative; height: 260px; width: 100%;">
                            <canvas id="revenueBarChart"></canvas>
                        </div>
                    </div>

                    <div class="chart-box large-chart" style="width: 100%;">
                        <div class="chart-header">
                            <div>
                                <h3>Xu hướng tăng trưởng người dùng</h3>
                                <p>Số lượng tài khoản đăng ký mới kích hoạt theo tháng</p>
                            </div>
                        </div>
                        <div style="position: relative; height: 220px; width: 100%;">
                            <canvas id="userGrowthLineChart"></canvas>
                        </div>
                    </div>
                </div>

                <div class="chart-box small-chart" style="height: 100%; display: flex; flex-direction: column; justify-content: space-between; background: #fff; padding: 24px; border-radius: 12px;">
                    <div>
                        <div class="chart-header" style="margin-bottom: 20px;">
                            <h3>Doanh thu theo Môn học</h3>
                            <span class="kpi-badge new-badge" style="background:#e0f2fe; color:#0369a1;">Tháng này</span>
                        </div>

                        <div class="donut-wrap" style="position: relative; width: 100%; height: 180px; display: flex; justify-content: center; align-items: center;">
                            <canvas id="subjectDoughnutChart" style="max-width: 180px; max-height: 180px;"></canvas>
                        </div>

                        <div class="chart-legend-scroll-container" style="margin-top: 20px; min-width: 0;">
                            <div id="doughnut-custom-legend" style="max-height: 160px; overflow-y: auto; padding-right: 4px;">
                            </div>
                        </div>
                    </div>

                    <p style="text-align: center; font-size: 12px; color: #64748b; margin-top: 16px; margin-bottom: 0;">
                        Thống kê các môn mang lại dòng tiền nhiều nhất
                    </p>
                </div>
            </div>
            <div class="table-section" style="margin-top: 24px;">
                <div class="table-header">
                    <h3>Gia sư chờ duyệt</h3>
                    <span class="new-apps-badge"><c:out value="${not empty pendingCount ? pendingCount : '0'}" /> Đơn đăng ký mới</span>
                </div>
                <table class="data-table">
                    <thead>
                    <tr>
                        <th style="width: 80px; text-align: center;">Ảnh</th>
                        <th>TÊN GIA SƯ</th>
                        <th>MÔN DẠY</th>
                        <th>NGÀY ỨNG TUYỂN</th>
                        <th style="text-align: center;">HÀNH ĐỘNG</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty pendingTutors}">
                            <c:forEach items="${pendingTutors}" var="t">
                                <tr>
                                    <td style="text-align: center;">
                                        <img class="complaint-avatar"
                                             src="${not empty t.avatarUrl ? (t.avatarUrl.startsWith('http') ? t.avatarUrl : pageContext.request.contextPath.concat(t.avatarUrl)) : 'https://ui-avatars.com/api/?name='.concat(t.fullName).concat('&background=random')}"
                                             alt="Avatar"
                                             onerror="this.onerror=null; this.src='https://ui-avatars.com/api/?name='+encodeURIComponent('${t.fullName}')+'&background=random';">
                                    </td>
                                    <td class="name-cell"><strong><c:out value="${t.fullName}"/></strong></td>
                                    <td><span class="subject-tag"><c:out value="${t.teachingSubject}"/></span></td>
                                    <td class="date-cell"><c:out value="${t.appliedDate}"/></td>
                                    <td class="action-cell" style="text-align: center;">
                                        <a href="${pageContext.request.contextPath}/admin/tutor-detail?id=${t.tutorId}" class="btn-action btn-view" style="text-decoration: none; display: inline-flex; align-items: center; gap: 4px; padding: 6px 12px; background: #f1f5f9; color: #1a2f5a; border-radius: 6px; font-size: 13px; font-weight: 500;">
                                            <span class="material-symbols-outlined" style="font-size: 16px;">visibility</span> Chi tiết
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/approve-tutor?id=${t.tutorId}" class="btn-action btn-approve" style="text-decoration: none; display: inline-flex; align-items: center; gap: 4px; padding: 6px 12px; background: #ecfdf5; color: #10b981; border-radius: 6px; font-size: 13px; font-weight: 500; margin-left: 6px;">
                                            <span class="material-symbols-outlined" style="font-size: 16px;">check</span> Duyệt
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/reject-tutor?id=${t.tutorId}" class="btn-action btn-reject" style="text-decoration: none; display: inline-flex; align-items: center; gap: 4px; padding: 6px 12px; background: #fef2f2; color: #ef4444; border-radius: 6px; font-size: 13px; font-weight: 500; margin-left: 6px;">
                                            <span class="material-symbols-outlined" style="font-size: 16px;">close</span> Từ chối
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="5" style="text-align:center; padding:32px; color:#94a3b8;">
                                    Không có gia sư nào đang chờ duyệt
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>

            <div class="table-section" style="margin-top: 24px; background: #fff; padding: 24px; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.05);">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                    <h3 style="margin: 0; font-size: 16px; color: #1a2f5a; font-weight: 700; display: flex; align-items: center; gap: 8px;">
                        <span class="material-symbols-outlined" style="color: #ef4444;">gavel</span>
                        Gia sư bị khiếu nại (Chờ xử lý)
                    </h3>
                </div>

                <div style="overflow-x: auto;">
                    <table style="width: 100%; border-collapse: collapse; text-align: left; font-size: 14px;">
                        <thead>
                        <tr style="border-bottom: 2px solid #f1f5f9; color: #64748b; font-weight: 600;">
                            <th style="padding: 12px 8px;">Người khiếu nại</th>
                            <th style="padding: 12px 8px;">Bên bị khiếu nại</th>
                            <th style="padding: 12px 8px;">Môn học</th>
                            <th style="padding: 12px 8px;">Lý do</th>
                            <th style="padding: 12px 8px; text-align: center;">Bằng chứng</th>
                            <th style="padding: 12px 8px; text-align: center;">Hành động</th>
                        </tr>
                        </thead>
                        <tbody>
<%--       ---- DEBUG  -----              <pre>--%>
<%--    <c:forEach var="c" items="${reportedTutors}">--%>
<%--        Key set: ${c.keySet()}--%>
<%--        Tên gia sư (tutor_name): ${c.tutor_name}--%>
<%--    </c:forEach>--%>
<%--</pre>--%>
                        <c:choose>
                            <c:when test="${not empty reportedTutors}">
                                <c:forEach var="c" items="${reportedTutors}">
                                    <tr style="border-bottom: 1px solid #f1f5f9; color: #334155;">
                                            <%-- CỘT NGƯỜI KHIẾU NẠI --%>
                                        <td style="padding: 12px 8px;">
                    <span style="font-size: 11px; padding: 2px 6px; border-radius: 4px; background: ${c.dispute_by == 'TUTOR' ? '#eff6ff' : '#fef3c7'}">
                            ${c.dispute_by == 'TUTOR' ? 'Gia sư' : 'Phụ huynh'}
                    </span>
                                            <br><strong>${c.dispute_by == 'TUTOR' ? c.tutor_name : c.parent_name}</strong>
                                        </td>

                                            <%-- CỘT BÊN BỊ KHIẾU NẠI --%>
                                        <td style="padding: 12px 8px;">
                    <span style="font-size: 11px; padding: 2px 6px; border-radius: 4px; background: #f1f5f9">
                            ${c.dispute_by == 'TUTOR' ? 'Phụ huynh' : 'Gia sư'}
                    </span>
                                            <br><strong>${c.dispute_by == 'TUTOR' ? c.parent_name : c.tutor_name}</strong>
                                        </td>

                                        <td style="padding: 12px 8px;">${c.subject_name}</td>
                                                <td style="padding: 12px 8px; max-width: 220px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;"
                                                    title="${c.complaint_reason}">
                                                        ${c.complaint_reason}
                                                </td>
                                        <td style="padding: 12px 8px; text-align: center;">
                                            <c:choose>
                                                <c:when test="${not empty c.dispute_evidence_url}">
                                                    <a href="${c.dispute_evidence_url}" target="_blank" style="color: #16a34a;">Xem</a>
                                                </c:when>
                                                <c:otherwise>Không có</c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td style="padding: 12px 8px; text-align: center;">
                                            <a href="${pageContext.request.contextPath}/admin/complaints?bookingId=${c.booking_id}" class="btn-detail-small">
                                                Xem chi tiết
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="6" style="text-align: center; padding: 24px;">Không có khiếu nại.</td></tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
            <footer class="page-footer" style="margin-top: 40px; text-align: center; color: #94a3b8; font-size: 13px;">
                © 2026 Gia Sư Bá Đạo VN • Giao diện quản trị hệ thống
            </footer>
        </div>
    </div>
</div>

<style>
    /* Định dạng thanh cuộn mượt cho Custom Legend của biểu đồ môn học */
    #doughnut-custom-legend::-webkit-scrollbar {
        width: 5px;
    }
    #doughnut-custom-legend::-webkit-scrollbar-track {
        background: #f1f5f9;
        border-radius: 4px;
    }
    #doughnut-custom-legend::-webkit-scrollbar-thumb {
        background: #cbd5e1;
        border-radius: 4px;
    }
    #doughnut-custom-legend::-webkit-scrollbar-thumb:hover {
        background: #94a3b8;
    }
</style>

<script>
    window.addEventListener('DOMContentLoaded', function() {
        // Đảm bảo dữ liệu luôn an toàn, không bị crash chuỗi JSON rỗng
        const userGrowthData = ${not empty chartJson ? chartJson : '[]'};
        const revenueData    = ${not empty revenueChartJson ? revenueChartJson : '[]'};
        const subjectLabels  = ${not empty subjectLabelsJson ? subjectLabelsJson : '[]'};
        const subjectData    = ${not empty subjectDataJson ? subjectDataJson : '[]'};

        // 1. BIỂU ĐỒ CỘT (BAR CHART): DOANH THU THEO THỜI GIAN
        const canvasBar = document.getElementById('revenueBarChart');
        if (canvasBar) {
            new Chart(canvasBar.getContext('2d'), {
                type: 'bar',
                data: {
                    labels: ['T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12'],
                    datasets: [{
                        label: 'Doanh thu thuần (đ)',
                        data: revenueData,
                        backgroundColor: '#10b981',
                        borderRadius: 6,
                        borderSkipped: false
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    return 'Doanh thu: ' + (context.raw || 0).toLocaleString('vi-VN') + ' đ';
                                }
                            }
                        }
                    },
                    scales: {
                        x: { grid: { display: false }, ticks: { color: '#64748b' } },
                        y: {
                            beginAtZero: true,
                            grid: { color: '#f1f5f9' },
                            ticks: {
                                color: '#64748b',
                                callback: function(value) {
                                    if(value >= 1000000) return (value/1000000) + 'M';
                                    if(value >= 1000) return (value/1000) + 'k';
                                    return value;
                                }
                            }
                        }
                    }
                }
            });
        }

        // 2. BIỂU ĐỒ TRÒN NÂNG CAO (DOUGHNUT CHART): TEXT TRUNG TÂM + CUSTOM LEGEND
        const canvasDoughnut = document.getElementById('subjectDoughnutChart');
        if (canvasDoughnut) {
            const finalLabels = subjectLabels.length > 0 ? subjectLabels : ['Chưa có dữ liệu'];
            const finalData   = subjectData.length > 0 ? subjectData : [0];
            const finalColors = subjectLabels.length > 0 ? [
                '#1a2f5a', '#2563eb', '#38bdf8', '#475569', '#34d399',
                '#f59e0b', '#f43f5e', '#a855f7', '#10b981', '#64748b'
            ] : ['#e2e8f0'];

            const totalRevenue = subjectData.reduce((a, b) => a + b, 0);

            const doughnutChart = new Chart(canvasDoughnut.getContext('2d'), {
                type: 'doughnut',
                data: {
                    labels: finalLabels,
                    datasets: [{
                        data: finalData,
                        backgroundColor: finalColors,
                        borderWidth: 2,
                        borderColor: '#ffffff'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    cutout: '75%',
                    plugins: {
                        legend: { display: false }, // Tắt chú thích mặc định xấu xí
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    let value = context.raw || 0;
                                    let percentage = totalRevenue > 0 ? ((value / totalRevenue) * 100).toFixed(1) : 0;
                                    return ` ${context.label}: ${value.toLocaleString('vi-VN')} đ (${percentage}%)`;
                                }
                            }
                        }
                    }
                },
                plugins: [{
                    id: 'centerTextPlugin',
                    beforeDraw: function(chart) {
                        const { width, height, ctx } = chart;
                        ctx.restore();

                        // Dòng 1: Tiêu đề nhỏ phía trên tâm biệt
                        ctx.font = "600 10px sans-serif";
                        ctx.textBaseline = "middle";
                        ctx.fillStyle = "#94a3b8";
                        const textTop = "TỔNG DOANH THU";
                        const textTopX = Math.round((width - ctx.measureText(textTop).width) / 2);
                        ctx.fillText(textTop, textTopX, height / 2 - 10);

                        // Dòng 2: Hiển thị tiền tệ VND to rõ ở tâm biểu đồ
                        ctx.font = "bold 14px sans-serif";
                        ctx.fillStyle = "#1a2f5a";
                        const textBottom = totalRevenue.toLocaleString('vi-VN') + " đ";
                        const textBottomX = Math.round((width - ctx.measureText(textBottom).width) / 2);
                        ctx.fillText(textBottom, textBottomX, height / 2 + 10);

                        ctx.save();
                    }
                }]
            });

            // TỰ ĐỘNG GENERATE CUSTOM LEGEND CUỘN XUỐNG DƯỚI CANVAS
            const legendContainer = document.getElementById('doughnut-custom-legend');
            if (legendContainer) {
                legendContainer.innerHTML = '';
                if (subjectLabels.length === 0) {
                    legendContainer.innerHTML = '<div style="text-align:center; color:#94a3b8; font-size:13px; padding:10px;">Không có dữ liệu tháng này</div>';
                } else {
                    subjectLabels.forEach((label, i) => {
                        const val = subjectData[i];
                        const color = doughnutChart.data.datasets[0].backgroundColor[i];

                        const item = document.createElement('div');
                        item.style.display = 'flex';
                        item.style.alignItems = 'center';
                        item.style.justifyContent = 'space-between';
                        item.style.padding = '6px 0';
                        item.style.borderBottom = '1px dashed #f1f5f9';

                        item.innerHTML = `
                            <div style="display: flex; align-items: center; gap: 8px; min-width: 0;">
                                <span style="width: 10px; height: 10px; background-color: \${color}; border-radius: 50%; flex-shrink: 0;"></span>
                                <span style="color: #475569; font-size: 13px; font-weight: 500; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">\${label}</span>
                            </div>
                            <span style="color: #1e293b; font-size: 13px; font-weight: 600; flex-shrink: 0;">\${val.toLocaleString('vi-VN')} đ</span>
                        `;
                        legendContainer.appendChild(item);
                    });
                }
            }
        }

        // 3. BIỂU ĐỒ ĐƯỜNG (LINE CHART): XU HƯỚNG TĂNG TRƯỞNG NGƯỜI DÙNG
        const canvasLine = document.getElementById('userGrowthLineChart');
        if (canvasLine) {
            new Chart(canvasLine.getContext('2d'), {
                type: 'line',
                data: {
                    labels: ['T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12'],
                    datasets: [{
                        label: 'Tài khoản mới',
                        data: userGrowthData,
                        borderColor: '#1a2f5a',
                        backgroundColor: 'rgba(26, 47, 90, 0.05)',
                        borderWidth: 3,
                        tension: 0.3,
                        fill: true,
                        pointBackgroundColor: '#1a2f5a'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        x: { grid: { display: false }, ticks: { color: '#94a3b8' } },
                        y: {
                            beginAtZero: true,
                            grid: { color: '#f8fafc' },
                            ticks: { color: '#94a3b8', precision: 0 }
                        }
                    }
                }
            });
        }
    });
</script>
</body>
</html>