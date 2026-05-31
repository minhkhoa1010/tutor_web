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
}