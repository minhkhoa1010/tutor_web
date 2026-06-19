package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.nlu.fit.tutorweb.entity.UserSession;
import vn.edu.nlu.fit.tutorweb.service.PaymentService;

import java.io.IOException;

@WebServlet("/parent/momo-return")
public class MomoReturnServlet extends HttpServlet {

    private final PaymentService paymentService = new PaymentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            UserSession userSession = (UserSession) request.getSession().getAttribute("clientUser");
            long amount = paymentService.processMomoCallback(request, userSession);

            if (amount > 0) {
                response.sendRedirect(request.getContextPath()
                        + "/parent/profile?payment=success&amount=" + amount);
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/parent/profile?payment=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/parent/profile?payment=failed");
        }
    }

    // MoMo IPN cũng gọi POST
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}