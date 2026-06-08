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

            <%-- Bóc dữ liệu đối tượng tutor cũ được Controller gửi sang --%>
            <c:set var="t" value="${requestScope.tutor}"/>

            <form class="register-form"
                  method="post"
                  action="<%= request.getContextPath() %>/tutor/resubmit-profile"
                  enctype="multipart/form-data">

                <%-- TRƯỜNG ẨN CỰC KỲ QUAN TRỌNG ĐỂ UPDATE ĐÚNG HỒ SƠ --%>
                <input type="hidden" name="tutorId" value="${t.id}">

                <div class="form-card">
                    <div class="form-section">
                        <h3 class="form-section-title">Thông tin cá nhân</h3>
                        <div class="form-grid">
                            <div class="form-group">
                                <label class="label">Họ tên <span class="req">*</span></label>
                                <input class="input-field" type="text" name="fullName" value="${t.fullName}" required>
                            </div>

                            <div class="form-group">
                                <label class="label">Giới tính</label>
                                <select class="select-field" name="gender">
                                    <%-- Đồng bộ cả chữ hiển thị tiếng Việt và mã định danh MALE/FEMALE --%>
                                    <option value="Nam" ${t.gender eq 'Nam' || t.gender eq 'MALE' ? 'selected' : ''}>Nam</option>
                                    <option value="Nữ" ${t.gender eq 'Nữ' || t.gender eq 'FEMALE' ? 'selected' : ''}>Nữ</option>
                                    <option value="Khác" ${t.gender eq 'Khác' ? 'selected' : ''}>Khác</option>
                                </select>
                            </div>

                            <div class="form-note form-field-full" style="background: #f1f5f9; color: #475569;">
                                🔒 Các thông tin bảo mật cố định (Ngày sinh: ${not empty t.birthDate ? t.birthDate : 'Chưa cập nhật'}) không được tự ý thay đổi trên web. Nếu có sai sót hệ trọng, vui lòng liên hệ trực tiếp bộ phận CSKH.
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <h3 class="form-section-title">Mức học phí mong muốn (VNĐ/Buổi)</h3>
                        <div class="form-group">
                            <label class="label">VNĐ <span class="req">*</span></label>
                            <input type="number" name="hourlyRate" class="input-field" value="${t.minRate}" required min="0">
                        </div>
                    </div>

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
                                <div class="hint" style="margin-top: 4px; font-size: 12px; color: #64748b;">Nếu không cần thay đổi ảnh thẻ cũ, vui lòng bỏ trống ô này.</div>
                            </div>

                            <div class="form-group" style="background: #fafafa; padding: 15px; border: 1px dashed #cbd5e1; border-radius: 6px;">
                                <label class="label">Ảnh bằng cấp / Thẻ sinh viên</label>
                                <c:if test="${not empty t.degreeUrls}">
                                    <div style="display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 10px;">
                                        <c:forEach var="url" items="${t.degreeUrls}">
                                            <img src="${url}" alt="Bằng cấp cũ" style="width: 60px; height: 60px; object-fit: cover; border-radius: 4px; border: 1px solid #e2e8f0;">
                                        </c:forEach>
                                    </div>
                                </c:if>
                                <input class="input-field" type="file" name="degreePhotos" multiple>
                                <div class="hint" style="margin-top: 4px; font-size: 12px; color: #64748b;">Chọn các tệp mới nếu bằng cấp trước đó bị mờ hoặc bị từ chối.</div>
                            </div>

                            <div class="form-group form-field-full" style="background: #fafafa; padding: 15px; border: 1px dashed #cbd5e1; border-radius: 6px;">
                                <label class="label">Ảnh Căn cước công dân (Mặt trước/sau)</label>
                                <c:if test="${not empty t.idCardUrls}">
                                    <div style="display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 10px;">
                                        <c:forEach var="url" items="${t.idCardUrls}">
                                            <img src="${url}" alt="CCCD cũ" style="width: 100px; height: 60px; object-fit: cover; border-radius: 4px; border: 1px solid #e2e8f0;">
                                        </c:forEach>
                                    </div>
                                </c:if>
                                <input class="input-field" type="file" name="citizenPhotos" multiple>
                                <div class="hint" style="margin-top: 4px; font-size: 12px; color: #64748b;">Tải lên lại ảnh CCCD rõ nét nếu hệ thống yêu cầu đối chiếu lại danh tính.</div>
                            </div>

                        </div>
                    </div>

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
                                    <%-- Đồng bộ khớp chuẩn với trường t.degreeLevel của đối tượng DTO --%>
                                    <option value="Sinh Viên" ${t.degreeLevel eq 'Sinh Viên' ? 'selected' : ''}>Sinh Viên</option>
                                    <option value="Cử Nhân" ${t.degreeLevel eq 'Cử Nhân' ? 'selected' : ''}>Cử Nhân</option>
                                    <option value="Thạc Sĩ" ${t.degreeLevel eq 'Thạc Sĩ' ? 'selected' : ''}>Thạc Sĩ</option>
                                    <option value="Giáo Viên" ${t.degreeLevel eq 'Giáo Viên' ? 'selected' : ''}>Giáo Viên / Giảng Viên</option>
                                </select>
                            </div>
                            <div class="form-group form-field-full">
                                <label class="label">Ưu điểm & Kinh nghiệm</label>
                                <%-- ĐÃ SỬA: Để trống textarea hoặc truyền trường thế thế phù hợp, không dùng t.subjectsLabel gây điền nhầm môn học vào đây --%>
                                <textarea class="textarea" name="strengths" placeholder="Nhập lại các thông tin thế mạnh, chứng chỉ ngoại ngữ, kinh nghiệm đứng lớp của bạn..." rows="4"></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <h3 class="form-section-title">Thông tin giảng dạy</h3>
                        <div class="form-grid">

                            <div class="form-group form-field-full">
                                <label class="label">Môn dạy <span class="req">*</span></label>
                                <div class="chip-grid">
                                    <c:forEach var="sub" items="${['Toán', 'Lý', 'Hóa', 'Văn', 'Tiếng Việt', 'Anh Văn', 'Báo Bài', 'Sinh', 'Sử', 'Địa', 'Tin Học', 'Vẽ', 'Rèn Chữ', 'Anh Văn Giao Tiếp', 'TOEIC', 'IELTS', 'TOEFL', 'Tiếng Pháp', 'Tiếng Hàn', 'Tiếng Hoa', 'Tiếng Nhật', 'Đàn Piano', 'Đàn Organ', 'Đàn Guitar', 'Tiếng Việt Cho Người Nước Ngoài', 'Nhảy Hiện Đại', 'Khoa Học Tự Nhiên', 'Khoa Học']}">
                                        <label class="check-card">
                                            <input type="checkbox" name="subjects" value="${sub}" ${fn:contains(t.subjects, sub) ? 'checked' : ''}> ${sub}
                                        </label>
                                    </c:forEach>
                                </div>
                            </div>

                            <div class="form-group form-field-full">
                                <label class="label">Lớp dạy <span class="req">*</span></label>
                                <div class="chip-grid">
                                    <c:forEach var="grade" items="${['Lớp Lá', 'Lớp 1', 'Lớp 2', 'Lớp 3', 'Lớp 4', 'Lớp 5', 'Lớp 6', 'Lớp 7', 'Lớp 8', 'Lớp 9', 'Lớp 10', 'Lớp 11', 'Lớp 12', 'Đại Học']}">
                                        <label class="check-card">
                                            <input type="checkbox" name="grades" value="${grade}" ${fn:contains(t.grades, grade) ? 'checked' : ''}> ${grade}
                                        </label>
                                    </c:forEach>
                                </div>
                            </div>

                            <div class="form-group form-field-full">
                                <label class="label">Khu vực dạy <span class="req">*</span></label>
                                <div class="chip-grid">
                                    <c:forEach var="area" items="${['Quận 1', 'Quận 2', 'Quận 3', 'Quận 4', 'Quận 5', 'Quận 6', 'Quận 7', 'Quận 8', 'Quận 9', 'Quận 10', 'Quận 11', 'Quận 12', 'Bình Tân', 'Bình Thạnh', 'Gò Vấp', 'Phú Nhuận', 'Tân Bình', 'Tân phú', 'Thủ Đức', 'Bình Chánh', 'Cần Giờ', 'Củ Chi', 'Hóc Môn', 'Nhà Bè']}">
                                        <label class="check-card">
                                                <%-- Đối chiếu trực tiếp chuỗi danh sách quận huyện từ DB --%>
                                            <input type="checkbox" name="areas" value="${area}" ${fn:contains(t.districtName, area) ? 'checked' : ''}> ${area}
                                        </label>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-actions" style="display: flex; justify-content: flex-end; gap: 15px; align-items: center;">
                        <span class="form-actions-note" style="margin-right: auto;">Các trường có dấu * là bắt buộc.</span>
                        <a href="<%= request.getContextPath() %>/home" style="padding: 11px 24px; border: 1px solid #cbd5e1; border-radius: 6px; color: #475569; text-decoration: none; font-size: 14px; font-weight: 500; background: #fff;">Hủy bỏ</a>
                        <button class="btn btn-primary" type="submit" style="margin: 0; padding: 11px 24px; border-radius: 6px; font-weight: 600;">Cập nhật &amp; Gửi duyệt lại</button>
                    </div>
                </div>
            </form>
        </section>
    </div>
</main>

<jsp:include page="/views/common/footer.jsp" />