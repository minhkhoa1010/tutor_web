package vn.edu.nlu.fit.tutorweb.entity;

import java.io.Serializable;
import java.util.List;

public class UserSession implements Serializable {
    private Long id;
    private String username;
    private String email;
    private String fullname;
    private String avatarUrl;
    private List<String> roles; // Chứa: "ADMIN", "TUTOR", "USER"
    private Long balance; // Hoặc dùng kiểu private long balance; tùy bạn cấu hình ở database

    // Trong file UserSession.java
    private String phone; // Thêm trường này

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    // Constructor, Getters, Setters
    public UserSession() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getFullname() { return fullname; }
    public void setFullname(String fullname) { this.fullname = fullname; }
    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }
    public List<String> getRoles() { return roles; }
    public void setRoles(List<String> roles) { this.roles = roles; }

    public boolean hasRole(String roleName) {
        return roles != null && roles.contains(roleName.toUpperCase());
    }
    public Long getBalance() {
        return balance;
    }
    public void setBalance(Long balance) {
        this.balance = balance;
    }
}