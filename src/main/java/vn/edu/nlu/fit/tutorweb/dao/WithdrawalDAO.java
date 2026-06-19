package vn.edu.nlu.fit.tutorweb.dao;

import org.jdbi.v3.core.Jdbi;
import vn.edu.nlu.fit.tutorweb.db.DBConnect;

public class WithdrawalRequestDAO {
    private final Jdbi jdbi = DBConnect.get();

    /**
     * Thực hiện tạo lệnh rút tiền, trừ số dư ví ảo trong cùng một Transaction
     * @return "SUCCESS" hoặc mã lỗi cụ thể
     */
    public String createWithdrawalRequest(long userId, long amount, String bankName, String bankAccountNumber, String bankAccountName) {
        try {
            return jdbi.inTransaction(handle -> {
                // 1. Kiểm tra số dư ví ảo hiện tại của người dùng
                long currentBalance = handle.createQuery("SELECT balance FROM users WHERE id = :userId FOR UPDATE")
                        .bind("userId", userId)
                        .mapTo(Long.class)
                        .one();

                if (currentBalance < amount) {
                    return "ERR_INSUFFICIENT_BALANCE";
                }

                // 2. Trừ tiền ảo trong ví ngay khi đặt lệnh (Đóng băng dòng tiền chờ Admin duyệt)
                handle.createUpdate("UPDATE users SET balance = balance - :amount WHERE id = :userId")
                        .bind("amount", amount)
                        .bind("userId", userId)
                        .execute();

                // 3. Insert thông tin vào bảng withdrawal_requests đúng cấu trúc DB
                long requestId = handle.createUpdate("""
                    INSERT INTO withdrawal_requests (user_id, amount, bank_name, bank_account_number, bank_account_name, status, created_at)
                    VALUES (:userId, :amount, :bankName, :bankAccountNumber, :bankAccountName, 'PENDING', NOW())
                """)
                        .bind("userId", userId)
                        .bind("amount", amount)
                        .bind("bankName", bankName)
                        .bind("bankAccountNumber", bankAccountNumber)
                        .bind("bankAccountName", bankAccountName)
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(Long.class)
                        .one();

                // 4. Ghi nhận vào bảng lịch sử giao dịch (transactions) hiển thị dấu trừ tạm tính
                handle.createUpdate("""
                    INSERT INTO transactions (user_id, type, amount, status, txn_ref, created_at)
                    VALUES (:userId, 'WITHDRAW_REQUEST', :amount, 'PENDING', :ref, NOW())
                """)
                        .bind("userId", userId)
                        .bind("amount", amount)
                        .bind("ref", "WITHDRAW_" + requestId)
                        .execute();

                return "SUCCESS";
            });
        } catch (Exception e) {
            e.printStackTrace();
            return "ERR_SYSTEM";
        }
    }
}