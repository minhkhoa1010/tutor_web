package vn.edu.nlu.fit.tutorweb.entity;

import org.jdbi.v3.core.mapper.reflect.ColumnName;
import java.io.Serializable;

public class Transaction implements Serializable {
    private static final long serialVersionUID = 1L;

    private long id;
    private long userId;
    private String type;
    private long amount;
    private String status;

    // Sử dụng ColumnName của JDBI để ánh xạ chính xác cột 'txn_ref' dưới Database
    @ColumnName("txn_ref")
    private String txnRef;

    private String createdAt;

    public Transaction() {}

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public long getUserId() { return userId; }
    public void setUserId(long userId) { this.userId = userId; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public long getAmount() { return amount; }
    public void setAmount(long amount) { this.amount = amount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getTxnRef() { return txnRef; }
    public void setTxnRef(String txnRef) { this.txnRef = txnRef; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    // Chuyển đổi nhãn loại giao dịch hiển thị lên giao diện
//    public String getTypeLabel() {
//        if (type == null) return "";
//        return switch (type.toUpperCase()) {
//            case "DEPOSIT"              -> "Nạp tiền";
//            case "PAYMENT"              -> "Thanh toán";
//            case "PAYMENT_FOR_BOOKING"  -> "Thuê gia sư";
//            case "REFUND"               -> "Hoàn tiền";
//            case "WITHDRAW"             -> "Rút tiền";
//            case "RECEIVE_FROM_BOOKING" -> "Nhận tiền dạy";
//            default                     -> type;
//        };
//    }
    public String getTypeLabel() {
        if (type == null) return "";
        return switch (type.toUpperCase()) {
            case "DEPOSIT"              -> "Nạp tiền";
            case "PAYMENT_FOR_BOOKING"  -> "Thuê gia sư";
            case "WITHDRAW"             -> "Rút tiền";
            case "WITHDRAW_REQUEST"     -> "Yêu cầu rút tiền";
            case "RECEIVE_FROM_BOOKING" -> "Nhận thù lao";
            case "REVENUE_FROM_BOOKING" -> "Doanh thu nền tảng";
            case "REFUND"               -> "Hoàn tiền"; // Đã sửa ở đây
            default                     -> type;
        };
    }
    // Chuyển đổi màu sắc/nhãn trạng thái giao dịch
    public String getStatusLabel() {
        if (status == null) return "";
        return switch (status.toUpperCase()) {
            case "SUCCESS" -> "Thành công";
            case "FAILED"  -> "Thất bại";
            case "PENDING" -> "Đang xử lý";
            default        -> status;
        };
    }
}