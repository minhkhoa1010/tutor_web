package vn.edu.nlu.fit.tutorweb.dao;

import jakarta.servlet.http.HttpServletRequest;
import org.mindrot.jbcrypt.BCrypt;
import vn.edu.nlu.fit.tutorweb.db.DBConnect;

import java.sql.Date;
import java.util.List;

public class TutorRegistrationDAO {

    public boolean registerTutor(
            HttpServletRequest request,
            String avatarUrl,
            List<String> degreeDocs,
            List<String> idDocs,
            long hourlyRate) {

        try {
            return DBConnect.get().inTransaction(h -> {

                System.out.println(">>> STEP 1: INSERT USERS");

                String email = request.getParameter("email");
                String phone = request.getParameter("phone");

                // normalize tránh blank/null lỗi logic
                if (email != null && email.isBlank()) email = null;
                if (phone != null && phone.isBlank()) phone = null;

                String rawPassword = request.getParameter("password");
                if (rawPassword == null || rawPassword.isBlank()) {
                    throw new RuntimeException("Password is null/empty");
                }

                // FIX: check tồn tại đúng cách + tránh NULL phá query
                if (email != null || phone != null) {

                    Long existed = h.createQuery("""
                                        SELECT id FROM users
                                        WHERE (:phone IS NOT NULL AND phone = :phone)
                                           OR (:email IS NOT NULL AND email = :email)
                                        LIMIT 1
                                    """)
                            .bind("phone", phone)
                            .bind("email", email)
                            .mapTo(Long.class)
                            .findFirst()
                            .orElse(null);

                    if (existed != null) {
                        throw new RuntimeException("Phone hoặc email đã tồn tại");
                    }
                }

                String username = (email != null) ? email : phone;
                String passwordHash = BCrypt.hashpw(rawPassword, BCrypt.gensalt());

                Long userId = h.createUpdate("""
                                    INSERT INTO users(
                                        username,
                                        password,
                                        email,
                                        phone,
                                        fullname,
                                        avatar_url,
                                        is_active
                                    )
                                    VALUES(
                                        :username,
                                        :password,
                                        :email,
                                        :phone,
                                        :fullName,
                                        :avatar,
                                        1
                                    )
                                """)
                        .bind("username", username)
                        .bind("password", passwordHash)
                        .bind("email", email)
                        .bind("phone", phone)
                        .bind("fullName", request.getParameter("fullName"))
                        .bind("avatar", avatarUrl)
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(Long.class)
                        .one();

                System.out.println(">>> USER CREATED ID = " + userId);

                System.out.println(">>> STEP 2: INSERT ROLE");

                h.createUpdate("""
                                    INSERT INTO user_roles(user_id, role_id)
                                    SELECT :userId, id FROM roles WHERE name = 'TUTOR'
                                """)
                        .bind("userId", userId)
                        .execute();

                System.out.println(">>> STEP 3: INSERT TUTOR PROFILE");

                String subjects = request.getParameterValues("subjects") == null
                        ? ""
                        : String.join(", ", request.getParameterValues("subjects"));

                // XỬ LÝ KHỐI LỚP DẠY: Lấy mảng dữ liệu từ frontend và gộp thành chuỗi
                String[] gradesArray = request.getParameterValues("grades");
                String grades = (gradesArray == null) ? "" : String.join(", ", gradesArray);

                String areas = request.getParameterValues("areas") == null
                        ? ""
                        : String.join(", ", request.getParameterValues("areas"));

                Long tutorId = h.createUpdate("""
                                    INSERT INTO tutors(
                                        user_id,
                                        qualification,
                                        experience_summary,
                                        teaching_subject,
                                        teaching_grade,
                                        hourly_rate,
                                        id_card_number,
                                        verification_status,
                                        gender,
                                        birth_date,
                                        school,
                                        major,
                                        teaching_area
                                    )
                                    VALUES(
                                        :userId,
                                        :qualification,
                                        :experience,
                                        :subjects,
                                        :grades,
                                        :rate,
                                        :cccd,
                                        'PENDING',
                                        :gender,
                                        :birthDate,
                                        :school,
                                        :major,
                                        :teachingArea
                                    )
                                """)
                        .bind("userId", userId)
                        .bind("qualification", request.getParameter("qualification"))
                        .bind("experience", request.getParameter("strengths"))
                        .bind("subjects", subjects)
                        .bind("grades", grades) // Bind dữ liệu chuỗi lớp dạy vào đây
                        .bind("rate", hourlyRate) // Sửa từ số 0 cứng thành biến hourlyRate lấy từ form gửi lên
                        .bind("cccd", request.getParameter("citizenId"))
                        .bind("gender", request.getParameter("gender"))
                        .bind("birthDate", buildBirthDate(request))
                        .bind("school", request.getParameter("school"))
                        .bind("major", request.getParameter("major"))
                        .bind("teachingArea", areas)
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(Long.class)
                        .one();

                System.out.println(">>> TUTOR ID = " + tutorId);

                System.out.println(">>> STEP 4: INSERT DOCUMENTS");

                // avatar
                h.createUpdate("""
                                    INSERT INTO tutor_documents(
                                        tutor_id,
                                        doc_type,
                                        file_url,
                                        status
                                    )
                                    VALUES(
                                        :tutorId,
                                        'PORTRAIT',
                                        :url,
                                        'PENDING'
                                    )
                                """)
                        .bind("tutorId", tutorId)
                        .bind("url", avatarUrl)
                        .execute();

                // degree docs
                if (degreeDocs != null) {
                    for (String url : degreeDocs) {
                        h.createUpdate("""
                                            INSERT INTO tutor_documents(
                                                tutor_id,
                                                doc_type,
                                                file_url,
                                                status
                                            )
                                            VALUES(
                                                :tutorId,
                                                'DEGREE',
                                                :url,
                                                'PENDING'
                                            )
                                        """)
                                .bind("tutorId", tutorId)
                                .bind("url", url)
                                .execute();
                    }
                }

                // id docs
                if (idDocs != null) {
                    for (int i = 0; i < idDocs.size(); i++) {

                        String docType = (i == 0)
                                ? "ID_CARD_FRONT"
                                : "ID_CARD_BACK";

                        h.createUpdate("""
                                            INSERT INTO tutor_documents(
                                                tutor_id,
                                                doc_type,
                                                file_url,
                                                status
                                            )
                                            VALUES(
                                                :tutorId,
                                                :docType,
                                                :url,
                                                'PENDING'
                                            )
                                        """)
                                .bind("tutorId", tutorId)
                                .bind("docType", docType)
                                .bind("url", idDocs.get(i))
                                .execute();
                    }
                }

                System.out.println(">>> REGISTER TUTOR SUCCESS");
                return true;
            });

        } catch (Exception e) {
            System.err.println(">>> REGISTER TUTOR FAILED");
            e.printStackTrace();
            return false;
        }
    }

    private Date buildBirthDate(HttpServletRequest request) {
        try {
            String year = request.getParameter("birthYear");
            String month = request.getParameter("birthMonth");
            String day = request.getParameter("birthDay");

            if (year == null || month == null || day == null) {
                return null;
            }

            return Date.valueOf(year + "-" + month + "-" + day);

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    // CẬP NHẬT
    public boolean updateTutorProfile(
            long userId,
            long tutorId,
            HttpServletRequest request,
            String newAvatarUrl,
            List<String> newDegreeDocs,
            List<String> newIdDocs,
            long hourlyRate) {
        try {
            return DBConnect.get().inTransaction(h -> {
                System.out.println(">>> STEP 1: UPDATE USERS (FULLNAME & AVATAR)");

                // 1. Cập nhật Họ tên công khai và ảnh đại diện bảng users nếu có upload ảnh mới
                if (newAvatarUrl != null && !newAvatarUrl.isBlank()) {
                    h.createUpdate("""
                        UPDATE users 
                        SET fullname = :fullName, avatar_url = :avatar 
                        WHERE id = :userId
                    """)
                            .bind("fullName", request.getParameter("fullName"))
                            .bind("avatar", newAvatarUrl)
                            .bind("userId", userId)
                            .execute();

                    // FIX LỖI: Cập nhật luôn cả ảnh PORTRAIT trong bảng tutor_documents để đồng bộ màn chi tiết Admin
                    h.createUpdate("""
                        UPDATE tutor_documents 
                        SET file_url = :avatar, status = 'PENDING'
                        WHERE tutor_id = :tutorId AND doc_type = 'PORTRAIT'
                    """)
                            .bind("avatar", newAvatarUrl)
                            .bind("tutorId", tutorId)
                            .execute();
                } else {
                    h.createUpdate("""
                        UPDATE users SET fullname = :fullName WHERE id = :userId
                    """)
                            .bind("fullName", request.getParameter("fullName"))
                            .bind("userId", userId)
                            .execute();
                }

                System.out.println(">>> STEP 2: UPDATE TUTOR PROFILE & RESET TO PENDING");

                String subjects = request.getParameterValues("subjects") == null
                        ? ""
                        : String.join(", ", request.getParameterValues("subjects"));

                String[] gradesArray = request.getParameterValues("grades");
                String grades = (gradesArray == null) ? "" : String.join(", ", gradesArray);

                String areas = request.getParameterValues("areas") == null
                        ? ""
                        : String.join(", ", request.getParameterValues("areas"));

                // 2. Cập nhật thông tin chi tiết hồ sơ gia sư
                h.createUpdate("""
                    UPDATE tutors
                    SET 
                        qualification       = :qualification,
                        experience_summary  = :experience,
                        teaching_subject    = :subjects,
                        teaching_grade      = :grades,
                        hourly_rate         = :rate,
                        gender              = :gender,
                        school              = :school,
                        major               = :major,
                        teaching_area       = :teachingArea,
                        verification_status = 'PENDING' -- Tự động quay lại hàng chờ duyệt
                    WHERE id = :tutorId AND user_id = :userId
                """)
                        .bind("userId", userId)
                        .bind("tutorId", tutorId)
                        .bind("qualification", request.getParameter("qualification"))
                        .bind("experience", request.getParameter("strengths"))
                        .bind("subjects", subjects)
                        .bind("grades", grades)
                        .bind("rate", hourlyRate)
                        .bind("gender", request.getParameter("gender"))
                        .bind("school", request.getParameter("school"))
                        .bind("major", request.getParameter("major"))
                        .bind("teachingArea", areas)
                        .execute();

                System.out.println(">>> STEP 3: UPDATE NEW LEGAL DOCUMENTS IF ANY");

                // 3. Nếu gia sư bổ sung Bằng cấp mới, tiến hành xóa bản ghi DEGREE cũ và thêm mới
                if (newDegreeDocs != null && !newDegreeDocs.isEmpty()) {
                    h.createUpdate("DELETE FROM tutor_documents WHERE tutor_id = :tutorId AND doc_type = 'DEGREE'")
                            .bind("tutorId", tutorId).execute();
                    for (String url : newDegreeDocs) {
                        h.createUpdate("INSERT INTO tutor_documents(tutor_id, doc_type, file_url, status) VALUES(:tutorId, 'DEGREE', :url, 'PENDING')")
                                .bind("tutorId", tutorId).bind("url", url).execute();
                    }
                }

                // 4. Nếu gia sư bổ sung ảnh CCCD mới, tiến hành xóa bản ghi ID_CARD cũ và thêm mới
                if (newIdDocs != null && !newIdDocs.isEmpty()) {
                    h.createUpdate("DELETE FROM tutor_documents WHERE tutor_id = :tutorId AND doc_type LIKE 'ID_CARD%'")
                            .bind("tutorId", tutorId).execute();
                    for (int i = 0; i < newIdDocs.size(); i++) {
                        String docType = (i == 0) ? "ID_CARD_FRONT" : "ID_CARD_BACK";
                        h.createUpdate("INSERT INTO tutor_documents(tutor_id, doc_type, file_url, status) VALUES(:tutorId, :docType, :url, 'PENDING')")
                                .bind("tutorId", tutorId).bind("docType", docType).bind("url", newIdDocs.get(i)).execute();
                    }
                }

                System.out.println(">>> UPDATE PROFILE SUCCESS - STATUS RESET TO PENDING");
                return true;
            });
        } catch (Exception e) {
            System.err.println(">>> UPDATE TUTOR PROFILE FAILED");
            e.printStackTrace();
            return false;
        }

    }
}