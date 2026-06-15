package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.nlu.fit.tutorweb.dao.ReviewDAO;
import vn.edu.nlu.fit.tutorweb.entity.UserSession;

import java.io.IOException;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {


    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {

            long bookingId =
                    Long.parseLong(request.getParameter("bookingId"));

            int rating =
                    Integer.parseInt(request.getParameter("rating"));

            String comment =
                    request.getParameter("comment");

            if (rating < 1 || rating > 5) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }
            UserSession user =
                    (UserSession) request.getSession()
                            .getAttribute("clientUser");

            if (user == null) {
                response.sendRedirect(
                        request.getContextPath() + "/views/auth/login.jsp"
                );
                return;
            }

            if (!reviewDAO.isBookingOwner(
                    bookingId,
                    user.getId()
            )) {
                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN
                );
                return;
            }
            reviewDAO.saveOrUpdateReview(
                    bookingId,
                    rating,
                    comment
            );

            String referer = request.getHeader("Referer");

            if (referer != null) {
                response.sendRedirect(referer);
            } else {
                response.sendRedirect(
                        request.getContextPath() + "/tutors"
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR
            );
        }
    }


}
