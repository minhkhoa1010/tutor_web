package vn.edu.nlu.fit.tutorweb.entity;

public class WithdrawalRequest {
    private int id;
    private long userId;
    private long amount;
    private String bankName;
    private String bankAccountNumber;
    private String bankAccountName;
    private String status;
    private String createdAt;

    // 1. THÊM THUỘC TÍNH NÀY VÀO CLASS
    private String fullname;

    // --- Các Getter và Setter cũ giữ nguyên ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public long getUserId() { return userId; }
    public void setUserId(long userId) { this.userId = userId; }

    public long getAmount() { return amount; }
    public void setAmount(long amount) { this.amount = amount; }

    public String getBankName() { return bankName; }
    public void setBankName(String bankName) { this.bankName = bankName; }

    public String getBankAccountNumber() { return bankAccountNumber; }
    public void setBankAccountNumber(String bankAccountNumber) { this.bankAccountNumber = bankAccountNumber; }

    public String getBankAccountName() { return bankAccountName; }
    public void setBankAccountName(String bankAccountName) { this.bankAccountName = bankAccountName; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    // 2. BỔ SUNG THÊM GETTER VÀ SETTER CHO FULLNAME Ở ĐÂY
    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }
}