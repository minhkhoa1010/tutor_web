package vn.edu.nlu.fit.tutorweb.dao;

import vn.edu.nlu.fit.tutorweb.db.DBConnect;
import vn.edu.nlu.fit.tutorweb.entity.Transaction;
import vn.edu.nlu.fit.tutorweb.entity.WithdrawalRequest;
import java.util.List;

public class WithdrawalDAO {

    // Lấy lịch sử nhận tiền (RECEIVE_FROM_BOOKING) của gia sư
    public List<Transaction> getIncomeTransactions(long userId) {
        return DBConnect.get().withHandle(h ->
                h.createQuery("""
            SELECT id, user_id, type, amount, status, txn_ref,
                   DATE_FORMAT(created_at, '%d/%m/%Y %H:%i') AS createdAt
            FROM transactions
            WHERE user_id = :userId
              AND type = 'REVENUE_FROM_BOOKING'
            ORDER BY created_at DESC
        """)
                        .bind("userId", userId)
                        .mapToBean(Transaction.class)
                        .list()
        );
    }

    // Lấy danh sách yêu cầu rút tiền của gia sư
    public List<WithdrawalRequest> getWithdrawalsByUserId(long userId) {
        return DBConnect.get().withHandle(h ->
                h.createQuery("""
                SELECT id, user_id, amount, bank_name, bank_account_number, 
                       bank_account_name, status,
                       DATE_FORMAT(created_at, '%d/%m/%Y %H:%i') AS createdAt
                FROM withdrawal_requests
                WHERE user_id = :userId
                ORDER BY created_at DESC
            """)
                        .bind("userId", userId)
                        .mapToBean(WithdrawalRequest.class)
                        .list()
        );
    }

    // Tạo yêu cầu rút tiền mới + trừ tiền ngay (giữ trong PENDING chờ admin duyệt)
    public boolean createWithdrawal(long userId, long amount,
                                    String bankName, String accountNumber, String accountName) {
        try {
            DBConnect.get().useTransaction(handle -> {
                handle.createUpdate(
                                "UPDATE users SET balance = balance - :amount WHERE id = :userId")
                        .bind("amount", amount)
                        .bind("userId", userId)
                        .execute();

                handle.createUpdate("""
                INSERT INTO withdrawal_requests
                (user_id, amount, bank_name, bank_account_number, bank_account_name, status, created_at)
                VALUES (:userId, :amount, :bankName, :accountNumber, :accountName, 'PENDING', NOW())
            """)
                        .bind("userId", userId)
                        .bind("amount", amount)
                        .bind("bankName", bankName)
                        .bind("accountNumber", accountNumber)
                        .bind("accountName", accountName)
                        .execute();

                // Ghi transactions dùng đúng column txn_ref
                handle.createUpdate("""
                INSERT INTO transactions (user_id, type, amount, status, txn_ref, created_at)
                VALUES (:userId, 'WITHDRAW', :amount, 'PENDING', :ref, NOW())
            """)
                        .bind("userId", userId)
                        .bind("amount", amount)
                        .bind("ref", "WITHDRAW_" + System.currentTimeMillis())
                        .execute();
            });
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Kiểm tra số dư đủ không
    public long getBalance(long userId) {
        return DBConnect.get().withHandle(h ->
                h.createQuery("SELECT balance FROM users WHERE id = :userId")
                        .bind("userId", userId)
                        .mapTo(Long.class)
                        .findOne()
                        .orElse(0L)
        );
    }
}