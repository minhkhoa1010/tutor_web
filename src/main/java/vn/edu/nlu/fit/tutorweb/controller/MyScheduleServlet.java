package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import vn.edu.nlu.fit.tutorweb.entity.Booking;
import vn.edu.nlu.fit.tutorweb.entity.UserSession;
import vn.edu.nlu.fit.tutorweb.service.BookingService;

import java.io.IOException;
import java.util.List;

@WebServlet("/parent/my-schedule")
public class MyScheduleServlet extends HttpServlet {

    private final BookingService bookingService = new BookingService();

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if(session == null){
            resp.sendRedirect(req.getContextPath()+"/login");
            return;
        }

        UserSession user =
                (UserSession) session.getAttribute("clientUser");

        if(user == null){
            resp.sendRedirect(req.getContextPath()+"/login");
            return;
        }

        List<Booking> schedules =
                bookingService.getHiredTutors(user.getId());

        req.setAttribute("schedules", schedules);

        req.getRequestDispatcher("/views/parent/my-schedule.jsp")
                .forward(req, resp);
    }
}