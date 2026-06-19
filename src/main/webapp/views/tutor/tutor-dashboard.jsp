<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<jsp:include page="/views/common/header.jsp">
  <jsp:param name="pageTitle" value="Bảng điều khiển Gia sư - Gia Sư Bá Đạo"/>
</jsp:include>
<jsp:include page="/views/common/navbar.jsp"/>

<main class="tutor-main-content" style="background-color: #f8fafc; padding: 40px 0; font-family: 'Plus Jakarta Sans', sans-serif;">
  <div class="container" style="max-width: 1240px; margin: 0 auto; padding: 0 20px;">

    <!-- TIÊU ĐỀ CHÀO MỪNG -->
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px;">
      <div>
        <h1 style="font-size: 28px; color: #0f172a; font-weight: 800; margin: 0 0 4px 0;">Xin chào, ${sessionScope.clientUser.fullname}! 👋</h1>
        <p style="color: #64748b; margin: 0; font-size: 15px;">Chào mừng bạn quay trở lại với không gian quản lý dạy học.</p>
      </div>
      <a href="${pageContext.request.contextPath}/tutor/settings" style="display: inline-flex; align-items: center; gap: 8px; background: #0f172a; color: #fff; padding: 12px 20px; border-radius: 10px; text-decoration: none; font-weight: 600; font-size: 14px; transition: 0.2s;">
        <i class="bi bi-calendar-plus"></i> Cập nhật lịch trống
      </a>
    </div>

    <!-- THẺ THỐNG KÊ NHANH -->
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 24px; margin-bottom: 32px;">

      <div style="background: #fff; padding: 24px; border-radius: 16px; border: 1px solid #e2e8f0; display: flex; align-items: center; gap: 20px;">
        <div style="background: #ecfdf5; color: #10b981; width: 56px; height: 56px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 24px;">
          <i class="bi bi-wallet2"></i>
        </div>
        <div>
          <span style="display: block; color: #64748b; font-size: 14px; font-weight: 500; margin-bottom: 4px;">Ví thu nhập</span>
          <strong style="font-size: 20px; color: #0f172a; font-weight: 700;">
            <fmt:formatNumber value="${not empty sessionScope.clientUser.balance ? sessionScope.clientUser.balance : 0}" type="number"/> đ
          </strong>
        </div>
      </div>

      <div style="background: #fff; padding: 24px; border-radius: 16px; border: 1px solid #e2e8f0; display: flex; align-items: center; gap: 20px;">
        <div style="background: #eff6ff; color: #3b82f6; width: 56px; height: 56px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 24px;">
          <i class="bi bi-journal-bookmark-fill"></i>
        </div>
        <div>
          <span style="display: block; color: #64748b; font-size: 14px; font-weight: 500; margin-bottom: 4px;">Lớp đang dạy</span>
          <strong style="font-size: 22px; color: #0f172a; font-weight: 700;">${activeClassesCount} lớp</strong>
        </div>
      </div>

      <div style="background: #fff; padding: 24px; border-radius: 16px; border: 1px solid #e2e8f0; display: flex; align-items: center; gap: 20px;">
        <div style="background: #fdf2f8; color: #ec4899; width: 56px; height: 56px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 24px;">
          <i class="bi bi-calendar-check"></i>
        </div>
        <div>
          <span style="display: block; color: #64748b; font-size: 14px; font-weight: 500; margin-bottom: 4px;">Tổng lịch yêu cầu</span>
          <strong style="font-size: 22px; color: #0f172a; font-weight: 700;">${totalBookingsCount} lượt</strong>
        </div>
      </div>

    </div>

    <!-- BỐ CỤC CHÍNH BẢNG ĐIỀU KHIỂN -->
    <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 32px; align-items: start;">

      <!-- BÊN TRÁI: DANH SÁCH LỊCH DẠY -->
      <section style="background: #fff; border-radius: 16px; border: 1px solid #e2e8f0; padding: 28px;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
          <h3 style="font-size: 18px; color: #0f172a; font-weight: 700; margin: 0; display: flex; align-items: center; gap: 10px;">
            <i class="bi bi-calendar3" style="color: #10b981;"></i> Danh sách ca dạy hiện tại
          </h3>
          <a href="${pageContext.request.contextPath}/tutor/my-lessons" style="color: #10b981; font-size: 14px; font-weight: 600; text-decoration: none;">Xem tất cả</a>
        </div>

        <div style="overflow-x: auto;">
          <table style="width: 100%; border-collapse: collapse; text-align: left;">
            <thead>
            <tr style="border-bottom: 2px solid #f1f5f9; color: #64748b; font-size: 13px; font-weight: 600;">
              <th style="padding: 12px 16px;">Học viên / Phụ huynh</th>
              <th style="padding: 12px 16px;">Môn học đăng ký</th>
              <th style="padding: 12px 16px;">Thời gian học</th>
              <th style="padding: 12px 16px; text-align: center;">Trạng thái</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
              <c:when test="${not empty upcomingLessons}">
                <c:forEach var="lesson" items="${upcomingLessons}">
                  <tr style="border-bottom: 1px solid #f1f5f9; font-size: 14px;">
                    <td style="padding: 16px; display: flex; align-items: center; gap: 12px;">
                      <img src="${not empty lesson.portraitUrl ? lesson.portraitUrl : pageContext.request.contextPath.concat('/assets/images/default-avatar.png')}" style="width: 36px; height: 36px; border-radius: 50%; object-fit: cover; border: 1px solid #e2e8f0;">
                      <div style="font-weight: 600; color: #0f172a;">${lesson.tutorName}</div>
                    </td>
                    <td style="padding: 16px; color: #334155;">
                                                <span style="background: #f1f5f9; padding: 4px 10px; border-radius: 6px; font-size: 12px; font-weight: 600; color: #0f172a;">
                                                    ${lesson.subjectName}
                                                </span>
                    </td>
                    <td style="padding: 16px; font-weight: 500; color: #334155;">
                        ${lesson.schedule}
                    </td>
                    <td style="padding: 16px; text-align: center;">
                                                <span style="padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 600;
                                                        background: ${lesson.status == 'ACTIVE' || lesson.status == 'PAID' ? '#d1fae5' : '#f1f5f9'};
                                                        color: ${lesson.status == 'ACTIVE' || lesson.status == 'PAID' ? '#065f46' : '#475569'};">
                                                    ${lesson.statusLabel}
                                                </span>
                    </td>
                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <tr>
                  <td colspan="4" style="text-align: center; padding: 40px 0; color: #94a3b8;">
                    <i class="bi bi-calendar-x" style="font-size: 32px; display: block; margin-bottom: 12px;"></i>
                    Hiện tại chưa có lịch dạy học chính thức nào diễn ra.
                  </td>
                </tr>
              </c:otherwise>
            </c:choose>
            </tbody>
          </table>
        </div>
      </section>

      <!-- BÊN PHẢI: THÔNG BÁO LỚP CHỜ THANH TOÁN / THAO TÁC NHANH -->
      <aside style="display: flex; flex-direction: column; gap: 24px;">

        <div style="background: #fff; border-radius: 16px; border: 1px solid #e2e8f0; padding: 24px;">
          <h3 style="font-size: 16px; color: #0f172a; font-weight: 700; margin: 0 0 16px 0; display: flex; align-items: center; gap: 8px;">
            <i class="bi bi-bell" style="color: #f59e0b;"></i> Yêu cầu đặt lịch mới
          </h3>

          <c:choose>
            <c:when test="${not empty pendingLessons}">
              <c:forEach var="pending" items="${pendingLessons}">
                <div style="padding: 14px; background: #fffbeb; border-radius: 12px; border: 1px solid #fef3c7; margin-bottom: 12px;">
                  <div style="font-size: 13px; color: #b45309; margin: 0 0 8px 0;">
                    Phụ huynh <strong>${pending.tutorName}</strong> vừa lên lịch đăng ký dạy môn <strong>${pending.subjectName}</strong> vào khung giờ: ${pending.schedule}.
                  </div>
                  <a href="${pageContext.request.contextPath}/tutor/my-lessons" style="display: inline-block; background: #b45309; color: #fff; text-decoration: none; padding: 6px 12px; border-radius: 6px; font-size: 12px; font-weight: 600;">Xem chi tiết</a>
                </div>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <div style="text-align: center; padding: 10px 0; color: #94a3b8; font-size: 13px;">
                Không có yêu cầu đặt lịch chờ xử lý.
              </div>
            </c:otherwise>
          </c:choose>
        </div>

        <div style="background: #fff; border-radius: 16px; border: 1px solid #e2e8f0; padding: 24px;">
          <h3 style="font-size: 16px; color: #0f172a; font-weight: 700; margin: 0 0 16px 0;">Thao tác nhanh</h3>
          <div style="display: flex; flex-direction: column; gap: 10px;">
            <a href="${pageContext.request.contextPath}/tutor/settings?tab=profile" style="display: flex; align-items: center; justify-content: space-between; padding: 12px 16px; background: #f8fafc; border-radius: 10px; text-decoration: none; color: #334155; font-size: 14px; font-weight: 600;">
              <span><i class="bi bi-person-vcard" style="margin-right: 8px; color: #64748b;"></i> Hồ sơ năng lực</span>
              <i class="bi bi-chevron-right" style="font-size: 12px;"></i>
            </a>
            <a href="${pageContext.request.contextPath}/tutor/wallet" style="display: flex; align-items: center; justify-content: space-between; padding: 12px 16px; background: #f8fafc; border-radius: 10px; text-decoration: none; color: #334155; font-size: 14px; font-weight: 600;">
              <span><i class="bi bi-cash-stack" style="margin-right: 8px; color: #10b981;"></i> Rút tiền về ngân hàng</span>
              <i class="bi bi-chevron-right" style="font-size: 12px;"></i>
            </a>
          </div>
        </div>

      </aside>
    </div>

  </div>
</main>

<jsp:include page="/views/common/footer.jsp" />