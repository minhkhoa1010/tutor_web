package vn.edu.nlu.fit.tutorweb.controller;

import vn.edu.nlu.fit.tutorweb.dao.BookingDAO;
import vn.edu.nlu.fit.tutorweb.entity.Booking;
import vn.edu.nlu.fit.tutorweb.entity.UserSession;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/parent/hired")
public class ParentHiredServlet extends HttpServlet {

    // Sử dụng BookingDAO để lấy danh sách
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserSession user = (UserSession) session.getAttribute("clientUser");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // --- DEBUG ---
        System.out.println("DEBUG: Dang lay booking cho parentId: " + user.getId());

        List<Booking> hiredTutors = bookingDAO.getHiredTutorsByParentId(user.getId());

        if (hiredTutors != null) {
            System.out.println("DEBUG: So luong booking tim thay: " + hiredTutors.size());
            for (Booking b : hiredTutors) {
                System.out.println("DEBUG: Booking ID: " + b.getId() + " - TutorName: " + b.getTutorName());
            }
        } else {
            System.out.println("DEBUG: List tra ve bi NULL!");
        }
        // -------------

        request.setAttribute("hiredTutors", hiredTutors);
        request.getRequestDispatcher("/views/parent/hired-tutors.jsp").forward(request, response);
    }
}