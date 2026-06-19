<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<jsp:include page="/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Hướng Dẫn & Chính Sách Vận Hành - Gia Sư Bá Đạo"/>
    <jsp:param name="pageCss" value="/assets/css/policy.css"/>
</jsp:include>

<jsp:include page="/views/common/navbar.jsp"/>

<section class="contact-hero" style="background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%); padding: 60px 0; text-align: center; color: #fff;">
    <div class="hero-content" style="max-width: 800px; margin: 0 auto; padding: 0 20px;">
        <span class="hero-badge" style="background: rgba(16, 185, 129, 0.1); color: #10b981; padding: 6px 16px; border-radius: 50px; font-size: 14px; font-weight: 600; display: inline-flex; align-items: center; gap: 8px; margin-bottom: 20px; border: 1px solid rgba(16, 185, 129, 0.2);">
            <i class="fa-solid fa-scale-balanced"></i>
            Hệ thống quy chế vận hành sàn
        </span>
        <h1 style="font-size: 36px; font-weight: 800; margin: 0 0 15px 0; letter-spacing: -0.5px;">HƯỚNG DẪN & CHÍNH SÁCH VẬN HÀNH</h1>
        <p style="font-size: 16px; color: #94a3b8; line-height: 1.6; margin: 0;">
            Văn bản quy định chuẩn mực tương tác, cơ chế bảo lưu tài chính bảo chứng và các biện pháp chế tài quản lý nghiêm ngặt áp dụng trên nền tảng Gia Sư Bá Đạo VN.
        </p>
    </div>
</section>

<section class="policy-container" style="max-width: 1200px; margin: 0 auto; padding: 40px 20px; font-family: 'Segoe UI', system-ui, sans-serif;">

    <div class="time-rules-card" style="background: #fffbeb; border: 1px solid #fef3c7; border-left: 6px solid #d97706; padding: 25px; border-radius: 12px; margin-bottom: 35px;">
        <h3 style="margin: 0 0 12px 0; color: #92400e; font-size: 18px; font-weight: 700; display: flex; align-items: center; gap: 10px;">
            <i class="fa-solid fa-clock"></i>
            QUY ĐỊNH PHÂN ĐỊNH KHUNG GIỜ HỌC TIÊU CHUẨN (QUAN TRỌNG)
        </h3>
        <p style="margin: 0 0 20px 0; color: #b45309; font-size: 14.5px; line-height: 1.6;">
            Để đồng bộ dữ liệu lịch trình giữa bộ lọc tìm kiếm của Phụ huynh và Lịch trống cam kết của Gia sư hệ thống, nền tảng quy định mốc thời gian chi tiết bắt buộc cho từng ca học như sau. Người dùng căn cứ vào đây để thiết lập và lựa chọn lịch học phù hợp:
        </p>

        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 15px;">
            <div style="background: #fff; padding: 15px; border-radius: 8px; border: 1px solid #fde68a; display: flex; align-items: center; gap: 12px;">
                <div style="color: #d97706; font-size: 20px;"><i class="fa-solid fa-cloud-sun"></i></div>
                <div>
                    <strong style="color: #1e293b; display: block; font-size: 14px;">Ca Sáng</strong>
                    <span style="font-size: 16px; font-weight: 700; color: #d97706;">07:00 – 11:30</span>
                </div>
            </div>
            <div style="background: #fff; padding: 15px; border-radius: 8px; border: 1px solid #fde68a; display: flex; align-items: center; gap: 12px;">
                <div style="color: #d97706; font-size: 20px;"><i class="fa-solid fa-cloud"></i></div>
                <div>
                    <strong style="color: #1e293b; display: block; font-size: 14px;">Ca Chiều</strong>
                    <span style="font-size: 16px; font-weight: 700; color: #d97706;">13:00 – 17:30</span>
                </div>
            </div>
            <div style="background: #fff; padding: 15px; border-radius: 8px; border: 1px solid #fde68a; display: flex; align-items: center; gap: 12px;">
                <div style="color: #d97706; font-size: 20px;"><i class="fa-solid fa-moon"></i></div>
                <div>
                    <strong style="color: #1e293b; display: block; font-size: 14px;">Ca Tối</strong>
                    <span style="font-size: 16px; font-weight: 700; color: #d97706;">18:00 – 22:00</span>
                </div>
            </div>
        </div>
        <p style="margin: 15px 0 0 0; font-size: 13px; color: #b45309; font-style: italic; display: flex; align-items: center; gap: 6px;">
            <i class="fa-solid fa-circle-info"></i>
            * Lưu ý: Khi khớp lịch ca học (ví dụ: Tối Thứ 2), hai bên tự thống nhất giờ bắt đầu cụ thể trong khoảng ca đó (ví dụ: 19:00 - 21:00) đảm bảo thời lượng buổi học.
        </p>
    </div>

    <div class="policy-tabs" style="display: flex; gap: 10px; margin-bottom: 25px; border-bottom: 2px solid #e2e8f0; padding-bottom: 12px;">
        <button id="tab-btn-parent" onclick="switchPolicyTab('parent')" style="padding: 12px 24px; font-size: 15px; font-weight: 700; border: none; border-radius: 6px; cursor: pointer; transition: all 0.2s; background: #0f172a; color: #fff; display: flex; align-items: center; gap: 8px;">
            <i class="fa-solid fa-user-shield"></i> PHẦN I: DÀNH CHO PHỤ HUYNH & HỌC VIÊN
        </button>
        <button id="tab-btn-tutor" onclick="switchPolicyTab('tutor')" style="padding: 12px 24px; font-size: 15px; font-weight: 700; border: 1px solid #cbd5e1; border-radius: 6px; cursor: pointer; transition: all 0.2s; background: #fff; color: #475569; display: flex; align-items: center; gap: 8px;">
            <i class="fa-solid fa-graduation-cap"></i> PHẦN II: DÀNH CHO GIA SƯ
        </button>
    </div>

    <div id="policy-content-parent" style="display: block;">
        <div style="background: #fff; border: 1px solid #e2e8f0; border-radius: 12px; padding: 35px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); line-height: 1.8; color: #334155;">

            <div style="background: #f8fafc; padding: 15px; border-radius: 6px; border-left: 4px solid #3b82f6; margin-bottom: 30px; font-style: italic; color: #475569; font-weight: 500;">
                <i class="fa-solid fa-circle-check" style="color: #3b82f6; margin-right: 6px;"></i>
                Khuyến khích giữ chân người dùng, bảo vệ quyền lợi và cảnh báo chế tài quản lý tài khoản vi phạm.
            </div>

            <div style="margin-bottom: 35px;">
                <h3 style="color: #0f172a; font-size: 18px; font-weight: 700; margin-bottom: 15px; display: flex; align-items: center; gap: 8px;">
                    <i class="fa-solid fa-list-check" style="color: #3b82f6;"></i> MỤC 1: QUY TRÌNH ĐĂNG KÝ VÀ KHỚP LỚP TIÊU CHUẨN
                </h3>
                <p style="margin-bottom: 12px;">
                    <strong>Điều 1.1: Tiếp nhận yêu cầu:</strong> Phụ huynh tạo yêu cầu tìm gia sư công khai trên hệ thống hoặc gửi lời mời trực tiếp đến Gia sư dựa trên bộ lọc hồ sơ năng lực bao gồm: môn học, lớp học, khu vực, học phí.
                </p>
                <p style="margin-bottom: 12px;">
                    <strong>Điều 1.2: Xác nhận giao dịch:</strong> Khi hai bên thống nhất lịch học và mức phí thông qua hệ thống, một hợp đồng điện tử tạm thời (Lớp học trực tuyến) sẽ được thiết lập.
                </p>
                <p style="margin-bottom: 0;">
                    <strong>Điều 1.3: Thanh toán bảo đảm:</strong> Phụ huynh thực hiện nạp tiền và thanh toán học phí qua Ví điện tử của hệ thống. Số tiền này sẽ được hệ thống giữ lại làm bảo chứng và chỉ giải ngân cho Gia sư sau khi buổi học kết thúc thành công và không có khiếu nại.
                </p>
            </div>

            <div style="margin-bottom: 35px;">
                <h3 style="color: #0f172a; font-size: 18px; font-weight: 700; margin-bottom: 15px; display: flex; align-items: center; gap: 8px;">
                    <i class="fa-solid fa-award" style="color: #3b82f6;"></i> MỤC 2: TẠI SAO PHỤ HUYNH NÊN GIAO DỊCH QUA APP? (QUYỀN LỢI ĐỘC QUYỀN)
                </h3>
                <p style="margin-bottom: 12px;">
                    <strong>Điều 2.1: Bảo chứng dòng tiền 100%:</strong> Khi thanh toán qua app, số tiền của Phụ huynh được cam kết an toàn. Nếu Gia sư tự ý nghỉ dạy, đi muộn, hoặc dạy sai kiến thức, hệ thống sẽ hoàn trả tiền lập tức về ví của Phụ huynh. Nếu giao dịch tiền mặt bên ngoài, Phụ huynh có nguy cơ cao bị lừa đảo (Gia sư nhận tiền cọc tháng đầu rồi biến mất).
                </p>
                <p style="margin-bottom: 12px;">
                    <strong>Điều 2.2: Quyền khiếu nại và Trọng tài:</strong> Hệ thống cung cấp nút "Khiếu nại" trong vòng 24 giờ sau mỗi buổi học. Ban quản trị Gia Sư Bá Đạo VN đóng vai trò là trọng tài độc lập, phân xử dựa trên nhật ký lớp học và minh chứng của hai bên.
                </p>
                <p style="margin-bottom: 12px;">
                    <strong>Điều 2.3: Chính sách "Đổi Gia sư miễn phí":</strong> Trong vòng 2 buổi học đầu tiên, nếu Phụ huynh cảm thấy phương pháp dạy của Gia sư không phù hợp với học sinh, hệ thống hỗ trợ hủy lớp, hoàn lại số dư còn lại và tự động đề xuất 3 hồ sơ Gia sư xuất sắc khác thay thế hoàn toàn miễn phí.
                </p>
                <p style="margin-bottom: 0;">
                    <strong>Điều 2.4: Tích điểm đổi quà & Ưu đãi học phí:</strong> Với mỗi buổi học thanh toán qua app, Phụ huynh được tích lũy điểm thưởng (Bá Đạo Xu). Điểm này dùng để đổi các voucher giảm giá học phí cho tháng sau hoặc đổi các bộ tài liệu ôn thi độc quyền do đội ngũ chuyên gia biên soạn.
                </p>
            </div>

            <div>
                <h3 style="color: #dc2626; font-size: 18px; font-weight: 700; margin-bottom: 15px; display: flex; align-items: center; gap: 8px;">
                    <i class="fa-solid fa-triangle-exclamation"></i> MỤC 3: CHÍNH SÁCH BẢO VỆ GIA SƯ VÀ CHẾ TÀI XỬ PHẠT (CẢNH BÁO PHỤ HUYNH)
                </h3>
                <p style="font-style: italic; color: #64748b; margin-bottom: 12px;">
                    Nền tảng xây dựng môi trường văn minh, bình đẳng, nghiêm cấm các hành vi trục lợi hoặc ép buộc Gia sư vi phạm quy định.
                </p>
                <p style="margin-bottom: 12px;">
                    <strong>Điều 3.1: Định nghĩa hành vi giao dịch ngoài luồng:</strong> Hành vi Phụ huynh chủ động hoặc đồng thuận yêu cầu Gia sư hủy lớp trên ứng dụng để chuyển sang hình thức trả tiền mặt trực tiếp nhằm né tránh sự giám sát của nền tảng được coi là Vi phạm nghiêm trọng nghiêm chế vận hành.
                </p>
                <p style="margin-bottom: 12px;">
                    <strong>Điều 3.2: Rủi ro khi giao dịch ngoài luồng:</strong> Hệ thống sẽ từ chối can thiệp, từ chối chịu trách nhiệm pháp lý và không hỗ trợ xử lý bất kỳ rủi ro nào (bao gồm: Gia sư có hành vi bạo lực ngôn từ/thết xác với học sinh, Gia sư giả mạo bằng cấp gây hậu quả nghiêm trọng, mất cắp tài sản tại nhà...).
                </p>
                <p style="margin-bottom: 12px;">
                    <strong>Điều 3.3: Hệ thống cảnh cáo tự động:</strong> Khi phát hiện các dấu hiệu bất thường (Hủy lớp liên tục sau khi đã xem thông tin liên hệ, có tin nhắn chứa từ khóa nhạy cảm né app), hệ thống sẽ gửi Cảnh báo vi phạm cấp độ 1 đến tài khoản Phụ huynh.
                </p>
                <p style="margin-bottom: 12px;">
                    <strong>Điều 3.4: Biện pháp khóa tài khoản tạm thời:</strong> Nếu Phụ huynh vi phạm một trong các điều sau, tài khoản sẽ bị đóng băng từ 14 đến 30 ngày:
                </p>
                <ul style="padding-left: 20px; margin-bottom: 12px; list-style-type: square;">
                    <li>Bị Gia sư tố cáo (kèm minh chứng) về việc ép buộc Gia sư bỏ app dạy ngoài.</li>
                    <li>Không thanh toán học phí đúng hạn hoặc bùng tiền của Gia sư làm ảnh hưởng đến uy tín nền tảng.</li>
                    <li>Có hành vi thô lỗ, xúc phạm danh dự của Gia sư được hệ thống xác minh là đúng.</li>
                </ul>
                <p style="margin-bottom: 0;">
                    <strong>Điều 3.5: Khóa tài khoản vĩnh viễn:</strong> Áp dụng cho các trường hợp tái phạm sau khi đã mở khóa tạm thời, hoặc Phụ huynh cấu kết với Gia sư lừa đảo chiếm đoạt tiền khuyến mãi của hệ thống. Thông tin số điện thoại và email vi phạm sẽ bị đưa vào Danh sách đen (Blacklist) trên toàn hệ thống.
                </p>
            </div>

        </div>
    </div>

    <div id="policy-content-tutor" style="display: none;">
        <div style="background: #fff; border: 1px solid #e2e8f0; border-radius: 12px; padding: 35px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); line-height: 1.8; color: #334155;">

            <div style="background: #f0fdf4; padding: 15px; border-radius: 6px; border-left: 4px solid #10b981; margin-bottom: 30px; font-style: italic; color: #15803d; font-weight: 500;">
                <i class="fa-solid fa-circle-check" style="color: #10b981; margin-right: 6px;"></i>
                Quy trình xét duyệt nghiêm ngặt, minh bạch chi phí tài chính và chế tài kỷ luật thép đối với gia sư.
            </div>

            <div style="margin-bottom: 35px;">
                <h3 style="color: #0f172a; font-size: 18px; font-weight: 700; margin-bottom: 15px; display: flex; align-items: center; gap: 8px;">
                    <i class="fa-solid fa-id-card-clip" style="color: #10b981;"></i> MỤC 4: TIÊU CHUẨN TRỞ THÀNH GIA SƯ VÀ QUY TRÌNH XgÉT DUYỆT HỒ SƠ
                </h3>
                <p style="font-style: italic; color: #64748b; margin-bottom: 12px;">
                    Để đảm bảo chất lượng giảng dạy cao nhất của thương hiệu Gia Sư Bá Đạo, toàn bộ đối tác Gia sư phải trải qua quy trình sàng lọc 3 lớp:
                </p>
                <p style="margin-bottom: 12px;">
                    <strong>Điều 4.1: Tính chính xác của hồ sơ:</strong> Gia sư phải cập nhật đầy đủ: Họ tên, Số ĐT chính chủ, Trường đại học/Cơ quan công tác, Chuyên ngành. Thông tin này phải trùng khớp với Căn cước công dân (CCCD).
                </p>
                <p style="margin-bottom: 12px;">
                    <strong>Điều 4.2: Bắt buộc minh chứng bằng cấp (Yêu cầu nghiêm ngặt):</strong> Hệ thống không chấp nhận hồ sơ khai gian. Gia sư bắt buộc phải tải lên ảnh chụp rõ nét của:
                </p>
                <ul style="padding-left: 20px; margin-bottom: 12px; list-style-type: circle;">
                    <li>Thẻ sinh viên (đối với đối tượng hiện là sinh viên).</li>
                    <li>Bằng cử nhân / Bằng thạc sĩ / Bằng sư phạm (đối với giáo viên/giảng viên/người đã tốt nghiệp).</li>
                    <li>Chứng chỉ ngoại ngữ chuyên môn (IELTS, TOEFL, JLPT, HSK...) nếu đăng ký dạy môn Ngoại ngữ.</li>
                </ul>
                <p style="margin-bottom: 0;">
                    <strong>Điều 4.3: Thời gian xét duyệt:</strong> Đội ngũ Quản trị viên sẽ tiến hành đối soát, xác thực thông tin bằng cấp với cơ sở giáo dục trong vòng 24 giờ đến 48 giờ làm việc. Hồ sơ hợp lệ mới được hiển thị công khai trên bộ lọc tìm kiếm của Phụ huynh.
                </p>
            </div>

            <div style="margin-bottom: 35px;">
                <h3 style="color: #0f172a; font-size: 18px; font-weight: 700; margin-bottom: 15px; display: flex; align-items: center; gap: 8px;">
                    <i class="fa-solid fa-wallet" style="color: #10b981;"></i> MỤC 5: CHÍNH SÁCH CHI PHÍ VÀ CHIẾT KHẤU NỀN TẢNG
                </h3>
                <p style="margin-bottom: 12px;">
                    <strong>Điều 5.1: Phí dịch vụ hệ thống (Platform Fee):</strong> Để duy trì hệ thống, bảo mật thông tin, chạy quảng cáo tìm kiếm học viên và vận hành cổng thanh toán, hệ thống sẽ thu phí trích phần trăm dựa trên thu nhập thực tế của mỗi buổi dạy thành công.
                </p>
                <p style="margin-bottom: 12px;">
                    <strong>Điều 5.2: Biểu phí chiết khấu chi tiết:</strong>
                </p>
                <ul style="padding-left: 20px; margin-bottom: 12px; list-style-type: circle;">
                    <li>Mức phí tiêu chuẩn: <strong>15%</strong> trên tổng giá trị buổi học (Gia sư thực nhận về ví số dư mức 85% học phí).</li>
                    <li>Mức phí ưu đãi dành cho Gia sư phân hạng Kim cương (Được đánh giá từ 4.9 - 5.0 sao và tích lũy dạy trên 50 buổi): Giảm trừ chỉ còn duy nhất <strong>10%</strong>.</li>
                </ul>
                <p style="margin-bottom: 0;">
                    <strong>Điều 5.3: Quy định rút tiền về tài khoản ngân hàng:</strong> Số dư khả dụng trong ví Gia sư có thể tạo lệnh rút bất kỳ lúc nào khi đạt mức tối thiểu là <strong>100.000 VNĐ</strong>. Lệnh rút tiền được hệ thống xử lý tự động từ 8h00 đến 17h00 hàng ngày. Gia sư cần đảm bảo thông tin số tài khoản và tên ngân hàng trùng khớp với tên trên hồ sơ hệ thống để tránh lỗi giao dịch.
                </p>
            </div>

            <div style="margin-bottom: 35px;">
                <h3 style="color: #0f172a; font-size: 18px; font-weight: 700; margin-bottom: 15px; display: flex; align-items: center; gap: 8px;">
                    <i class="fa-solid fa-user-check" style="color: #10b981;"></i> MỤC 6: QUY TẮC ỨNG XỬ VÀ QUẢN LÝ CHẤT LƯỢNG
                </h3>
                <p style="margin-bottom: 12px;">
                    <strong>Điều 6.1: Tác phong sư phạm:</strong> Gia sư phải lên lớp đúng giờ (vào phòng học trực tuyến hoặc có mặt tại nhà phụ huynh trước ít nhất 5 phút). Trang phục lịch sự, ngôn từ chuẩn mực, có giáo án biên soạn riêng trước mỗi buổi dạy.
                </p>
                <p style="margin-bottom: 0;">
                    <strong>Điều 6.2: Nghiêm cấm gian lận đánh giá:</strong> Gia sư không được tự tạo tài khoản phụ huynh ảo để tự đặt lớp và tự đánh giá 5 sao cho bản thân. Hệ thống có thuật toán kiểm tra IP và thiết bị, nếu phát hiện sẽ hủy toàn bộ kết quả đánh giá.
                </p>
            </div>

            <div>
                <h3 style="color: #dc2626; font-size: 18px; font-weight: 700; margin-bottom: 15px; display: flex; align-items: center; gap: 8px;">
                    <i class="fa-solid fa-gavel"></i> MỤC 7: KỶ LUẬT THÉP VÀ KHÓA TÀI KHOẢN GIA SƯ VĨNH VIỄN
                </h3>
                <p style="font-style: italic; color: #64748b; margin-bottom: 15px;">
                    Gia sư đóng vai trò cốt lõi trong việc giữ gìn uy tín của sàn. Bất kỳ hành vi trục lợi nào đều phải chịu hình thức xử lý nghiêm khắc nhất.
                </p>
                <p style="margin-bottom: 12px;">
                    <strong>Điều 7.1: Xử lý hành vi "Kéo phụ huynh ra ngoài app":</strong> Nếu Gia sư chủ động gợi ý Phụ huynh hủy lớp trên app để giao dịch tiền mặt riêng, đây được coi là hành vi Đánh cắp tài nguyên dữ liệu và vi phạm đạo đức đối tác nghiêm trọng.
                </p>
                <p style="margin-bottom: 12px;">
                    <strong>Điều 7.2: Chế tài xử phạt vi phạm giao dịch ngoài luồng:</strong>
                </p>
                <div style="background: #fff5f5; border: 1px solid #fee2e2; padding: 20px; border-radius: 8px; margin-bottom: 15px; color: #b91c1c;">
                    <ul style="padding-left: 20px; margin: 0; font-weight: 600; list-style-type: square;">
                        <li style="margin-bottom: 8px;">Phạt tiền: Tịch thu toàn bộ số dư hiện có trong ví tài khoản Gia sư để bồi thường thiệt hại vận hành hệ thống.</li>
                        <li style="margin-bottom: 8px;">Khóa tài khoản: Kích hoạt lệnh đóng vĩnh viễn, tước bỏ hoàn toàn danh hiệu và tư cách đối tác Gia sư.</li>
                        <li style="margin-bottom: 0;">Chế tài pháp lý: Đưa thông tin cá nhân công khai (Họ tên, CCCD, Trường học) vào danh sách đen (Blacklist) của Nền tảng nhằm cảnh báo cho các tổ chức giáo dục khác.</li>
                    </ul>
                </div>
                <p style="margin-bottom: 0;">
                    <strong>Điều 7.3: Khóa tài khoản do chất lượng kém hoặc vi phạm khác:</strong>
                </p>
                <ul style="padding-left: 20px; list-style-type: square;">
                    <li style="margin-bottom: 8px;"><strong>Hủy lịch đột xuất:</strong> Gia sư tự ý hủy lớp > 3 lần trong một tháng mà không có lý do chính đáng (ốm đau có giấy chứng nhận y tế) sẽ bị khóa quyền nhận lớp trong thời gian 30 ngày.</li>
                    <li style="margin-bottom: 8px;"><strong>Điểm đánh giá thấp:</strong> Nếu điểm xếp hạng trung bình (Rating) từ Phụ huynh bị tụt xuống dưới 3.5 sao trong vòng 2 tháng liên tiếp, hệ thống sẽ tự động hủy tư cách hiển thị hồ sơ Gia sư.</li>
                    <li style="margin-bottom: 0;"><strong>Gian lận bằng cấp:</strong> Nếu phát hiện ảnh bằng cấp, thẻ sinh viên là sản phẩm chỉnh sửa kỹ thuật (Photoshop) hoặc giả mạo thông tin người khác, hệ thống sẽ xóa tài khoản lập tức và chuyển giao sang cơ quan chức năng nếu cấu thành hành vi lừa đảo chiếm đoạt tài sản.</li>
                </ul>
            </div>

        </div>
    </div>

</section>

<jsp:include page="/views/common/footer.jsp"/>

<script>
    function switchPolicyTab(tabName) {
        const parentBtn = document.getElementById('tab-btn-parent');
        const tutorBtn = document.getElementById('tab-btn-tutor');
        const parentContent = document.getElementById('policy-content-parent');
        const tutorContent = document.getElementById('policy-content-tutor');

        if (tabName === 'parent') {
            parentBtn.style.background = '#0f172a';
            parentBtn.style.color = '#fff';
            parentBtn.style.border = 'none';

            tutorBtn.style.background = '#fff';
            tutorBtn.style.color = '#475569';
            tutorBtn.style.border = '1px solid #cbd5e1';

            parentContent.style.display = 'block';
            tutorContent.style.display = 'none';
        } else if (tabName === 'tutor') {
            tutorBtn.style.background = '#10b981';
            tutorBtn.style.color = '#fff';
            tutorBtn.style.border = 'none';

            parentBtn.style.background = '#fff';
            parentBtn.style.color = '#475569';
            parentBtn.style.border = '1px solid #cbd5e1';

            parentContent.style.display = 'none';
            tutorContent.style.display = 'block';
        }
    }
</script>