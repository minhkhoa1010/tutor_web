package vn.edu.nlu.fit.tutorweb.entity;

public class ChatConversation {
    private long id;
    private Long bookingId;
    private String status;
    private Long otherUserId;
    private String otherFullname;
    private String otherAvatarUrl;
    private String otherRole;
    private String subjectName;
    private String lastMessage;
    private String lastMessageType;
    private String lastMessageAt;
    private int unreadCount;

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public Long getBookingId() { return bookingId; }
    public void setBookingId(Long bookingId) { this.bookingId = bookingId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Long getOtherUserId() { return otherUserId; }
    public void setOtherUserId(Long otherUserId) { this.otherUserId = otherUserId; }

    public String getOtherFullname() { return otherFullname; }
    public void setOtherFullname(String otherFullname) { this.otherFullname = otherFullname; }

    public String getOtherAvatarUrl() { return otherAvatarUrl; }
    public void setOtherAvatarUrl(String otherAvatarUrl) { this.otherAvatarUrl = otherAvatarUrl; }

    public String getOtherRole() { return otherRole; }
    public void setOtherRole(String otherRole) { this.otherRole = otherRole; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

    public String getLastMessage() { return lastMessage; }
    public void setLastMessage(String lastMessage) { this.lastMessage = lastMessage; }

    public String getLastMessageType() { return lastMessageType; }
    public void setLastMessageType(String lastMessageType) { this.lastMessageType = lastMessageType; }

    public String getLastMessageAt() { return lastMessageAt; }
    public void setLastMessageAt(String lastMessageAt) { this.lastMessageAt = lastMessageAt; }

    public int getUnreadCount() { return unreadCount; }
    public void setUnreadCount(int unreadCount) { this.unreadCount = unreadCount; }
}
