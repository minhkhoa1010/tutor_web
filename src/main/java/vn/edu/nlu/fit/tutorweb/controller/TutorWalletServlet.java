package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.nlu.fit.tutorweb.dao.TransactionDAO;
import vn.edu.nlu.fit.tutorweb.dao.WithdrawalDAO;
import vn.edu.nlu.fit.tutorweb.entity.UserSession;
import java.io.IOException;

@WebServlet("/tutor/wallet")
public class TutorWalletServlet extends HttpServlet {
    private final WithdrawalDAO withdrawalDAO = new WithdrawalDAO();
    private final TransactionDAO transactionDAO = new TransactionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        UserSession user = session != null ? (UserSession) session.getAttribute("clientUser") : null;

        if (user == null || !user.hasRole("TUTOR")) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        req.setAttribute("withdrawalRequests",
                withdrawalDAO.getWithdrawalsByUserId(user.getId()));
        req.setAttribute("incomeTransactions",
                transactionDAO.getEarningsByUserId(user.getId()));
        req.getRequestDispatcher("/views/tutor/wallet.jsp").forward(req, resp);
    }
}