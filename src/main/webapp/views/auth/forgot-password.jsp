<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<c:set var="pageTitle" value="Quên mật khẩu" scope="request"/>

<jsp:include page="/views/common/header.jsp"/>

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
            background:#fff;
            padding:32px;
            border-radius:16px;
            box-shadow:0 10px 25px rgba(0,0,0,.08);
    ">

        <h2 style="
                margin-bottom:10px;
                color:#0f172a;
                text-align:center;
        ">
            Quên mật khẩu
        </h2>

        <p style="
                text-align:center;
                color:#64748b;
                margin-bottom:24px;
        ">
            Nhập email để nhận liên kết đặt lại mật khẩu
        </p>

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

        <c:if test="${not empty success}">
            <div style="
                    background:#ecfdf5;
                    color:#059669;
                    padding:12px;
                    border-radius:8px;
                    margin-bottom:16px;
            ">
                    ${success}
            </div>
        </c:if>

        <form method="post"
              action="${pageContext.request.contextPath}/forgot-password">

            <input
                    type="email"
                    name="email"
                    required
                    placeholder="Nhập email"
                    style="
                        width:100%;
                        padding:12px;
                        border:1px solid #cbd5e1;
                        border-radius:8px;
                        margin-bottom:16px;
                    "
            >

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
                    "
            >
                Tạo liên kết đặt lại mật khẩu
            </button>

        </form>

        <c:if test="${not empty resetLink}">

            <div style="
                    margin-top:24px;
                    padding:16px;
                    border:1px solid #bae6fd;
                    background:#f0f9ff;
                    border-radius:12px;
            ">

                <div style="
                        font-weight:600;
                        margin-bottom:8px;
                        color:#0369a1;
                ">
                    Liên kết đặt lại mật khẩu
                </div>

                <a href="${resetLink}"
                   target="_blank"
                   style="
                        word-break:break-all;
                        color:#2563eb;
                   ">
                        ${resetLink}
                </a>

            </div>

        </c:if>

    </div>

</main>

<jsp:include page="/views/common/footer.jsp"/>