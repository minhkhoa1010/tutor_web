package vn.edu.nlu.fit.tutorweb.dto;

public class StudentSearchResult {
    private long id;
    private String fullname;
    private String email;
    private String avatarUrl;
    private String createdAt;
    private int isActive;

    // 1. BỔ SUNG: Thuộc tính hứng số điện thoại từ Database
    private String phone;

    // Constructor mặc định
    public StudentSearchResult() {
    }

    // --- Giữ nguyên các Getter/Setter cũ của bạn ở đây ---
    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public String getFullname() { return fullname; }
    public void setFullname(String fullname) { this.fullname = fullname; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String url) { this.avatarUrl = url; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    public int getIsActive() { return isActive; }
    public void setIsActive(int isActive) { this.isActive = isActive; }

    // 2. BỔ SUNG: Cặp hàm Getter/Setter viết đúng chuẩn CamelCase cho biến phone
    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }
}