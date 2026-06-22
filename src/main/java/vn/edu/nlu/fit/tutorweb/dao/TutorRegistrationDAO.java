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
            long hourlyRate, String[] schedulesArray) {

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

                // 1. Lấy danh sách Môn học (Checkbox) kết hợp thành chuỗi "Toán, Lý, Hóa"
                String subjects = request.getParameterValues("subjects") == null
                        ? ""
                        : String.join(", ", request.getParameterValues("subjects"));

                // 2. Lấy chuỗi Kinh nghiệm / Giới thiệu bản thân từ form
                String experienceSummary =
                        request.getParameter("experienceSummary");

                if (experienceSummary == null) {
                    experienceSummary = "";
                }

                // XỬ LÝ KHỐI LỚP DẠY
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
                        .bind("experience", experienceSummary)
                        .bind("subjects", subjects)
                        .bind("grades", grades)
                        .bind("rate", hourlyRate)
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

                // =========================================================================
                // 🌟 🌟 🌟 BỔ SUNG KHỐI LƯU LỊCH RẢNH (TUTOR_SCHEDULES) KHI ĐĂNG KÝ MỚI
                // =========================================================================
                System.out.println(">>> STEP 5: INSERT TUTOR AVAILABLE SCHEDULES (NEW REGISTER)");
                if (schedulesArray != null && schedulesArray.length > 0) {
                    var batch = h.prepareBatch("INSERT INTO tutor_schedules(tutor_id, time_slot_id) VALUES(:tutorId, :slotId)");
                    for (String slotIdStr : schedulesArray) {
                        if (slotIdStr != null && !slotIdStr.isBlank()) {
                            int slotId = Integer.parseInt(slotIdStr.trim());
                            batch.bind("tutorId", tutorId) // Sử dụng chính xác mã gia sư vừa sinh ở Step 3
                                    .bind("slotId", slotId)
                                    .add();
                        }
                    }
                    batch.execute();
                    System.out.println(">>> Đã lưu đồng bộ lịch biểu rảnh thành công cho Gia sư mới!");
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
            // ƯU TIÊN 1: Lấy ngày sinh đã lọc sạch từ Controller gửi qua Attribute
            if (request.getAttribute("validatedBirthDate") != null) {
                return (Date) request.getAttribute("validatedBirthDate");
            }

            // ƯU TIÊN 2: Đọc trực tiếp nếu form gửi dạng input type="date"
            String birthDateStr = request.getParameter("birthDate");
            if (birthDateStr != null && !birthDateStr.isBlank()) {
                return Date.valueOf(birthDateStr);
            }

            // ƯU TIÊN 3: Ghép dữ liệu từ 3 hộp chọn selectbox cũ nếu có
            String year = request.getParameter("birthYear");
            String month = request.getParameter("birthMonth");
            String day = request.getParameter("birthDay");

            if (year == null || month == null || day == null || year.isBlank() || month.isBlank() || day.isBlank()) {
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
            long hourlyRate, String[] schedulesArray) {
        try {
            return DBConnect.get().inTransaction(h -> {
                System.out.println(">>> STEP 1: UPDATE USERS (FULLNAME & AVATAR)");

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

                h.createUpdate("""
                UPDATE tutors
                SET 
                    qualification       = :qualification,
                    experience_summary  = :experience,
                    teaching_subject    = :subjects,
                    teaching_grade      = :grades,
                    hourly_rate         = :rate,
                    gender              = :gender,
                    birth_date          = :birthDate,
                    school              = :school,
                    major               = :major,
                    teaching_area       = :teachingArea,
                    verification_status = 'PENDING'
                WHERE id = :tutorId AND user_id = :userId
            """)
                        .bind("userId", userId)
                        .bind("tutorId", tutorId)
                        .bind("qualification", request.getParameter("qualification"))
                        .bind("experience", request.getParameter("experienceSummary"))
                        .bind("subjects", subjects)
                        .bind("grades", grades)
                        .bind("rate", hourlyRate)
                        .bind("gender", request.getParameter("gender"))
                        .bind("birthDate", buildBirthDate(request))
                        .bind("school", request.getParameter("school"))
                        .bind("major", request.getParameter("major"))
                        .bind("teachingArea", areas)
                        .execute();

                System.out.println(">>> STEP 3: UPDATE NEW LEGAL DOCUMENTS IF ANY");

                if (newDegreeDocs != null && !newDegreeDocs.isEmpty()) {
                    h.createUpdate("DELETE FROM tutor_documents WHERE tutor_id = :tutorId AND doc_type = 'DEGREE'")
                            .bind("tutorId", tutorId).execute();
                    for (String url : newDegreeDocs) {
                        h.createUpdate("INSERT INTO tutor_documents(tutor_id, doc_type, file_url, status) VALUES(:tutorId, 'DEGREE', :url, 'PENDING')")
                                .bind("tutorId", tutorId).bind("url", url).execute();
                    }
                }

                if (newIdDocs != null && !newIdDocs.isEmpty()) {
                    h.createUpdate("DELETE FROM tutor_documents WHERE tutor_id = :tutorId AND doc_type LIKE 'ID_CARD%'")
                            .bind("tutorId", tutorId).execute();
                    for (int i = 0; i < newIdDocs.size(); i++) {
                        String docType = (i == 0) ? "ID_CARD_FRONT" : "ID_CARD_BACK";
                        h.createUpdate("INSERT INTO tutor_documents(tutor_id, doc_type, file_url, status) VALUES(:tutorId, :docType, :url, 'PENDING')")
                                .bind("tutorId", tutorId).bind("docType", docType).bind("url", newIdDocs.get(i)).execute();
                    }
                }

                System.out.println(">>> STEP 4: UPDATE TUTOR AVAILABLE SCHEDULES");

                h.createUpdate("DELETE FROM tutor_schedules WHERE tutor_id = :tutorId")
                        .bind("tutorId", tutorId)
                        .execute();

                if (schedulesArray != null && schedulesArray.length > 0) {
                    var batch = h.prepareBatch("INSERT INTO tutor_schedules(tutor_id, time_slot_id) VALUES(:tutorId, :slotId)");
                    for (String slotIdStr : schedulesArray) {
                        if (slotIdStr != null && !slotIdStr.isBlank()) {
                            int slotId = Integer.parseInt(slotIdStr.trim());
                            batch.bind("tutorId", tutorId)
                                    .bind("slotId", slotId)
                                    .add();
                        }
                    }
                    batch.execute();
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

    // =========================================================================
    // 🌟 FULL UPDATE: CẬP NHẬT CẢ THÔNG TIN CƠ BẢN (USERS) & NĂNG LỰC (TUTORS)
    // =========================================================================
    public boolean updateTutorSettings(
            long userId,
            String fullname,
            String phone,
            String school,
            String major,
            String qualification,
            String experienceSummary,
            String[] subjects,
            String[] grades,
            String[] areas) {

        try {
            return DBConnect.get().inTransaction(h -> {
                System.out.println(">>> [SETTINGS] BƯỚC 1: CẬP NHẬT BẢNG USERS (HỌ TÊN & SĐT)");

                // 1. Cập nhật thông tin tài khoản cơ bản
                h.createUpdate("""
                            UPDATE users 
                            SET fullname = :fullname, phone = :phone 
                            WHERE id = :userId
                        """)
                        .bind("fullname", fullname != null ? fullname.trim() : "")
                        .bind("phone", (phone != null && !phone.isBlank()) ? phone.trim() : null)
                        .bind("userId", userId)
                        .execute();

                System.out.println(">>> [SETTINGS] BƯỚC 2: CHUYỂN MẢNG CHECKBOX THÀNH CHUỖI GỘP");

                // Chuẩn hóa tránh lỗi NullPointerException khi gia sư bỏ tích sạch checkbox
                String subjectsStr = (subjects == null) ? "" : String.join(", ", subjects);
                String gradesStr   = (grades == null) ? "" : String.join(", ", grades);
                String areasStr    = (areas == null) ? "" : String.join(", ", areas);

                System.out.println(">>> [SETTINGS] BƯỚC 3: CẬP NHẬT BẢNG TUTORS (HỌC VẤN & PHẠM VI)");

                // 2. Cập nhật chi tiết năng lực gia sư
                h.createUpdate("""
                            UPDATE tutors
                            SET 
                                school             = :school,
                                major              = :major,
                                qualification      = :qualification,
                                experience_summary = :experience,
                                teaching_subject   = :subjects,
                                teaching_grade     = :grades,
                                teaching_area      = :areas
                            WHERE user_id = :userId
                        """)
                        .bind("school", school != null ? school.trim() : "")
                        .bind("major", major != null ? major.trim() : "")
                        .bind("qualification", qualification)
                        .bind("experience", experienceSummary != null ? experienceSummary.trim() : "")
                        .bind("subjects", subjectsStr)
                        .bind("grades", gradesStr)
                        .bind("areas", areasStr)
                        .bind("userId", userId)
                        .execute();

                System.out.println(">>> [SETTINGS] CẬP NHẬT ĐỒNG BỘ THÀNH CÔNG CHO USER ID = " + userId);
                return true;
            });
        } catch (Exception e) {
            System.err.println(">>> [SETTINGS] LỖI HỆ THỐNG KHI UPDATE SETTINGS");
            e.printStackTrace();
            return false;
        }
    }


}