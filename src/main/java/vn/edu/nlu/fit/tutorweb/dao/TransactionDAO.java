package vn.edu.nlu.fit.tutorweb.dao;

import org.jdbi.v3.core.Jdbi;
import vn.edu.nlu.fit.tutorweb.db.DBConnect;
import vn.edu.nlu.fit.tutorweb.entity.Transaction;

import java.util.List;

public class TransactionDAO {
    private final Jdbi jdbi = DBConnect.get();

    // Lấy toàn bộ lịch sử giao dịch của user (dùng cho phụ huynh - trang lịch sử thanh toán)
    public List<Transaction> getByUserId(long userId) {
        String sql = """
        SELECT id, user_id, type, amount, status, txn_ref,
               DATE_FORMAT(created_at, '%d/%m/%Y %H:%i') AS createdAt
        FROM transactions
        WHERE user_id = :userId
        ORDER BY created_at DESC
    """;
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("userId", userId)
                        .mapToBean(Transaction.class)
                        .list()
        );
    }

    // Lấy lịch sử NHẬN TIỀN của gia sư (tab "Lịch sử nhận tiền" trong wallet.jsp)
    // Dùng đúng ENUM: REVENUE_FROM_BOOKING và RECEIVE_FROM_BOOKING
    public List<Transaction> getEarningsByUserId(long userId) {
        String sql = """
        SELECT id, user_id, type, amount, status, txn_ref,
               DATE_FORMAT(created_at, '%d/%m/%Y %H:%i') AS createdAt
        FROM transactions
        WHERE user_id = :userId
          AND type IN ('REVENUE_FROM_BOOKING', 'RECEIVE_FROM_BOOKING')
          AND status = 'SUCCESS'
        ORDER BY created_at DESC
    """;
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("userId", userId)
                        .mapToBean(Transaction.class)
                        .list()
        );
    }
}