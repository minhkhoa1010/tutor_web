<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- Đổi URI cũ sang chuẩn Jakarta để ép JSTL hoạt động đúng --%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<jsp:include page="/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Trang chủ - Gia Sư Bá Đạo"/>
    <jsp:param name="pageCss" value="/assets/css/home.css"/>
</jsp:include>

<jsp:include page="/views/common/navbar.jsp"/>

<%-- ĐIỀU KIỆN LINH HOẠT: Kiểm tra vai trò TUTOR và trạng thái hồ sơ gửi từ Servlet --%>
<c:if test="${not empty sessionScope.clientUser}">

    <%-- TRƯỜNG HỢP 1: Hồ sơ đang chờ xét duyệt (PENDING) --%>
    <c:if test="${tutorStatus eq 'PENDING'}">
        <div style="background-color: #fef3c7; border-left: 4px solid #d97706; padding: 16px; margin: 15px 0; border-radius: 6px; color: #92400e; font-size: 14px; display: flex; align-items: flex-start; gap: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.05);">
            <svg style="width: 20px; height: 20px; color: #d97706; flex-shrink: 0; margin-top: 1px;" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 6v6h4.5m4.5 0a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" />
            </svg>
            <div>
                <span style="font-weight: 700; font-size: 15px; display: block; margin-bottom: 2px;">Hồ sơ đang chờ phê duyệt</span>
                Hệ thống đang tiến hành xác thực thông tin tài khoản của bạn. Tiến trình này thường hoàn tất trong vòng 24 giờ. Quyền truy cập bảng điều khiển sẽ tự động mở khóa ngay sau khi được phê duyệt.
            </div>
        </div>
    </c:if>

    <%-- TRƯỜNG HỢP 2: Hồ sơ bị từ chối xét duyệt (REJECTED) --%>
    <c:if test="${tutorStatus eq 'REJECTED'}">
        <div style="background-color: #fee2e2; border-left: 4px solid #dc2626; padding: 16px; margin: 15px 0; border-radius: 6px; color: #991b1b; font-size: 14px; display: flex; align-items: flex-start; gap: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.05);">
            <svg style="width: 20px; height: 20px; color: #dc2626; flex-shrink: 0; margin-top: 1px;" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="m9.75 9.75 4.5 4.5m0-4.5-4.5 4.5M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" />
            </svg>
            <div>
                <span style="font-weight: 700; font-size: 15px; display: block; margin-bottom: 2px;">Yêu cầu xét duyệt bị từ chối</span>
                Hồ sơ ứng tuyển thành viên của bạn chưa đáp ứng đủ các tiêu chí minh bạch hoặc thiếu chứng chỉ đính kèm.
                Vui lòng <a href="${pageContext.request.contextPath}/tutor/resubmit-profile" style="color: #b91c1c; font-weight: 600; text-decoration: underline; transition: color 0.2s;">nhấp vào đây để bổ sung hồ sơ năng lực</a>.
            </div>
        </div>
    </c:if>

</c:if>
<main class="page-main">
    <div class="container">
        <section class="hero hero-modern">
            <div class="hero-copy">
                <span class="badge">Hệ thống gia sư 5 sao</span>
                <h1 class="hero-title">Khai mở tiềm năng cùng Gia sư tinh hoa</h1>
                <p class="hero-sub">Kết nối nhanh phụ huynh với đội ngũ gia sư xuất sắc. Học tập cá nhân hóa, lộ trình rõ ràng, lịch học linh hoạt.</p>
                <form class="search-panel" method="get" action="<%= request.getContextPath() %>/tutors/search">
                    <div class="search-row">
                        <input class="input-field" type="text" name="keyword" placeholder="Môn học, lớp học hoặc kỹ năng...">
                        <button class="btn btn-primary" type="submit">Tìm gia sư ngay</button>
                    </div>
                    <div class="search-grid">
                        <div class="form-group">
                            <label class="label">Môn dạy</label>
                            <select class="select-field" name="subjectId">
                                <option value="">Chọn môn</option>
                                <option value="1">Toán</option>
                                <option value="2">Lý</option>
                                <option value="3">Hóa</option>
                                <option value="4">Văn</option>
                                <option value="5">Tiếng Việt</option>
                                <option value="6">Anh Văn</option>
                                <option value="7">TOEIC</option>
                                <option value="8">IELTS</option>
                                <option value="9">Tiếng Nhật</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="label">Lớp dạy</label>
                            <select class="select-field" name="gradeId">
                                <option value="">Chọn lớp</option>
                                <option value="1">Lớp 1</option>
                                <option value="2">Lớp 2</option>
                                <option value="3">Lớp 3</option>
                                <option value="4">Lớp 4</option>
                                <option value="5">Lớp 5</option>
                                <option value="6">Lớp 6</option>
                                <option value="7">Lớp 7</option>
                                <option value="8">Lớp 8</option>
                                <option value="9">Lớp 9</option>
                                <option value="10">Lớp 10</option>
                                <option value="11">Lớp 11</option>
                                <option value="12">Lớp 12</option>
                                <option value="13">Ôn Thi Đại Học</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="label">Khu vực dạy</label>
                            <select class="select-field" name="districtId">
                                <option value="">Chọn khu vực</option>
                                <option value="1">Quận 1</option>
                                <option value="2">Quận 2</option>
                                <option value="3">Quận 3</option>
                                <option value="4">Quận 4</option>
                                <option value="5">Quận 5</option>
                                <option value="6">Quận 7</option>
                                <option value="7">Thủ Đức</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="label">Thời gian dạy</label>
                            <select class="select-field" name="scheduleId">
                                <option value="">Chọn thời gian</option>
                                <option value="1">Sáng Thứ 2</option>
                                <option value="2">Chiều Thứ 2</option>
                                <option value="3">Tối Thứ 2</option>
                                <option value="4">Sáng Thứ 3</option>
                                <option value="5">Chiều Thứ 3</option>
                                <option value="6">Tối Thứ 3</option>
                                <option value="7">Sáng Thứ 4</option>
                                <option value="8">Chiều Thứ 4</option>
                                <option value="9">Tối Thứ 4</option>
                                <option value="10">Sáng Thứ 5</option>
                                <option value="11">Chiều Thứ 5</option>
                                <option value="12">Tối Thứ 5</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="label">Hình thức</label>
                            <select class="select-field" name="teachingMode">
                                <option value="">Chọn hình thức</option>
                                <option value="ONLINE">Online</option>
                                <option value="OFFLINE">Trực tiếp</option>
                                <option value="BOTH">Linh hoạt</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="label">Học phí (từ)</label>
                            <input class="input-field" type="number" name="minRate" placeholder="VD: 200000">
                        </div>
                        <div class="form-group">
                            <label class="label">Học phí (đến)</label>
                            <input class="input-field" type="number" name="maxRate" placeholder="VD: 700000">
                        </div>
                        <div class="form-group">
                            <label class="label">Giới tính</label>
                            <select class="select-field" name="gender">
                                <option value="">Chọn giới tính</option>
                                <option value="MALE">Nam</option>
                                <option value="FEMALE">Nữ</option>
                                <option value="OTHER">Khác</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="label">Trình độ</label>
                            <select class="select-field" name="degreeLevel">
                                <option value="">Chọn trình độ</option>
                                <option value="COLLEGE">Cao đẳng</option>
                                <option value="BACHELOR">Đại học</option>
                                <option value="MASTER">Thạc sĩ</option>
                                <option value="PHD">Tiến sĩ</option>
                                <option value="OTHER">Khác</option>
                            </select>
                        </div>
                    </div>
                </form>
                <div class="hero-highlights">
                    <div class="highlight-item"><span class="icon-dot"></span> Bảo mật thông tin</div>
                    <div class="highlight-item"><span class="icon-dot"></span> 20,000+ gia sư</div>
                    <div class="highlight-item"><span class="icon-dot"></span> Hồ sơ minh bạch</div>
                    <div class="highlight-item"><span class="icon-dot"></span> Hỗ trợ 24/7</div>
                </div>
            </div>
            <div class="hero-visual">
                <div class="hero-illustration"></div>
                <div class="hero-stat">
                    <div class="hero-stat-title">10,000+</div>
                    <div class="meta">Gia sư chất lượng cao</div>
                </div>
            </div>
        </section>

        <section class="section">
            <div class="section-header">
                <div>
                    <h2 class="section-title">Gia sư tiêu biểu</h2>
                    <div class="section-sub">Những người dẫn dắt tận tâm được cộng đồng đánh giá cao nhất.</div>
                </div>
                <a class="section-link" href="${pageContext.request.contextPath}/tutors">Xem tất cả</a>
            </div>
            <div class="tutor-grid">
                <%-- SỬ DỤNG JSTL ĐỂ LẶP QUA DANH SÁCH GIA SƯ ĐỘNG --%>
                <c:choose>
                    <c:when test="${not empty featuredTutors}">
                        <c:forEach var="tutor" items="${featuredTutors}">
                            <article class="tutor-card">
                                <div class="tutor-top">
                                    <div class="tutor-avatar"
                                         style="background-image: url('${not empty tutor.avatarUrl ? tutor.avatarUrl : pageContext.request.contextPath.concat('/assets/images/default-avatar.png')}');
                                                 background-size: cover; background-position: center;">
                                    </div>
                                    <span class="rating-pill">${tutor.ratingAverage > 0 ? tutor.ratingAverage : '0.0'}</span>
                                </div>

                                <h3><c:out value="${tutor.fullName}"/></h3>
                                <div class="meta" style="margin-bottom: 12px;">
                                    <span style="font-weight: 600; color: #1f2937;"><c:out value="${tutor.qualification}"/></span>
                                    <c:if test="${not empty tutor.school}">
                                        <div style="display: flex; align-items: center; gap: 6px; font-size: 13px; color: #4b5563; margin-top: 4px;">
                                            <svg style="width: 15px; height: 15px; color: #6b7280; flex-shrink: 0;" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                                                <path stroke-linecap="round" stroke-linejoin="round" d="M12 21v-8.25M15.75 21v-8.25M8.25 21v-8.25M3 9l9-6 9 6m-1.5 12V10.332A48.36 48.36 0 0 0 12 9.75c-2.551 0-5.056.2-7.5.582V21M3 21h18M12 6.75h.008v.008H12V6.75Z" />
                                            </svg>
                                            <span><c:out value="${tutor.school}"/> (<c:out value="${tutor.major}"/>)</span>
                                        </div>
                                    </c:if>
                                </div>

                                <div class="tutor-tags" style="display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 12px;">
    <span class="tag-pill" style="display: inline-flex; align-items: center; gap: 4px; padding: 4px 10px; background: #f3f4f6; border-radius: 20px; font-size: 12px; color: #374151;">
        <svg style="width: 14px; height: 14px; color: #4b5563;" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M12 6.042A8.967 8.967 0 0 0 6 3.75c-1.052 0-2.062.18-3 .512v14.25A8.987 8.987 0 0 1 6 18c2.305 0 4.408.867 6 2.292m0-14.25a8.966 8.966 0 0 1 6-2.292c1.052 0 2.062.18 3 .512v14.25A8.987 8.987 0 0 0 18 18a8.967 8.967 0 0 0-6 2.292m0-14.25v14.25" />
        </svg>
        <c:out value="${tutor.teachingSubject}"/>
    </span>

                                    <c:if test="${not empty tutor.teachingGrade}">
        <span class="tag-pill" style="display: inline-flex; align-items: center; gap: 4px; padding: 4px 10px; background: #f3f4f6; border-radius: 20px; font-size: 12px; color: #374151;">
            <svg style="width: 14px; height: 14px; color: #4b5563;" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M4.26 10.174c-.053-.462.19-1.01.621-1.213L11.43 5.75a1.125 1.125 0 0 1 1.012 0l6.548 3.211c.43.203.673.75.62 1.213a35.53 35.53 0 0 1-.745 4.78c-.242 1.173-1.061 2.082-2.24 2.584l-3.492 1.487a1.125 1.125 0 0 1-.866 0l-3.492-1.487c-1.18-.502-1.998-1.411-2.24-2.584a35.531 35.531 0 0 1-.745-4.78ZM19.5 10.5v5.25c0 1.242-1.008 2.25-2.25 2.25h-1.5M4.5 10.5v5.25c0 1.242 1.008 2.25 2.25 2.25h1.5" />
            </svg>
            Lớp: <c:out value="${tutor.teachingGrade}"/>
        </span>
                                    </c:if>

                                    <span class="tag-pill" style="display: inline-flex; align-items: center; gap: 4px; padding: 4px 10px; background: #f3f4f6; border-radius: 20px; font-size: 12px; color: #374151;">
        <svg style="width: 14px; height: 14px; color: #4b5563;" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M15 10.5a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z" />
            <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 10.5c0 7.142-7.5 11.25-7.5 11.25S4.5 17.642 4.5 10.5a7.5 7.5 0 1 1 15 0Z" />
        </svg>
        <c:out value="${tutor.teachingArea}"/>
    </span>

                                    <c:choose>
                                        <c:when test="${not empty tutor.availableSchedules}">
            <span class="tag-pill" title="${tutor.availableSchedules}" style="display: inline-flex; align-items: center; gap: 4px; padding: 4px 10px; background: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 20px; font-size: 12px; color: #16a34a; font-weight: 500; max-width: 100%; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                <svg style="width: 14px; height: 14px; color: #16a34a; flex-shrink: 0;" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0v-7.5A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 11.25v7.5" />
                </svg>
                Lịch: <c:out value="${tutor.availableSchedules}"/>
            </span>
                                        </c:when>
                                        <c:otherwise>
            <span class="tag-pill" style="display: inline-flex; align-items: center; gap: 4px; padding: 4px 10px; background: #fef2f2; border: 1px solid #fee2e2; border-radius: 20px; font-size: 12px; color: #991b1b; font-style: italic;">
                Chưa đăng ký lịch rảnh
            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <c:if test="${not empty tutor.experienceSummary}">
                                    <p style="font-size: 13px; color: #6b7280; margin: 8px 0; line-height: 1.5; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                        <c:out value="${tutor.experienceSummary}"/>
                                    </p>
                                </c:if>

                                <div class="tutor-actions">
            <span class="price">
                <fmt:formatNumber value="${tutor.hourlyRate}" type="number" groupingUsed="true"/>đ/buổi
            </span>
                                    <a class="btn btn-outline" href="${pageContext.request.contextPath}/tutors/detail?id=${tutor.tutorId}">Hồ sơ chi tiết</a>
                                </div>
                            </article>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div style="grid-column: 1 / -1; text-align: center; color: #6b7280; padding: 40px 0;">
                            Hiện tại chưa có gia sư tiêu biểu nào được phê duyệt.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <section class="section">
            <h2 class="section-title center-title">Lớp học mới nhất</h2>
            <div class="section-sub center-sub">Cơ hội giảng dạy hấp dẫn dành cho gia sư tận tâm. Đăng ký nhận lớp ngay hôm nay.</div>
            <div class="class-list">
                <div class="class-item">
                    <div>
                        <div class="class-name">Toán nâng cao lớp 8</div>
                        <div class="meta">Đăng 2 giờ trước</div>
                        <div class="class-tags">
                            <span class="tag-pill">Quận 1, TP.HCM</span>
                            <span class="tag-pill">3,500,000đ/tháng</span>
                            <span class="tag-pill">Trực tiếp</span>
                            <span class="tag-pill">3 buổi/tuần</span>
                        </div>
                    </div>
                    <button class="btn btn-primary">Nhận lớp ngay</button>
                </div>
                <div class="class-item">
                    <div>
                        <div class="class-name">Tiếng Anh giao tiếp</div>
                        <div class="meta">Đăng 5 giờ trước</div>
                        <div class="class-tags">
                            <span class="tag-pill">Online (toàn quốc)</span>
                            <span class="tag-pill">4,200,000đ/tháng</span>
                            <span class="tag-pill">Online</span>
                            <span class="tag-pill">2 buổi/tuần</span>
                        </div>
                    </div>
                    <button class="btn btn-primary">Nhận lớp ngay</button>
                </div>
                <div class="class-item">
                    <div>
                        <div class="class-name">Vật lý lớp 11</div>
                        <div class="meta">Đăng 8 giờ trước</div>
                        <div class="class-tags">
                            <span class="tag-pill">Cầu Giấy, Hà Nội</span>
                            <span class="tag-pill">2,800,000đ/tháng</span>
                            <span class="tag-pill">Trực tiếp</span>
                            <span class="tag-pill">2 buổi/tuần</span>
                        </div>
                    </div>
                    <button class="btn btn-primary">Nhận lớp ngay</button>
                </div>
            </div>
        </section>

        <section class="section process process-split">
            <div class="process-header">
                <h2 class="section-title" style="color: #fff;">Quy trình kết nối tri thức</h2>
                <div class="section-sub" style="color: rgba(255,255,255,0.7);">Đơn giản, minh bạch, theo dõi rõ ràng.</div>
            </div>
            <div class="process-columns">
                <div class="process-column">
                    <div class="process-label">01</div>
                    <h3>Cho Phụ huynh</h3>
                    <div class="process-list">
                        <div class="process-item">
                            <div class="process-title">Tìm kiếm &amp; Đăng yêu cầu</div>
                            <div class="meta">Mô tả môn học và mong muốn gia sư phù hợp.</div>
                        </div>
                        <div class="process-item">
                            <div class="process-title">Duyệt hồ sơ gia sư</div>
                            <div class="meta">Xem chi tiết đánh giá và xác thực hồ sơ.</div>
                        </div>
                        <div class="process-item">
                            <div class="process-title">Phỏng vấn &amp; Học thử</div>
                            <div class="meta">Trao đổi trước khi chính thức bắt đầu.</div>
                        </div>
                        <div class="process-item">
                            <div class="process-title">Bắt đầu khóa học</div>
                            <div class="meta">Theo dõi tiến trình và hỗ trợ định kỳ.</div>
                        </div>
                    </div>
                </div>
                <div class="process-column">
                    <div class="process-label">02</div>
                    <h3>Cho Gia sư</h3>
                    <div class="process-list">
                        <div class="process-item">
                            <div class="process-title">Đăng ký tài khoản</div>
                            <div class="meta">Cập nhật hồ sơ năng lực và chứng chỉ.</div>
                        </div>
                        <div class="process-item">
                            <div class="process-title">Xác thực hồ sơ</div>
                            <div class="meta">Đội ngũ hỗ trợ xét duyệt trong 24 giờ.</div>
                        </div>
                        <div class="process-item">
                            <div class="process-title">Ứng tuyển lớp học</div>
                            <div class="meta">Nhận lớp phù hợp với lịch và chuyên môn.</div>
                        </div>
                        <div class="process-item">
                            <div class="process-title">Giảng dạy &amp; Thu nhập</div>
                            <div class="meta">Nhận thanh toán đúng hạn và minh bạch.</div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="section">
            <div class="stats stats-strip">
                <div class="stat">
                    <div class="section-title">15k+</div>
                    <div class="meta">Gia sư tuyển chọn</div>
                </div>
                <div class="stat">
                    <div class="section-title">20k+</div>
                    <div class="meta">Phụ huynh tin dùng</div>
                </div>
                <div class="stat">
                    <div class="section-title">98%</div>
                    <div class="meta">Tỷ lệ hài lòng</div>
                </div>
                <div class="stat">
                    <div class="section-title">100%</div>
                    <div class="meta">Hồ sơ xác thực</div>
                </div>
            </div>
        </section>
    </div>
</main>

<jsp:include page="/views/common/footer.jsp" />
