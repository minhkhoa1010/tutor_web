<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Dang ky - Gia Su Ba Dao" />
    <jsp:param name="pageCss" value="/assets/css/register.css" />
</jsp:include>
<jsp:include page="/views/common/navbar.jsp" />

<main class="page-main">
    <div class="container">
        <section class="section auth-preview">
            <h2 class="section-title">Đăng ký tài khoản</h2>
            <div class="section-sub">Chọn vai trò phù hợp để bắt đầu hành trình học tập.</div>
            <div class="auth-grid">
                <div class="card">
                    <div class="card-header">Học viên &amp; Phụ huynh</div>
                    <form method="post"
                          action="<%=request.getContextPath()%>/register">

                        <div class="form-group">
                            <label>Họ tên</label>
                            <input class="input-field"  type="text"
                                   name="fullname"
                                   required>
                        </div>

                        <div class="form-group">
                            <label>Email</label>
                            <input class="input-field" type="email"
                                   name="email"
                                   required>
                        </div>

                        <div class="form-group">
                            <label>Số điện thoại</label>
                            <input class="input-field" type="text"
                                   name="phone"
                                   required>
                        </div>

                        <div class="form-group">
                            <label>Mật khẩu</label>
                            <input class="input-field" type="password"
                                   name="password"
                                   required>
                        </div>

                        <div class="form-group">
                            <label>Xác nhận mật khẩu</label>
                            <input class="input-field" type="password"
                                   name="confirmPassword"
                                   required>
                        </div>

                        <button class="btn btn-primary"
                                type="submit">
                            Đăng ký học viên
                        </button>

                    </form>
                </div>
                <div class="card">
                    <div class="card-header">Trở thành gia sư</div>
                    <div class="section-sub">Hoàn thiện hồ sơ để trung tâm duyệt và nhận lớp phù hợp.</div>
                    <a class="btn btn-emerald" href="#tutor-form">Điền hồ sơ gia sư</a>
                </div>
            </div>
        </section>
        <section class="section register-page" id="tutor-form">
            <div class="section-head">
                <h2 class="section-title">Đăng ký gia sư</h2>
                <div class="section-sub">Vui lòng điền đầy đủ thông tin để trung tâm duyệt hồ sơ.</div>
            </div>
            <form class="register-form"
                  method="post"
                  action="<%= request.getContextPath() %>/register-tutor"
                  enctype="multipart/form-data">
                <div class="form-card">
                    <div class="form-section">
                        <h3 class="form-section-title">Thông tin cá nhân</h3>
                        <div class="form-grid">
                            <div class="form-group">
                                <label class="label">Họ tên <span class="req">*</span></label>
                                <input class="input-field" type="text" name="fullName" placeholder="Nguyễn Văn Thành" required>
                            </div>
                            <div class="form-group">
                                <label class="label">Ngày sinh <span class="req">*</span></label>
                                <div class="split-fields">
                                    <select class="select-field" name="birthDay" required>
                                        <option value="">Ngày</option>
                                        <option>01</option>
                                        <option>02</option>
                                        <option>03</option>
                                        <option>04</option>
                                        <option>05</option>
                                        <option>06</option>
                                        <option>07</option>
                                        <option>08</option>
                                        <option>09</option>
                                        <option>10</option>
                                        <option>11</option>
                                        <option>12</option>
                                        <option>13</option>
                                        <option>14</option>
                                        <option>15</option>
                                        <option>16</option>
                                        <option>17</option>
                                        <option>18</option>
                                        <option>19</option>
                                        <option>20</option>
                                        <option>21</option>
                                        <option>22</option>
                                        <option>23</option>
                                        <option>24</option>
                                        <option>25</option>
                                        <option>26</option>
                                        <option>27</option>
                                        <option>28</option>
                                        <option>29</option>
                                        <option>30</option>
                                        <option>31</option>
                                    </select>
                                    <select class="select-field" name="birthMonth" required>
                                        <option value="">Tháng</option>
                                        <option>01</option>
                                        <option>02</option>
                                        <option>03</option>
                                        <option>04</option>
                                        <option>05</option>
                                        <option>06</option>
                                        <option>07</option>
                                        <option>08</option>
                                        <option>09</option>
                                        <option>10</option>
                                        <option>11</option>
                                        <option>12</option>
                                    </select>
                                    <select class="select-field" name="birthYear" required>
                                        <option value="">Năm</option>
                                        <option>1990</option>
                                        <option>1991</option>
                                        <option>1992</option>
                                        <option>1993</option>
                                        <option>1994</option>
                                        <option>1995</option>
                                        <option>1996</option>
                                        <option>1997</option>
                                        <option>1998</option>
                                        <option>1999</option>
                                        <option>2000</option>
                                        <option>2001</option>
                                        <option>2002</option>
                                        <option>2003</option>
                                        <option>2004</option>
                                        <option>2005</option>
                                        <option>2006</option>
                                        <option>2007</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="label">Giới tính</label>
                                <select class="select-field" name="gender">
                                    <option>Nam</option>
                                    <option>Nữ</option>
                                    <option>Khác</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="label">Số CCCD <span class="req">*</span></label>
                                <input class="input-field" type="text" name="citizenId" placeholder="012345678901" required>
                            </div>
                            <div class="form-group">
                                <label class="label">Email <span class="req">*</span></label>
                                <input class="input-field" type="email" name="email" placeholder="example@email.com" required>
                            </div>
                            <div class="form-group">
                                <label class="label">Điện thoại <span class="req">*</span></label>
                                <input class="input-field" type="text" name="phone" placeholder="0932609268" required>
                            </div>
                            <div class="form-group">
                                <label class="label">Đăng ký mật khẩu <span class="req">*</span></label>
                                <input class="input-field" type="password" name="password" required>
                            </div>
                            <div class="form-group">
                                <label class="label">Xác nhận lại mật khẩu <span class="req">*</span></label>
                                <input class="input-field" type="password" name="confirmPassword" required>
                            </div>
                            <div class="form-note form-field-full">
                                Gia sư tạo mật khẩu và lưu lại để sử dụng sau này (mật khẩu dùng để báo tình trạng lớp, in giấy giới thiệu, chỉnh sửa hồ sơ gia sư).
                            </div>
                        </div>
                    </div>
                    <div class="form-section">
                        <h3 class="form-section-title">Mức học phí mong muốn (VNĐ/Giờ hoặc VNĐ/Buổi)</h3>
                        <div class="form-group">

                        <label class="label">VNĐ <span class="req">*</span></label>
                            <input type="number" name="hourlyRate" class="input-field" placeholder="Ví dụ: 200000" required min="0">
                        </div>
                    </div>
                    <div class="form-section">
                        <h3 class="form-section-title">Hình ảnh &amp; xác thực</h3>
                        <div class="form-grid">
                            <div class="form-group">
                                <label class="label">Ảnh thẻ <span class="req">*</span></label>
                                <input class="input-field" type="file" name="portrait" required>
                                <div class="hint">Ảnh thẻ (ảnh đại diện) là ảnh chụp một mình, nhìn rõ khuôn mặt. Ưu tiên hình 3x4 hoặc 4x6. Upload tối đa 1 file.</div>
                            </div>
                            <div class="form-group">
                                <label class="label">Ảnh bằng cấp <span class="req">*</span></label>
                                <input class="input-field" type="file" name="degreePhotos" multiple required>
                                <div class="hint">Ảnh chụp thẻ sinh viên hoặc bằng cấp chuyên môn cao nhất. Upload tối đa 4 file.</div>
                            </div>
                            <div class="form-group">
                                <label class="label">Ảnh CCCD <span class="req">*</span></label>
                                <input class="input-field" type="file" name="citizenPhotos" multiple required>
                                <div class="hint">Ảnh mặt trước và mặt sau CCCD, rõ nét không mờ chữ. Upload tối đa 2 file.</div>
                            </div>
                            <div class="form-note form-field-full">
                                Lưu ý: Trung tâm chỉ giao lớp khi gia sư cập nhật hình ảnh đầy đủ vào hồ sơ.
                            </div>
                        </div>
                    </div>
                    <div class="form-section">
                        <h3 class="form-section-title">Học tập &amp; kinh nghiệm</h3>
                        <div class="form-grid">
                            <div class="form-group">
                                <label class="label">Trường đào tạo <span class="req">*</span></label>
                                <input class="input-field" type="text" name="school" placeholder="Đại Học Sư Phạm" required>
                            </div>
                            <div class="form-group">
                                <label class="label">Ngành học <span class="req">*</span></label>
                                <input class="input-field" type="text" name="major" placeholder="Sư Phạm Vật Lý" required>
                            </div>
                            <div class="form-group form-field-full">
                                <label class="label">Trình độ / Bằng cấp cao nhất <span class="req">*</span></label>
                                <select class="select-field" name="qualification" style="width: 100%; padding: 10px; border: 1px solid #cbd5e1; border-radius: 4px;" required>
                                    <option value="">-- Chọn trình độ hiện tại --</option>
                                    <option value="Sinh Viên">Sinh Viên</option>
                                    <option value="Cử Nhân">Cử Nhân</option>
                                    <option value="Thạc Sĩ">Thạc Sĩ</option>
                                    <option value="Giáo Viên">Giáo Viên / Giảng Viên</option>
                                </select>
                            </div>
                            <div class="form-group form-field-full">
                                <label for="experience" style="font-weight: 600; margin-bottom: 8px; display: block;">
                                    Kinh nghiệm giảng dạy & Thành tích <span class="req">*</span>
                                </label>
                                <textarea id="experience" name="experienceSummary" rows="5"
                                          style="width: 100%; padding: 12px; border: 1px solid #e2e8f0; border-radius: 8px; resize: none;"
                                          placeholder="Mời bạn nhập thông tin theo mẫu:
- Học lực/Thành tích: [Ví dụ: Thủ khoa, GPA 3.8/4.0, Chứng chỉ IELTS 7.5...]
- Kinh nghiệm: [Ví dụ: Đã có 2 năm giảng dạy, kèm cặp 10+ học sinh...]
- Phương pháp dạy: [Ví dụ: Tập trung vào tư duy logic, không gây áp lực...
- Gia sư có thể tự thêm:.....]"></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="form-section">
                        <h3 class="form-section-title">Thông tin giảng dạy</h3>
                        <div class="form-grid">
                            <div class="form-group form-field-full" style="margin-top: 24px;">
                                <label class="label" style="display: flex; align-items: center; gap: 6px; font-weight: 600;">
                                    <svg style="width: 18px; height: 18px; color: #4b5563;" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0v-7.5A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 11.25v7.5" />
                                    </svg>
                                    Thời gian dạy phù hợp (Lịch rảnh) <span class="req">*</span>
                                </label>
                                <div style="font-size: 13px; color: #6b7280; margin-bottom: 12px;">Vui lòng chọn các khoảng thời gian bạn có thể nhận lớp ổn định.</div>
                                <div class="chip-grid">
                                    <label class="check-card"><input type="checkbox" name="schedules" value="1"> Sáng Thứ 2</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="2"> Chiều Thứ 2</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="3"> Tối Thứ 2</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="4"> Sáng Thứ 3</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="5"> Chiều Thứ 3</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="6"> Tối Thứ 3</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="7"> Sáng Thứ 4</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="8"> Chiều Thứ 4</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="9"> Tối Thứ 4</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="10"> Sáng Thứ 5</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="11"> Chiều Thứ 5</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="12"> Tối Thứ 5</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="13"> Sáng Thứ 6</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="14"> Chiều Thứ 6</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="15"> Tối Thứ 6</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="16"> Sáng Thứ 7</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="17"> Chiều Thứ 7</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="18"> Tối Thứ 7</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="19"> Sáng CN</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="20"> Chiều CN</label>
                                    <label class="check-card"><input type="checkbox" name="schedules" value="21"> Tối CN</label>
                                </div>
                            </div>
                            <div class="form-group form-field-full">
                                <label class="label">Môn dạy <span class="req">*</span></label>
                                <div class="chip-grid">
                                    <label class="check-card"><input type="checkbox" name="subjects" value="Toán"> Toán</label>
                                    <label class="check-card"><input type="checkbox" name="subjects" value="Lý"> Lý</label>
                                    <label class="check-card"><input type="checkbox" name="subjects" value="Hóa"> Hóa</label>
                                    <label class="check-card"><input type="checkbox" name="subjects" value="Văn"> Văn</label>
                                    <label class="check-card"><input type="checkbox" name="subjects" value="Tiếng Việt"> Tiếng Việt</label>
                                    <label class="check-card"><input type="checkbox" name="subjects" value="Anh Văn"> Anh Văn</label>
                                    <label class="check-card"><input type="checkbox" name="subjects" value="Báo Bài"> Báo Bài</label>
                                    <label class="check-card"><input type="checkbox" name="subjects" value="Sinh"> Sinh</label>
                                    <label class="check-card"><input type="checkbox" name="subjects" value="Sử"> Sử</label>
                                    <label class="check-card"><input type="checkbox" name="subjects" value="Địa"> Địa</label>
                                    <label class="check-card"><input type="checkbox" name="subjects" value="Tin Học"> Tin Học</label>
                                    <label class="check-card"><input type="checkbox" name="subjects" value="Vẽ"> Vẽ</label>
                                    <label class="check-card"><input type="checkbox" name="subjects" value="Rèn Chữ"> Rèn Chữ</label>
                                    <label class="check-card"><input type="checkbox" name="subjects" value="Anh Văn Giao Tiếp"> Anh Văn Giao Tiếp</label>
                                    <label class="check-card"><input type="checkbox" name="subjects" value="TOEIC"> TOEIC</label>
                                    <label class="check-card"><input type="checkbox" name="subjects" value="IELTS"> IELTS</label>
                                    <label class="check-card"><input type="checkbox" name="subjects" value="TOEFL"> TOEFL</label>
                                    <label class="check-card"><input type="checkbox" name="subjects" value="Tiếng Pháp"> Tiếng Pháp</label>
                                    <label class="check-card"><input type="checkbox" name="subjects" value="Tiếng Hàn"> Tiếng Hàn</label>
                                    <label class="check-card"><input type="checkbox" name="subjects" value="Tiếng Hoa"> Tiếng Hoa</label>
                                    <label class="check-card"><input type="checkbox" name="subjects" value="Tiếng Nhật"> Tiếng Nhật</label>
                                    <label class="check-card"><input type="checkbox" name="subjects" value="Đàn Piano"> Đàn Piano</label>
                                    <label class="check-card"><input type="checkbox" name="subjects" value="Đàn Organ"> Đàn Organ</label>
                                    <label class="check-card"><input type="checkbox" name="subjects" value="Đàn Guitar"> Đàn Guitar</label>
                                    <label class="check-card"><input type="checkbox" name="subjects" value="Tiếng Việt Cho Người Nước Ngoài"> Tiếng Việt Cho Người Nước Ngoài</label>
                                    <label class="check-card"><input type="checkbox" name="subjects" value="Nhảy Hiện Đại"> Nhảy Hiện Đại</label>
                                    <label class="check-card"><input type="checkbox" name="subjects" value="Khoa Học Tự Nhiên"> Khoa Học Tự Nhiên</label>
                                    <label class="check-card"><input type="checkbox" name="subjects" value="Khoa Học"> Khoa Học</label>
                                </div>
                            </div>
                            <div class="form-group form-field-full">

                                <div class="chip-grid">
                                    <div class="form-group form-field-full">
                                        <label class="label">Lớp dạy <span class="req">*</span></label>
                                        <div class="chip-grid">
                                            <label class="check-card"><input type="checkbox" name="grades" value="Lớp Lá"> Lớp Lá</label>
                                            <label class="check-card"><input type="checkbox" name="grades" value="Lớp 1"> Lớp 1</label>
                                            <label class="check-card"><input type="checkbox" name="grades" value="Lớp 2"> Lớp 2</label>
                                            <label class="check-card"><input type="checkbox" name="grades" value="Lớp 3"> Lớp 3</label>
                                            <label class="check-card"><input type="checkbox" name="grades" value="Lớp 4"> Lớp 4</label>
                                            <label class="check-card"><input type="checkbox" name="grades" value="Lớp 5"> Lớp 5</label>
                                            <label class="check-card"><input type="checkbox" name="grades" value="Lớp 6"> Lớp 6</label>
                                            <label class="check-card"><input type="checkbox" name="grades" value="Lớp 7"> Lớp 7</label>
                                            <label class="check-card"><input type="checkbox" name="grades" value="Lớp 8"> Lớp 8</label>
                                            <label class="check-card"><input type="checkbox" name="grades" value="Lớp 9"> Lớp 9</label>
                                            <label class="check-card"><input type="checkbox" name="grades" value="Lớp 10"> Lớp 10</label>
                                            <label class="check-card"><input type="checkbox" name="grades" value="Lớp 11"> Lớp 11</label>
                                            <label class="check-card"><input type="checkbox" name="grades" value="Lớp 12"> Lớp 12</label>
                                            <label class="check-card"><input type="checkbox" name="grades" value="Đại Học"> Đại Học</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group form-field-full">
                                <label class="label">Khu vực dạy <span class="req">*</span></label>
                                <div class="chip-grid">
                                    <label class="check-card"><input type="checkbox" name="areas" value="Quận 1"> Quận 1</label>
                                    <label class="check-card"><input type="checkbox" name="areas" value="Quận 2"> Quận 2</label>
                                    <label class="check-card"><input type="checkbox" name="areas" value="Quận 3"> Quận 3</label>
                                    <label class="check-card"><input type="checkbox" name="areas" value="Quận 4"> Quận 4</label>
                                    <label class="check-card"><input type="checkbox" name="areas" value="Quận 5"> Quận 5</label>
                                    <label class="check-card"><input type="checkbox" name="areas" value="Quận 6"> Quận 6</label>
                                    <label class="check-card"><input type="checkbox" name="areas" value="Quận 7"> Quận 7</label>
                                    <label class="check-card"><input type="checkbox" name="areas" value="Quận 8"> Quận 8</label>
                                    <label class="check-card"><input type="checkbox" name="areas" value="Quận 9"> Quận 9</label>
                                    <label class="check-card"><input type="checkbox" name="areas" value="Quận 10"> Quận 10</label>
                                    <label class="check-card"><input type="checkbox" name="areas" value="Quận 11"> Quận 11</label>
                                    <label class="check-card"><input type="checkbox" name="areas" value="Quận 12"> Quận 12</label>
                                    <label class="check-card"><input type="checkbox" name="areas" value="Bình Tân"> Bình Tân</label>
                                    <label class="check-card"><input type="checkbox" name="areas" value="Bình Thạnh"> Bình Thạnh</label>
                                    <label class="check-card"><input type="checkbox" name="areas" value="Gò Vấp"> Gò Vấp</label>
                                    <label class="check-card"><input type="checkbox" name="areas" value="Phú Nhuận"> Phú Nhuận</label>
                                    <label class="check-card"><input type="checkbox" name="areas" value="Tân Bình"> Tân Bình</label>
                                    <label class="check-card"><input type="checkbox" name="areas" value="Tân phú"> Tân phú</label>
                                    <label class="check-card"><input type="checkbox" name="areas" value="Thủ Đức"> Thủ Đức</label>
                                    <label class="check-card"><input type="checkbox" name="areas" value="Bình Chánh"> Bình Chánh</label>
                                    <label class="check-card"><input type="checkbox" name="areas" value="Cần Giờ"> Cần Giờ</label>
                                    <label class="check-card"><input type="checkbox" name="areas" value="Củ Chi"> Củ Chi</label>
                                    <label class="check-card"><input type="checkbox" name="areas" value="Hóc Môn"> Hóc Môn</label>
                                    <label class="check-card"><input type="checkbox" name="areas" value="Nhà Bè"> Nhà Bè</label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="form-actions">
                        <button class="btn btn-primary" type="submit">Gửi hồ sơ đăng ký</button>
                        <span class="form-actions-note">Các trường có dấu * là bắt buộc.</span>
                    </div>
                </div>
            </form>
        </section>
    </div>
</main>

<jsp:include page="/views/common/footer.jsp" />
