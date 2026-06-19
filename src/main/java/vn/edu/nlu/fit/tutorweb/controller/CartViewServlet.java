package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/parent/cart")
public class CartViewServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Cart đã có trong session rồi — JSP đọc trực tiếp
        // Nếu chưa đăng nhập thì redirect login
        if (req.getSession().getAttribute("clientUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        req.getRequestDispatcher("/views/parent/cart.jsp").forward(req, resp);
    }
}