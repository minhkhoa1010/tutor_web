package vn.edu.nlu.fit.tutorweb.controller;

import vn.edu.nlu.fit.tutorweb.dao.TutorDAO;
import vn.edu.nlu.fit.tutorweb.entity.TutorSearchResult;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Arrays;

@WebServlet("/tutors")
public class TutorListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final TutorDAO tutorDAO = new TutorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        try {
            // 1. Thu thập dữ liệu từ Form bộ lọc URL (Đã bổ sung thêm gender)
            String keyword = request.getParameter("keyword");
            String minRateStr = request.getParameter("minRate");
            String maxRateStr = request.getParameter("maxRate");
            String district = request.getParameter("district");
            String subject = request.getParameter("subject");
            String grade = request.getParameter("grade");
            String sortBy = request.getParameter("sortBy");
            String gender = request.getParameter("gender"); // <-- ĐÃ THÊM

            String[] degreeLevels = request.getParameterValues("degreeLevel");
            String[] scheduleSlots = request.getParameterValues("scheduleSlot");

            // 2. Đồng bộ ngược trạng thái giữ nguyên giao diện người dùng
            request.setAttribute("selectedKeyword", keyword);
            request.setAttribute("selectedMinRate", minRateStr);
            request.setAttribute("selectedMaxRate", maxRateStr);
            request.setAttribute("selectedDistrict", district);
            request.setAttribute("selectedSubject", subject);
            request.setAttribute("selectedGrade", grade);
            request.setAttribute("selectedSortBy", sortBy);
            request.setAttribute("selectedGender", gender); // <-- GIỮ TRẠNG THÁI CHỌN GIỚI TÍNH

            if (degreeLevels != null) {
                request.setAttribute("selectedDegrees", Arrays.asList(degreeLevels));
            }
            if (scheduleSlots != null) {
                request.setAttribute("selectedSchedules", Arrays.asList(scheduleSlots));
            }

            // 3. Đổ dữ liệu động từ Database để hiển thị khớp 100% dữ liệu bộ lọc trên giao diện
            request.setAttribute("activeSubjects", tutorDAO.getAllDistinctSubjects());
            request.setAttribute("activeAreas", tutorDAO.getAllDistinctAreas());
            request.setAttribute("activeGrades", tutorDAO.getAllDistinctGrades());
            request.setAttribute("activeDegrees", tutorDAO.getAllDistinctDegrees());
            request.setAttribute("activeSchedules", tutorDAO.getAllTimeSlots());

            // 4. Gọi hàm DAO xử lý SQL Động (Đã truyền thêm tham số gender vào đúng vị trí cấu trúc)
            List<TutorSearchResult> list = tutorDAO.searchAndFilterTutorsAdvanced(
                    keyword,
                    minRateStr,
                    maxRateStr,
                    district,
                    subject,
                    grade,
                    gender, // <-- THAM SỐ GENDER ĐƯỢC CHÈN VÀO ĐÂY
                    degreeLevels,
                    scheduleSlots,
                    sortBy
            );

            // 5. Thiết lập metadata cho trang
            request.setAttribute("pageTitle", "Danh sách gia sư");
            request.setAttribute("pageCss", "/assets/css/list-tutor.css");

            request.setAttribute("tutors", list);
            request.getRequestDispatcher("/views/tutor/list-tutor.jsp").forward(request, response);

        } catch (Exception e) {
            response.setContentType("text/plain;charset=UTF-8");
            e.printStackTrace(response.getWriter());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}