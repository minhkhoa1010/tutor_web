package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.nlu.fit.tutorweb.dao.BookingDAO;
import vn.edu.nlu.fit.tutorweb.dao.ReviewDAO;
import vn.edu.nlu.fit.tutorweb.dao.TutorDAO;
import vn.edu.nlu.fit.tutorweb.dao.UserDAO;
import vn.edu.nlu.fit.tutorweb.dto.Cart;
import vn.edu.nlu.fit.tutorweb.dto.TutorProfile;
import vn.edu.nlu.fit.tutorweb.entity.Booking;
import vn.edu.nlu.fit.tutorweb.entity.UserSession;
import vn.edu.nlu.fit.tutorweb.service.SavedTutorService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/tutor/tutor-detail")
public class TutorDetailServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final TutorDAO tutorDAO = new TutorDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();
    private final SavedTutorService savedTutorService = new SavedTutorService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");

        if (idParam == null || idParam.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        try {
            long tutorId = Long.parseLong(idParam.trim());

            // =========================
            // Lấy thông tin gia sư
            // =========================
            TutorProfile tutor = tutorDAO.getTutorDetailForClient(tutorId);

            if (tutor == null) {
                resp.sendRedirect(req.getContextPath() + "/home");
                return;
            }

            // =========================
            // Lấy phone + email gia sư
            // =========================
            String tutorPhone = "";
            String tutorEmail = "";

            Long tutorUserId = tutorDAO.getUserIdByTutorId(tutorId);

            if (tutorUserId != null) {
                tutorPhone = userDAO.getPhoneByUserId(tutorUserId);
                tutorEmail = userDAO.getEmailByUserId(tutorUserId);
            }

            req.setAttribute("tutorPhone", tutorPhone);
            req.setAttribute("tutorEmail", tutorEmail);

            // =========================
            // Lịch bận của gia sư
            // =========================
            BookingDAO bookingDAO = new BookingDAO();

            List<String> allBusyDays = bookingDAO.getBusySchedules(tutorId);
            List<String> myBookedDays = new ArrayList<>();

            // =========================
            // Lấy user đăng nhập
            // =========================
            HttpSession session = req.getSession(false);

            UserSession user =
                    (session != null)
                            ? (UserSession) session.getAttribute("clientUser")
                            : null;

            // =========================
            // Đánh dấu lịch đã thuê
            // =========================
            if (user != null) {

                List<Booking> myBookings =
                        bookingDAO.getHiredTutorsByParentId(user.getId());

                for (Booking b : myBookings) {

                    if (b.getTutorId() == tutorId) {

                        if (b.getSchedule() != null) {

                            String[] days = b.getSchedule().split(",");

                            for (String d : days) {
                                myBookedDays.add(d.trim());
                            }
                        }
                    }
                }
            }

            // =========================
            // Đẩy dữ liệu sang JSP
            // =========================
            req.setAttribute("allBusyDays", allBusyDays);
            req.setAttribute("myBookedDays", myBookedDays);
            req.setAttribute("tutor", tutor);
            req.setAttribute("reviews",
                    tutorDAO.getReviewsByTutorId(tutorId));

            // =========================
            // Chức năng dành cho phụ huynh
            // =========================
            if (user != null && user.hasRole("USER")) {

                req.setAttribute(
                        "savedTutorIds",
                        savedTutorService.getSavedTutorIdsByParentId(user.getId())
                );

                Cart cart = (Cart) session.getAttribute("cart");

                req.setAttribute(
                        "cartTutorIds",
                        cart != null
                                ? cart.getTutorIds()
                                : new ArrayList<>()
                );

                Long bookingId =
                        reviewDAO.getCompletedBookingId(
                                user.getId(),
                                tutorId
                        );

                req.setAttribute("canReview", bookingId != null);
                req.setAttribute("bookingId", bookingId);

                if (bookingId != null) {
                    req.setAttribute(
                            "myReview",
                            reviewDAO.findByBookingId(bookingId)
                    );
                }
            }

            req.getRequestDispatcher("/views/tutor/tutor-detail.jsp")
                    .forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/home");
        }
    }
}