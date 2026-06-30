<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Báo cáo & thống kê – Gia Sư Bá Đạo VN</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" />

    <style>
        .report-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(180px, 1fr));
            gap: 18px;
            margin-bottom: 24px;
        }

        .report-card {
            background: #ffffff;
            border-radius: 16px;
            padding: 22px;
            box-shadow: 0 4px 16px rgba(15, 23, 42, 0.08);
        }

        .report-card .label {
            color: #64748b;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 10px;
        }

        .report-card .value {
            color: #0f172a;
            font-size: 28px;
            font-weight: 800;
        }

        .export-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(220px, 1fr));
            gap: 18px;
            margin-top: 20px;
        }

        .export-box {
            background: #ffffff;
            border-radius: 16px;
            padding: 22px;
            box-shadow: 0 4px 16px rgba(15, 23, 42, 0.08);
        }

        .export-box h3 {
            margin: 0 0 8px 0;
            color: #0f172a;
        }

        .export-box p {
            color: #64748b;
            min-height: 42px;
        }

        .btn-export {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-decoration: none;
            border-radius: 10px;
            padding: 10px 14px;
            background: #0f172a;
            color: #ffffff;
            font-weight: 700;
            font-size: 14px;
        }

        .btn-export:hover {
            background: #1e293b;
        }
    </style>
</head>

<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="admin-wrapper">

        <jsp:include page="/views/admin/common/sidebar.jsp" />

    <div class="main-content">

        <header class="topbar">
            <div class="topbar-brand">
                <span class="brand-dot"></span>
                <span class="brand-name">Gia Sư Bá Đạo VN</span>
            </div>

            <div class="topbar-search">
                <span class="search-icon material-symbols-outlined">search</span>
                <input type="text" placeholder="Tìm kiếm báo cáo...">
            </div>

            <nav class="topbar-links">
                <a href="#">Trợ giúp</a>
                <a href="#">Báo cáo</a>
            </nav>

            <div class="topbar-actions">
                <button class="icon-btn notif-btn">
                    <span class="material-symbols-outlined">notifications</span>
                    <span class="notif-dot"></span>
                </button>

                <button class="icon-btn">
                    <span class="material-symbols-outlined">mail</span>
                </button>

                <img class="avatar-sm"
                     src="${not empty sessionScope.clientUser.avatarUrl ? sessionScope.clientUser.avatarUrl : 'https://ui-avatars.com/api/?name=Admin+User&background=1a2f5a&color=fff'}"
                     alt="Admin">
            </div>
        </header>

        <div class="page-body">

            <div class="page-title-row">
                <div>
                    <h1>Báo cáo & thống kê</h1>
                    <p>Xem báo cáo lớp học, doanh thu, lượng người dùng và xuất file báo cáo CSV.</p>
                </div>
            </div>

            <div class="report-grid">
                <div class="report-card">
                    <div class="label">Tổng người dùng</div>
                    <div class="value">${totalUsers}</div>
                </div>

                <div class="report-card">
                    <div class="label">Người dùng hoạt động</div>
                    <div class="value">${activeUsers}</div>
                </div>

                <div class="report-card">
                    <div class="label">Tổng gia sư</div>
                    <div class="value">${totalTutors}</div>
                </div>

                <div class="report-card">
                    <div class="label">Tổng lớp học</div>
                    <div class="value">${totalBookings}</div>
                </div>

                <div class="report-card">
                    <div class="label">Lớp đã hoàn thành</div>
                    <div class="value">${completedBookings}</div>
                </div>

                <div class="report-card">
                    <div class="label">Giao dịch tháng này</div>
                    <div class="value">
                        <fmt:formatNumber value="${monthlyTransactionAmount}" type="number"/>đ
                    </div>
                </div>

                <div class="report-card">
                    <div class="label">Tổng giao dịch thành công</div>
                    <div class="value">
                        <fmt:formatNumber value="${totalTransactionAmount}" type="number"/>đ
                    </div>
                </div>
            </div>

            <div class="table-section">
                <div class="table-header">
                    <h3>Xuất file báo cáo</h3>
                    <span class="new-apps-badge">CSV</span>
                </div>

                <div class="export-grid">
                    <div class="export-box">
                        <h3>Thống kê người dùng</h3>
                        <p>Xuất danh sách người dùng, vai trò, trạng thái tài khoản.</p>
                        <a class="btn-export" href="${ctx}/admin/reports/export?type=users">
                            <span class="material-symbols-outlined">download</span>
                            Xuất user CSV
                        </a>
                    </div>

                    <div class="export-box">
                        <h3>Báo cáo lớp học</h3>
                        <p>Xuất danh sách lớp học, phụ huynh, gia sư, trạng thái.</p>
                        <a class="btn-export" href="${ctx}/admin/reports/export?type=bookings">
                            <span class="material-symbols-outlined">download</span>
                            Xuất lớp học CSV
                        </a>
                    </div>

                    <div class="export-box">
                        <h3>Báo cáo doanh thu</h3>
                        <p>Xuất lịch sử giao dịch, số tiền, trạng thái thanh toán.</p>
                        <a class="btn-export" href="${ctx}/admin/reports/export?type=revenue">
                            <span class="material-symbols-outlined">download</span>
                            Xuất doanh thu CSV
                        </a>
                    </div>
                </div>
            </div>

            <footer class="page-footer">
                © 2026 Gia Sư Bá Đạo VN • Giao diện quản trị hệ thống
            </footer>
        </div>
    </div>
</div>

</body>
</html>