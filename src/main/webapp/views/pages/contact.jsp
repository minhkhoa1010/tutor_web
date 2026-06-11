<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<jsp:include page="/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Liên hệ - Gia Sư Bá Đạo"/>
    <jsp:param name="pageCss" value="/assets/css/contact.css"/>
</jsp:include>

<jsp:include page="/views/common/navbar.jsp"/>

<!-- Hero -->
<section class="contact-hero">
    <div class="hero-content">
        <span class="hero-badge">
            <i class="fa-solid fa-headset"></i>
            Hỗ trợ khách hàng 24/7
        </span>

        <h1>Liên Hệ Với Chúng Tôi</h1>

        <p>
            Đội ngũ Gia Sư Bá Đạo luôn sẵn sàng hỗ trợ phụ huynh,
            học sinh và gia sư trong quá trình sử dụng hệ thống.
        </p>
    </div>
</section>

<!-- Contact Section -->
<section class="contact-section">

    <!-- Left -->
    <div class="contact-info-card">

        <h2>Thông Tin Liên Hệ</h2>

        <div class="info-item">
            <div class="icon-box">
                <i class="fa-solid fa-location-dot"></i>
            </div>
            <div>
                <h4>Địa chỉ</h4>
                <p>
                    Trường Đại học Nông Lâm TP.HCM<br>
                    Khu phố 6, Phường Linh Trung,<br>
                    TP. Thủ Đức, TP.HCM
                </p>
            </div>
        </div>

        <div class="info-item">
            <div class="icon-box">
                <i class="fa-solid fa-phone"></i>
            </div>
            <div>
                <h4>Điện thoại</h4>
                <p>0909 999 999</p>
            </div>
        </div>

        <div class="info-item">
            <div class="icon-box">
                <i class="fa-solid fa-envelope"></i>
            </div>
            <div>
                <h4>Email</h4>
                <p>support@giasubadao.vn</p>
            </div>
        </div>

        <div class="info-item">
            <div class="icon-box">
                <i class="fa-solid fa-clock"></i>
            </div>
            <div>
                <h4>Giờ làm việc</h4>
                <p>08:00 - 22:00 (Thứ 2 - Chủ Nhật)</p>
            </div>
        </div>

    </div>

    <!-- Right -->
    <div class="contact-form-card">

        <div class="form-header">
            <h2>Gửi Yêu Cầu Hỗ Trợ</h2>
            <p>
                Hãy để lại thông tin, chúng tôi sẽ phản hồi
                trong thời gian sớm nhất.
            </p>
        </div>

        <form action="${pageContext.request.contextPath}/submit-contact"
              method="post"
              class="contact-form">

            <div class="input-group">
                <i class="fa-solid fa-user"></i>
                <input type="text"
                       name="fullName"
                       placeholder="Họ và tên"
                       required>
            </div>

            <div class="input-group">
                <i class="fa-solid fa-envelope"></i>
                <input type="email"
                       name="email"
                       placeholder="Email"
                       required>
            </div>

            <div class="input-group">
                <i class="fa-solid fa-phone"></i>
                <input type="text"
                       name="phone"
                       placeholder="Số điện thoại">
            </div>

            <div class="input-group textarea-group">
                <i class="fa-solid fa-message"></i>
                <textarea
                        name="message"
                        rows="6"
                        placeholder="Nội dung cần hỗ trợ..."
                        required></textarea>
            </div>

            <button type="submit" class="btn-send">
                <i class="fa-solid fa-paper-plane"></i>
                Gửi Yêu Cầu
            </button>

        </form>
    </div>

</section>

<!-- Map -->
<section class="map-section">

    <div class="map-header">
        <h2>Vị Trí Của Chúng Tôi</h2>
        <p>Đại học Nông Lâm Thành phố Hồ Chí Minh</p>
    </div>

    <div class="map-wrapper">
        <iframe
                src="https://maps.google.com/maps?q=Đại%20học%20Nông%20Lâm%20TPHCM&t=&z=15&ie=UTF8&iwloc=&output=embed"
                allowfullscreen>
        </iframe>
    </div>

</section>

<!-- Footer -->
<jsp:include page="/views/common/footer.jsp"/>

</body>
</html>