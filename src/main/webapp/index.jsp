<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Trang chu - Gia Su Ba Dao" />
    <jsp:param name="pageCss" value="/assets/css/home.css" />
</jsp:include>
<jsp:include page="/views/common/navbar.jsp" />

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
                <a class="section-link" href="<%= request.getContextPath() %>/views/tutor/list.jsp">Xem tất cả</a>
            </div>
            <div class="tutor-grid">
                <article class="tutor-card">
                    <div class="tutor-top">
                        <div class="tutor-avatar avatar-1"></div>
                        <span class="rating-pill">4.9</span>
                    </div>
                    <h3>Nguyễn Thùy Linh</h3>
                    <div class="meta">Tiếng Anh • ĐH Ngoại ngữ</div>
                    <div class="tutor-tags">
                        <span class="tag-pill">IELTS 8.5</span>
                        <span class="tag-pill">Q.1</span>
                    </div>
                    <div class="tutor-actions">
                        <span class="price">450k/buổi</span>
                        <a class="btn btn-outline" href="<%= request.getContextPath() %>/views/tutor/detail.jsp">Hồ sơ chi tiết</a>
                    </div>
                </article>
                <article class="tutor-card">
                    <div class="tutor-top">
                        <div class="tutor-avatar avatar-2"></div>
                        <span class="rating-pill">4.8</span>
                    </div>
                    <h3>Trần Minh Quân</h3>
                    <div class="meta">Anh Văn • RMIT</div>
                    <div class="tutor-tags">
                        <span class="tag-pill">IELTS 8.5</span>
                        <span class="tag-pill">Q.3</span>
                    </div>
                    <div class="tutor-actions">
                        <span class="price">600k/buổi</span>
                        <a class="btn btn-outline" href="<%= request.getContextPath() %>/views/tutor/detail.jsp">Hồ sơ chi tiết</a>
                    </div>
                </article>
                <article class="tutor-card">
                    <div class="tutor-top">
                        <div class="tutor-avatar avatar-3"></div>
                        <span class="rating-pill">5.0</span>
                    </div>
                    <h3>Lê Bảo Trân</h3>
                    <div class="meta">Ngữ Văn • ĐHSP</div>
                    <div class="tutor-tags">
                        <span class="tag-pill">Thủ Đức</span>
                        <span class="tag-pill">Giỏi Văn</span>
                    </div>
                    <div class="tutor-actions">
                        <span class="price">300k/buổi</span>
                        <a class="btn btn-outline" href="<%= request.getContextPath() %>/views/tutor/detail.jsp">Hồ sơ chi tiết</a>
                    </div>
                </article>
                <article class="tutor-card">
                    <div class="tutor-top">
                        <div class="tutor-avatar avatar-4"></div>
                        <span class="rating-pill">4.8</span>
                    </div>
                    <h3>Phạm Hoàng Nam</h3>
                    <div class="meta">Kỹ sư CNTT • ĐH Bách Khoa</div>
                    <div class="tutor-tags">
                        <span class="tag-pill">Vật Lý</span>
                        <span class="tag-pill">Lớp 12</span>
                    </div>
                    <div class="tutor-actions">
                        <span class="price">400k/buổi</span>
                        <a class="btn btn-outline" href="<%= request.getContextPath() %>/views/tutor/detail.jsp">Hồ sơ chi tiết</a>
                    </div>
                </article>
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
