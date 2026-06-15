<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<jsp:include page="/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Cập nhật hồ sơ ứng tuyển - Gia Sư Bá Đạo" />
    <jsp:param name="pageCss" value="/assets/css/register.css" />
</jsp:include>
<jsp:include page="/views/common/navbar.jsp" />

<main class="page-main">
    <div class="container">
        <section class="section register-page" id="tutor-form" style="padding-top: 20px;">
            <div class="section-head">
                <h2 class="section-title">Cập nhật hồ sơ gia sư</h2>
                <div class="section-sub">Vui lòng điều chỉnh lại các thông tin chưa chính xác theo yêu cầu của trung tâm để gửi duyệt lại.</div>
            </div>

            <c:if test="${not empty requestScope.error}">
                <div style="background: #fee2e2; color: #991b1b; padding: 12px; border-radius: 4px; margin-bottom: 20px; font-size: 14px; border: 1px solid #fca5a5;">
                    ⚠️ ${requestScope.error}
                </div>
            </c:if>

            <c:set var="t" value="${requestScope.tutor}"/>

            <form class="register-form"
                  method="post"
                  action="<%= request.getContextPath() %>/tutor/resubmit-profile"
                  enctype="multipart/form-data">

                <input type="hidden" name="tutorId" value="${t.id}">

                <div class="form-card">

                    <%-- SECTION 1: THÔNG TIN CÁ NHÂN --%>
                    <div class="form-section">
                        <h3 class="form-section-title">Thông tin cá nhân</h3>
                        <div class="form-grid">
                            <div class="form-group">
                                <label class="label">Họ tên <span class="req">*</span></label>
                                <input class="input-field" type="text" name="fullName" value="${t.fullName}" required>
                            </div>

                            <div class="form-group">
                                <label class="label">Ngày sinh <span class="req">*</span></label>
                                <input class="input-field" type="date" name="birthDate" value="${t.birthDate}" required style="width: 100%; padding: 10px; border: 1px solid #cbd5e1; border-radius: 4px;">
                            </div>

                            <div class="form-group">
                                <label class="label">Giới tính</label>
                                <select class="select-field" name="gender">
                                    <option value="Nam" ${t.gender eq 'Nam' || t.gender eq 'MALE' ? 'selected' : ''}>Nam</option>
                                    <option value="Nữ" ${t.gender eq 'Nữ' || t.gender eq 'FEMALE' ? 'selected' : ''}>Nữ</option>
                                    <option value="Khác" ${t.gender eq 'Khác' ? 'selected' : ''}>Khác</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <%-- SECTION 2: MỨC HỌC PHÍ --%>
                    <div class="form-section">
                        <h3 class="form-section-title">Mức học phí mong muốn (VNĐ/Buổi)</h3>
                        <div class="form-group">
                            <label class="label">VNĐ <span class="req">*</span></label>
                            <input type="number" name="hourlyRate" class="input-field" value="${t.minRate}" required min="0">
                        </div>
                    </div>

                    <%-- SECTION 3: HÌNH ẢNH BIỂU MẪU --%>
                    <div class="form-section">
                        <h3 class="form-section-title">Hình ảnh &amp; xác thực tài liệu</h3>
                        <div class="form-grid">
                            <div class="form-group" style="background: #fafafa; padding: 15px; border: 1px dashed #cbd5e1; border-radius: 6px;">
                                <label class="label">Ảnh thẻ / Ảnh chân dung</label>
                                <c:if test="${not empty t.portraitUrl}">
                                    <div style="margin-bottom: 10px;">
                                        <img src="${t.portraitUrl}" alt="Ảnh chân dung cũ" style="max-width: 100px; height: 120px; object-fit: cover; border-radius: 4px; border: 1px solid #e2e8f0;">
                                    </div>
                                </c:if>
                                <input class="input-field" type="file" name="portrait">
                            </div>

                            <div class="form-group" style="background: #fafafa; padding: 15px; border: 1px dashed #cbd5e1; border-radius: 6px;">
                                <label class="label">Ảnh bằng cấp / Thẻ sinh viên</label>
                                <c:if test="${not empty t.degreeUrls}">
                                    <div style="display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 10px;">
                                        <c:forEach var="url" items="${t.degreeUrls}">
                                            <img src="${url}" style="width: 60px; height: 60px; object-fit: cover; border-radius: 4px; border: 1px solid #e2e8f0;">
                                        </c:forEach>
                                    </div>
                                </c:if>
                                <input class="input-field" type="file" name="degreePhotos" multiple>
                            </div>

                            <div class="form-group form-field-full" style="background: #fafafa; padding: 15px; border: 1px dashed #cbd5e1; border-radius: 6px;">
                                <label class="label">Ảnh Căn cước công dân (Mặt trước/sau)</label>
                                <c:if test="${not empty t.idCardUrls}">
                                    <div style="display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 10px;">
                                        <c:forEach var="url" items="${t.idCardUrls}">
                                            <img src="${url}" style="width: 100px; height: 60px; object-fit: cover; border-radius: 4px; border: 1px solid #e2e8f0;">
                                        </c:forEach>
                                    </div>
                                </c:if>
                                <input class="input-field" type="file" name="citizenPhotos" multiple>
                            </div>
                        </div>
                    </div>

                    <%-- SECTION 4: HỌC VẤN --%>
                    <div class="form-section">
                        <h3 class="form-section-title">Học tập &amp; kinh nghiệm</h3>
                        <div class="form-grid">
                            <div class="form-group">
                                <label class="label">Trường đào tạo <span class="req">*</span></label>
                                <input class="input-field" type="text" name="school" value="${t.school}" required>
                            </div>
                            <div class="form-group">
                                <label class="label">Ngành học <span class="req">*</span></label>
                                <input class="input-field" type="text" name="major" value="${t.major}" required>
                            </div>
                            <div class="form-group form-field-full">
                                <label class="label">Trình độ / Bằng cấp cao nhất</label>
                                <select class="select-field" name="qualification" style="width: 100%; padding: 10px; border: 1px solid #cbd5e1; border-radius: 4px;">
                                    <option value="Sinh Viên" ${t.degreeLevel eq 'Sinh Viên' ? 'selected' : ''}>Sinh Viên</option>
                                    <option value="Cử Nhân" ${t.degreeLevel eq 'Cử Nhân' ? 'selected' : ''}>Cử Nhân</option>
                                    <option value="Thạc Sĩ" ${t.degreeLevel eq 'Thạc Sĩ' ? 'selected' : ''}>Thạc Sĩ</option>
                                    <option value="Giáo Viên" ${t.degreeLevel eq 'Giáo Viên' ? 'selected' : ''}>Giáo Viên / Giảng Viên</option>
                                </select>
                            </div>
                            <div class="form-group form-field-full">
                                <label class="label">Ưu điểm & Kinh nghiệm</label>
                                <textarea class="textarea"
                                          name="experienceSummary"
                                          placeholder="Thông tin thế mạnh và kinh nghiệm giảng dạy của bạn..."
                                          rows="4">${t.experienceSummary}</textarea>
                            </div>
                        </div>
                    </div>

                    <%-- SECTION 5: THÔNG TIN GIẢNG DẠY & BUỔI HỌC --%>
                    <div class="form-section">
                        <h3 class="form-section-title">Thông tin giảng dạy</h3>
                        <div class="form-grid">

                            <div class="form-group form-field-full">
                                <label class="label">Môn dạy <span class="req">*</span></label>
                                <div class="chip-grid">
                                    <c:forEach var="sub" items="${['Toán', 'Lý', 'Hóa', 'Văn', 'Tiếng Việt', 'Anh Văn', 'Báo Bài', 'Sinh', 'Sử', 'Địa', 'Tin Học', 'Vẽ', 'Rèn Chữ', 'Anh Văn Giao Tiếp', 'TOEIC', 'IELTS', 'TOEFL', 'Tiếng Pháp', 'Tiếng Hàn', 'Tiếng Hoa', 'Tiếng Nhật', 'Đàn Piano', 'Đàn Organ', 'Đàn Guitar']}">
                                        <label class="check-card">
                                            <input type="checkbox" name="subjects" value="${sub}" ${not empty t.subjects && fn:contains(t.subjects, sub) ? 'checked' : ''}> ${sub}
                                        </label>
                                    </c:forEach>
                                </div>
                            </div>

                            <div class="form-group form-field-full">
                                <label class="label">Lớp dạy <span class="req">*</span></label>
                                <div class="chip-grid">
                                    <c:forEach var="grade" items="${['Lớp Lá', 'Lớp 1', 'Lớp 2', 'Lớp 3', 'Lớp 4', 'Lớp 5', 'Lớp 6', 'Lớp 7', 'Lớp 8', 'Lớp 9', 'Lớp 10', 'Lớp 11', 'Lớp 12', 'Đại Học']}">
                                        <label class="check-card">
                                            <input type="checkbox" name="grades" value="${grade}" ${not empty t.grades && fn:contains(t.grades, grade) ? 'checked' : ''}> ${grade}
                                        </label>
                                    </c:forEach>
                                </div>
                            </div>

                            <div class="form-group form-field-full">
                                <label class="label">Khu vực dạy <span class="req">*</span></label>
                                <div class="chip-grid">
                                    <c:forEach var="area" items="${['Quận 1', 'Quận 2', 'Quận 3', 'Quận 4', 'Quận 5', 'Quận 6', 'Quận 7', 'Quận 8', 'Quận 9', 'Quận 10', 'Quận 11', 'Quận 12', 'Bình Tân', 'Bình Thạnh', 'Gò Vấp', 'Phú Nhuận', 'Tân Bình', 'Tân phú', 'Thủ Đức', 'Bình Chánh', 'Cần Giờ', 'Củ Chi', 'Hóc Môn', 'Nhà Bè']}">
                                        <label class="check-card">
                                            <input type="checkbox" name="areas" value="${area}" ${not empty t.districtName && fn:contains(t.districtName, area) ? 'checked' : ''}> ${area}
                                        </label>
                                    </c:forEach>
                                </div>
                            </div>

                            <div class="form-group form-field-full">
                                <label class="label">Thời khóa biểu có thể dạy (Lịch rảnh) <span class="req">*</span></label>
                                <div class="chip-grid">
                                    <label class="check-card"><input type="checkbox" name="schedules" value="1" ${not empty t.availableSchedules && fn:contains(t.availableSchedules, 'Sáng Thứ 2') ? 'checked' : ''}> Sáng Thứ 2</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="2" ${not empty t.availableSchedules && fn:contains(t.availableSchedules, 'Chiều Thứ 2') ? 'checked' : ''}> Chiều Thứ 2</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="3" ${not empty t.availableSchedules && fn:contains(t.availableSchedules, 'Tối Thứ 2') ? 'checked' : ''}> Tối Thứ 2</label>

                                    <label class="check-card"><input type="checkbox" name="schedules" value="4" ${not empty t.availableSchedules && fn:contains(t.availableSchedules, 'Sáng Thứ 3') ? 'checked' : ''}> Sáng Thứ 3</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="5" ${not empty t.availableSchedules && fn:contains(t.availableSchedules, 'Chiều Thứ 3') ? 'checked' : ''}> Chiều Thứ 3</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="6" ${not empty t.availableSchedules && fn:contains(t.availableSchedules, 'Tối Thứ 3') ? 'checked' : ''}> Tối Thứ 3</label>

                                    <label class="check-card"><input type="checkbox" name="schedules" value="7" ${not empty t.availableSchedules && fn:contains(t.availableSchedules, 'Sáng Thứ 4') ? 'checked' : ''}> Sáng Thứ 4</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="8" ${not empty t.availableSchedules && fn:contains(t.availableSchedules, 'Chiều Thứ 4') ? 'checked' : ''}> Chiều Thứ 4</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="9" ${not empty t.availableSchedules && fn:contains(t.availableSchedules, 'Tối Thứ 4') ? 'checked' : ''}> Tối Thứ 4</label>

                                    <label class="check-card"><input type="checkbox" name="schedules" value="10" ${not empty t.availableSchedules && fn:contains(t.availableSchedules, 'Sáng Thứ 5') ? 'checked' : ''}> Sáng Thứ 5</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="11" ${not empty t.availableSchedules && fn:contains(t.availableSchedules, 'Chiều Thứ 5') ? 'checked' : ''}> Chiều Thứ 5</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="12" ${not empty t.availableSchedules && fn:contains(t.availableSchedules, 'Tối Thứ 5') ? 'checked' : ''}> Tối Thứ 5</label>

                                    <label class="check-card"><input type="checkbox" name="schedules" value="13" ${not empty t.availableSchedules && fn:contains(t.availableSchedules, 'Sáng Thứ 6') ? 'checked' : ''}> Sáng Thứ 6</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="14" ${not empty t.availableSchedules && fn:contains(t.availableSchedules, 'Chiều Thứ 6') ? 'checked' : ''}> Chiều Thứ 6</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="15" ${not empty t.availableSchedules && fn:contains(t.availableSchedules, 'Tối Thứ 6') ? 'checked' : ''}> Tối Thứ 6</label>

                                    <label class="check-card"><input type="checkbox" name="schedules" value="16" ${not empty t.availableSchedules && fn:contains(t.availableSchedules, 'Sáng Thứ 7') ? 'checked' : ''}> Sáng Thứ 7</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="17" ${not empty t.availableSchedules && fn:contains(t.availableSchedules, 'Chiều Thứ 7') ? 'checked' : ''}> Chiều Thứ 7</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="18" ${not empty t.availableSchedules && fn:contains(t.availableSchedules, 'Tối Thứ 7') ? 'checked' : ''}> Tối Thứ 7</label>

                                    <label class="check-card"><input type="checkbox" name="schedules" value="19" ${not empty t.availableSchedules && fn:contains(t.availableSchedules, 'Sáng Chủ Nhật') ? 'checked' : ''}> Sáng CN</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="20" ${not empty t.availableSchedules && fn:contains(t.availableSchedules, 'Chiều Chủ Nhật') ? 'checked' : ''}> Chiều CN</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="21" ${not empty t.availableSchedules && fn:contains(t.availableSchedules, 'Tối Chủ Nhật') ? 'checked' : ''}> Tối CN</label>
                                </div>
                            </div>

                        </div>
                    </div>

                    <%-- SECTION 6: HÀNH ĐỘNG FORM (NÚT BẤM HOÀN CHỈNH) --%>
                    <div class="form-actions" style="display: flex; justify-content: flex-end; gap: 15px; align-items: center; margin-top: 30px; padding-top: 20px; border-top: 1px solid #e2e8f0;">
                        <span class="form-actions-note" style="margin-right: auto; color: #64748b; font-size: 14px;">Các trường có dấu * là bắt buộc.</span>
                        <a href="<%= request.getContextPath() %>/home" style="padding: 11px 24px; border: 1px solid #cbd5e1; border-radius: 6px; color: #475569; text-decoration: none; font-size: 14px; font-weight: 500; background: #fff;">Hủy bỏ</a>
                        <button class="btn btn-primary" type="submit" style="margin: 0; padding: 11px 24px; border-radius: 6px; font-weight: 600;">Cập nhật &amp; Gửi duyệt lại</button>
                    </div>

                </div>
            </form>
        </section>
    </div>
</main>

<jsp:include page="/views/common/footer.jsp" />