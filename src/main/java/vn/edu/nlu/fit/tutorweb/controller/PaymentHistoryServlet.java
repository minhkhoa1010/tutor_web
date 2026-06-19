package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.nlu.fit.tutorweb.dao.TransactionDAO;
import vn.edu.nlu.fit.tutorweb.entity.UserSession;

import java.io.IOException;

@WebServlet("/parent/history")
public class PaymentHistoryServlet extends HttpServlet {

    private final TransactionDAO transactionDAO = new TransactionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserSession userSession = (UserSession) request.getSession()
                .getAttribute("clientUser");

        if (userSession == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("transactions",
                transactionDAO.getByUserId(userSession.getId()));

        request.getRequestDispatcher("/views/parent/payment-history.jsp")
                .forward(request, response);
    }
}