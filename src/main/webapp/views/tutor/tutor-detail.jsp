<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%-- 1. Nhúng Header động và truyền thông tin cấu trúc Layout --%>
<c:set var="pageTitle" value="${not empty requestScope.tutor.fullName ? requestScope.tutor.fullName : 'Hồ sơ gia sư'} - Gia Sư Bá Đạo" scope="request"/>
<c:set var="pageCss" value="/assets/css/tutor-detail.css" scope="request"/>

<jsp:include page="/views/common/header.jsp"/>
<jsp:include page="/views/common/navbar.jsp"/>

<%-- 2. Đặt biến cục bộ 't' đại diện cho đối tượng tutor từ requestScope truyền sang --%>
<c:set var="t" value="${requestScope.tutor}"/>

<main class="page-main">
  <div class="container">
    <section class="section tutor-detail-page" style="padding-top: 24px;">

      <%-- BREADCRUMB: Điều hướng tinh tế phong cách tối giản --%>
      <div class="breadcrumb" style="margin-bottom: 24px; font-size: 14px; color: #64748b; display: flex; align-items: center; gap: 8px;">
        <a href="<%= request.getContextPath() %>/home" style="color: #0d9488; text-decoration: none; font-weight: 500;">Trang chủ</a>
        <span style="color: #cbd5e1;">/</span>
        <a href="<%= request.getContextPath() %>/tutors" style="color: #0d9488; text-decoration: none; font-weight: 500;">Danh sách gia sư</a>
        <span style="color: #cbd5e1;">/</span>
        <span style="color: #1e293b; font-weight: 500;">${t.fullName}</span>
      </div>

      <div class="tutor-detail-grid" style="display: flex; gap: 32px; align-items: flex-start; width: 100%;">

        <%-- KHỐI BÊN TRÁI: KHUNG ẢNH CHÂN DUNG & THÔNG TIN ĐỊNH DANH TÓM TẮT --%>
        <div class="detail-sidebar" style="flex: 1; min-width: 320px; background: #ffffff; border: 1px solid #e2e8f0; border-radius: 12px; padding: 28px; text-align: center; box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.05);">
          <div class="avatar-container" style="margin-bottom: 20px; display: inline-block; position: relative;">
            <c:choose>
              <c:when test="${not empty t.portraitUrl}">
                <img src="${t.portraitUrl}" alt="${t.fullName}" style="width: 160px; height: 190px; object-fit: cover; border-radius: 8px; border: 1px solid #e2e8f0; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);">
              </c:when>
              <c:otherwise>
                <img src="<%= request.getContextPath() %>/assets/images/default-avatar.png" alt="Avatar mặc định" style="width: 160px; height: 190px; object-fit: cover; border-radius: 8px; border: 1px solid #e2e8f0;">
              </c:otherwise>
            </c:choose>
          </div>

          <h2 class="tutor-name" style="font-size: 24px; color: #0f172a; margin: 0 0 8px 0; font-weight: 700; letter-spacing: -0.5px;">${t.fullName}</h2>

          <div class="tutor-tag" style="display: inline-flex; align-items: center; gap: 6px; background: #f0fdfa; color: #0d9488; font-weight: 600; font-size: 13px; padding: 4px 12px; border-radius: 9999px; margin-bottom: 24px; border: 1px solid #ccfbf1;">
            <svg style="width: 14px; height: 14px;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4M7.835 4.697a3.42 3.42 0 001.946-.806 3.42 3.42 0 014.438 0 3.42 3.42 0 001.946.806 3.42 3.42 0 013.138 3.138 3.42 3.42 0 00.806 1.946 3.42 3.42 0 010 4.438 3.42 3.42 0 00-.806 1.946 3.42 3.42 0 01-3.138 3.138 3.42 3.42 0 00-1.946.806 3.42 3.42 0 01-4.438 0 3.42 3.42 0 00-1.946-.806 3.42 3.42 0 01-3.138-3.138 3.42 3.42 0 00-.806-1.946 3.42 3.42 0 010-4.438 3.42 3.42 0 00.806-1.946 3.42 3.42 0 013.138-3.138z"></path></svg>
            ${not empty t.degreeLevel ? t.degreeLevel : 'Gia sư'}
          </div>

          <div class="quick-info-list" style="text-align: left; border-top: 1px solid #f1f5f9; padding-top: 20px; font-size: 14px; color: #475569; display: flex; flex-direction: column; gap: 12px;">
            <div style="display: flex; align-items: center; gap: 10px;">
              <svg style="width: 16px; height: 16px; color: #94a3b8;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5m0 0V11m0 0h4m-4 0h-4m4 0v4m0 0h4m-4 0h-4"></path></svg>
              <span><strong>Học trường:</strong> ${not empty t.school ? t.school : 'Đang cập nhật'}</span>
            </div>
            <div style="display: flex; align-items: center; gap: 10px;">
              <svg style="width: 16px; height: 16px; color: #94a3b8;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 14l9-5-9-5-9 5 9 5zm0 0l6.16-3.422a12.083 12.083 0 01.665 6.479A11.952 11.952 0 0012 20.055a11.952 11.952 0 00-6.824-2.998 12.078 12.078 0 01.665-6.479L12 14zm-4 6v-7.5l4-2.222"></path></svg>
              <span><strong>Chuyên ngành:</strong> ${not empty t.major ? t.major : 'Đang cập nhật'}</span>
            </div>

            <%-- 🌟 BỔ SUNG: KHỐI NGÀY SINH TRONG TRANG CHI TIẾT HỒ SƠ --%>
            <div style="display: flex; align-items: center; gap: 10px;">
              <svg style="width: 16px; height: 16px; color: #94a3b8;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
              <span>
                <strong>Ngày sinh:</strong>
                <c:choose>
                  <c:when test="${not empty t.birthDate and t.birthDate != 'null'}">
                    <fmt:parseDate value="${t.birthDate}" pattern="yyyy-MM-dd" var="detailDate" scope="page" />
                    <fmt:formatDate value="${detailDate}" pattern="dd/MM/yyyy" />
                    <c:remove var="detailDate" scope="page" />
                  </c:when>
                  <c:otherwise>Chưa cập nhật</c:otherwise>
                </c:choose>
              </span>
            </div>

            <div style="display: flex; align-items: center; gap: 10px;">
              <svg style="width: 16px; height: 16px; color: #94a3b8;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path></svg>
              <span><strong>Giới tính:</strong> ${t.gender eq 'Nam' || t.gender eq 'MALE' ? 'Nam' : (t.gender eq 'Nữ' || t.gender eq 'FEMALE' ? 'Nữ' : 'Chưa cập nhật')}</span>
            </div>
          </div>

          <%-- NÚT HÀNH ĐỘNG ĐĂNG KÝ HỌC --%>
          <div class="action-box" style="margin-top: 24px; padding-top: 20px; border-top: 1px solid #f1f5f9;">
            <form method="get" action="<%= request.getContextPath() %>/booking/create">
              <input type="hidden" name="tutorId" value="${t.id}">
              <button type="submit" class="btn btn-primary" style="width: 100%; margin: 0; padding: 14px; font-size: 15px; font-weight: 600; border-radius: 8px; cursor: pointer; border: none; display: inline-flex; align-items: center; justify-content: center; gap: 8px; box-shadow: 0 4px 6px -1px rgba(13, 148, 136, 0.2);">
                <svg style="width: 18px; height: 18px;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                Đăng ký nhận gia sư này
              </button>
            </form>
          </div>

          <%-- Nút Trao đổi --%>
          <a href="${pageContext.request.contextPath}/chat?tutorId=${t.id}"
             style="width: 100%; padding: 14px; margin-top: 10px;
          font-size: 15px; font-weight: 600; border-radius: 8px; border: 1px solid #0d9488;
          color: #0d9488; background: transparent; text-decoration: none;
          display: inline-flex; align-items: center; justify-content: center; gap: 8px;">
            Trao đổi ngay
          </a>
        </div>

        <%-- KHỐI BÊN PHẢI: MÔ TẢ ĐẶC TÍNH VÀ CẤU HÌNH CHI TIẾT CỦA GIA SƯ --%>
        <div class="detail-content" style="flex: 2; display: flex; flex-direction: column; gap: 24px;">

          <div class="form-card" style="margin-bottom: 0; padding: 28px; background: #ffffff; border-radius: 12px; border: 1px solid #e2e8f0; box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.05);">

            <%-- CẤU CẤU GIÁ VÀ HỌC PHÍ CHI TIẾT --%>
            <div class="price-section" style="background: #f8fafc; padding: 18px 24px; border-radius: 8px; margin-bottom: 28px; border-left: 4px solid #0d9488; display: flex; justify-content: space-between; align-items: center;">
              <div>
                <div style="font-size: 12px; color: #64748b; margin-bottom: 4px; text-transform: uppercase; font-weight: 700; letter-spacing: 0.75px;">Mức học phí đề xuất</div>
                <div style="font-size: 26px; font-weight: 700; color: #b91c1c;">
                  <c:choose>
                    <c:when test="${not empty t.minRate}">
                      <span class="price-format">${t.minRate}</span> <span style="font-size: 14px; color: #64748b; font-weight: 500;">VNĐ / Buổi học</span>
                    </c:when>
                    <c:otherwise>Liên hệ trung tâm</c:otherwise>
                  </c:choose>
                </div>
              </div>
              <div style="color: #94a3b8;">
                <svg style="width: 32px; height: 32px;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
              </div>
            </div>

            <%-- PHẠM VI KHÔNG GIAN ĐẢM NHẬN GIẢNG DẠY --%>
            <div class="form-section">
              <h3 class="form-section-title" style="font-size: 16px; font-weight: 700; color: #1e293b; border-bottom: 1px solid #f1f5f9; padding-bottom: 8px; margin-bottom: 16px;">Phạm vi dịch vụ</h3>
              <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 16px;">
                <div style="display: flex; align-items: flex-start; gap: 10px;">
                  <svg style="width: 18px; height: 18px; color: #0d9488; margin-top: 2px; flex-shrink: 0;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                  <div>
                    <div style="font-size: 13px; color: #64748b;">Khu vực dạy học</div>
                    <span style="color: #334155; font-weight: 500; font-size: 14px;">${not empty t.districtName ? t.districtName : 'Mọi khu vực'}</span>
                  </div>
                </div>
                <div style="display: flex; align-items: flex-start; gap: 10px;">
                  <svg style="width: 18px; height: 18px; color: #0d9488; margin-top: 2px; flex-shrink: 0;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path></svg>
                  <div>
                    <div style="font-size: 13px; color: #64748b;">Các khối lớp nhận dạy</div>
                    <span style="color: #334155; font-weight: 500; font-size: 14px;">${not empty t.grades ? t.grades : 'Theo yêu cầu học viên'}</span>
                  </div>
                </div>
              </div>
            </div>

            <%-- CÁC MÔN HỌC ĐẢM NHẬN --%>
            <div class="form-section" style="margin-top: 28px;">
              <h3 class="form-section-title" style="font-size: 16px; font-weight: 700; color: #1e293b; border-bottom: 1px solid #f1f5f9; padding-bottom: 8px; margin-bottom: 16px;">Môn học phụ trách</h3>
              <div class="chip-grid" style="display: flex; flex-wrap: wrap; gap: 8px;">
                <c:choose>
                  <c:when test="${not empty t.subjects}">
                    <c:forEach var="sub" items="${fn:split(t.subjects, ',')}">
                      <span class="label-badge" style="background: #f8fafc; color: #334155; border: 1px solid #e2e8f0; padding: 6px 14px; font-size: 13px; font-weight: 500; border-radius: 6px;">
                          ${fn:trim(sub)}
                      </span>
                    </c:forEach>
                  </c:when>
                  <c:otherwise>
                    <span style="color: #94a3b8; font-style: italic; font-size: 14px;">Liên hệ để biết thêm các môn mở rộng</span>
                  </c:otherwise>
                </c:choose>
              </div>
            </div>

            <%-- PHẦN CẤU TRÚC LỊCH BIỂU RẢNH --%>
            <div class="form-section" style="margin-top: 28px;">
              <h3 style="font-size: 16px; font-weight: 700; color: #1e293b; margin-bottom: 16px;">Lịch biểu giảng dạy rảnh</h3>
              <table class="schedule-table" style="width: 100%; border-collapse: collapse; border: 1px solid #e2e8f0;">
                <thead>
                <tr style="background: #f8fafc;">
                  <th style="padding: 12px; border: 1px solid #e2e8f0; color: #64748b;">Thời gian</th>
                  <c:forEach var="dayHeader" items="${fn:split('T2,T3,T4,T5,T6,T7,CN', ',')}">
                    <th style="padding: 12px; border: 1px solid #e2e8f0; color: #64748b;">${dayHeader}</th>
                  </c:forEach>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="time" items="${fn:split('Sáng,Chiều,Tối', ',')}">
                  <tr>
                    <td style="padding: 12px; border: 1px solid #e2e8f0; font-weight: 600; background: #fafafa;">${time}</td>
                    <c:forEach var="day" items="${fn:split('Thứ 2,Thứ 3,Thứ 4,Thứ 5,Thứ 6,Thứ 7,Chủ Nhật', ',')}">
                      <c:set var="checkString" value="${time.concat(' ').concat(day)}" />
                      <td style="padding: 12px; border: 1px solid #e2e8f0; text-align: center;
                                     ${not empty t.availableSchedules and fn:contains(t.availableSchedules, checkString) ? 'background: #f0fdfa;' : ''}">
                        <c:if test="${not empty t.availableSchedules and fn:contains(t.availableSchedules, checkString)}">
                          <span style="color: #059669; font-weight: bold;">✓</span>
                        </c:if>
                      </td>
                    </c:forEach>
                  </tr>
                </c:forEach>
                </tbody>
              </table>
            </div>

            <%-- ƯU ĐIỂM & KINH NGHIỆM GIẢNG DẠY --%>
            <div class="form-section" style="margin-top: 28px;">
              <h3 style="font-size: 16px; font-weight: 700; color: #1e293b; border-bottom: 1px solid #f1f5f9; padding-bottom: 8px; margin-bottom: 16px;">Ưu điểm & Kinh nghiệm giảng dạy</h3>
              <div style="background: #f8fafc; border: 1px solid #e2e8f0; padding: 20px; border-radius: 8px; line-height: 1.7; color: #334155; font-size: 14px; white-space: pre-line;">
                <c:choose>
                  <c:when test="${not empty t.experienceSummary}">${t.experienceSummary}</c:when>
                  <c:otherwise><span style="color: #94a3b8; font-style: italic;">Gia sư chưa cập nhật thông tin.</span></c:otherwise>
                </c:choose>
              </div>
            </div>
              <c:if test="${canReview}">
                <div class="form-section" style="margin-top: 28px;">

                  <h3 style="font-size: 16px;
               font-weight: 700;
               color: #1e293b;
               border-bottom: 1px solid #f1f5f9;
               padding-bottom: 8px;
               margin-bottom: 16px;">

                      ${not empty myReview ? 'Cập nhật đánh giá của bạn' : 'Đánh giá gia sư'}

                  </h3>

                  <form method="post"
                        action="${pageContext.request.contextPath}/review">

                    <input type="hidden"
                           name="bookingId"
                           value="${bookingId}">

                    <div style="margin-bottom:16px;">
                      <label style="display:block;
                      margin-bottom:8px;
                      font-weight:600;">
                        Số sao đánh giá
                      </label>

                      <select name="rating"
                              required
                              style="padding:10px;
                       border:1px solid #e2e8f0;
                       border-radius:8px;">

                        <option value="">-- Chọn số sao --</option>

                        <option value="5"
                          ${myReview.rating == 5 ? 'selected' : ''}>
                          ★★★★★ (5 sao)
                        </option>

                        <option value="4"
                          ${myReview.rating == 4 ? 'selected' : ''}>
                          ★★★★ (4 sao)
                        </option>

                        <option value="3"
                          ${myReview.rating == 3 ? 'selected' : ''}>
                          ★★★ (3 sao)
                        </option>

                        <option value="2"
                          ${myReview.rating == 2 ? 'selected' : ''}>
                          ★★ (2 sao)
                        </option>

                        <option value="1"
                          ${myReview.rating == 1 ? 'selected' : ''}>
                          ★ (1 sao)
                        </option>

                      </select>
                    </div>

                    <div style="margin-bottom:16px;">
                      <label style="display:block;
                      margin-bottom:8px;
                      font-weight:600;">
                        Nhận xét
                      </label>

                      <textarea name="comment"
                                rows="4"
                                maxlength="1000"
                                style="width:100%;
                         border:1px solid #e2e8f0;
                         border-radius:8px;
                         padding:12px;">${not empty myReview ? myReview.comment : ''}</textarea>
                    </div>

                    <button type="submit"
                            class="btn btn-primary">

                        ${not empty myReview ? 'Cập nhật đánh giá' : 'Gửi đánh giá'}

                    </button>

                  </form>
                </div>
              </c:if>
            <%-- PHẦN ĐÁNH GIÁ (REVIEWS) --%>
            <div class="form-section" style="margin-top: 28px;">
              <h3 class="form-section-title" style="font-size: 16px; font-weight: 700; color: #1e293b; border-bottom: 1px solid #f1f5f9; padding-bottom: 8px; margin-bottom: 16px;">
                Đánh giá từ học viên (${fn:length(reviews)})
              </h3>
              <c:if test="${empty reviews}">
                <p style="color: #64748b; font-size: 14px; font-style: italic;">Gia sư này hiện chưa có đánh giá nào.</p>
              </c:if>
              <div class="review-list">
                <c:forEach var="r" items="${reviews}">
                  <div class="review-card" style="background: #ffffff; border: 1px solid #f1f5f9; padding: 16px; margin-bottom: 12px; border-radius: 8px;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                      <strong style="color: #0f172a;">${r.studentName}</strong>
                      <span style="color: #f59e0b; font-size: 13px;">
                        <c:forEach begin="1" end="${r.rating}">★</c:forEach>
                      </span>
                    </div>
                    <p style="color: #334155; font-size: 14px; margin: 0;">${r.comment}</p>
                    <small style="color: #94a3b8; font-size: 12px; display: block; margin-top: 8px;">${r.createdAt}</small>
                  </div>
                </c:forEach>
              </div>
            </div>

          </div>
        </div>
      </div>
    </section>
  </div>
</main>

<jsp:include page="/views/common/footer.jsp" />

<script>
  document.querySelectorAll('.price-format').forEach(function(el) {
    var val = parseFloat(el.textContent);
    if(!isNaN(val)) {
      el.textContent = val.toLocaleString('vi-VN');
    }
  });
</script>