package vn.edu.nlu.fit.tutorweb.dao;

import org.jdbi.v3.core.Jdbi;
import vn.edu.nlu.fit.tutorweb.db.DBConnect;

import java.util.Arrays;
import java.util.List;

public class UserDAO {
    private final Jdbi jdbi = DBConnect.get();

    // 1. Cập nhật thông tin Full Profile (Chữ)
    public boolean updateFullProfile(long userId, String fullname, String phone, String username, String email) {
        String sql = "UPDATE users SET fullname = :fullname, phone = :phone, username = :username, email = :email WHERE id = :id";
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("fullname", fullname)
                        .bind("phone", phone)
                        .bind("username", username)
                        .bind("email", email)
                        .bind("id", userId)
                        .execute() > 0
        );
    }

    // 2. Cập nhật URL ảnh từ Cloudinary
    public boolean updateAvatarUrl(long userId, String avatarUrl) {
        String sql = "UPDATE users SET avatar_url = :avatarUrl WHERE id = :id";
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("avatarUrl", avatarUrl)
                        .bind("id", userId)
                        .execute() > 0
        );
    }

    // 3. Các hàm kiểm tra trùng lặp (Bắt buộc phải có trong DAO)
    public boolean isPhoneExisted(String phone, long excludeUserId) {
        String sql = "SELECT COUNT(*) FROM users WHERE phone = :phone AND id != :excludeUserId";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("phone", phone)
                        .bind("excludeUserId", excludeUserId)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }

    public boolean isUsernameExisted(String username, long excludeUserId) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = :username AND id != :excludeUserId";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("username", username)
                        .bind("excludeUserId", excludeUserId)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }

    public boolean isEmailExisted(String email, long excludeUserId) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = :email AND id != :excludeUserId";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("email", email)
                        .bind("excludeUserId", excludeUserId)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }

    public String getPhoneByUserId(long userId) {
        String sql = "SELECT phone FROM users WHERE id = :id";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("id", userId)
                        .mapTo(String.class)
                        .findOne()
                        .orElse("") // Trả về rỗng nếu không tìm thấy hoặc phone là NULL
        );
    }
    public String getEmailByUserId(long userId) {
        String sql = "SELECT email FROM users WHERE id = :id";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("id", userId)
                        .mapTo(String.class)
                        .findOne()
                        .orElse("")
        );
    }

    // 4. Xử lý cộng tiền vào tài khoản khi nạp tiền thành công qua MOMO (Đã đổi vnp_txn_ref -> txn_ref)
    public boolean depositMoney(long userId, long amount, String orderId) {
        String updateBalanceSql = "UPDATE users SET balance = balance + :amount WHERE id = :id";

        // Đã cập nhật tên cột thành 'txn_ref' để truyền mã orderId từ MoMo sang
        String insertTransactionSql = "INSERT INTO transactions (user_id, type, amount, status, txn_ref, created_at) " +
                "VALUES (:userId, 'DEPOSIT', :amount, 'SUCCESS', :orderId, NOW())";

        // Sử dụng Transaction của JDBI để đảm bảo an toàn dữ liệu
        return jdbi.inTransaction(handle -> {
            // Thực thi cập nhật số dư
            int updatedUser = handle.createUpdate(updateBalanceSql)
                    .bind("amount", amount)
                    .bind("id", userId)
                    .execute();

            // Thực thi chèn lịch sử giao dịch nạp tiền MoMo
            int insertedTxn = handle.createUpdate(insertTransactionSql)
                    .bind("userId", userId)
                    .bind("amount", amount)
                    .bind("orderId", orderId)
                    .execute();

            return updatedUser > 0 && insertedTxn > 0;
        });
    }

    // =========================================================================
    // 🌟 DANH MỤC MÔN HỌC (Khớp hoàn toàn 28 môn từ register.jsp)
    // =========================================================================
    public List<String> getAllSubjects() {
        return Arrays.asList(
                "Toán", "Lý", "Hóa", "Văn", "Tiếng Việt", "Anh Văn", "Báo Bài",
                "Sinh", "Sử", "Địa", "Tin Học", "Vẽ", "Rèn Chữ", "Anh Văn Giao Tiếp",
                "TOEIC", "IELTS", "TOEFL", "Tiếng Pháp", "Tiếng Hàn", "Tiếng Hoa",
                "Tiếng Nhật", "Đàn Piano", "Đàn Organ", "Đàn Guitar",
                "Tiếng Việt Cho Người Nước Ngoài", "Nhảy Hiện Đại",
                "Khoa Học Tự Nhiên", "Khoa Học"
        );
    }

    // =========================================================================
    // 🌟 DANH MỤC LỚP HỌC (Khớp hoàn toàn 14 lớp từ register.jsp)
    // =========================================================================
    public List<String> getAllGrades() {
        return Arrays.asList(
                "Lớp Lá", "Lớp 1", "Lớp 2", "Lớp 3", "Lớp 4", "Lớp 5",
                "Lớp 6", "Lớp 7", "Lớp 8", "Lớp 9", "Lớp 10", "Lớp 11",
                "Lớp 12", "Đại Học"
        );
    }

    // =========================================================================
    // 🌟 DANH MỤC KHU VỰC (Khớp hoàn toàn 24 quận huyện từ register.jsp)
    // =========================================================================
    public List<String> getAllAreas() {
        return Arrays.asList(
                "Quận 1", "Quận 2", "Quận 3", "Quận 4", "Quận 5", "Quận 6",
                "Quận 7", "Quận 8", "Quận 9", "Quận 10", "Quận 11", "Quận 12",
                "Bình Tân", "Bình Thạnh", "Gò Vấp", "Phú Nhuận", "Tân Bình",
                "Tân phú", "Thủ Đức", "Bình Chánh", "Cần Giờ", "Củ Chi",
                "Hóc Môn", "Nhà Bè"
        );
    }
}
