package vn.edu.nlu.fit.tutorweb.dao;

import org.jdbi.v3.core.Jdbi;
import vn.edu.nlu.fit.tutorweb.db.DBConnect;
import java.util.Map;

public class UserDAO {

    private final Jdbi jdbi = DBConnect.get();

    /**
     * Cập nhật thông tin cơ bản của User (Dùng cho trang Cài đặt / Profile cá nhân)
     */
    public boolean updateBasicProfile(long userId, String fullname, String phone) {
        String sql = "UPDATE users SET fullname = :fullname, phone = :phone WHERE id = :id";
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("fullname", fullname)
                        .bind("phone", phone)
                        .bind("id", userId)
                        .execute() > 0
        );
    }

    /**
     * Cập nhật ảnh đại diện mới cho User
     */
    public boolean updateAvatar(long userId, String avatarUrl) {
        String sql = "UPDATE users SET avatar_url = :avatarUrl WHERE id = :id";
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("avatarUrl", avatarUrl)
                        .bind("id", userId)
                        .execute() > 0
        );
    }

    /**
     * Kiểm tra nhanh xem số điện thoại đã có ai đăng ký chưa (tránh trùng lặp khi sửa profile)
     */
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
}