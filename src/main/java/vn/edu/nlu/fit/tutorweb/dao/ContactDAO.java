package vn.edu.nlu.fit.tutorweb.dao;

import org.jdbi.v3.core.Jdbi;
import vn.edu.nlu.fit.tutorweb.db.DBConnect;
import vn.edu.nlu.fit.tutorweb.entity.Contact;

import java.util.List;

public class ContactDAO {

    // Đồng bộ khai báo JDBI từ hệ thống core của ông
    private final Jdbi jdbi = DBConnect.get();

    /**
     * 1. LƯU YÊU CẦU LIÊN HỆ MỚI TỪ CLIENT
     */
    public boolean insertContact(Contact contact) {
        String sql = """
            INSERT INTO contacts (fullname, email, phone, subject, message, is_read, created_at)
            VALUES (:fullname, :email, :phone, :subject, :message, 0, NOW())
        """;

        int rows = jdbi.withHandle(h ->
                h.createUpdate(sql)
                        .bindBean(contact) // Tự động map các thuộc tính của object Contact vào SQL
                        .execute()
        );
        return rows > 0;
    }

    /**
     * 2. LẤY TOÀN BỘ DANH SÁCH LIÊN HỆ ĐỂ HIỂN THỊ TRÊN TRANG ADMIN
     */
    public List<Contact> getAllContacts() {
        String sql = """
            SELECT 
                id, 
                fullname, 
                email, 
                phone, 
                subject, 
                message, 
                is_read AS isRead, 
                created_at AS createdAt
            FROM contacts
            ORDER BY id DESC
        """;

        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .mapToBean(Contact.class)
                        .list()
        );
    }
    /**
     * 3. CẬP NHẬT TRẠNG THÁI ĐÃ ĐỌC / ĐÃ PHẢN HỒI (JDBI)
     */
    public boolean updateContactStatus(long id, int isRead) {
        String sql = "UPDATE contacts SET is_read = :isRead WHERE id = :id";
        int rows = jdbi.withHandle(h ->
                h.createUpdate(sql)
                        .bind("isRead", isRead)
                        .bind("id", id)
                        .execute()
        );
        return rows > 0;
    }
}