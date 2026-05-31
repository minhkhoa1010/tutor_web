package vn.edu.nlu.fit.tutorweb.db;

import org.jdbi.v3.core.Jdbi;
import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnect {
    private static Jdbi jdbi;

    private static void connect() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = DBProperties.get("db.url");
            String username = DBProperties.get("db.username");
            String password = DBProperties.get("db.password");

            if (url == null) throw new RuntimeException("Cấu hình DB URL không tìm thấy");

            jdbi = Jdbi.create(url, username, password);
            System.out.println("Kết nối Database qua JDBI thành công");
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi kết nối DB: " + e.getMessage());
        }
    }

    public static Jdbi get() {
        if (jdbi == null) {
            connect();
        }
        return jdbi;
    }

    // Hoàn thiện hàm lấy Connection thuần từ JDBI để phòng khi các chức năng cũ cần dùng
    public static Connection getConnection() {
        try {
            String url = DBProperties.get("db.url");
            String username = DBProperties.get("db.username");
            String password = DBProperties.get("db.password");
            return DriverManager.getConnection(url, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Không thể tạo Connection thuần: " + e.getMessage());
        }
    }
}