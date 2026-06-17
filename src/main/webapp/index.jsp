<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="pageTitle" value="Trang chủ - Gia Sư Bửu Đạo" scope="request"/>
<c:set var="pageCss" value="/assets/css/home.css" scope="request"/>

<jsp:include page="/views/common/header.jsp"/>

<jsp:include page="/views/common/navbar.jsp"/>
<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<%-- ĐIỀU KIỆN LINH HOẠT: Kiểm tra vai trò TUTOR và trạng thái hồ sơ gửi từ Servlet --%>
<c:if test="${not empty sessionScope.clientUser}">

    <%-- TRƯỜNG HỢP 1: Hồ sơ đang chờ xét duyệt (PENDING) --%>
    <c:if test="${tutorStatus eq 'PENDING'}">
        <div style="background-color: #fef3c7; border-left: 4px solid #d97706; padding: 16px; margin: 15px 0; border-radius: 6px; color: #92400e; font-size: 14px; display: flex; align-items: flex-start; gap: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.05);">
            <svg style="width: 20px; height: 20px; color: #d97706; flex-shrink: 0; margin-top: 1px;" fill="none"
                 viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round"
                      d="M12 6v6h4.5m4.5 0a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"/>
            </svg>
            <div>
                <span style="font-weight: 700; font-size: 15px; display: block; margin-bottom: 2px;">Hồ sơ đang chờ phê duyệt</span>
                Hệ thống đang tiến hành xác thực thông tin tài khoản của bạn. Tiến trình này thường hoàn tất trong vòng
                24 giờ. Quyền truy cập bảng điều khiển sẽ tự động mở khóa ngay sau khi được phê duyệt.
            </div>
        </div>
    </c:if>

    <%-- TRƯỜNG HỢP 2: Hồ sơ bị từ chối xét duyệt (REJECTED) --%>
    <c:if test="${tutorStatus eq 'REJECTED'}">
        <div style="background-color: #fee2e2; border-left: 4px solid #dc2626; padding: 16px; margin: 15px 0; border-radius: 6px; color: #991b1b; font-size: 14px; display: flex; align-items: flex-start; gap: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.05);">
            <svg style="width: 20px; height: 20px; color: #dc2626; flex-shrink: 0; margin-top: 1px;" fill="none"
                 viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round"
                      d="m9.75 9.75 4.5 4.5m0-4.5-4.5 4.5M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"/>
            </svg>
            <div>
                <span style="font-weight: 700; font-size: 15px; display: block; margin-bottom: 2px;">Yêu cầu xét duyệt bị từ chối</span>
                Hồ sơ ứng tuyển thành viên của bạn chưa đáp ứng đủ các tiêu chí minh bạch hoặc thiếu chứng chỉ đính kèm.
                Vui lòng <a href="${pageContext.request.contextPath}/tutor/resubmit-profile"
                            style="color: #b91c1c; font-weight: 600; text-decoration: underline; transition: color 0.2s;">nhấp
                vào đây để bổ sung hồ sơ năng lực</a>.
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
                <p class="hero-sub">Kết nối nhanh phụ huynh với đội ngũ gia sư xuất sắc. Học tập cá nhân hóa, lộ trình
                    rõ ràng, lịch học linh hoạt.</p>
                <form class="search-panel" method="get" action="<%= request.getContextPath() %>/tutors/search">
                    <div class="search-row">
                        <input class="input-field" type="text" name="keyword"
                               placeholder="Môn học, lớp học hoặc kỹ năng...">
                        <button class="btn btn-primary" type="submit">Tìm gia sư ngay</button>
                    </div>
                    <div class="search-grid">
                        <div class="form-group">
                            <label class="label">Môn dạy</label>
                            <select class="select-field" name="subject">
                                <option value="">Chọn môn</option>

                                <c:forEach var="sub" items="${activeSubjects}">
                                    <option value="${sub}"
                                        ${selectedSubject == sub ? 'selected' : ''}>
                                            ${sub}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="label">Lớp dạy</label>
                            <select class="select-field" name="grade">
                                <option value="">Chọn lớp</option>

                                <c:forEach var="g" items="${activeGrades}">
                                    <option value="${g}"
                                        ${selectedGrade == g ? 'selected' : ''}>
                                            ${g}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="label">Khu vực dạy</label>
                            <select class="select-field" name="district">
                                <option value="">Chọn khu vực</option>

                                <c:forEach var="area" items="${activeAreas}">
                                    <option value="${area}"
                                        ${selectedDistrict == area ? 'selected' : ''}>
                                            ${area}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="label">Thời gian dạy</label>

                            <select class="select-field" name="schedule">
                                <option value="">Chọn thời gian</option>

                                <c:forEach var="slot" items="${activeSchedules}">
                                    <option value="${slot}"
                                        ${selectedSchedule == slot ? 'selected' : ''}>
                                            ${slot}
                                    </option>
                                </c:forEach>
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
                                <%-- Đổi value thành 'Nam' và 'Nữ' để tương thích chính xác với Database --%>
                                <option value="Nam" ${selectedGender == 'Nam' ? 'selected' : ''}>Nam</option>
                                <option value="Nữ" ${selectedGender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                                <option value="Khác" ${selectedGender == 'Khác' ? 'selected' : ''}>Khác</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="label">Trình độ</label>
                            <select class="select-field" name="degreeLevel">
                                <option value="">Chọn trình độ</option>

                                <c:forEach var="degree" items="${activeDegrees}">
                                    <option value="${degree}"
                                        ${selectedDegree == degree ? 'selected' : ''}>
                                            ${degree}
                                    </option>
                                </c:forEach>
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
                <%-- HERO VISUAL: Mini tutor cards + floating badges --%>
                <div class="hero-visual-wrap">

                    <%-- Floating badge top-left --%>
                    <div class="hero-badge hero-badge--tl">
                        <span style="font-size:18px;">🎓</span>
                        <div>
                            <div style="font-size:12px;font-weight:700;color:var(--navy-900);line-height:1.2;">50,000+</div>
                            <div style="font-size:10px;color:var(--ink-500);">Buổi học thành công</div>
                        </div>
                    </div>

                    <%-- Main card stack --%>
                    <div class="hero-card-stack">

                        <%-- Card 1 — nổi bật nhất --%>
                        <div class="hero-tutor-card hero-tutor-card--main">
                            <div class="htc-avatar" style="background:linear-gradient(135deg,#c7d2fe,#818cf8);">MT</div>
                            <div class="htc-info">
                                <div class="htc-name">Nguyễn Minh Tuấn</div>
                                <div class="htc-sub">Toán · THPT · 150,000đ/buổi</div>
                                <div class="htc-stars">★★★★★ <span style="color:var(--ink-500);font-size:11px;font-weight:400;">4.9</span></div>
                            </div>
                            <div class="htc-badge">Xác thực ✓</div>
                        </div>

                        <%-- Card 2 --%>
                        <div class="hero-tutor-card">
                            <div class="htc-avatar" style="background:linear-gradient(135deg,#fde68a,#fca5a5);">LA</div>
                            <div class="htc-info">
                                <div class="htc-name">Trần Lê Anh</div>
                                <div class="htc-sub">IELTS · Online · 200,000đ/buổi</div>
                                <div class="htc-stars">★★★★★ <span style="color:var(--ink-500);font-size:11px;font-weight:400;">5.0</span></div>
                            </div>
                            <div class="htc-badge">Xác thực ✓</div>
                        </div>

                        <%-- Card 3 --%>
                        <div class="hero-tutor-card">
                            <div class="htc-avatar" style="background:linear-gradient(135deg,#bbf7d0,#6ee7b7);">PH</div>
                            <div class="htc-info">
                                <div class="htc-name">Lê Phương Hoa</div>
                                <div class="htc-sub">Văn · THCS · 120,000đ/buổi</div>
                                <div class="htc-stars">★★★★☆ <span style="color:var(--ink-500);font-size:11px;font-weight:400;">4.8</span></div>
                            </div>
                            <div class="htc-badge">Xác thực ✓</div>
                        </div>

                    </div>

                    <%-- Floating badge bottom-right --%>
                    <div class="hero-badge hero-badge--br">
                        <span style="font-size:16px;">⭐</span>
                        <div>
                            <div style="font-size:12px;font-weight:700;color:var(--navy-900);line-height:1.2;">4.9 / 5.0</div>
                            <div style="font-size:10px;color:var(--ink-500);">Điểm đánh giá TB</div>
                        </div>
                    </div>

                </div>

                    <div class="hero-stat">
                        <div class="hero-stat-title">10,000+</div>
                        <div class="hero-stat-desc">
                            Gia sư chất lượng cao
                        </div>
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

                                    <%-- TAG NGÀY SINH PHONG CÁCH HIỆN ĐẠI TỐI GIẢN --%>
                                <c:if test="${not empty tutor.birthDate and tutor.birthDate != 'null'}">
                                    <div style="display: flex; align-items: center; gap: 6px; font-size: 13px; color: #475569; margin-top: 2px; margin-bottom: 10px;">
                                        <svg style="width: 15px; height: 15px; color: #0d9488; flex-shrink: 0;" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0v-7.5A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 11.25v7.5" />
                                        </svg>
                                        <span style="font-weight: 500;">Ngày sinh:</span>
                                        <span style="color: #1e293b;">
            <fmt:parseDate value="${tutor.birthDate}" pattern="yyyy-MM-dd" var="cleanDate" scope="page" />
            <fmt:formatDate value="${cleanDate}" pattern="dd/MM/yyyy" />
            <c:remove var="cleanDate" scope="page" />
        </span>
                                    </div>
                                </c:if>
                                <div class="meta" style="margin-bottom: 12px;">
                                    <span style="font-weight: 600; color: #1f2937;"><c:out
                                            value="${tutor.qualification}"/></span>
                                    <c:if test="${not empty tutor.school}">
                                        <div style="display: flex; align-items: center; gap: 6px; font-size: 13px; color: #4b5563; margin-top: 4px;">
                                            <svg style="width: 15px; height: 15px; color: #6b7280; flex-shrink: 0;"
                                                 fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                                                <path stroke-linecap="round" stroke-linejoin="round"
                                                      d="M12 21v-8.25M15.75 21v-8.25M8.25 21v-8.25M3 9l9-6 9 6m-1.5 12V10.332A48.36 48.36 0 0 0 12 9.75c-2.551 0-5.056.2-7.5.582V21M3 21h18M12 6.75h.008v.008H12V6.75Z"/>
                                            </svg>
                                            <span><c:out value="${tutor.school}"/> (<c:out
                                                    value="${tutor.major}"/>)</span>
                                        </div>
                                    </c:if>
                                </div>

                                <div class="tutor-tags"
                                     style="display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 12px;">
    <span class="tag-pill"
          style="display: inline-flex; align-items: center; gap: 4px; padding: 4px 10px; background: #f3f4f6; border-radius: 20px; font-size: 12px; color: #374151;">
        <svg style="width: 14px; height: 14px; color: #4b5563;" fill="none" viewBox="0 0 24 24" stroke-width="2"
             stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round"
                  d="M12 6.042A8.967 8.967 0 0 0 6 3.75c-1.052 0-2.062.18-3 .512v14.25A8.987 8.987 0 0 1 6 18c2.305 0 4.408.867 6 2.292m0-14.25a8.966 8.966 0 0 1 6-2.292c1.052 0 2.062.18 3 .512v14.25A8.987 8.987 0 0 0 18 18a8.967 8.967 0 0 0-6 2.292m0-14.25v14.25"/>
        </svg>
        <c:out value="${tutor.teachingSubject}"/>
    </span>

                                    <c:if test="${not empty tutor.teachingGrade}">
        <span class="tag-pill"
              style="display: inline-flex; align-items: center; gap: 4px; padding: 4px 10px; background: #f3f4f6; border-radius: 20px; font-size: 12px; color: #374151;">
            <svg style="width: 14px; height: 14px; color: #4b5563;" fill="none" viewBox="0 0 24 24" stroke-width="2"
                 stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round"
                      d="M4.26 10.174c-.053-.462.19-1.01.621-1.213L11.43 5.75a1.125 1.125 0 0 1 1.012 0l6.548 3.211c.43.203.673.75.62 1.213a35.53 35.53 0 0 1-.745 4.78c-.242 1.173-1.061 2.082-2.24 2.584l-3.492 1.487a1.125 1.125 0 0 1-.866 0l-3.492-1.487c-1.18-.502-1.998-1.411-2.24-2.584a35.531 35.531 0 0 1-.745-4.78ZM19.5 10.5v5.25c0 1.242-1.008 2.25-2.25 2.25h-1.5M4.5 10.5v5.25c0 1.242 1.008 2.25 2.25 2.25h1.5"/>
            </svg>
            Lớp: <c:out value="${tutor.teachingGrade}"/>
        </span>
                                    </c:if>

                                    <span class="tag-pill"
                                          style="display: inline-flex; align-items: center; gap: 4px; padding: 4px 10px; background: #f3f4f6; border-radius: 20px; font-size: 12px; color: #374151;">
        <svg style="width: 14px; height: 14px; color: #4b5563;" fill="none" viewBox="0 0 24 24" stroke-width="2"
             stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M15 10.5a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z"/>
            <path stroke-linecap="round" stroke-linejoin="round"
                  d="M19.5 10.5c0 7.142-7.5 11.25-7.5 11.25S4.5 17.642 4.5 10.5a7.5 7.5 0 1 1 15 0Z"/>
        </svg>
        <c:out value="${tutor.teachingArea}"/>
    </span>

                                    <c:choose>
                                        <c:when test="${not empty tutor.availableSchedules}">
            <span class="tag-pill" title="${tutor.availableSchedules}"
                  style="display: inline-flex; align-items: center; gap: 4px; padding: 4px 10px; background: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 20px; font-size: 12px; color: #16a34a; font-weight: 500; max-width: 100%; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                <svg style="width: 14px; height: 14px; color: #16a34a; flex-shrink: 0;" fill="none" viewBox="0 0 24 24"
                     stroke-width="2" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round"
                          d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0v-7.5A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 11.25v7.5"/>
                </svg>
                Lịch: <c:out value="${tutor.availableSchedules}"/>
            </span>
                                        </c:when>
                                        <c:otherwise>
            <span class="tag-pill"
                  style="display: inline-flex; align-items: center; gap: 4px; padding: 4px 10px; background: #fef2f2; border: 1px solid #fee2e2; border-radius: 20px; font-size: 12px; color: #991b1b; font-style: italic;">
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
                                    <a class="btn btn-outline"
                                       href="${pageContext.request.contextPath}/tutor/tutor-detail?id=${tutor.tutorId}">Hồ
                                        sơ chi tiết</a>
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

        <%-- =====================================================
             SECTION: TÌM GIA SƯ THEO MÔN HỌC (ĐỘNG TỪ DB)
             ===================================================== --%>
        <section class="section">
            <div class="section-header" style="flex-direction: column; align-items: center; text-align: center; gap: 6px; margin-bottom: 32px;">
                <h2 class="section-title" style="font-size: 1.6rem;">Tìm gia sư theo môn học</h2>
                <p class="section-sub" style="margin-bottom: 0;">Chọn môn bạn cần, hệ thống gợi ý gia sư phù hợp nhất ngay lập tức.</p>
            </div>
            <div class="subject-grid">

                <c:choose>

                    <c:when test="${not empty subjectCards}">

                        <c:forEach var="card" items="${subjectCards}">

                            <a href="${pageContext.request.contextPath}/tutors?subject=${card.name}"
                               class="subject-card">

                                <div class="subject-icon"
                                     style="background:${card.bgColor};">

                                    <i class="${card.iconClass}"></i>

                                </div>

                                <div class="subject-name">
                                    <c:out value="${card.name}"/>
                                </div>

                                <div class="subject-meta">
                                    Xem gia sư →
                                </div>

                            </a>

                        </c:forEach>

                    </c:when>

                    <c:otherwise>

                        <a href="${pageContext.request.contextPath}/tutors?subject=Toán"
                           class="subject-card">
                            <div class="subject-icon" style="background:#eff6ff;">
                                <i class="fa-solid fa-square-root-variable"></i>
                            </div>
                            <div class="subject-name">Toán</div>
                            <div class="subject-meta">Xem gia sư →</div>
                        </a>

                        <a href="${pageContext.request.contextPath}/tutors?subject=Lý"
                           class="subject-card">
                            <div class="subject-icon" style="background:#fefce8;">
                                <i class="fa-solid fa-bolt"></i>
                            </div>
                            <div class="subject-name">Vật Lý</div>
                            <div class="subject-meta">Xem gia sư →</div>
                        </a>

                        <a href="${pageContext.request.contextPath}/tutors?subject=Hóa"
                           class="subject-card">
                            <div class="subject-icon" style="background:#f0fdf4;">
                                <i class="fa-solid fa-flask"></i>
                            </div>
                            <div class="subject-name">Hóa Học</div>
                            <div class="subject-meta">Xem gia sư →</div>
                        </a>

                        <a href="${pageContext.request.contextPath}/tutors?subject=Anh+Văn"
                           class="subject-card">
                            <div class="subject-icon" style="background:#fdf2f8;">
                                <i class="fa-solid fa-globe"></i>
                            </div>
                            <div class="subject-name">Tiếng Anh</div>
                            <div class="subject-meta">Xem gia sư →</div>
                        </a>

                    </c:otherwise>

                </c:choose>

            </div>
        </section>

        <%-- =====================================================
             SECTION: TẠI SAO CHỌN CHÚNG TÔI (USP x3)
             ===================================================== --%>
        <section class="section">
            <div style="text-align: center; margin-bottom: 36px;">
                <h2 class="section-title" style="font-size: 1.6rem;">Tại sao phụ huynh tin tưởng chúng tôi?</h2>
                <p class="section-sub" style="margin-bottom: 0;">Ba cam kết cốt lõi chúng tôi giữ với mỗi gia đình.</p>
            </div>
            <div class="usp-grid">
                <div class="usp-card">
                    <div class="usp-icon-wrap" style="background:#ecfdf5;">
                        <svg width="26" height="26" fill="none" stroke="#10b981" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75m-3-7.036A11.959 11.959 0 013.598 6 11.99 11.99 0 003 9.749c0 5.592 3.824 10.29 9 11.623 5.176-1.332 9-6.03 9-11.622 0-1.31-.21-2.571-.598-3.751h-.152c-3.196 0-6.1-1.248-8.25-3.285z"/></svg>
                    </div>
                    <h3 class="usp-title">Gia sư xác thực 3 lớp</h3>
                    <p class="usp-desc">Mỗi gia sư đều được kiểm tra CCCD, bằng cấp và phỏng vấn trực tiếp trước khi xuất hiện trên nền tảng. Không có gia sư ảo.</p>
                    <a href="${pageContext.request.contextPath}/tutors" class="usp-link">Tìm gia sư ngay →</a>
                </div>
                <div class="usp-card">
                    <div class="usp-icon-wrap" style="background:#eff6ff;">
                        <svg width="26" height="26" fill="none" stroke="#3b82f6" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25m-18 0A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75m-18 0v-7.5A2.25 2.25 0 015.25 9h13.5A2.25 2.25 0 0121 11.25v7.5"/></svg>
                    </div>
                    <h3 class="usp-title">Lịch học hoàn toàn linh hoạt</h3>
                    <p class="usp-desc">Chọn buổi học phù hợp với lịch trình gia đình — sáng, chiều, tối, cả tuần 7 ngày. Không ép ca cố định.</p>
                    <a href="${pageContext.request.contextPath}/tutors" class="usp-link">Xem lịch rảnh gia sư →</a>
                </div>
                <div class="usp-card">
                    <div class="usp-icon-wrap" style="background:#fefce8;">
                        <svg width="26" height="26" fill="none" stroke="#f59e0b" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M11.48 3.499a.562.562 0 011.04 0l2.125 5.111a.563.563 0 00.475.345l5.518.442c.499.04.701.663.321.988l-4.204 3.602a.563.563 0 00-.182.557l1.285 5.385a.562.562 0 01-.84.61l-4.725-2.885a.563.563 0 00-.586 0L6.982 20.54a.562.562 0 01-.84-.61l1.285-5.386a.562.562 0 00-.182-.557l-4.204-3.602a.563.563 0 01.321-.988l5.518-.442a.563.563 0 00.475-.345L11.48 3.5z"/></svg>
                    </div>
                    <h3 class="usp-title">Đánh giá 100% từ phụ huynh thật</h3>
                    <p class="usp-desc">Chỉ phụ huynh đã hoàn thành buổi học mới được để lại nhận xét. Không có đánh giá ảo, không mua sao.</p>
                    <a href="${pageContext.request.contextPath}/tutors" class="usp-link">Đọc đánh giá thực →</a>
                </div>
            </div>
        </section>

        <%-- =====================================================
             SECTION: TESTIMONIALS — REVIEWS THỰC TẾ TỪ DB
             Nếu chưa có review → hiện placeholder
             Mỗi card có nút "Xem gia sư" link đến tutor-detail
             ===================================================== --%>
        <section class="section testimonial-section">
            <div style="text-align: center; margin-bottom: 36px;">
                <h2 class="section-title" style="font-size: 1.6rem; color: var(--navy-900);">Phụ huynh nói gì về chúng tôi?</h2>
                <p class="section-sub" style="margin-bottom: 0;">Đánh giá thực tế từ những gia đình đã sử dụng dịch vụ.</p>
            </div>
            <div class="testimonial-grid">
                <c:choose>
                    <c:when test="${not empty featuredReviews}">
                        <c:forEach var="rv" items="${featuredReviews}">
                            <div class="testimonial-card">
                                <div class="testimonial-quote">"</div>
                                <p class="testimonial-text"><c:out value="${rv.comment}"/></p>
                                <div class="testimonial-footer">
                                        <%-- Avatar initials từ tên phụ huynh --%>
                                    <c:set var="nameParts" value="${fn:split(rv.studentName, ' ')}"/>
                                    <c:set var="initials" value=""/>
                                    <c:forEach var="part" items="${nameParts}" varStatus="s">
                                        <c:if test="${s.last or s.index == 0}">
                                            <c:set var="initials" value="${initials}${fn:substring(part,0,1)}"/>
                                        </c:if>
                                    </c:forEach>
                                    <div class="testimonial-avatar" style="background: linear-gradient(135deg, #c7d2fe, #93c5fd);">
                                        <c:out value="${fn:toUpperCase(initials)}"/>
                                    </div>
                                    <div style="flex:1; min-width:0;">
                                        <div class="testimonial-name"><c:out value="${rv.studentName}"/></div>
                                        <div class="testimonial-subject">
                                            <c:out value="${not empty rv.teachingSubject ? rv.teachingSubject : 'Gia sư'}"/>
                                        </div>
                                    </div>
                                    <div style="display:flex; flex-direction:column; align-items:flex-end; gap:6px; flex-shrink:0;">
                                        <div class="testimonial-stars">
                                            <c:forEach begin="1" end="${rv.rating}">★</c:forEach>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/tutor/tutor-detail?id=${rv.tutorId}"
                                           style="font-size:11px; font-weight:600; color:var(--mint-600); text-decoration:none; white-space:nowrap;">
                                            Xem gia sư →
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <%-- Placeholder khi chưa có review nào trong DB --%>
                        <div class="testimonial-card">
                            <div class="testimonial-quote">"</div>
                            <p class="testimonial-text">Con tôi học Toán với thầy được 3 tháng, điểm từ 5 lên 9. Thầy rất kiên nhẫn và có phương pháp riêng giúp con hiểu bài nhanh hơn hẳn.</p>
                            <div class="testimonial-footer">
                                <div class="testimonial-avatar" style="background:linear-gradient(135deg,#c7d2fe,#93c5fd);">NL</div>
                                <div><div class="testimonial-name">Chị Nguyễn Thị Lan</div><div class="testimonial-subject">Toán lớp 8 · TP.HCM</div></div>
                                <div class="testimonial-stars">★★★★★</div>
                            </div>
                        </div>
                        <div class="testimonial-card">
                            <div class="testimonial-quote">"</div>
                            <p class="testimonial-text">Tìm được cô dạy IELTS phù hợp trên này, con đạt 7.0 sau 4 tháng luyện thi. Giao diện dễ dùng, đặt lịch nhanh, gia sư chất lượng.</p>
                            <div class="testimonial-footer">
                                <div class="testimonial-avatar" style="background:linear-gradient(135deg,#fde68a,#fca5a5);">TVH</div>
                                <div><div class="testimonial-name">Anh Trần Văn Hùng</div><div class="testimonial-subject">IELTS · Hà Nội</div></div>
                                <div class="testimonial-stars">★★★★★</div>
                            </div>
                        </div>
                        <div class="testimonial-card">
                            <div class="testimonial-quote">"</div>
                            <p class="testimonial-text">Đây là lần đầu tôi thấy một nền tảng giáo dục Việt Nam làm tốt đến vậy. Hồ sơ gia sư rõ ràng, có đánh giá thật, lịch học linh hoạt.</p>
                            <div class="testimonial-footer">
                                <div class="testimonial-avatar" style="background:linear-gradient(135deg,#fbcfe8,#fda4af);">PTH</div>
                                <div><div class="testimonial-name">Chị Phạm Thu Hương</div><div class="testimonial-subject">Tiếng Anh lớp 5 · Đà Nẵng</div></div>
                                <div class="testimonial-stars">★★★★★</div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <%-- =====================================================
             SECTION: CTA BANNER
             ===================================================== --%>
        <section class="section">
            <div class="cta-banner">
                <div class="cta-content">
                    <h2 class="cta-title">Sẵn sàng bắt đầu hành trình chinh phục tri thức?</h2>
                    <p class="cta-sub">Hàng nghìn gia sư chất lượng cao đang chờ kết nối với bạn ngay hôm nay.</p>
                    <div class="cta-actions">
                        <a href="${pageContext.request.contextPath}/tutors" class="btn"
                           style="background:var(--mint-600);color:#fff;padding:14px 32px;font-size:15px;font-weight:700;border-radius:999px;box-shadow:0 4px 14px rgba(16,185,129,0.35);transition:all 0.2s;">
                            Tìm gia sư ngay
                        </a>
                        <a href="${pageContext.request.contextPath}/register-page" class="btn"
                           style="background:rgba(255,255,255,0.12);color:#fff;border:1.5px solid rgba(255,255,255,0.4);padding:14px 32px;font-size:15px;font-weight:600;border-radius:999px;transition:all 0.2s;">
                            Trở thành gia sư
                        </a>
                    </div>
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
                        <div class="process-item"><div class="process-title">Tìm kiếm &amp; Đăng yêu cầu</div><div class="meta">Mô tả môn học và mong muốn gia sư phù hợp.</div></div>
                        <div class="process-item"><div class="process-title">Duyệt hồ sơ gia sư</div><div class="meta">Xem chi tiết đánh giá và xác thực hồ sơ.</div></div>
                        <div class="process-item"><div class="process-title">Phỏng vấn &amp; Học thử</div><div class="meta">Trao đổi trước khi chính thức bắt đầu.</div></div>
                        <div class="process-item"><div class="process-title">Bắt đầu khóa học</div><div class="meta">Theo dõi tiến trình và hỗ trợ định kỳ.</div></div>
                    </div>
                </div>
                <div class="process-column">
                    <div class="process-label">02</div>
                    <h3>Cho Gia sư</h3>
                    <div class="process-list">
                        <div class="process-item"><div class="process-title">Đăng ký tài khoản</div><div class="meta">Cập nhật hồ sơ năng lực và chứng chỉ.</div></div>
                        <div class="process-item"><div class="process-title">Xác thực hồ sơ</div><div class="meta">Đội ngũ hỗ trợ xét duyệt trong 24 giờ.</div></div>
                        <div class="process-item"><div class="process-title">Ứng tuyển lớp học</div><div class="meta">Nhận lớp phù hợp với lịch và chuyên môn.</div></div>
                        <div class="process-item"><div class="process-title">Giảng dạy &amp; Thu nhập</div><div class="meta">Nhận thanh toán đúng hạn và minh bạch.</div></div>
                    </div>
                </div>
            </div>
        </section>

        <section class="section">
            <div class="stats stats-strip">
                <div class="stat"><div class="section-title">15k+</div><div class="meta">Gia sư tuyển chọn</div></div>
                <div class="stat"><div class="section-title">20k+</div><div class="meta">Phụ huynh tin dùng</div></div>
                <div class="stat"><div class="section-title">98%</div><div class="meta">Tỷ lệ hài lòng</div></div>
                <div class="stat"><div class="section-title">100%</div><div class="meta">Hồ sơ xác thực</div></div>
            </div>
        </section>
    </div>
</main>

<jsp:include page="/views/common/footer.jsp"/>
