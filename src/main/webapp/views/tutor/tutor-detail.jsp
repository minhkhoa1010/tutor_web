<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%-- 1. Nhúng Header động và truyền thông tin cấu trúc Layout --%>
<jsp:include page="/views/common/header.jsp">
  <jsp:param name="pageTitle" value="${not empty requestScope.tutor.fullName ? requestScope.tutor.fullName : 'Hồ sơ gia sư'} - Gia Sư Bá Đạo" />
  <jsp:param name="pageCss" value="/assets/css/tutor-detail.css" />
</jsp:include>
<jsp:include page="/views/common/navbar.jsp" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
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
          <!-- KHU VỰC CHỌN LỊCH HỌC TRỰC QUAN (THÊM VÀO ĐÂY) -->
          <div class="schedule-selection-box" style="margin-top: 20px; padding: 16px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px;">
            <p style="font-weight: 600; color: #1e293b; margin-bottom: 12px; font-size: 14px;">Chọn lịch học:</p>
            <div style="display: flex; gap: 8px; flex-wrap: wrap;">
              <c:set var="scheduleArray" value="${fn:split(t.availableSchedules, ',')}" />
              <c:forEach var="day" items="${scheduleArray}">
                <c:set var="cleanDay" value="${fn:trim(day)}" />
                <c:set var="isBusy" value="${fn:contains(allBusyDays, cleanDay)}" />
                <c:set var="isMine" value="${fn:contains(myBookedDays, cleanDay)}" />

                <c:if test="${not empty cleanDay}">
                  <label class="schedule-label ${isBusy ? 'booked' : ''} ${isMine ? 'my-booked' : ''}"
                         style="display: flex; align-items: center; gap: 6px; padding: 8px 12px; border-radius: 6px; cursor: ${isBusy ? 'not-allowed' : 'pointer'}; border: 1px solid #cbd5e1; font-size: 13px; transition: all 0.2s;">
                    <input type="checkbox" value="${cleanDay}"
                           class="tutor-schedule-checkbox"
                      ${isBusy ? 'disabled' : ''}
                      ${isMine ? 'checked' : ''}
                           style="accent-color: #0d9488;">
                    <span style="font-weight: 500;">${cleanDay} ${isBusy ? '(Đã thuê)' : ''}</span>
                  </label>
                </c:if>
              </c:forEach>
            </div>
          </div>
          <%-- NÚT HÀNH ĐỘNG ĐĂNG KÝ HỌC --%>
          <div class="action-box" style="margin-top: 24px; padding-top: 20px; border-top: 1px solid #f1f5f9;">
            <form method="get" action="<%= request.getContextPath() %>/booking/create">
              <input type="hidden" name="tutorId" value="${t.id}">
              <%-- Thay form booking cũ bằng nút mở popup --%>
              <button type="button" onclick="openHireModal()"
                      class="btn btn-primary"
                      style="width:100%; padding:14px; font-size:15px; font-weight:600; border-radius:8px;
               cursor:pointer; border:none; display:inline-flex; align-items:center;
               justify-content:center; gap:8px; box-shadow:0 4px 6px -1px rgba(13,148,136,0.2);">
                <svg style="width:18px;height:18px;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                        d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                </svg>
                Đăng ký nhận gia sư này
              </button>
            </form>
          </div>
          <%-- NÚT WISHLIST + CART TRONG SIDEBAR DETAIL --%>
          <c:set var="isFavDetail" value="${not empty savedTutorIds && fn:contains(savedTutorIds, t.id)}" />
          <c:set var="isInCartDetail" value="${not empty cartTutorIds && fn:contains(cartTutorIds, t.id)}" />
          <div style="display: flex; gap: 10px; margin-top: 10px;">
            <%-- Trái tim: Wishlist --%>
            <button id="btn-detail-wishlist"
                    data-tutor-id="${t.id}"
                    title="${isFavDetail ? 'Bỏ yêu thích' : 'Thêm yêu thích'}"
                    style="flex: 1; padding: 12px; border-radius: 8px; font-size: 14px; font-weight: 600;
                            border: 1px solid ${isFavDetail ? '#fecaca' : '#e2e8f0'};
                            background: ${isFavDetail ? '#fff1f2' : '#fff'};
                            color: ${isFavDetail ? '#ef4444' : '#64748b'};
                            cursor: pointer; display: inline-flex; align-items: center; justify-content: center; gap: 6px;
                            transition: all 0.2s;">
              <i id="icon-detail-wishlist" class="${isFavDetail ? 'fa-solid' : 'fa-regular'} fa-heart"></i>
              <span id="text-detail-wishlist">${isFavDetail ? 'Đã lưu' : 'Yêu thích'}</span>
            </button>
            <%-- Giỏ hàng: Cart --%>
            <button id="btn-detail-cart"
                    data-tutor-id="${t.id}"
                    style="flex: 1; padding: 12px; border-radius: 8px; font-size: 14px; font-weight: 600;
                            border: none; cursor: pointer;
                            background: ${isInCartDetail ? '#475569' : '#ccfbf1'};
                            color: ${isInCartDetail ? '#fff' : '#0d9488'};
                            display: inline-flex; align-items: center; justify-content: center; gap: 6px;
                            transition: all 0.2s;">
              <i id="icon-detail-cart" class="${isInCartDetail ? 'fa-solid fa-check-double' : 'fa-solid fa-cart-plus'}"></i>
              <span id="text-detail-cart">${isInCartDetail ? 'Đã chọn' : 'Vào giỏ'}</span>
            </button>
          </div>
          <%-- Nút Trao đổi --%>
          <button id="btn-contact-tutor"
                  data-phone="${tutorPhone}"
                  data-email="${tutorEmail}"
                  style="
            width: 100%;
            padding: 14px;
            margin-top: 10px;
            font-size: 15px;
            font-weight: 600;
            border-radius: 8px;
            border: 1px solid #0d9488;
            color: #0d9488;
            background: transparent;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.2s ease;
        ">
            <i class="fa-solid fa-comments"></i>
            Trao đổi ngay
          </button>
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
  <%-- ===== POPUP XÁC NHẬN THUÊ GIA SƯ ===== --%>
  <div id="hire-modal-overlay" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.5);
     z-index:9999; align-items:center; justify-content:center;">
    <div style="background:#fff; border-radius:16px; padding:32px; max-width:420px; width:90%;
                box-shadow:0 20px 40px rgba(0,0,0,0.15); position:relative;">

      <%-- Nút X đóng --%>
      <button onclick="closeHireModal()" style="position:absolute; top:16px; right:16px; background:none;
                border:none; font-size:20px; color:#94a3b8; cursor:pointer; line-height:1;">✕</button>

      <%-- CASE 1: Chưa đăng nhập --%>
      <div id="modal-not-logged-in" style="display:none; text-align:center;">
        <div style="font-size:48px; margin-bottom:16px;">🔒</div>
        <h3 style="font-size:18px; font-weight:700; color:#0f172a; margin:0 0 8px;">Vui lòng đăng nhập</h3>
        <p style="color:#64748b; font-size:14px; margin:0 0 24px;">Bạn cần đăng nhập tài khoản Phụ huynh để thuê gia sư.</p>
        <div style="display:flex; gap:10px; justify-content:center;">
          <a href="${pageContext.request.contextPath}/login"
             style="background:#0d9488; color:#fff; padding:10px 24px; border-radius:8px;
                          font-weight:600; text-decoration:none; font-size:14px;">Đăng nhập ngay</a>
          <button onclick="closeHireModal()" style="background:#f1f5f9; color:#475569; padding:10px 24px;
                        border-radius:8px; font-weight:600; border:none; cursor:pointer; font-size:14px;">Đóng</button>
        </div>
      </div>
        <%-- CASE 2: Thiếu tiền --%>
        <div id="modal-insufficient" style="display:none; text-align:center;">
          <div style="font-size:48px; margin-bottom:16px;">💸</div>
          <h3 style="font-size:18px; font-weight:700; color:#0f172a; margin:0 0 8px;">Số dư không đủ</h3>
          <p style="color:#64748b; font-size:14px; margin:0 0 8px;">Tổng học phí (<span id="modal-insufficient-sessions" style="font-weight:600;">0</span> buổi): <strong id="modal-tutor-price" style="color:#ef4444;"></strong></p>
          <p style="color:#64748b; font-size:14px; margin:0 0 24px;">Số dư hiện tại: <strong id="modal-user-balance" style="color:#64748b;"></strong></p>
          <div style="display:flex; gap:10px; justify-content:center;">
            <a href="${pageContext.request.contextPath}/parent/profile"
               style="background:#0d9488; color:#fff; padding:10px 24px; border-radius:8px;
                    font-weight:600; text-decoration:none; font-size:14px;">Nạp ví ngay</a>
            <button onclick="closeHireModal()" style="background:#f1f5f9; color:#475569; padding:10px 24px;
                  border-radius:8px; font-weight:600; border:none; cursor:pointer; font-size:14px;">Đóng</button>
          </div>
        </div>

        <%-- CASE 3: Đủ tiền — xác nhận --%>
        <div id="modal-confirm" style="display:none;">
          <div style="text-align:center; margin-bottom:20px;">
            <div style="font-size:48px; margin-bottom:12px;">✅</div>
            <h3 style="font-size:18px; font-weight:700; color:#0f172a; margin:0 0 4px;">Xác nhận thuê gia sư</h3>
            <p style="color:#64748b; font-size:13px; margin:0;">Hãy kiểm tra thông tin trước khi xác nhận</p>
          </div>
          <div style="background:#f8fafc; border-radius:10px; padding:16px; margin-bottom:20px;
                  border:1px solid #e2e8f0; font-size:14px; display:flex; flex-direction:column; gap:10px;">
            <div style="display:flex; justify-content:space-between;">
              <span style="color:#64748b;">Gia sư</span>
              <span style="font-weight:600; color:#0f172a;" id="modal-confirm-name"></span>
            </div>
            <div style="display:flex; justify-content:space-between;">
              <span style="color:#64748b;" id="modal-confirm-session-label">Tổng học phí (0 buổi)</span>
              <span style="font-weight:700; color:#0d9488;" id="modal-confirm-price"></span>
            </div>
            <div style="display:flex; justify-content:space-between; border-top:1px dashed #e2e8f0; padding-top:10px;">
              <span style="color:#64748b;">Số dư sau khi thuê</span>
              <span style="font-weight:600; color:#334155;" id="modal-confirm-remaining"></span>
            </div>
          </div>
          <div style="display:flex; gap:10px;">
            <button id="btn-confirm-hire" onclick="executeHire()"
                    style="flex:1; background:#0d9488; color:#fff; padding:12px; border-radius:8px;
                         font-weight:700; border:none; cursor:pointer; font-size:14px;
                         display:flex; align-items:center; justify-content:center; gap:6px;">
              <svg style="width:16px;height:16px;" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12.75l6 6 9-13.5"/>
              </svg>
              Xác nhận thuê
            </button>
            <button onclick="closeHireModal()" style="flex:1; background:#f1f5f9; color:#475569; padding:12px;
                  border-radius:8px; font-weight:600; border:none; cursor:pointer; font-size:14px;">Huỷ bỏ</button>
          </div>
        </div>

    </div>
  </div>
  <div id="login-prompt-modal" style="display: none; position: fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:9999; justify-content:center; align-items:center;">
    <div style="background: white; padding: 24px; border-radius: 12px; width: 350px; text-align: center;">
      <h3 style="margin-top:0;">Bạn cần đăng nhập</h3>
      <p style="color: #64748b;">Vui lòng đăng nhập để thực hiện tính năng này.</p>
      <div style="display: flex; gap: 10px; margin-top: 20px;">
        <button onclick="closeLoginModal()" style="flex:1; padding: 10px; border:1px solid #e2e8f0; border-radius:6px; cursor:pointer;">Hủy</button>
        <a href="${pageContext.request.contextPath}/login" style="flex:1; padding: 10px; background:#0d9488; color:white; text-decoration:none; border-radius:6px;">Đăng nhập</a>
      </div>
    </div>
  </div>
  <div id="schedule-select-modal" style="display: none; position: fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:9999; justify-content:center; align-items:center;">
    <div style="background: white; padding: 24px; border-radius: 12px; width: 400px; max-height: 85vh; overflow-y: auto; box-shadow: 0 10px 25px rgba(0,0,0,0.2);">
      <h3 style="margin-top:0; color:#0d9488; font-size: 18px; font-weight: 700;">Chọn khung giờ học</h3>
      <p style="color: #64748b; font-size: 13px; margin-bottom: 15px;">Vui lòng chọn các buổi học mong muốn của bạn với gia sư này.</p>

      <div id="modal-schedule-list" style="text-align: left; margin: 20px 0; display: flex; flex-direction: column; gap: 10px;">
      </div>

      <div style="display: flex; gap: 10px; margin-top: 25px;">
        <button onclick="closeScheduleModal()" style="flex:1; padding: 11px; border:1px solid #e2e8f0; background:#f8fafc; color:#64748b; border-radius:6px; cursor:pointer; font-weight:600;">Hủy</button>
        <button id="btn-submit-cart-schedule" style="flex:1; padding: 11px; background:#0d9488; color:white; border:none; border-radius:6px; cursor:pointer; font-weight:600;">Xác nhận chọn</button>
      </div>
    </div>
  </div>
  <div id="contact-modal"
       style="display:none;
            position:fixed;
            inset:0;
            background:rgba(0,0,0,0.5);
            z-index:99999;
            justify-content:center;
            align-items:center;">

    <div style="background:#fff;
                width:400px;
                max-width:90%;
                padding:24px;
                border-radius:12px;
                position:relative;">

      <button onclick="closeContactModal()"
              style="position:absolute;
                       top:12px;
                       right:12px;
                       border:none;
                       background:none;
                       cursor:pointer;
                       font-size:18px;">
        ✕
      </button>

      <h3 style="margin-top:0;color:#0f172a;">
        Thông tin liên hệ gia sư
      </h3>

      <div style="margin-top:20px;">
        <p>
          <strong>Số điện thoại:</strong>
          <span id="contact-phone"></span>
        </p>

        <p>
          <strong>Email:</strong>
          <span id="contact-email"></span>
        </p>
      </div>
    </div>
  </div>
  <script>
    let currentTutorIdForCart = null;
    let currentCartButton = null;
    let originalCartHTML = '';

    function closeScheduleModal() {
      document.getElementById('schedule-select-modal').style.display = 'none';
    }

    document.querySelectorAll('.btn-add-cart').forEach(button => {
      button.addEventListener('click', function (e) {
        e.preventDefault();
        e.stopPropagation();

        // Kiểm tra biến đăng nhập hệ thống của bạn
        if (typeof IS_LOGGED_IN !== 'undefined' && !IS_LOGGED_IN) {
          // Nếu có modal thông báo đăng nhập thì bật lên
          const loginAlert = document.getElementById('your-login-alert-modal-id');
          if (loginAlert) loginAlert.style.display = 'flex';
          return;
        }

        currentTutorIdForCart = this.getAttribute('data-tutor-id');
        currentCartButton = this;
        originalCartHTML = this.innerHTML;

        // Nếu trạng thái đang là "Đã chọn", nhấn lại nghĩa là muốn Xóa khỏi giỏ hàng
        if (this.innerHTML.includes('Đã chọn')) {
          executeToggleCart(currentTutorIdForCart, '');
          return;
        }

        // Gọi API lấy lịch học từ TutorScheduleAPI
        fetch('${pageContext.request.contextPath}/api/tutor/schedules?tutorId=' + currentTutorIdForCart)
                .then(res => res.json())
                .then(data => {
                  const listContainer = document.getElementById('modal-schedule-list');
                  listContainer.innerHTML = ''; // Xóa sạch dữ liệu cũ cũ

                  if (!data.all || data.all.length === 0) {
                    listContainer.innerHTML = '<p style="color:#ef4444; text-align:center; font-size:14px; padding: 10px;">⚠️ Gia sư này chưa đăng ký lịch trống!</p>';
                    return;
                  }

                  // Render danh sách checkbox - ĐÃ SỬA: Thêm dấu \ trước $ để tránh xung đột JSP EL
                  data.all.forEach(sched => {
                    const cleanSched = sched.trim();
                    let isDisabled = data.busy.includes(cleanSched);

                    const itemLabel = document.createElement('label');
                    itemLabel.style.cssText = 'display:flex; align-items:center; gap:12px; padding:10px 14px; border-radius:8px; border:1px solid #e2e8f0; cursor:pointer; font-size:14px; transition: all 0.2s;';

                    let statusBadge = '';
                    if (isDisabled) {
                      statusBadge = ' <span style="margin-left:auto; color:#ef4444; font-weight:600; font-size:12px; background:#fef2f2; padding:2px 6px; border-radius:4px;">Đã thuê</span>';
                      itemLabel.style.background = '#f8fafc';
                      itemLabel.style.color = '#94a3b8';
                      itemLabel.style.cursor = 'not-allowed';
                    }

                    // Lưu ý các dấu \${} bên dưới để không bị JSP nuốt chữ
                    itemLabel.innerHTML = `
                        <input type="checkbox" class="popup-schedule-cb" value="\${cleanSched}"
                               style="width:16px; height:16px; accent-color:#0d9488;"
                               \${isDisabled ? 'disabled' : ''}>
                        <span style="font-weight:500; color: #334155;">\${cleanSched}</span>
                        \${statusBadge}
                    `;
                    listContainer.appendChild(itemLabel);
                  });

                  // Bật modal popup chọn lịch học lên
                  document.getElementById('schedule-select-modal').style.display = 'flex';
                })
                .catch(err => console.error("Lỗi lấy lịch học từ API:", err));
      });
    });

    // Bắt sự kiện nút xác nhận bên trong popup khi phụ huynh chọn xong lịch
    document.getElementById('btn-submit-cart-schedule').addEventListener('click', function() {
      const checkedBoxes = document.querySelectorAll('.popup-schedule-cb:checked');
      if (checkedBoxes.length === 0) {
        alert('⚠️ Bạn phải chọn ít nhất một lịch học để thêm vào giỏ!');
        return;
      }

      // Ghép các ô checkbox được tick thành chuỗi: "Sáng Thứ 2, Chiều Thứ 5"
      const selectedSchedules = Array.from(checkedBoxes).map(cb => cb.value).join(', ');
      closeScheduleModal();

      // Đẩy dữ liệu sang CartServlet xử lý logic
      executeToggleCart(currentTutorIdForCart, selectedSchedules);
    });

    function executeToggleCart(tutorId, scheduleStr) {
      if (currentCartButton) {
        currentCartButton.disabled = true;
        currentCartButton.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang xử lý...';
      }

      fetch('${pageContext.request.contextPath}/cart/toggle?tutorId=' + tutorId + '&schedule=' + encodeURIComponent(scheduleStr), {
        method: 'POST'
      })
              .then(res => res.json())
              .then(data => {
                if (currentCartButton) currentCartButton.disabled = false;

                if (data.status === 'added') {
                  // Thay đổi giao diện nút sang trạng thái "Đã chọn"
                  currentCartButton.style.background = '#475569';
                  currentCartButton.innerHTML = '<i class="fa-solid fa-check-double"></i> Đã chọn';

                  // Cập nhật số lượng item trên badge giỏ hàng của thanh Header nếu có
                  const cartBadge = document.getElementById('cart-badge-count');
                  if (cartBadge && data.total !== undefined) cartBadge.innerText = data.total;

                } else if (data.status === 'removed') {
                  // Khôi phục lại trạng thái nút gốc khi xóa khỏi giỏ hàng
                  currentCartButton.style.background = '#0d9488';
                  currentCartButton.innerHTML = originalCartHTML;

                  const cartBadge = document.getElementById('cart-badge-count');
                  if (cartBadge && data.total !== undefined) cartBadge.innerText = data.total;

                } else if (data.status === 'clash' || data.status === 'require_schedule') {
                  // Trả nút về ban đầu và thông báo lỗi trùng lịch chéo từ BookingDAO phát hiện
                  currentCartButton.innerHTML = originalCartHTML;
                  alert(data.message);
                } else {
                  currentCartButton.innerHTML = originalCartHTML;
                  alert('⚠️ Có lỗi xảy ra, vui lòng thử lại sau.');
                }
              })
              .catch(err => {
                if (currentCartButton) {
                  currentCartButton.disabled = false;
                  currentCartButton.innerHTML = originalCartHTML;
                }
                console.error("Lỗi hệ thống giỏ hàng:", err);
              });
    }
    /// --- 1. CẤU HÌNH BIẾN TOÀN CỤC ---
    var TUTOR_ID = ${t.id};
    var TUTOR_NAME = '<c:out value="${t.fullName}"/>';
    var TUTOR_PRICE = ${not empty t.hourlyRate ? t.hourlyRate : 0}; // Học phí gốc của 1 buổi
    var IS_LOGGED_IN = ${not empty sessionScope.clientUser};
    var USER_BALANCE = ${not empty sessionScope.clientUser ? sessionScope.clientUser.balance : 0};

    // --- 2. CÁC HÀM TIỆN ÍCH ---
    function formatVND(n) { return n.toLocaleString('vi-VN') + 'đ'; }

    // --- ĐÃ SỬA: Chỉ đếm những ô ĐƯỢC TICK chọn và KHÔNG bị disabled ---
    function getCheckedSessionsCount() {
      return document.querySelectorAll('.tutor-schedule-checkbox:checked:not([disabled])').length;
    }

    // --- ĐÃ SỬA: Chỉ lấy chuỗi văn bản của những ô ĐƯỢC TICK chọn và KHÔNG bị disabled ---
    function getCheckedSchedules() {
      return Array.from(document.querySelectorAll('.tutor-schedule-checkbox:checked:not([disabled])'))
              .map(cb => cb.value)
              .join(', ');
    }

    function showToast(msg, type) {
      const colors = { success:'#0d9488', error:'#ef4444', warning:'#f59e0b' };
      const toast = document.createElement('div');
      toast.textContent = msg;
      toast.style.cssText = 'position:fixed;bottom:24px;right:24px;z-index:99999;background:' + (colors[type]||'#334155') +
              ';color:#fff;padding:14px 20px;border-radius:10px;font-size:14px;font-weight:600;box-shadow:0 4px 12px rgba(0,0,0,0.15);';
      document.body.appendChild(toast);
      setTimeout(() => { toast.remove(); }, 3500);
    }

    // --- 3. QUẢN LÝ MODAL ---
    function showLoginModal() { document.getElementById('login-prompt-modal').style.display = 'flex'; }
    function closeLoginModal() { document.getElementById('login-prompt-modal').style.display = 'none'; }
    function closeHireModal() { document.getElementById('hire-modal-overlay').style.display = 'none'; }

    // --- 4. HÀM THUÊ TRỰC TIẾP TỪ NÚT "THUÊ NGAY" ---
    function openHireModal() {
      if (!IS_LOGGED_IN) { showLoginModal(); return; }

      var chosenSchedule = getCheckedSchedules();
      var sessionCount = getCheckedSessionsCount();

      if (!chosenSchedule || sessionCount === 0) {
        showToast('⚠️ Vui lòng chọn ít nhất một buổi học!', 'warning');
        return;
      }

      // 🔥 Tính toán tiền động dựa vào số buổi học được chọn
      var totalCalculatedPrice = TUTOR_PRICE * sessionCount;

      const overlay = document.getElementById('hire-modal-overlay');
      // Ẩn toàn bộ các case nội dung modal trước khi hiển thị
      document.getElementById('modal-not-logged-in').style.display = 'none';
      document.getElementById('modal-insufficient').style.display = 'none';
      document.getElementById('modal-confirm').style.display = 'none';

      // Kiểm tra số dư với mức tổng tiền mới tính toán
      if (USER_BALANCE < totalCalculatedPrice) {
        document.getElementById('modal-insufficient-sessions').textContent = sessionCount;
        document.getElementById('modal-tutor-price').textContent = formatVND(totalCalculatedPrice);
        document.getElementById('modal-user-balance').textContent = formatVND(USER_BALANCE);
        document.getElementById('modal-insufficient').style.display = 'block';
      } else {
        document.getElementById('modal-confirm-name').textContent = TUTOR_NAME;
        document.getElementById('modal-confirm-session-label').textContent = 'Tổng học phí (' + sessionCount + ' buổi)';
        document.getElementById('modal-confirm-price').textContent = formatVND(totalCalculatedPrice);
        document.getElementById('modal-confirm-remaining').textContent = formatVND(USER_BALANCE - totalCalculatedPrice);
        document.getElementById('modal-confirm').style.display = 'block';
      }
      overlay.style.display = 'flex';
    }

    // --- 5. LOGIC GỬI ĐƠN BOOKING TRỰC TIẾP LÊN SERVER ---
    function executeHire() {
      var chosenSchedule = getCheckedSchedules();
      var btn = document.getElementById('btn-confirm-hire');

      if (btn) {
        btn.disabled = true;
        btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang xử lý...';
      }

      fetch('${pageContext.request.contextPath}/booking/hire', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'tutorId=' + TUTOR_ID + '&schedule=' + encodeURIComponent(chosenSchedule)
      })
              .then(res => res.json())
              .then(data => {
                if (data.status === 'SUCCESS') {
                  showToast('🎉 Thuê gia sư thành công!', 'success');
                  setTimeout(() => {
                    window.location.href = '${pageContext.request.contextPath}/parent/hired-tutors';
                  }, 1500);
                } else {
                  // 🔥 ĐÃ SỬA: Chuyển toàn bộ mã lỗi hệ thống sang Tiếng Việt trực quan
                  let errMsg = 'Có lỗi xảy ra, vui lòng thử lại sau.';

                  switch (data.status) {
                    case 'ERR_ALREADY_HIRED':
                      errMsg = 'Bạn đã có một hợp đồng lớp học đang hoạt động với gia sư này rồi!';
                      break;
                    case 'ERR_SCHEDULE_CLASH':
                      errMsg = 'Lịch học bạn chọn đã bị trùng với lịch của người khác vừa thuê trước mất rồi!';
                      break;
                    case 'ERR_BALANCE_NOT_ENOUGH':
                    case 'ERR_INSUFFICIENT_BALANCE':
                      errMsg = 'Số dư tài khoản ví của bạn không đủ để thực hiện thanh toán!';
                      break;
                    case 'ERR_EMPTY_SCHEDULE':
                      errMsg = 'Vui lòng chọn ít nhất một khung giờ trống trước khi xác nhận!';
                      break;
                    case 'ERR_TUTOR_NOT_FOUND':
                      errMsg = 'Không tìm thấy thông tin gia sư này trên hệ thống!';
                      break;
                    case 'ERR_SYSTEM':
                      errMsg = 'Hệ thống đang bận xử lý giao dịch, vui lòng thử lại sau ít phút.';
                      break;
                  }

                  // Hiển thị thông báo tiếng Việt bằng Toast hoặc Alert tùy ông chọn
                  alert('⚠️ Thông báo: ' + errMsg);

                  if (btn) {
                    btn.disabled = false;
                    btn.innerHTML = '<svg style="width:16px;height:16px;" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12.75l6 6 9-13.5"/></svg> Xác nhận thuê';
                  }
                }
              })
              .catch(err => {
                console.error("Lỗi API Hire:", err);
                alert('❌ Lỗi kết nối hệ thống đường truyền. Vui lòng kiểm tra lại!');
                if (btn) {
                  btn.disabled = false;
                  btn.innerHTML = 'Xác nhận thuê';
                }
              });
    }

    // --- 6. LOGIC THÊM VÀO GIỎ HÀNG (CART DETAIL) ---
    document.addEventListener('DOMContentLoaded', function() {
      var cartBtn = document.getElementById('btn-detail-cart');
      if (cartBtn) {
        cartBtn.addEventListener('click', function() {
          if (!IS_LOGGED_IN) { showLoginModal(); return; }

          var selected = getCheckedSchedules();
          if (!selected) { showToast('⚠️ Vui lòng chọn lịch trước khi thêm vào giỏ!', 'warning'); return; }

          fetch('${pageContext.request.contextPath}/cart/toggle?tutorId=' + TUTOR_ID + '&schedule=' + encodeURIComponent(selected), { method: 'POST' })
                  .then(res => res.status === 401 ? (showLoginModal(), null) : res.json())
                  .then(data => {
                    if (!data) return;
                    var icon = document.getElementById('icon-detail-cart');
                    var text = document.getElementById('text-detail-cart');
                    if (data.status === 'added') {
                      icon.className = 'fa-solid fa-check-double'; text.textContent = 'Đã chọn';
                      cartBtn.style.background = '#475569'; cartBtn.style.color = '#fff';
                      showToast('🛒 Đã thêm gia sư kèm lịch vào giỏ hàng!', 'success');
                    } else if (data.status === 'removed') {
                      icon.className = 'fa-solid fa-cart-plus'; text.textContent = 'Vào giỏ';
                      cartBtn.style.background = '#ccfbf1'; cartBtn.style.color = '#0d9488';
                      showToast('🗑️ Đã xóa gia sư khỏi giỏ hàng.', 'info');
                    } else if (data.status === 'clash') {
                      showToast('❌ Lịch học vừa chọn đã bị trùng chéo!', 'error');
                    }

                    // Cập nhật lại số badge nhỏ trên giỏ hàng hệ thống thanh Header nhanh
                    var globalBadge = document.getElementById('cart-badge-count');
                    if (globalBadge && data.total !== undefined) globalBadge.innerText = data.total;
                  });
        });
      }
    });
  </script>
  <style>
    @keyframes spin { to { transform: rotate(360deg); } }
  </style>


</main>

<jsp:include page="/views/common/footer.jsp" />

<script>
  document.querySelectorAll('.price-format').forEach(function(el) {
    var val = parseFloat(el.textContent);
    if(!isNaN(val)) {
      el.textContent = val.toLocaleString('vi-VN');
    }
  });
  // ===== WISHLIST & CART CHO TUTOR-DETAIL =====
  (function() {
    // WISHLIST
    var wishBtn = document.getElementById('btn-detail-wishlist');
    if (wishBtn) {
      wishBtn.addEventListener('click', function() {
        // Kiểm tra đăng nhập qua biến toàn cục IS_LOGGED_IN
        if (!IS_LOGGED_IN) { showLoginModal(); return; }

        var tutorId = this.getAttribute('data-tutor-id');
        var icon = document.getElementById('icon-detail-wishlist');
        var text = document.getElementById('text-detail-wishlist');

        fetch('${pageContext.request.contextPath}/parent/wishlist?tutorId=' + tutorId, { method: 'POST' })
                .then(function(res) {
                  if (res.status === 401) { showLoginModal(); return null; }
                  return res.json();
                })
                .then(function(data) {
                  if (!data) return;
                  if (data.status === 'added') {
                    icon.className = 'fa-solid fa-heart';
                    text.textContent = 'Đã lưu';
                    wishBtn.style.color = '#ef4444';
                    wishBtn.style.borderColor = '#fecaca';
                    wishBtn.style.background = '#fff1f2';
                  } else if (data.status === 'removed') {
                    icon.className = 'fa-regular fa-heart';
                    text.textContent = 'Yêu thích';
                    wishBtn.style.color = '#64748b';
                    wishBtn.style.borderColor = '#e2e8f0';
                    wishBtn.style.background = '#fff';
                  }
                })
                .catch(function(e) { console.error('Wishlist error:', e); });
      });
    }

    // CART
    var cartBtn = document.getElementById('btn-detail-cart');
    if (cartBtn) {
      cartBtn.addEventListener('click', function() {
        // 1. Kiểm tra đăng nhập bằng biến IS_LOGGED_IN
        if (!IS_LOGGED_IN) { showLoginModal(); return; }

        // 2. Validate lịch học (Bắt buộc chọn lịch trước khi thêm vào giỏ)
        var selected = getCheckedSchedules();
        if (!selected) { showToast('⚠️ Vui lòng chọn lịch trước khi thêm vào giỏ!', 'warning'); return; }

        var tutorId = this.getAttribute('data-tutor-id');
        var icon = document.getElementById('icon-detail-cart');
        var text = document.getElementById('text-detail-cart');

        fetch('${pageContext.request.contextPath}/cart/toggle?tutorId=' + tutorId + '&schedule=' + encodeURIComponent(selected), { method: 'POST' })
                .then(function(res) {
                  if (res.status === 401) { showLoginModal(); return null; }
                  return res.json();
                })
                .then(function(data) {
                  if (!data) return;
                  if (data.status === 'added') {
                    icon.className = 'fa-solid fa-check-double';
                    text.textContent = 'Đã chọn';
                    cartBtn.style.background = '#475569';
                    cartBtn.style.color = '#fff';
                  } else if (data.status === 'removed') {
                    icon.className = 'fa-solid fa-cart-plus';
                    text.textContent = 'Vào giỏ';
                    cartBtn.style.background = '#ccfbf1';
                    cartBtn.style.color = '#0d9488';
                  }
                })
                .catch(function(e) { console.error('Cart error:', e); });
      });
    }
  })();
  function executeHire() {
    var chosenSchedule = getCheckedSchedules(); // Hàm bạn đã có
    if (!chosenSchedule) {
      showToast('⚠️ Vui lòng chọn lịch học!', 'warning');
      return;
    }

    var btn = document.getElementById('btn-confirm-hire');
    btn.disabled = true; // Khóa nút để tránh spam

    // Gửi đúng định dạng form-urlencoded
    var params = 'tutorId=' + TUTOR_ID + '&schedule=' + encodeURIComponent(chosenSchedule);

    fetch('${pageContext.request.contextPath}/booking/hire', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: params
    })
            .then(res => res.json())
            .then(data => {
              if (data.status === 'SUCCESS') {
                alert('Thuê gia sư thành công!');
                location.reload();
              } else {
                alert('Lỗi: ' + data.status);
                btn.disabled = false; // Mở lại nút nếu lỗi
              }
            })
            .catch(err => {
              console.error(err);
              btn.disabled = false;
            });
  }
  function closeContactModal() {
    document.getElementById('contact-modal').style.display = 'none';
  }

  document.addEventListener('DOMContentLoaded', function () {

    const btnContact = document.getElementById('btn-contact-tutor');

    if (btnContact) {

      btnContact.addEventListener('click', function () {

        const phone = this.dataset.phone;
        const email = this.dataset.email;

        document.getElementById('contact-phone').textContent =
                phone || 'Chưa cập nhật';

        document.getElementById('contact-email').textContent =
                email || 'Chưa cập nhật';

        document.getElementById('contact-modal').style.display = 'flex';
      });
    }

  });
</script>