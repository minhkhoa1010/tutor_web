<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<jsp:include page="/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Danh sách Gia sư - Gia Sư Bá Đạo"/>
</jsp:include>

<jsp:include page="/views/common/navbar.jsp"/>

<%-- Tính min/max giá từ dữ liệu thực tế --%>
<c:set var="dbMinPrice" value="100000" />
<c:set var="dbMaxPrice" value="1000000" />
<c:if test="${not empty tutors}">
    <c:forEach var="t" items="${tutors}">
        <c:if test="${t.hourlyRate < dbMinPrice}"><c:set var="dbMinPrice" value="${t.hourlyRate}" /></c:if>
        <c:if test="${t.hourlyRate > dbMaxPrice}"><c:set var="dbMaxPrice" value="${t.hourlyRate}" /></c:if>
    </c:forEach>
</c:if>

<main class="page-main" style="background-color: #f1f5f9; padding: 30px 0; font-family: 'Plus Jakarta Sans', sans-serif;">
    <div class="container" style="max-width: 1300px; margin: 0 auto; padding: 0 16px;">

        <%-- UPPER CONTROL BAR --%>
        <div style="background: #ffffff; border-radius: 16px; padding: 20px; margin-bottom: 24px; box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.05); display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px;">
            <div>
                <h1 style="font-size: 24px; font-weight: 700; color: #0f172a; margin: 0 0 6px 0;">Đội ngũ Gia sư tinh hoa</h1>
                <p style="color: #64748b; font-size: 14px; margin: 0; display: flex; align-items: center; gap: 6px;">
                    <svg style="width: 16px; height: 16px; color: #0d9488;" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12c0 1.268-.63 2.39-1.593 3.068a3.745 3.745 0 01-1.043 3.296 3.745 3.745 0 01-3.296 1.043A3.745 3.745 0 0112 21c-1.268 0-2.39-.63-3.068-1.593a3.746 3.746 0 01-3.296-1.043 3.745 3.745 0 01-1.043-3.296A3.745 3.745 0 013 12c0-1.268.63-2.39 1.593-3.068a3.745 3.745 0 011.043-3.296 3.746 3.746 0 013.296-1.043A3.746 3.746 0 0112 3c1.268 0 2.39.63 3.068 1.593a3.746 3.746 0 013.296 1.043 3.746 3.746 0 011.043 3.296A3.745 3.745 0 0121 12z"></path></svg>
                    Tìm thấy <span style="color: #0d9488; font-weight: 700; font-size: 16px;">${not empty tutors ? tutors.size() : 0}</span> ứng viên phù hợp tiêu chí.
                </p>
            </div>

            <div style="display: flex; align-items: center; gap: 16px;">
                <div style="background: #f1f5f9; padding: 4px; border-radius: 8px; display: inline-flex; gap: 4px;">
                    <button id="btn-grid-layout" onclick="changeLayout('grid')" style="border: none; padding: 6px 12px; border-radius: 6px; cursor: pointer; font-weight: 600; font-size: 13px; transition: all 0.2s; display: inline-flex; align-items: center; gap: 4px;">
                        <svg style="width: 14px; height: 14px;" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6A2.25 2.25 0 016 3.75h2.25A2.25 2.25 0 0110.5 6v2.25a2.25 2.25 0 01-2.25 2.25H6a2.25 2.25 0 01-2.25-2.25V6zM3.75 15.75A2.25 2.25 0 016 13.5h2.25a2.25 2.25 0 012.25 2.25V18a2.25 2.25 0 01-2.25 2.25H6A2.25 2.25 0 013.75 18v-2.25zM13.5 6a2.25 2.25 0 012.25-2.25H18A2.25 2.25 0 0120.25 6v2.25A2.25 2.25 0 0118 10.5h-2.25a2.25 2.25 0 01-2.25-2.25V6zM13.5 15.75a2.25 2.25 0 012.25-2.25H18a2.25 2.25 0 012.25 2.25V18A2.25 2.25 0 0118 20.25h-2.25A2.25 2.25 0 0113.5 18v-2.25z"></path></svg>
                        Lưới
                    </button>
                    <button id="btn-list-layout" onclick="changeLayout('list')" style="border: none; padding: 6px 12px; border-radius: 6px; cursor: pointer; font-weight: 600; font-size: 13px; transition: all 0.2s; display: inline-flex; align-items: center; gap: 4px;">
                        <svg style="width: 14px; height: 14px;" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M3.75 12h16.5m-16.5 5.25h16.5m-16.5-10.5h16.5"></path></svg>
                        Danh sách
                    </button>
                </div>
                <a href="${pageContext.request.contextPath}/tutors" style="background: #fff; color: #64748b; border: 1px solid #e2e8f0; padding: 8px 16px; border-radius: 8px; text-decoration: none; font-size: 13px; font-weight: 600; box-shadow: 0 1px 2px 0 rgba(0,0,0,0.05); display: inline-flex; align-items: center; gap: 6px;">
                    <svg style="width: 14px; height: 14px;" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M16.023 9.348h4.992v-.001M2.985 19.644v-4.992m0 0h4.992m-4.993 0l3.181 3.183a8.25 8.25 0 0013.803-3.7M4.031 9.865a8.25 8.25 0 0113.803-3.7l3.181 3.182m0-4.991v4.99"></path></svg>
                    Reset Bộ Lọc
                </a>
            </div>
        </div>

        <div style="display: grid; grid-template-columns: 340px 1fr; gap: 24px; align-items: start;">

            <%-- BÊN TRÁI: SIDEBAR BỘ LỌC --%>
            <aside style="background: #ffffff; border-radius: 16px; padding: 24px; box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.05); border: 1px solid #e2e8f0;">
                <h3 style="font-size: 16px; font-weight: 700; color: #0f172a; margin: 0 0 20px 0; border-bottom: 2px solid #f1f5f9; padding-bottom: 14px; display: flex; align-items: center; gap: 8px;">
                    <svg style="width: 18px; height: 18px; color: #0d9488;" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M10.5 6h9.75M10.5 6a1.5 1.5 0 11-3 0m3 0a1.5 1.5 0 10-3 0M3.75 6H7.5m3 12h9.75m-9.75 0a1.5 1.5 0 01-3 0m3 0a1.5 1.5 0 00-3 0m-3.75 0H7.5m9-6h3.75m-3.75 0a1.5 1.5 0 01-3 0m3 0a1.5 1.5 0 00-3 0m-9.75 0h9.75"></path></svg>
                    Bộ lọc nâng cao
                </h3>

                <%--
                    QUAN TRỌNG: form chỉ chứa các input text/select/checkbox thông thường.
                    Các hidden input cho schedule slot sẽ được JS inject vào trước khi submit.
                --%>
                <form id="filter-form" method="get" action="${pageContext.request.contextPath}/tutors" style="display: flex; flex-direction: column; gap: 20px;">

                    <%-- 1. Từ khóa --%>
                    <div>
                        <label style="display: block; font-size: 13px; font-weight: 600; color: #334155; margin-bottom: 6px;">Tìm theo từ khóa</label>
                        <input type="text" name="keyword" value="${selectedKeyword}" placeholder="Tên gia sư, trường đại học..." style="width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; box-sizing: border-box;">
                    </div>

                    <%--
                        FIX LỖI GIÁ: max lấy từ dbMaxPrice — tính động từ dữ liệu thực tế
                        Nếu DB có gia sư 5tr thì max=5000000, slider chạm đúng đầu phải
                        JS dùng SLIDER_MAX để check "Không giới hạn" thay vì hardcode 1000000
                    --%>
                    <div>
                        <label style="display: flex; justify-content: space-between; font-size: 13px; font-weight: 600; color: #334155; margin-bottom: 6px;">
                            <span>Học phí tối đa / buổi</span>
                            <span id="price-display" style="color: #0d9488; font-weight: 700;"></span>
                        </label>
                        <input type="range" id="priceRange" name="maxRate"
                               min="50000"
                               max="${dbMaxPrice}"
                               step="1000"
                               value="${not empty selectedMaxRate ? selectedMaxRate : dbMaxPrice}"
                               data-max="${dbMaxPrice}"
                               style="width: 100%; accent-color: #0d9488; cursor: pointer;">
                        <div style="display: flex; justify-content: space-between; font-size: 11px; color: #94a3b8; margin-top: 4px;">
                            <span>Thấp nhất: 50.000đ</span>
                            <span>Cao nhất: <fmt:formatNumber value="${dbMaxPrice}" type="number"/>đ</span>
                        </div>
                    </div>

                    <%-- 3. Môn học (Động DB — đã tách từng môn riêng từ TutorDAO) --%>
                    <div>
                        <label style="display: block; font-size: 13px; font-weight: 600; color: #334155; margin-bottom: 6px;">Môn học giảng dạy</label>
                        <select name="subject" style="width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; background-color: #fff; box-sizing: border-box;">
                            <option value="">-- Tất cả môn học --</option>
                            <c:forEach var="sub" items="${activeSubjects}">
                                <option value="${sub}" ${selectedSubject == sub ? 'selected' : ''}>${sub}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <%-- 4. Cấp học / Khối lớp --%>
                    <div>
                        <label style="display: block; font-size: 13px; font-weight: 600; color: #334155; margin-bottom: 6px;">Cấp học / Khối lớp</label>
                        <select name="grade" style="width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; background-color: #fff; box-sizing: border-box;">
                            <option value="">-- Tất cả cấp học --</option>
                            <option value="Tiểu Học" ${selectedGrade == 'Tiểu Học' ? 'selected' : ''}>Mầm non & Tiểu học (Lớp Lá -> Lớp 5)</option>
                            <option value="THCS" ${selectedGrade == 'THCS' ? 'selected' : ''}>THCS (Lớp 6 -> Lớp 9)</option>
                            <option value="THPT" ${selectedGrade == 'THPT' ? 'selected' : ''}>THPT (Lớp 10 -> Lớp 12)</option>
                            <option value="Đại Học" ${selectedGrade == 'Đại Học' ? 'selected' : ''}>Đại học / Ôn thi đại học</option>
                        </select>
                    </div>

                    <%-- 5. Khu vực (Động DB — đã tách từng quận riêng từ TutorDAO) --%>
                    <div>
                        <label style="display: block; font-size: 13px; font-weight: 600; color: #334155; margin-bottom: 6px;">Khu vực đứng lớp</label>
                        <select name="district" style="width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; background-color: #fff; box-sizing: border-box;">
                            <option value="">-- Tất cả khu vực --</option>
                            <c:forEach var="area" items="${activeAreas}">
                                <option value="${area}" ${selectedDistrict == area ? 'selected' : ''}>${area}</option>
                            </c:forEach>
                        </select>
                    </div>
                        <%-- 5.5 Lọc theo Giới tính --%>
                        <div>
                            <label style="display: block; font-size: 13px; font-weight: 600; color: #334155; margin-bottom: 6px;">Giới tính gia sư</label>
                            <select name="gender" style="width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; background-color: #fff; box-sizing: border-box;">
                                <option value="">-- Tất cả giới tính --</option>
                                <option value="Nam" ${selectedGender == 'Nam' ? 'selected' : ''}>Nam</option>
                                <option value="Nữ" ${selectedGender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                                <option value="OTHER" ${selectedGender == 'OTHER' ? 'selected' : ''}>Khác</option>
                            </select>
                        </div>

                    <%-- 6. Trình độ học vấn --%>
                    <div>
                        <label style="display: block; font-size: 13px; font-weight: 600; color: #334155; margin-bottom: 8px;">Trình độ chuyên môn</label>
                        <div style="display: flex; flex-direction: column; gap: 10px; font-size: 14px;">
                            <label style="display: flex; align-items: center; gap: 8px; cursor: pointer;">
                                <input type="checkbox" name="degreeLevel" value="Sinh viên" ${fn:contains(selectedDegrees, 'Sinh viên') ? 'checked' : ''} style="width:16px; height:16px; accent-color:#0d9488;"> Sinh viên
                            </label>
                            <label style="display: flex; align-items: center; gap: 8px; cursor: pointer;">
                                <input type="checkbox" name="degreeLevel" value="Cử nhân" ${fn:contains(selectedDegrees, 'Cử nhân') ? 'checked' : ''} style="width:16px; height:16px; accent-color:#0d9488;"> Cử nhân
                            </label>
                            <label style="display: flex; align-items: center; gap: 8px; cursor: pointer;">
                                <input type="checkbox" name="degreeLevel" value="Giáo viên" ${fn:contains(selectedDegrees, 'Giáo viên') ? 'checked' : ''} style="width:16px; height:16px; accent-color:#0d9488;"> Giáo viên
                            </label>
                            <label style="display: flex; align-items: center; gap: 8px; cursor: pointer;">
                                <input type="checkbox" name="degreeLevel" value="Thạc sĩ" ${fn:contains(selectedDegrees, 'Thạc sĩ') ? 'checked' : ''} style="width:16px; height:16px; accent-color:#0d9488;"> Thạc sĩ / Tiến sĩ
                            </label>
                        </div>
                    </div>

                    <%-- 7. Sắp xếp học phí --%>
                    <div>
                        <label style="display: block; font-size: 13px; font-weight: 600; color: #334155; margin-bottom: 6px;">Sắp xếp học phí</label>
                        <select name="sortBy" style="width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; background-color: #fff; box-sizing: border-box;">
                            <option value="">-- Mặc định --</option>
                            <option value="rate_asc" ${selectedSortBy == 'rate_asc' ? 'selected' : ''}>Học phí: Thấp đến Cao</option>
                            <option value="rate_desc" ${selectedSortBy == 'rate_desc' ? 'selected' : ''}>Học phí: Cao đến Thấp</option>
                        </select>
                    </div>

                    <%--
                        CONTAINER INJECT HIDDEN INPUT CHO SCHEDULE
                        JS sẽ inject các <input type="hidden" name="scheduleSlot" value="...">
                        vào đây trước khi form submit, để gửi lên server đúng format
                    --%>
                    <div id="schedule-hidden-container"></div>

                    <button type="submit" style="width: 100%; background: #0d9488; color: #fff; padding: 12px; border: none; border-radius: 8px; font-weight: 600; cursor: pointer; font-size: 14px; box-shadow: 0 4px 6px -1px rgba(13, 148, 136, 0.2); display: inline-flex; align-items: center; justify-content: center; gap: 8px;">
                        <svg style="width: 16px; height: 16px;" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 3c2.755 0 5.455.232 8.083.678.533.09.917.556.917 1.096v1.044a2.25 2.25 0 01-.659 1.591l-5.432 5.432a2.25 2.25 0 00-.659 1.591v2.927a2.25 2.25 0 01-1.244 2.013L9.75 21v-6.568a2.25 2.25 0 00-.659-1.591L3.659 7.409A2.25 2.25 0 013 5.818V4.774c0-.54.384-1.006.917-1.096A48.32 48.32 0 0112 3z"></path></svg>
                        Áp dụng bộ lọc
                    </button>
                </form>

                <%--
                    MA TRẬN THỜI KHÓA BIỂU — NẰM NGOÀI form
                    FIX LỖI 4: Multi-select — click để toggle từng ô, lưu vào JS Set
                    Khi bấm "Áp dụng bộ lọc", JS sẽ inject hidden inputs vào form rồi submit
                --%>
                <div style="margin-top: 24px; border-top: 2px solid #f1f5f9; padding-top: 20px;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                        <label style="font-size: 13px; font-weight: 600; color: #334155;">
                            Lọc theo Thứ & Buổi
                            <span id="schedule-count-badge" style="display:none; background:#0d9488; color:#fff; border-radius:10px; padding:1px 7px; font-size:11px; margin-left:6px;">0</span>
                        </label>
                        <button id="clear-schedule-filter" type="button" style="border: none; background: transparent; color: #ef4444; font-size: 12px; font-weight: 700; cursor: pointer; display: inline-flex; align-items: center; gap: 2px;">
                            <svg style="width: 12px; height: 12px;" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9.75 9.75l4.5 4.5m0-4.5l-4.5 4.5M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                            Xóa chọn
                        </button>
                    </div>

                    <table style="width: 100%; border-collapse: collapse; text-align: center; font-size: 12px;">
                        <thead>
                        <tr style="background: #f8fafc; color: #64748b;">
                            <th style="padding: 6px; border: 1px solid #e2e8f0; font-weight: 600;">Buổi</th>
                            <th style="border: 1px solid #e2e8f0; font-weight: 600;">T2</th>
                            <th style="border: 1px solid #e2e8f0; font-weight: 600;">T3</th>
                            <th style="border: 1px solid #e2e8f0; font-weight: 600;">T4</th>
                            <th style="border: 1px solid #e2e8f0; font-weight: 600;">T5</th>
                            <th style="border: 1px solid #e2e8f0; font-weight: 600;">T6</th>
                            <th style="border: 1px solid #e2e8f0; font-weight: 600;">T7</th>
                            <th style="border: 1px solid #e2e8f0; font-weight: 600;">CN</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td style="padding: 8px 4px; border: 1px solid #e2e8f0; font-weight: 600; background: #f8fafc; color: #475569;">Sáng</td>
                            <td class="schedule-cell" data-slot="Sáng Thứ 2"></td>
                            <td class="schedule-cell" data-slot="Sáng Thứ 3"></td>
                            <td class="schedule-cell" data-slot="Sáng Thứ 4"></td>
                            <td class="schedule-cell" data-slot="Sáng Thứ 5"></td>
                            <td class="schedule-cell" data-slot="Sáng Thứ 6"></td>
                            <td class="schedule-cell" data-slot="Sáng Thứ 7"></td>
                            <td class="schedule-cell" data-slot="Sáng Chủ Nhật"></td>
                        </tr>
                        <tr>
                            <td style="padding: 8px 4px; border: 1px solid #e2e8f0; font-weight: 600; background: #f8fafc; color: #475569;">Chiều</td>
                            <td class="schedule-cell" data-slot="Chiều Thứ 2"></td>
                            <td class="schedule-cell" data-slot="Chiều Thứ 3"></td>
                            <td class="schedule-cell" data-slot="Chiều Thứ 4"></td>
                            <td class="schedule-cell" data-slot="Chiều Thứ 5"></td>
                            <td class="schedule-cell" data-slot="Chiều Thứ 6"></td>
                            <td class="schedule-cell" data-slot="Chiều Thứ 7"></td>
                            <td class="schedule-cell" data-slot="Chiều Chủ Nhật"></td>
                        </tr>
                        <tr>
                            <td style="padding: 8px 4px; border: 1px solid #e2e8f0; font-weight: 600; background: #f8fafc; color: #475569;">Tối</td>
                            <td class="schedule-cell" data-slot="Tối Thứ 2"></td>
                            <td class="schedule-cell" data-slot="Tối Thứ 3"></td>
                            <td class="schedule-cell" data-slot="Tối Thứ 4"></td>
                            <td class="schedule-cell" data-slot="Tối Thứ 5"></td>
                            <td class="schedule-cell" data-slot="Tối Thứ 6"></td>
                            <td class="schedule-cell" data-slot="Tối Thứ 7"></td>
                            <td class="schedule-cell" data-slot="Tối Chủ Nhật"></td>
                        </tr>
                        </tbody>
                    </table>
                    <p style="font-size: 11px; color: #94a3b8; margin: 8px 0 0 0; text-align: center;">
                        Tích nhiều ô → lọc gia sư có <em>bất kỳ</em> slot đã chọn
                    </p>
                </div>
            </aside>

            <%-- BÊN PHẢI: KẾT QUẢ CARD GIA SƯ --%>
            <section>
                <c:choose>
                    <c:when test="${not empty tutors}">
                        <div id="tutors-container-list" class="layout-grid">
                            <c:forEach var="tutor" items="${tutors}">
                                <article class="tutor-card-item"
                                         data-schedules="${tutor.availableSchedules}"
                                         style="background: #ffffff; border-radius: 16px; border: 1px solid #e2e8f0; padding: 24px; display: flex; box-shadow: 0 1px 3px rgba(0,0,0,0.02); transition: all 0.3s ease;">

                                        <%-- Avatar & Đánh giá --%>
                                    <div class="card-avatar-section" style="display: flex; flex-direction: column; align-items: center; gap: 10px;">
                                        <c:choose>
                                            <c:when test="${not empty tutor.avatarUrl}">
                                                <div style="width: 80px; height: 80px; border-radius: 50%; border: 3px solid #ccfbf1; background-image: url('${tutor.avatarUrl}'); background-size: cover; background-position: center;"></div>
                                            </c:when>
                                            <c:otherwise>
                                                <div style="width: 80px; height: 80px; border-radius: 50%; border: 3px solid #ccfbf1; background-image: url('${pageContext.request.contextPath}/assets/images/default-avatar.png'); background-size: cover; background-position: center;"></div>
                                            </c:otherwise>
                                        </c:choose>
                                        <span style="display: inline-flex; align-items: center; gap: 4px; background: #fef9c3; color: #854d0e; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 700;">
                                            <c:choose>
                                                <c:when test="${tutor.ratingAverage > 0}">
                                                    ★ ${tutor.ratingAverage}
                                                </c:when>
                                                <c:otherwise>
                                                    ★ Mới
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>

                                        <%-- Thông tin chi tiết --%>
                                    <div class="card-info-section" style="flex: 1; display: flex; flex-direction: column; justify-content: space-between; margin-left: 20px;">
                                        <div>
                                            <div style="display: flex; justify-content: space-between; align-items: flex-start; gap: 8px;">
                                                <h3 style="font-size: 19px; font-weight: 700; color: #0f172a; margin: 0 0 6px 0; line-height: 1.3;">
                                                    <c:out value="${tutor.fullName}"/>
                                                </h3>
                                                <span style="font-size: 11px; font-weight: 700; color: #0f766e; background: #ccfbf1; padding: 4px 8px; border-radius: 6px; text-transform: uppercase; white-space: nowrap;">
                                                    <c:out value="${tutor.qualification}"/>
                                                </span>
                                            </div>

                                            <p style="font-size: 13px; color: #475569; margin: 0 0 8px 0; display: flex; align-items: center; gap: 6px;">
                                                <svg style="width: 14px; height: 14px; color: #64748b; flex-shrink: 0;" fill="none" stroke="currentColor" stroke-width="1.75" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 21v-8.25M15.75 21v-8.25M8.25 21v-8.25M3 9l9-6 9 6m-1.5 12V10.332A48.36 48.36 0 0012 9.75c-2.551 0-5.056.2-7.5.582V21M3 21h18M12 6.75h.008v.008H12V6.75z"></path></svg>
                                                <c:out value="${tutor.school}"/>
                                                <c:if test="${not empty tutor.major}">
                                                    <span style="color: #94a3b8;">|</span>
                                                    <span style="font-style: italic; color: #64748b;"><c:out value="${tutor.major}"/></span>
                                                </c:if>
                                            </p>

                                            <p style="margin: 0 0 8px 0; font-size: 13px; color: #475569; display: flex; align-items: center; gap: 6px; flex-wrap: wrap;">
                                                <svg style="width: 14px; height: 14px; color: #64748b; flex-shrink: 0;" fill="none" stroke="currentColor" stroke-width="1.75" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 6.042A8.967 8.967 0 006 3.75c-1.052 0-2.062.18-3 .512v14.25A8.987 8.987 0 016 18c2.305 0 4.408.867 6 2.292m0-14.25a8.966 8.966 0 016-2.292c1.052 0 2.062.18 3 .512v14.25A8.987 8.987 0 0018 18a8.967 8.967 0 00-6 2.292m0-14.25v14.25"></path></svg>
                                                <span>Chuyên dạy: <span style="color: #0d9488; font-weight: 600;"><c:out value="${tutor.teachingSubject}"/></span> — Khối: <span style="color: #334155; font-weight: 600;"><c:out value="${tutor.teachingGrade}"/></span></span>
                                            </p>

                                            <p style="margin: 0 0 12px 0; font-size: 13px; color: #64748b; display: flex; align-items: center; gap: 6px;">
                                                <svg style="width: 14px; height: 14px; color: #64748b; flex-shrink: 0;" fill="none" stroke="currentColor" stroke-width="1.75" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M15 10.5a3 3 0 11-6 0 3 3 0 016 0z"></path><path stroke-linecap="round" stroke-linejoin="round" d="M19.5 10.5c0 7.142-7.5 11.25-7.5 11.25S4.5 17.642 4.5 10.5a7.5 7.5 0 1115 0z"></path></svg>
                                                <span>Khu vực: <span style="color: #334155; font-weight: 500;"><c:out value="${not empty tutor.teachingArea ? tutor.teachingArea : 'Toàn thành phố'}"/></span></span>
                                            </p>

                                                <%-- Hiển thị slot lịch --%>
                                            <div style="display: flex; gap: 4px; flex-wrap: wrap; margin-bottom: 12px;">
                                                <c:forEach var="day" items="${fn:split(tutor.availableSchedules, ',')}">
                                                    <span style="font-size: 10px; background: #f1f5f9; color: #475569; padding: 2px 6px; border-radius: 4px; font-weight: 600;">${fn:trim(day)}</span>
                                                </c:forEach>
                                            </div>
                                        </div>

                                        <div style="display: flex; align-items: center; justify-content: space-between; border-top: 1px dashed #e2e8f0; padding-top: 14px; margin-top: 8px;">
                                            <div>
                                                <span style="font-size: 18px; font-weight: 800; color: #0d9488;">
                                                    <fmt:formatNumber value="${tutor.hourlyRate}" type="number"/>đ
                                                </span>
                                                <span style="font-size: 12px; color: #64748b;"> / buổi</span>
                                            </div>
                                            <a href="${pageContext.request.contextPath}/tutor/tutor-detail?id=${tutor.tutorId}" style="background: #0d9488; color: #ffffff; padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; text-decoration: none; display: inline-flex; align-items: center; gap: 4px;">
                                                Xem hồ sơ
                                                <svg style="width: 14px; height: 14px;" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5L21 12m0 0l-7.5 7.5M21 12H3"></path></svg>
                                            </a>
                                        </div>
                                    </div>
                                </article>
                            </c:forEach>
                        </div>
                        <%-- PAGINATION BAR — JS render vào đây --%>
                        <div id="pagination-bar" class="pagination-bar"></div>
                    </c:when>
                    <c:otherwise>
                        <div style="text-align: center; background: #ffffff; border-radius: 16px; border: 1px solid #e2e8f0; padding: 80px 20px; color: #64748b; display: flex; flex-direction: column; align-items: center; justify-content: center;">
                            <svg style="width: 48px; height: 48px; color: #94a3b8; margin-bottom: 16px;" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M15.182 16.318A4.486 4.486 0 0012.016 15a4.486 4.486 0 00-3.198 1.318M21 12a9 9 0 11-18 0 9 9 0 0118 0zM9.75 9.75c0 .414-.168.75-.375.75s-.375-.336-.375-.75.168-.75.375-.75.375.336.375.75zm-.375 0h.008v.015h-.008V9.75zm5.625 0c0 .414-.168.75-.375.75s-.375-.336-.375-.75.168-.75.375-.75.375.336.375.75zm-.375 0h.008v.015h-.008V9.75z"></path></svg>
                            <p style="font-size: 18px; font-weight: 700; color: #1e293b; margin: 0 0 6px 0;">Không tìm thấy gia sư nào thích hợp</p>
                            <p style="font-size: 14px; color: #94a3b8; margin: 0;">Hãy thử đổi từ khóa hoặc mở rộng điều kiện lọc nhé.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>
    </div>
</main>

<style>
    .layout-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(290px, 1fr)); gap: 20px; }
    .layout-grid .tutor-card-item { flex-direction: column !important; }
    .layout-grid .card-info-section { margin-left: 0 !important; margin-top: 16px !important; }
    .layout-list { display: flex; flex-direction: column; gap: 16px; }
    .tutor-card-item:hover { transform: translateY(-4px); border-color: #b2f5ea !important; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.05) !important; }

    /* Schedule cell */
    .schedule-cell {
        border: 1px solid #e2e8f0;
        height: 30px;
        cursor: pointer;
        background: #ffffff;
        transition: all 0.15s ease;
        position: relative;
        user-select: none;
    }
    .schedule-cell:hover { background: #ccfbf1 !important; }
    .schedule-cell.active-slot { background: #0d9488 !important; border-color: #0f766e !important; }
    .schedule-cell.active-slot::after {
        content: "✓";
        color: #ffffff;
        font-size: 11px;
        font-weight: 700;
        position: absolute;
        top: 50%; left: 50%;
        transform: translate(-50%, -50%);
    }

    /* Pagination */
    .pagination-bar {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 6px;
        margin-top: 28px;
        flex-wrap: wrap;
    }
    .pg-btn {
        min-width: 36px;
        height: 36px;
        padding: 0 10px;
        border: 1px solid #e2e8f0;
        background: #ffffff;
        border-radius: 8px;
        font-size: 13px;
        font-weight: 600;
        color: #475569;
        cursor: pointer;
        transition: all 0.15s;
        display: inline-flex;
        align-items: center;
        justify-content: center;
    }
    .pg-btn:hover:not(:disabled) { background: #f1f5f9; border-color: #cbd5e1; }
    .pg-btn.active { background: #0d9488; color: #fff; border-color: #0d9488; }
    .pg-btn:disabled { opacity: 0.35; cursor: not-allowed; }
    .pg-ellipsis {
        min-width: 36px;
        height: 36px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        font-size: 13px;
        color: #94a3b8;
        font-weight: 700;
        letter-spacing: 1px;
    }
</style>

<script>
    // =====================================================================
    // LAYOUT SWITCH
    // =====================================================================
    function changeLayout(type) {
        const container = document.getElementById('tutors-container-list');
        if (!container) return;
        container.className = type === 'grid' ? 'layout-grid' : 'layout-list';
        localStorage.setItem('tutor_layout_pref', type);
    }

    document.addEventListener('DOMContentLoaded', function () {

        // Khôi phục layout từ localStorage
        changeLayout(localStorage.getItem('tutor_layout_pref') || 'grid');

        // =====================================================================
        // FIX LỖI 3: SLIDER HỌC PHÍ
        // Hiển thị đúng giá trị thực — không bị -5đ nữa vì step="1000"
        // =====================================================================
        const slider = document.getElementById('priceRange');
        const display = document.getElementById('price-display');
        // Lấy max thực tế từ data-max attribute (= dbMaxPrice từ server)
        const SLIDER_MAX = slider ? parseInt(slider.getAttribute('data-max')) : 5000000;
        if (slider && display) {
            function updatePriceDisplay(val) {
                const num = parseInt(val);
                // So sánh với SLIDER_MAX động — không hardcode
                display.textContent = num >= SLIDER_MAX
                    ? 'Không giới hạn'
                    : 'Dưới ' + num.toLocaleString('vi-VN') + 'đ';
            }
            updatePriceDisplay(slider.value);
            slider.addEventListener('input', e => updatePriceDisplay(e.target.value));
        }

        // =====================================================================
        // FIX LỖI 4: MULTI-SELECT LỊCH HỌC
        // - Dùng JS Set để lưu tất cả slot đang được chọn
        // - Khôi phục trạng thái từ URL params khi trang load lại sau filter
        // - Khi submit form → inject hidden inputs vào form
        // =====================================================================
        const selectedSlots = new Set();

        // --- Khôi phục trạng thái từ URL (sau khi server trả về trang) ---
        const urlParams = new URLSearchParams(window.location.search);
        urlParams.getAll('scheduleSlot').forEach(slot => {
            selectedSlots.add(slot);
        });

        // --- Render lại visual các cell đã chọn ---
        function syncCellVisuals() {
            document.querySelectorAll('.schedule-cell').forEach(cell => {
                const slot = cell.getAttribute('data-slot');
                cell.classList.toggle('active-slot', selectedSlots.has(slot));
            });
            // Cập nhật badge đếm
            const badge = document.getElementById('schedule-count-badge');
            if (selectedSlots.size > 0) {
                badge.textContent = selectedSlots.size;
                badge.style.display = 'inline';
            } else {
                badge.style.display = 'none';
            }
        }
        syncCellVisuals(); // chạy ngay khi load

        // --- Click toggle từng cell ---
        document.querySelectorAll('.schedule-cell').forEach(cell => {
            cell.addEventListener('click', function () {
                const slot = this.getAttribute('data-slot');
                if (selectedSlots.has(slot)) {
                    selectedSlots.delete(slot);
                } else {
                    selectedSlots.add(slot);
                }
                syncCellVisuals();
            });
        });

        // --- Nút xóa toàn bộ chọn ---
        document.getElementById('clear-schedule-filter').addEventListener('click', function () {
            selectedSlots.clear();
            syncCellVisuals();
        });

        // --- Trước khi submit form: inject hidden inputs cho từng slot đã chọn ---
        document.getElementById('filter-form').addEventListener('submit', function () {
            // Xóa hidden inputs cũ (nếu submit lại)
            const container = document.getElementById('schedule-hidden-container');
            container.innerHTML = '';
            // Inject hidden input cho từng slot đang được tích chọn
            selectedSlots.forEach(slot => {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'scheduleSlot';
                input.value = slot;
                container.appendChild(input);
            });
            // Nếu slider kéo hết sang phải (= max = không giới hạn) thì không gửi maxRate
            if (slider && parseInt(slider.value) >= SLIDER_MAX) {
                slider.removeAttribute('name');
            }
        });

        // =====================================================================
        // PHÂN TRANG CLIENT-SIDE
        // - 4 card / trang
        // - Số trang hiển thị: 1 2 3 ... (maxPage-2) (maxPage-1) maxPage
        //   hoặc đầy đủ nếu ≤ 7 trang
        // - Mỗi lần chuyển trang: scroll nhẹ lên đầu kết quả
        // =====================================================================
        const PAGE_SIZE = 4;
        let currentPage = 1;

        const allCards = Array.from(document.querySelectorAll('.tutor-card-item'));
        const totalPages = Math.ceil(allCards.length / PAGE_SIZE);
        const paginationBar = document.getElementById('pagination-bar');

        function showPage(page) {
            currentPage = page;
            const start = (page - 1) * PAGE_SIZE;
            const end = start + PAGE_SIZE;

            allCards.forEach((card, idx) => {
                card.style.display = (idx >= start && idx < end) ? 'flex' : 'none';
            });

            renderPagination();

            // Scroll nhẹ lên đầu vùng kết quả
            const section = document.getElementById('tutors-container-list');
            if (section) section.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }

        function renderPagination() {
            if (!paginationBar || totalPages <= 1) return;
            paginationBar.innerHTML = '';

            // Nút ← Trước
            const prevBtn = document.createElement('button');
            prevBtn.className = 'pg-btn';
            prevBtn.innerHTML = '&#8592;';
            prevBtn.disabled = currentPage === 1;
            prevBtn.addEventListener('click', () => showPage(currentPage - 1));
            paginationBar.appendChild(prevBtn);

            // Tính dãy số trang hiển thị
            // Logic: luôn hiện 3 trang đầu, dấu ..., 3 trang cuối
            // Nếu tổng ≤ 7 thì hiện hết
            const pages = buildPageRange(currentPage, totalPages);

            pages.forEach(item => {
                if (item === '...') {
                    const el = document.createElement('span');
                    el.className = 'pg-ellipsis';
                    el.textContent = '···';
                    paginationBar.appendChild(el);
                } else {
                    const btn = document.createElement('button');
                    btn.className = 'pg-btn' + (item === currentPage ? ' active' : '');
                    btn.textContent = item;
                    btn.addEventListener('click', () => showPage(item));
                    paginationBar.appendChild(btn);
                }
            });

            // Nút → Sau
            const nextBtn = document.createElement('button');
            nextBtn.className = 'pg-btn';
            nextBtn.innerHTML = '&#8594;';
            nextBtn.disabled = currentPage === totalPages;
            nextBtn.addEventListener('click', () => showPage(currentPage + 1));
            paginationBar.appendChild(nextBtn);
        }

        function buildPageRange(current, total) {
            // Nếu ≤ 7 trang: hiện hết
            if (total <= 7) {
                return Array.from({ length: total }, (_, i) => i + 1);
            }

            const result = [];
            // Luôn có trang 1
            result.push(1);

            if (current <= 4) {
                // Gần đầu: 1 2 3 4 5 ... (total-1) total
                for (let i = 2; i <= Math.min(5, total - 2); i++) result.push(i);
                result.push('...');
                result.push(total - 1);
                result.push(total);
            } else if (current >= total - 3) {
                // Gần cuối: 1 2 ... (total-4) (total-3) (total-2) (total-1) total
                result.push(2);
                result.push('...');
                for (let i = Math.max(total - 4, 3); i <= total; i++) result.push(i);
            } else {
                // Giữa: 1 2 ... (current-1) current (current+1) ... (total-1) total
                result.push(2);
                result.push('...');
                result.push(current - 1);
                result.push(current);
                result.push(current + 1);
                result.push('...');
                result.push(total - 1);
                result.push(total);
            }

            return result;
        }

        // Khởi tạo trang đầu tiên
        if (allCards.length > 0) showPage(1);
    });
</script>

<jsp:include page="/views/common/footer.jsp"/>
