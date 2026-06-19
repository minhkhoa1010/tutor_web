package vn.edu.nlu.fit.tutorweb.entity;

import java.sql.Timestamp;

public class Contact {
    private Long id;
    private String fullname;
    private String email;
    private String phone;
    private String subject;
    private String message;
    private int isRead;
    private Timestamp createdAt;

    // Constructor mặc định
    public Contact() {}

    // Constructor dùng khi insert (chưa có id, isRead, createdAt)
    public Contact(String fullname, String email, String phone, String subject, String message) {
        this.fullname = fullname;
        this.email = email;
        this.phone = phone;
        this.subject = subject;
        this.message = message;
    }

    // Các hàm Getter và Setter ở đây...
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getFullname() { return fullname; }
    public void setFullname(String fullname) { this.fullname = fullname; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public int getIsRead() { return isRead; }
    public void setIsRead(int isRead) { this.isRead = isRead; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}