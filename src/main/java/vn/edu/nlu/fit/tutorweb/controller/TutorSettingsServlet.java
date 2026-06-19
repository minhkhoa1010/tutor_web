package vn.edu.nlu.fit.tutorweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.nlu.fit.tutorweb.dao.AdminDAO;
import vn.edu.nlu.fit.tutorweb.dao.TutorDAO;
import vn.edu.nlu.fit.tutorweb.dao.TutorRegistrationDAO;
import vn.edu.nlu.fit.tutorweb.dao.UserDAO;
import vn.edu.nlu.fit.tutorweb.dto.TutorProfile;
import vn.edu.nlu.fit.tutorweb.entity.UserSession;
import vn.edu.nlu.fit.tutorweb.service.TutorService;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebServlet("/tutor/settings")
public class TutorSettingsServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();
    private final TutorRegistrationDAO registrationDAO = new TutorRegistrationDAO();
    private final TutorDAO tutorDAO = new TutorDAO();
    private final UserDAO userDAO = new UserDAO();
    private final TutorService tutorService = new TutorService();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserSession userSession = (UserSession) session.getAttribute("clientUser");

        if (userSession == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        // Lấy thông tin tab hiện tại trên URL (?tab=profile, ?tab=fees, ?tab=schedule)
        String currentTab = request.getParameter("tab");
        if (currentTab == null || currentTab.isEmpty()) {
            currentTab = "profile";
        }

        // Lấy thông tin hồ sơ gia sư để render dữ liệu
        TutorProfile tutor = adminDAO.getTutorProfileByUserId(userSession.getId());
        request.setAttribute("tutor", tutor);


        // Nạp dữ liệu theo Tab
        if ("profile".equals(currentTab)) {
            request.setAttribute("allSubjects", userDAO.getAllSubjects());
            request.setAttribute("allGrades", userDAO.getAllGrades());
            request.setAttribute("allAreas", userDAO.getAllAreas());
        }
        else if ("schedule".equals(currentTab)) {
            // Nạp danh sách lịch cho tab schedule
            request.setAttribute("allSlots", tutorService.getAllSlots());
        }

        request.getRequestDispatcher("/views/tutor/settings.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        UserSession userSession = (UserSession) session.getAttribute("clientUser");

        if (userSession == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        String actionType = request.getParameter("actionType");
        String redirectTab = "profile";

        // Lấy tutorId (khóa chính bảng tutors) dựa vào userId đang đăng nhập
        Long tutorId = tutorDAO.getTutorIdByUserId(userSession.getId());
        if (tutorId == null) {
            session.setAttribute("msgError", "Không tìm thấy hồ sơ gia sư hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // =======================================================
        // TAB 1: CẬP NHẬT HỒ SƠ NĂNG LỰC (Thông tin Users & Tutors)
        // =======================================================
        if ("updateTutorInfo".equals(actionType)) {
            String fullname = request.getParameter("fullname");
            String phone = request.getParameter("phone");
            String school = request.getParameter("school");
            String major = request.getParameter("major");
            String qualification = request.getParameter("qualification");
            String experienceSummary = request.getParameter("experienceSummary");

            String[] subjects = request.getParameterValues("subjects");
            String[] grades = request.getParameterValues("grades");
            String[] areas = request.getParameterValues("areas");

            // Tận dụng hàm registrationDAO đã có sẵn để update thông tin cơ bản, học vấn và môn/lớp
            boolean success = registrationDAO.updateTutorSettings(
                    userSession.getId(), fullname, phone, school, major,
                    qualification, experienceSummary, subjects, grades, areas
            );

            if (success) {
                // Đồng bộ cập nhật lại Họ tên hiển thị trên Session
                userSession.setFullname(fullname);
                session.setAttribute("clientUser", userSession);
                session.setAttribute("msgSuccess", "Cập nhật hồ sơ năng lực thành công!");
            } else {
                session.setAttribute("msgError", "Cập nhật hồ sơ thất bại, hệ thống xảy ra sự cố.");
            }
            redirectTab = "profile";

            // =======================================================
            // TAB 2: CẬP NHẬT THIẾT LẬP HỌC PHÍ
            // =======================================================
        } else if ("updateTutorFees".equals(actionType)) {
            try {
                int hourlyRate = Integer.parseInt(request.getParameter("hourlyRate"));

                // Gọi hàm updateHourlyRate chuyên trách từ TutorDAO của ông
                tutorDAO.updateHourlyRate(tutorId, hourlyRate);

                session.setAttribute("msgSuccess", "Cập nhật mức học phí thành công!");
            } catch (NumberFormatException e) {
                session.setAttribute("msgError", "Số tiền học phí nhập vào không hợp lệ.");
            }
            redirectTab = "fees";

            // =======================================================
            // TAB 3: CẬP NHẬT LỊCH TRỐNG
            // =======================================================
        } else if ("updateTutorSchedule".equals(actionType)) {
                String[] selectedSchedules = request.getParameterValues("schedules");

                try {
                    // Service đã tích hợp logic chặn xóa nếu có Booking
                    tutorService.updateSchedule(tutorId, selectedSchedules);
                    session.setAttribute("msgSuccess", "Cập nhật lịch thành công!");
                } catch (RuntimeException e) {
                    // Bắt lỗi chặn (Blocking) từ DAO/Service ném lên
                    session.setAttribute("msgError", e.getMessage());
                } catch (Exception e) {
                    session.setAttribute("msgError", "Có lỗi xảy ra: " + e.getMessage());
                }

                redirectTab = "schedule"; // Chỉ set biến, để dưới cùng redirect 1 lần thôi
            }

            // Redirect duy nhất ở cuối hàm, đảm bảo không lỗi
            response.sendRedirect(request.getContextPath() + "/tutor/settings?tab=" + redirectTab);
        }
    }
