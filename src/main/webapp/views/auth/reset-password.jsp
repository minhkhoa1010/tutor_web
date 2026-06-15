<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<jsp:include page="/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Đặt lại mật khẩu"/>
</jsp:include>

<jsp:include page="/views/common/navbar.jsp"/>

<main style="
        min-height:70vh;
        display:flex;
        justify-content:center;
        align-items:center;
        background:#f8fafc;
">

    <div style="
            width:100%;
            max-width:500px;
            background:white;
            padding:32px;
            border-radius:16px;
            box-shadow:0 10px 25px rgba(0,0,0,.08);
    ">

        <h2 style="
                text-align:center;
                margin-bottom:20px;
        ">
            Đặt lại mật khẩu
        </h2>

        <c:if test="${not empty error}">
            <div style="
                    background:#fef2f2;
                    color:#dc2626;
                    padding:12px;
                    border-radius:8px;
                    margin-bottom:16px;
            ">
                    ${error}
            </div>
        </c:if>

        <c:if test="${not empty token}">

            <form method="post"
                  action="${pageContext.request.contextPath}/reset-password">

                <input type="hidden"
                       name="token"
                       value="${token}">

                <div style="margin-bottom:16px;">
                    <label>Mật khẩu mới</label>

                    <input
                            type="password"
                            name="password"
                            required
                            minlength="6"
                            style="
                            width:100%;
                            padding:12px;
                            border:1px solid #cbd5e1;
                            border-radius:8px;
                            margin-top:8px;
                        ">
                </div>

                <div style="margin-bottom:16px;">
                    <label>Xác nhận mật khẩu</label>

                    <input
                            type="password"
                            name="confirmPassword"
                            required
                            minlength="6"
                            style="
                            width:100%;
                            padding:12px;
                            border:1px solid #cbd5e1;
                            border-radius:8px;
                            margin-top:8px;
                        ">
                </div>

                <button
                        type="submit"
                        style="
                        width:100%;
                        padding:12px;
                        border:none;
                        border-radius:8px;
                        background:#0d9488;
                        color:white;
                        font-weight:600;
                        cursor:pointer;
                    ">
                    Đổi mật khẩu
                </button>

            </form>

        </c:if>

    </div>

</main>

<jsp:include page="/views/common/footer.jsp"/>