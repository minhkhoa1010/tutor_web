package vn.edu.nlu.fit.tutorweb.action;

import org.jdbi.v3.core.Jdbi;
import org.mindrot.jbcrypt.BCrypt;
import vn.edu.nlu.fit.tutorweb.db.DBConnect;

public class FixPassword {
    public static void main(String[] args) {
        // 1. Tự sinh chuỗi băm chuẩn đét từ chính thư viện BCrypt của dự án
        String cleanHash = BCrypt.hashpw("123456", BCrypt.gensalt(10));
        System.out.println(">>> Chuỗi hash chuẩn vừa sinh ra: " + cleanHash);

        try {
            Jdbi jdbi = DBConnect.get();
            jdbi.useHandle(handle -> {
                // 2. Cập nhật đè trực tiếp vào DB qua Java JDBC (An toàn 100% về Encoding)
                int rows = handle.createUpdate("UPDATE users SET password = :pass WHERE id IN (1, 2, 3)")
                        .bind("pass", cleanHash)
                        .execute();
                System.out.println(">>> Đã cập nhật thành công mật khẩu '123456' cho " + rows + " tài khoản!");
            });
        } catch (Exception e) {
            System.err.println("❌ Lỗi khi tự động update bằng Java: ");
            e.printStackTrace();
        }
    }
}