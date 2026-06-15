package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.nlu.fit.tutorweb.dao.ReviewDAO;
import vn.edu.nlu.fit.tutorweb.dao.TutorDAO;
import vn.edu.nlu.fit.tutorweb.dto.TutorProfile;
import vn.edu.nlu.fit.tutorweb.entity.Review;
import vn.edu.nlu.fit.tutorweb.entity.UserSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/tutor/tutor-detail")
public class TutorDetailServlet extends HttpServlet {


    private final TutorDAO tutorDAO = new TutorDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");

        if (idParam == null || idParam.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        try {

            long tutorId = Long.parseLong(idParam.trim());

            TutorProfile tutor =
                    TutorDAO.getTutorDetailForClient(tutorId);

            if (tutor == null) {
                resp.sendRedirect(req.getContextPath() + "/home");
                return;
            }

            List<Review> reviews =
                    tutorDAO.getReviewsByTutorId(tutorId);

            req.setAttribute("tutor", tutor);
            req.setAttribute("reviews", reviews);

            HttpSession session = req.getSession(false);

            if (session != null) {

                UserSession user =
                        (UserSession) session.getAttribute("clientUser");

                if (user != null) {

                    Long bookingId =
                            reviewDAO.getCompletedBookingId(
                                    user.getId(),
                                    tutorId
                            );

                    boolean canReview =
                            bookingId != null;

                    req.setAttribute(
                            "canReview",
                            canReview
                    );

                    req.setAttribute(
                            "bookingId",
                            bookingId
                    );

                    if (bookingId != null) {

                        Review myReview =
                                reviewDAO.findByBookingId(
                                        bookingId
                                );

                        req.setAttribute(
                                "myReview",
                                myReview
                        );
                    }
                }
            }

            req.getRequestDispatcher(
                    "/views/tutor/tutor-detail.jsp"
            ).forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/home");
        }
    }

}
