package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.nlu.fit.tutorweb.service.PaymentService;

import java.io.IOException;

@WebServlet("/parent/momo-payment")
public class MomoPaymentServlet extends HttpServlet {

    private final PaymentService paymentService = new PaymentService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String amount = request.getParameter("amount");
            String payUrl = paymentService.createMomoPaymentUrl(amount);
            response.sendRedirect(payUrl);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/parent/profile?payment=failed");
        }
    }
}