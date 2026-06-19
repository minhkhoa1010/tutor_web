package vn.edu.nlu.fit.tutorweb.entity;

import java.io.Serializable;

public class Booking implements Serializable {
    private static final long serialVersionUID = 1L;

    private long id;
    private long parentId;
    private long tutorId;

    private String subjectName;
    private String schedule;
    private long totalPrice;
    private int totalLesson;

    private String status;
    private String createdAt;

    private String tutorName;
    private String portraitUrl;
    private String dateOfBirth;

    // BỔ SUNG: Hai trường mới để hứng dữ liệu khiếu nại phục vụ cho giao diện chi tiết hoặc trang Admin
    private String disputeReason;
    private String disputeBy;

    public Booking() {}

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public long getParentId() { return parentId; }
    public void setParentId(long parentId) { this.parentId = parentId; }

    public long getTutorId() { return tutorId; }
    public void setTutorId(long tutorId) { this.tutorId = tutorId; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

    public String getSchedule() { return schedule; }
    public void setSchedule(String schedule) { this.schedule = schedule; }

    public long getTotalPrice() { return totalPrice; }
    public void setTotalPrice(long totalPrice) { this.totalPrice = totalPrice; }

    public int getTotalLesson() { return totalLesson; }
    public void setTotalLesson(int totalLesson) { this.totalLesson = totalLesson; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    public String getTutorName() { return tutorName; }
    public void setTutorName(String tutorName) { this.tutorName = tutorName; }

    public String getPortraitUrl() { return portraitUrl; }
    public void setPortraitUrl(String portraitUrl) { this.portraitUrl = portraitUrl; }

    public String getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(String dateOfBirth) { this.dateOfBirth = dateOfBirth; }

    public String getDisputeReason() { return disputeReason; }
    public void setDisputeReason(String disputeReason) { this.disputeReason = disputeReason; }

    public String getDisputeBy() { return disputeBy; }
    public void setDisputeBy(String disputeBy) { this.disputeBy = disputeBy; }

    /**
     * CẬP NHẬT: Thêm các nhãn tiếng Việt cho luồng trạng thái mới
     */
    public String getStatusLabel() {
        if (status == null) return "Không rõ";

        return switch (status.toUpperCase()) {
            case "PENDING" -> "Chờ thanh toán";
            case "PAID" -> "Đã thanh toán";
            case "ACTIVE" -> "Đang học";
            case "PENDING_COMPLETED" -> "Chờ xác nhận kết thúc";
            case "DISPUTED" -> "Đang khiếu nại";
            case "COMPLETED" -> "Đã hoàn thành";
            case "REFUNDED" -> "Đã hoàn tiền";
            case "CANCELLED" -> "Đã hủy";
            default -> status;
        };
    }
}