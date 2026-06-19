<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<jsp:include page="/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Cài đặt gia sư - Gia Sư Bá Đạo"/>
</jsp:include>

<jsp:include page="/views/common/navbar.jsp" />
<c:set var="u" value="${sessionScope.clientUser}"/>
<main class="page-main" style="background-color: #f8fafc; padding: 40px 0; font-family: sans-serif;">
    <div class="container" style="max-width: 1200px; margin: 0 auto; display: flex; gap: 30px;">

        <aside style="width: 280px; background: #fff; padding: 24px 16px; border-radius: 16px; border: 1px solid #f1f5f9; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); height: fit-content;">
            <h4 style="margin: 0 0 16px 12px; color: #64748b; font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em;">Cài đặt gia sư</h4>
            <ul style="list-style: none; padding: 0; margin: 0; display: flex; flex-direction: column; gap: 8px;">

                <li>
                    <a href="${pageContext.request.contextPath}/tutor/settings?tab=profile"
                       style="display: flex; align-items: center; gap: 12px; padding: 12px 16px; text-decoration: none; border-radius: 10px; font-size: 14px; font-weight: 600; transition: all 0.2s;
                      ${param.tab == 'profile' || empty param.tab ? 'background: #0f172a; color: #fff;' : 'color: #475569; background: transparent;'}"
                       onmouseover="if(this.style.background!=='rgb(15, 23, 42)') {this.style.background='#f8fafc'; this.style.color='#0f172a';}"
                       onmouseout="if(this.style.background!=='rgb(15, 23, 42)') {this.style.background='transparent'; this.style.color='#475569';}">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                        Hồ sơ năng lực
                    </a>
                </li>

                <li>
                    <a href="${pageContext.request.contextPath}/tutor/settings?tab=fees"
                       style="display: flex; align-items: center; gap: 12px; padding: 12px 16px; text-decoration: none; border-radius: 10px; font-size: 14px; font-weight: 600; transition: all 0.2s;
                      ${param.tab == 'fees' ? 'background: #0f172a; color: #fff;' : 'color: #475569; background: transparent;'}"
                       onmouseover="if(this.style.background!=='rgb(15, 23, 42)') {this.style.background='#f8fafc'; this.style.color='#0f172a';}"
                       onmouseout="if(this.style.background!=='rgb(15, 23, 42)') {this.style.background='transparent'; this.style.color='#475569';}">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
                        Thiết lập học phí
                    </a>
                </li>

                <li>
                    <a href="${pageContext.request.contextPath}/tutor/settings?tab=schedule"
                       style="display: flex; align-items: center; gap: 12px; padding: 12px 16px; text-decoration: none; border-radius: 10px; font-size: 14px; font-weight: 600; transition: all 0.2s;
                      ${param.tab == 'schedule' ? 'background: #0f172a; color: #fff;' : 'color: #475569; background: transparent;'}"
                       onmouseover="if(this.style.background!=='rgb(15, 23, 42)') {this.style.background='#f8fafc'; this.style.color='#0f172a';}"
                       onmouseout="if(this.style.background!=='rgb(15, 23, 42)') {this.style.background='transparent'; this.style.color='#475569';}">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                        Cập nhật lịch trống
                    </a>
                </li>
            </ul>
        </aside>

        <section style="flex: 1; background: #fff; padding: 35px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.05);">

            <%-- THÊM: Nút Quay lại Bảng điều khiển tối ưu UI --%>
            <div style="margin-bottom: 24px;">
                <a href="${pageContext.request.contextPath}/tutor/dashboard"
                   style="display: inline-flex; align-items: center; gap: 8px; text-decoration: none; color: #475569; background-color: #f1f5f9; padding: 10px 18px; border-radius: 10px; font-size: 14px; font-weight: 600; transition: all 0.2s; border: 1px solid #e2e8f0;"
                   onmouseover="this.style.background='#e2e8f0'; this.style.color='#0f172a'; this.style.borderColor='#cbd5e1';"
                   onmouseout="this.style.background='#f1f5f9'; this.style.color='#475569'; this.style.borderColor='#e2e8f0';">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="19" y1="12" x2="5" y2="12"></line>
                        <polyline points="12 19 5 12 12 5"></polyline>
                    </svg>
                    Quay lại bảng điều khiển
                </a>
            </div>

            <c:if test="${not empty sessionScope.msgSuccess}">
                <div style="padding: 12px; background: #f0fdf4; color: #16a34a; border-radius: 6px; margin-bottom: 20px; font-size: 14px; font-weight: 600;">
                        ${sessionScope.msgSuccess}
                </div>
                <c:remove var="msgSuccess" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.msgError}">
                <div style="padding: 12px; background: #fef2f2; color: #dc2626; border-radius: 6px; margin-bottom: 20px; font-size: 14px; font-weight: 600;">
                        ${sessionScope.msgError}
                </div>
                <c:remove var="msgError" scope="session"/>
            </c:if>

            <c:choose>
                <%-- ======================================================= --%>
                <%-- TAB 2: THIẾT LẬP HỌC PHÍ --%>
                <%-- ======================================================= --%>
                <c:when test="${param.tab == 'fees'}">
                    <div style="border-bottom: 1px solid #e2e8f0; padding-bottom: 15px; margin-bottom: 25px;">
                        <h3 style="margin: 0 0 5px 0; font-size: 22px; color: #0f172a;">Thiết lập học phí</h3>
                        <p style="margin: 0; color: #64748b; font-size: 14px;">Điều chỉnh mức học phí mong muốn nhận được cho mỗi buổi dạy.</p>
                    </div>

                    <form method="POST" action="${pageContext.request.contextPath}/tutor/settings">
                        <input type="hidden" name="actionType" value="updateTutorFees">
                        <div style="margin-bottom: 25px; max-width: 400px;">
                            <label style="display: block; font-size: 14px; font-weight: 600; margin-bottom: 8px; color: #334155;">Học phí mong muốn (VNĐ / Buổi) *</label>
                            <input type="number" name="hourlyRate" value="${tutor.hourlyRate}" required min="0" step="10000"
                                   style="width: 100%; padding: 11px 14px; border: 1px solid #cbd5e1; border-radius: 6px; box-sizing: border-box; font-size: 15px;">
                        </div>
                        <button type="submit" style="background: #10b981; color: #fff; border: none; padding: 12px 30px; border-radius: 6px; font-size: 15px; font-weight: 600; cursor: pointer; transition: background 0.2s;">
                            Cập nhật học phí
                        </button>
                    </form>
                </c:when>

                <%-- ======================================================= --%>
                <%-- TAB 3: CẬP NHẬT LỊCH TRỐNG (BẢNG CHỌN TIỆN LỢI) --%>
                <%-- ======================================================= --%>
                <c:when test="${param.tab == 'schedule'}">
                    <div style="border-bottom: 1px solid #e2e8f0; padding-bottom: 15px; margin-bottom: 25px;">
                        <h3 style="margin: 0 0 5px 0; font-size: 22px; color: #0f172a;">Cập nhật lịch trống</h3>
                        <p style="margin: 0; color: #64748b; font-size: 14px;">Chọn các khoảng thời gian bạn có thể dạy trong tuần để phụ huynh dễ dàng đăng ký.</p>
                    </div>

                    <form method="POST" action="${pageContext.request.contextPath}/tutor/settings">
                        <input type="hidden" name="actionType" value="updateTutorSchedule">

                        <div style="margin-bottom: 25px; overflow-x: auto;">
                            <table style="width: 100%; border-collapse: collapse; min-width: 600px; font-size: 14px; text-align: center;">
                                <thead>
                                <tr style="background-color: #f1f5f9; border-bottom: 2px solid #cbd5e1;">
                                    <th style="padding: 12px; font-weight: 700; color: #475569; text-align: left; width: 120px;">Buổi \ Thứ</th>
                                    <th style="padding: 12px; font-weight: 600; color: #475569;">Thứ 2</th>
                                    <th style="padding: 12px; font-weight: 600; color: #475569;">Thứ 3</th>
                                    <th style="padding: 12px; font-weight: 600; color: #475569;">Thứ 4</th>
                                    <th style="padding: 12px; font-weight: 600; color: #475569;">Thứ 5</th>
                                    <th style="padding: 12px; font-weight: 600; color: #475569;">Thứ 6</th>
                                    <th style="padding: 12px; font-weight: 600; color: #475569;">Thứ 7</th>
                                    <th style="padding: 12px; font-weight: 600; color: #475569;">Chủ Nhật</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:set var="days" value="${['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'Chủ Nhật']}" />

                                <tr style="border-bottom: 1px solid #e2e8f0;">
                                    <td style="padding: 14px; font-weight: 600; color: #0f172a; text-align: left; background-color: #f8fafc;">Sáng</td>
                                    <c:forEach var="day" items="${days}">
                                        <td style="padding: 14px;">
                                            <label style="cursor: pointer; display: inline-flex; align-items: center; justify-content: center; width: 24px; height: 24px;">
                                                <input type="checkbox" name="schedules" value="Sáng ${day}"
                                                    ${fn:contains(tutor.availableSchedules, 'Sáng '.concat(day)) ? 'checked' : ''}
                                                       style="width: 18px; height: 18px; accent-color: #10b981; cursor: pointer;">
                                            </label>
                                        </td>
                                    </c:forEach>
                                </tr>
                                <tr style="border-bottom: 1px solid #e2e8f0;">
                                    <td style="padding: 14px; font-weight: 600; color: #0f172a; text-align: left; background-color: #f8fafc;">Chiều</td>
                                    <c:forEach var="day" items="${days}">
                                        <td style="padding: 14px;">
                                            <label style="cursor: pointer; display: inline-flex; align-items: center; justify-content: center; width: 24px; height: 24px;">
                                                <input type="checkbox" name="schedules" value="Chiều ${day}"
                                                    ${fn:contains(tutor.availableSchedules, 'Chiều '.concat(day)) ? 'checked' : ''}
                                                       style="width: 18px; height: 18px; accent-color: #10b981; cursor: pointer;">
                                            </label>
                                        </td>
                                    </c:forEach>
                                </tr>
                                <tr style="border-bottom: 1px solid #e2e8f0;">
                                    <td style="padding: 14px; font-weight: 600; color: #0f172a; text-align: left; background-color: #f8fafc;">Tối</td>
                                    <c:forEach var="day" items="${days}">
                                        <td style="padding: 14px;">
                                            <label style="cursor: pointer; display: inline-flex; align-items: center; justify-content: center; width: 24px; height: 24px;">
                                                <input type="checkbox" name="schedules" value="Tối ${day}"
                                                    ${fn:contains(tutor.availableSchedules, 'Tối '.concat(day)) ? 'checked' : ''}
                                                       style="width: 18px; height: 18px; accent-color: #10b981; cursor: pointer;">
                                            </label>
                                        </td>
                                    </c:forEach>
                                </tr>
                                </tbody>
                            </table>
                        </div>

                        <button type="submit" style="background: #10b981; color: #fff; border: none; padding: 12px 30px; border-radius: 6px; font-size: 15px; font-weight: 600; cursor: pointer; transition: background 0.2s;">
                            Lưu lịch trống
                        </button>
                    </form>
                </c:when>

                <%-- ======================================================= --%>
                <%-- TAB MẶC ĐỊNH (HOẶC ?tab=profile): HỒ SƠ NĂNG LỰC --%>
                <%-- ======================================================= --%>
                <c:otherwise>
                    <div style="border-bottom: 1px solid #e2e8f0; padding-bottom: 15px; margin-bottom: 25px;">
                        <h3 style="margin: 0 0 5px 0; font-size: 22px; color: #0f172a;">Hồ sơ năng lực</h3>
                        <p style="margin: 0; color: #64748b; font-size: 14px;">Cập nhật thông tin học vấn và kinh nghiệm để thu hút phụ huynh.</p>
                    </div>

                    <form method="POST" action="${pageContext.request.contextPath}/tutor/settings">
                        <input type="hidden" name="actionType" value="updateTutorInfo">

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px;">
                            <div>
                                <label style="display: block; font-size: 14px; font-weight: 600; margin-bottom: 6px; color: #334155;">Trường đại học / Cơ quan công tác *</label>
                                <input type="text" name="school" value="${tutor.school}" required style="width: 100%; padding: 10px; border: 1px solid #cbd5e1; border-radius: 6px; box-sizing: border-box;">
                            </div>
                            <div>
                                <label style="display: block; font-size: 14px; font-weight: 600; margin-bottom: 6px; color: #334155;">Chuyên ngành học *</label>
                                <input type="text" name="major" value="${tutor.major}" required style="width: 100%; padding: 10px; border: 1px solid #cbd5e1; border-radius: 6px; box-sizing: border-box;">
                            </div>
                        </div>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px;">
                            <div>
                                <label style="display: block; font-size: 14px; font-weight: 600; margin-bottom: 6px; color: #334155;">Họ và tên *</label>
                                <input type="text" name="fullname" value="${u.fullname}" required style="width: 100%; padding: 10px; border: 1px solid #cbd5e1; border-radius: 6px; box-sizing: border-box;">
                            </div>
                            <div>
                                <label style="display: block; font-size: 14px; font-weight: 600; margin-bottom: 6px; color: #334155;">Số điện thoại *</label>
                                <input type="tel" name="phone" value="${u.phone}" required style="width: 100%; padding: 10px; border: 1px solid #cbd5e1; border-radius: 6px; box-sizing: border-box;">
                            </div>
                        </div>
                        <div style="margin-bottom: 20px;">
                            <label style="display: block; font-size: 14px; font-weight: 600; margin-bottom: 6px; color: #334155;">Trình độ / Bằng cấp cao nhất *</label>
                            <select class="select-field" name="qualification" style="width: 100%; padding: 10px; border: 1px solid #cbd5e1; border-radius: 6px; background-color: #fff;" required>
                                <option value="Sinh Viên" ${tutor.degreeLevel eq 'Sinh Viên' ? 'selected' : ''}>Sinh Viên</option>
                                <option value="Cử Nhân" ${tutor.degreeLevel eq 'Cử Nhân' ? 'selected' : ''}>Cử Nhân</option>
                                <option value="Thạc Sĩ" ${tutor.degreeLevel eq 'Thạc Sĩ' ? 'selected' : ''}>Thạc Sĩ</option>
                                <option value="Giáo Viên" ${tutor.degreeLevel eq 'Giáo Viên' ? 'selected' : ''}>Giáo Viên / Giảng Viên</option>
                            </select>
                        </div>

                        <div style="margin-bottom: 25px;">
                            <label style="display: block; font-size: 14px; font-weight: 600; margin-bottom: 6px; color: #334155;">Tóm tắt câu chuyện & Kinh nghiệm bản thân *</label>
                            <textarea name="experienceSummary" rows="4" required style="width: 100%; padding: 10px; border: 1px solid #cbd5e1; border-radius: 6px; resize: vertical; box-sizing: border-box;">${tutor.experienceSummary}</textarea>
                        </div>

                        <hr style="border: 0; border-top: 1px solid #e2e8f0; margin: 30px 0;">

                        <div style="margin-bottom: 25px;">
                            <label style="display: block; font-size: 14px; font-weight: 700; color: #1e293b; margin-bottom: 10px;">Môn dạy *</label>
                            <div style="display: flex; flex-wrap: wrap; gap: 8px;">
                                <c:forEach var="item" items="${allSubjects}">
                                    <label style="display: inline-flex; align-items: center; gap: 6px; padding: 6px 14px; background: #f1f5f9; border-radius: 20px; font-size: 13px; cursor: pointer; user-select: none;">
                                        <input type="checkbox" name="subjects" value="${item}" ${fn:contains(tutor.subjects, item) ? 'checked' : ''}> ${item}
                                    </label>
                                </c:forEach>
                            </div>
                        </div>

                        <div style="margin-bottom: 25px;">
                            <label style="display: block; font-size: 14px; font-weight: 700; color: #1e293b; margin-bottom: 10px;">Lớp dạy *</label>
                            <div style="display: flex; flex-wrap: wrap; gap: 8px;">
                                <c:forEach var="item" items="${allGrades}">
                                    <label style="display: inline-flex; align-items: center; gap: 6px; padding: 6px 14px; background: #f1f5f9; border-radius: 20px; font-size: 13px; cursor: pointer; user-select: none;">
                                        <input type="checkbox" name="grades" value="${item}" ${fn:contains(tutor.grades, item) ? 'checked' : ''}> ${item}
                                    </label>
                                </c:forEach>
                            </div>
                        </div>

                        <div style="margin-bottom: 30px;">
                            <label style="display: block; font-size: 14px; font-weight: 700; color: #1e293b; margin-bottom: 10px;">Khu vực dạy *</label>
                            <div style="display: flex; flex-wrap: wrap; gap: 8px;">
                                <c:forEach var="item" items="${allAreas}">
                                    <label style="display: inline-flex; align-items: center; gap: 6px; padding: 6px 14px; background: #f1f5f9; border-radius: 20px; font-size: 13px; cursor: pointer; user-select: none;">
                                        <input type="checkbox" name="areas" value="${item}" ${fn:contains(tutor.districtName, item) || fn:contains(tutor.provinceName, item) ? 'checked' : ''}> ${item}
                                    </label>
                                </c:forEach>
                            </div>
                        </div>

                        <button type="submit" style="background: #10b981; color: #fff; border: none; padding: 12px 30px; border-radius: 6px; font-size: 15px; font-weight: 600; cursor: pointer; transition: background 0.2s;">
                            Lưu hồ sơ năng lực
                        </button>
                    </form>
                </c:otherwise>
            </c:choose>
        </section>
    </div>
</main>

<jsp:include page="/views/common/footer.jsp" />