<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý tài khoản - Gia Sư Bá Đạo</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            margin: 0;
            padding: 24px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }

        h1 {
            margin: 0;
            color: #1f2937;
        }

        .back-link {
            text-decoration: none;
            color: #2563eb;
            font-weight: bold;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 14px rgba(0,0,0,0.08);
        }

        th, td {
            padding: 14px 16px;
            border-bottom: 1px solid #e5e7eb;
            text-align: left;
            font-size: 14px;
        }

        th {
            background: #111827;
            color: white;
        }

        .status-active {
            color: #15803d;
            font-weight: bold;
        }

        .status-locked {
            color: #dc2626;
            font-weight: bold;
        }

        .btn {
            border: none;
            padding: 8px 12px;
            border-radius: 8px;
            color: white;
            cursor: pointer;
            font-weight: bold;
        }

        .btn-lock {
            background: #dc2626;
        }

        .btn-unlock {
            background: #16a34a;
        }

        .badge {
            display: inline-block;
            padding: 4px 8px;
            background: #e0f2fe;
            color: #0369a1;
            border-radius: 999px;
            font-size: 12px;
            font-weight: bold;
        }

        .message {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 16px;
        }

        .success {
            background: #dcfce7;
            color: #166534;
        }

        .error {
            background: #fee2e2;
            color: #991b1b;
        }
    </style>
</head>
<body>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="page-header">
    <div>
        <h1>Quản lý tài khoản</h1>
        <p>Admin xem danh sách người dùng và khóa/mở tài khoản.</p>
    </div>

    <a class="back-link" href="${ctx}/admin/dashboard">← Về Dashboard</a>
</div>

<c:if test="${param.success == 'updated'}">
    <div class="message success">Cập nhật trạng thái tài khoản thành công.</div>
</c:if>

<c:if test="${param.error == 'cannot-lock-admin'}">
    <div class="message error">Không thể khóa tài khoản admin mặc định.</div>
</c:if>

<c:if test="${param.error == 'invalid-id'}">
    <div class="message error">ID tài khoản không hợp lệ.</div>
</c:if>

<table>
    <thead>
    <tr>
        <th>ID</th>
        <th>Họ tên</th>
        <th>Email</th>
        <th>SĐT</th>
        <th>Vai trò</th>
        <th>Ngày tạo</th>
        <th>Trạng thái</th>
        <th>Hành động</th>
    </tr>
    </thead>

    <tbody>
    <c:forEach var="u" items="${users}">
        <tr>
            <td>#${u.id}</td>
            <td>${u.fullname}</td>
            <td>${u.email}</td>
            <td>
                <c:choose>
                    <c:when test="${not empty u.phone}">
                        ${u.phone}
                    </c:when>
                    <c:otherwise>
                        Chưa có
                    </c:otherwise>
                </c:choose>
            </td>
            <td>
                <span class="badge">${u.roleName}</span>
            </td>
            <td>${u.createdAt}</td>
            <td>
                <c:choose>
                    <c:when test="${u.active}">
                        <span class="status-active">Hoạt động</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status-locked">Bị khóa</span>
                    </c:otherwise>
                </c:choose>
            </td>
            <td>
                <c:if test="${u.id != 1}">
                    <form action="${ctx}/admin/users/toggle" method="post" style="display:inline;">
                        <input type="hidden" name="id" value="${u.id}"/>

                        <c:choose>
                            <c:when test="${u.active}">
                                <input type="hidden" name="action" value="lock"/>
                                <button class="btn btn-lock" type="submit"
                                        onclick="return confirm('Bạn chắc chắn muốn khóa tài khoản này?')">
                                    Khóa
                                </button>
                            </c:when>

                            <c:otherwise>
                                <input type="hidden" name="action" value="unlock"/>
                                <button class="btn btn-unlock" type="submit"
                                        onclick="return confirm('Bạn chắc chắn muốn mở khóa tài khoản này?')">
                                    Mở khóa
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </form>
                </c:if>

                <c:if test="${u.id == 1}">
                    Admin mặc định
                </c:if>
            </td>
        </tr>
    </c:forEach>

    <c:if test="${empty users}">
        <tr>
            <td colspan="8">Chưa có tài khoản nào.</td>
        </tr>
    </c:if>
    </tbody>
</table>

</body>
</html>