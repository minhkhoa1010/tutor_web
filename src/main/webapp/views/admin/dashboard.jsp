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
            <a href="${pageContext.request.contextPath}/admin/classes" class="nav-item">
                <span class="nav-icon material-symbols-outlined">menu_book</span>
                <span>Lớp học</span>
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
                    <p>Chỉ số hiệu suất thời gian thực và tăng trưởng người dùng.</p>
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
                            <%-- Kiểm tra chuỗi, nếu KHÔNG bắt đầu bằng dấu trừ '-' thì là số dương hoặc bằng 0 --%>
                            <c:when test="${not empty tutorGrowth && !tutorGrowth.startsWith('-')}">
                                <span class="kpi-badge green-badge">+${tutorGrowth}%</span>
                            </c:when>
                            <%-- Ngược lại, nếu chứa dấu trừ thì là số âm -> Hiện màu đỏ --%>
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
                            <%-- Kiểm tra chuỗi tương tự cho phần học viên --%>
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
                        <span class="kpi-badge red-badge">-2.1%</span>
                    </div>
                    <div class="kpi-label">Doanh thu tháng</div>
                    <div class="kpi-value">
                        <%-- Định dạng số sang tiền tệ Việt Nam (Ví dụ: 15,000,000 đ) --%>
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

            <div class="charts-row">
                <div class="chart-box large-chart">
                    <div class="chart-header">
                        <div>
                            <h3>Tăng trưởng người dùng</h3>
                            <p>Người dùng hoạt động hàng tháng trong năm hiện tại</p>
                        </div>
                        <div class="chart-legend">
                            <span class="legend-dot navy"></span> TỔNG CỘNG
                        </div>
                    </div>
                    <canvas id="userGrowthChart"></canvas>
                </div>
                <div class="chart-box small-chart">
                    <div class="chart-header">
                        <h3>Phân bố tài khoản</h3>
                        <select class="period-select">
                            <option>30 Ngày Qua</option>
                            <option>90 Ngày Qua</option>
                        </select>
                    </div>
                    <div class="donut-wrap">
                        <canvas id="roleChart"></canvas>
                        <div class="donut-center">
                            <span class="donut-center-num donut-num">0</span>
                            <span class="donut-sub">TỔNG CỘNG</span>
                        </div>
                    </div>
                    <div class="dist-legend">
                        <div class="dist-item">
                            <span class="dist-dot green-dot"></span>
                            <span>Học viên</span>
                            <span class="dist-pct">0%</span>
                        </div>
                        <div class="dist-item">
                            <span class="dist-dot navy-dot"></span>
                            <span>Gia sư</span>
                            <span class="dist-pct">0%</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="table-section">
                <div class="table-header">
                    <h3>Gia sư chờ duyệt</h3>
                    <span class="new-apps-badge"><c:out value="${not empty pendingCount ? pendingCount : '0'}" /> Đơn đăng ký mới</span>
                </div>
                <table class="data-table">
                    <thead>
                    <tr>
                        <th>Ảnh đại diện</th>
                        <th>TÊN GIA SƯ</th>
                        <th>Môn dạy</th>
                        <th>NGÀY ỨNG TUYỂN</th>
                        <th>Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty pendingTutors}">
                            <c:forEach items="${pendingTutors}" var="t">
                                <tr>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty t.avatarUrl && (t.avatarUrl.startsWith('http://') || t.avatarUrl.startsWith('https://'))}">
                                                <img class="table-avatar" src="${t.avatarUrl}" alt="Avatar" style="width:40px; height:40px; border-radius:50%; object-fit:cover;" onerror="this.onerror=null; this.src='https://ui-avatars.com/api/?name=${t.fullName}&background=random';">
                                            </c:when>
                                            <c:when test="${not empty t.avatarUrl}">
                                                <img class="table-avatar" src="${pageContext.request.contextPath}${t.avatarUrl}" alt="Avatar" style="width:40px; height:40px; border-radius:50%; object-fit:cover;" onerror="this.onerror=null; this.src='https://ui-avatars.com/api/?name=${t.fullName}&background=random';">
                                            </c:when>
                                            <c:otherwise>
                                                <img class="table-avatar" src="https://ui-avatars.com/api/?name=${t.fullName}&background=random" alt="Avatar" style="width:40px; height:40px; border-radius:50%;">
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="name-cell"><strong><c:out value="${t.fullName}"/></strong></td>
                                    <td><span class="subject-tag"><c:out value="${t.teachingSubject}"/></span></td>
                                    <td class="date-cell"><c:out value="${t.appliedDate}"/></td>
                                    <td class="action-cell">
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

            <div class="table-section" style="margin-top:24px;">
                <div class="table-header">
                    <h3 class="reported-title"><span class="material-symbols-outlined">notifications</span> Gia sư bị báo cáo</h3>
                    <a href="#" class="view-all-link">Xem tất cả báo cáo</a>
                </div>
                <table class="data-table">
                    <thead>
                    <tr>
                        <th>TÊN GIA SƯ</th>
                        <th>LÝ DO VI PHẠM</th>
                        <th>HÀNH ĐỘNG</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty reportedTutors}">
                            <c:forEach items="${reportedTutors}" var="r">
                                <tr>
                                    <td class="name-cell"><strong>${r.fullName}</strong></td>
                                    <td>
                                        <c:forEach items="${r.violations}" var="v">
                                            <span class="violation-tag">${v}</span>
                                        </c:forEach>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/lock-user?id=${r.tutorId}" class="btn-lock" style="text-decoration:none;">Khóa tài khoản</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td class="name-cell"><strong>Lê Văn Hùng</strong></td>
                                <td>
                                    <span class="violation-tag">BỎ TIẾT HỌC</span>
                                    <span class="violation-tag">NHIỀU BÁO CÁO</span>
                                </td>
                                <td><a href="#" class="btn-lock" style="text-decoration:none;">Khóa tài khoản</a></td>
                            </tr>
                            <tr>
                                <td class="name-cell"><strong>Phạm Minh Đức</strong></td>
                                <td><span class="violation-tag">SPAM</span></td>
                                <td><a href="#" class="btn-lock" style="text-decoration:none;">Khóa tài khoản</a></td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>

            <footer class="page-footer">
                © 2026 Gia Sư Bá Đạo VN • Giao diện quản trị hệ thống
            </footer>

        </div>
    </div>
</div>

<script>
    window.addEventListener('DOMContentLoaded', function() {
        const growthData    = ${not empty chartJson ? chartJson : '[]'};
        const totalTutors   = Number('${totalTutors}') || 0;
        const totalStudents = Number('${totalStudents}') || 0;

        const canvasBar = document.getElementById('userGrowthChart');
        if (canvasBar) {
            const barCtx = canvasBar.getContext('2d');
            new Chart(barCtx, {
                type: 'bar',
                data: {
                    labels: ['T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12'],
                    datasets: [{
                        label: 'Người dùng mới',
                        data: growthData,
                        backgroundColor: '#1a2f5a',
                        borderRadius: 8,
                        borderSkipped: false
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
                            grid: { color: '#f1f5f9' },
                            ticks: { color: '#94a3b8', precision: 0 }
                        }
                    }
                }
            });
        }

        // Tính toán phân bổ biểu đồ tròn
        const totalAll   = totalTutors + totalStudents;
        // Nếu database chưa có dữ liệu, dùng giá trị mặc định (85-15) để biểu đồ hiển thị đẹp mắt, tránh chia cho 0
        const studentPct = totalAll > 0 ? Math.round(totalStudents / totalAll * 100) : 85;
        const tutorPct   = totalAll > 0 ? Math.round(totalTutors / totalAll * 100) : 15;

        const studentLabel = document.querySelector('.dist-item:nth-child(1) .dist-pct');
        const tutorLabel   = document.querySelector('.dist-item:nth-child(2) .dist-pct');
        const totalLabel   = document.querySelector('.donut-num');

        if (studentLabel) studentLabel.textContent = studentPct + '%';
        if (tutorLabel) tutorLabel.textContent = tutorPct + '%';
        if (totalLabel) {
            totalLabel.textContent = totalAll >= 1000 ? (totalAll / 1000).toFixed(1) + 'k' : totalAll;
        }

        const canvasDonut = document.getElementById('roleChart');
        if (canvasDonut) {
            const donutCtx = canvasDonut.getContext('2d');
            new Chart(donutCtx, {
                type: 'doughnut',
                data: {
                    datasets: [{
                        data: [studentPct, tutorPct],
                        backgroundColor: ['#10b981', '#1a2f5a'],
                        borderWidth: 0
                    }]
                },
                options: {
                    responsive: false,
                    cutout: '78%',
                    plugins: { legend: { display: false }, tooltip: { enabled: false } }
                }
            });
        }
    });
</script>
</body>
</html>