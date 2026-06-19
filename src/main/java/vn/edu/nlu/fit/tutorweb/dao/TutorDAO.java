package vn.edu.nlu.fit.tutorweb.dao;

import vn.edu.nlu.fit.tutorweb.db.DBConnect;
import vn.edu.nlu.fit.tutorweb.dto.TutorProfile;
import vn.edu.nlu.fit.tutorweb.entity.Booking;
import vn.edu.nlu.fit.tutorweb.entity.Review;
import vn.edu.nlu.fit.tutorweb.entity.TutorSearchResult;

import java.util.*;
import java.util.stream.Collectors;

public class TutorDAO {

    /**
     * Lấy chi tiết hồ sơ gia sư cho Client xem
     */
    public static TutorProfile getTutorDetailForClient(long tutorId) {
        return DBConnect.get().withHandle(h ->
                h.createQuery("""
    SELECT
        t.id AS id,
        u.fullname AS fullName,
        t.gender AS gender,
        t.qualification AS degreeLevel,
        t.hourly_rate AS hourlyRate,
        t.hourly_rate AS minRate,
        t.teaching_subject AS subjects,
        t.teaching_grade AS grades,
        t.teaching_area AS districtName,
        t.experience_summary AS experienceSummary,
        u.avatar_url AS portraitUrl,
        t.birth_date AS birthDate,
        t.school AS school,
        t.major AS major,
        (SELECT GROUP_CONCAT(ts.slot_name SEPARATOR ', ')
         FROM tutor_schedules tsch
         JOIN time_slots ts ON tsch.time_slot_id = ts.id
         WHERE tsch.tutor_id = t.id) AS availableSchedules
    FROM tutors t
    JOIN users u ON t.user_id = u.id
    WHERE t.id = :id
""")
                        .bind("id", tutorId)
                        .map((rs, ctx) -> {
                            TutorProfile profile = new TutorProfile(
                                    rs.getLong("id"),
                                    rs.getString("fullName"),
                                    rs.getString("gender"),
                                    rs.getString("degreeLevel"),

                                    rs.getObject("minRate") != null ? rs.getInt("minRate") : null,
                                    null,
                                    rs.getString("subjects"),
                                    rs.getString("grades"),
                                    null,
                                    rs.getString("districtName"),
                                    rs.getString("portraitUrl"),
                                    new ArrayList<>(),
                                    new ArrayList<>(),
                                    rs.getObject("hourlyRate") != null ? rs.getInt("hourlyRate") : 0, // SỬA: Lấy hourlyRate từ SQL
                                    rs.getString("birthDate"),
                                    rs.getString("school"),
                                    rs.getString("major")
                            );

                            profile.setExperienceSummary(rs.getString("experienceSummary"));
                            profile.setAvailableSchedules(rs.getString("availableSchedules"));

                            return profile;
                        })
                        .findOne()
                        .orElse(null)
        );
    }
    public Long getUserIdByTutorId(long tutorId) {
        String sql = """
        SELECT user_id
        FROM tutors
        WHERE id = :tutorId
    """;

        return DBConnect.get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("tutorId", tutorId)
                        .mapTo(Long.class)
                        .findOne()
                        .orElse(null)
        );
    }
    /**
     * Lấy danh sách gia sư tiêu biểu hiển thị ở Trang chủ
     */
    public List<TutorSearchResult> getFeaturedTutors(int limit) {
        return DBConnect.get().withHandle(h ->
                h.createQuery("""
        SELECT 
            t.id AS tutorId,
            u.fullname AS fullName,
            u.avatar_url AS avatarUrl,
            t.qualification AS qualification,
            t.school AS school,
            t.major AS major,
            t.teaching_subject AS teachingSubject,
            t.teaching_grade AS teachingGrade,
            t.teaching_area AS teachingArea,
            t.experience_summary AS experienceSummary,
            t.hourly_rate AS hourlyRate,
            t.rating_average AS ratingAverage,
            t.birth_date AS birthDate,
            (SELECT GROUP_CONCAT(ts.slot_name SEPARATOR ', ') 
             FROM tutor_schedules tsch
             JOIN time_slots ts ON tsch.time_slot_id = ts.id
             WHERE tsch.tutor_id = t.id) AS availableSchedules
        FROM tutors t
        JOIN users u ON t.user_id = u.id
     WHERE t.verification_status = 'APPROVED'
     AND t.rating_average > 0
     ORDER BY
         t.rating_average DESC,
         (
             SELECT COUNT(*)
             FROM reviews r
             JOIN bookings b ON r.booking_id = b.id
             WHERE b.tutor_id = t.id
         ) DESC,
         t.id DESC
     LIMIT :limit
    """)
                        .bind("limit", limit)
                        .mapToBean(TutorSearchResult.class)
                        .list()
        );
    }

    /**
     * Lấy toàn bộ danh sách phục vụ trang quản trị Admin
     */
    public List<TutorSearchResult> getAllTutorsForAdmin() {
        return DBConnect.get().withHandle(h ->
                h.createQuery("""
            SELECT
                t.id            AS tutorId,
                u.fullname      AS fullName,
                u.avatar_url    AS avatarUrl,
                t.teaching_subject AS teachingSubject,
                t.teaching_grade   AS teachingGrade,
                t.teaching_area    AS teachingArea,
                t.hourly_rate      AS hourlyRate,
                t.rating_average   AS ratingAverage,
                t.qualification    AS qualification,
                t.verification_status AS verificationStatus,
                t.school           AS school,
                t.major            AS major,
                t.experience_summary AS experienceSummary
            FROM tutors t
            JOIN users u ON t.user_id = u.id
            ORDER BY t.id DESC
        """)
                        .mapToBean(TutorSearchResult.class)
                        .list()
        );
    }

    /**
     * Lấy các lượt đánh giá dựa trên id gia sư
     */
    public List<Review> getReviewsByTutorId(long tutorId) {
        return DBConnect.get().withHandle(h ->
                h.createQuery("""
                SELECT r.id, u.fullname as studentName, r.rating, r.comment, r.created_at
                FROM reviews r
                JOIN bookings b ON r.booking_id = b.id
                JOIN users u ON b.parent_id = u.id
                WHERE b.tutor_id = :tutorId
                ORDER BY r.created_at DESC
            """)
                        .bind("tutorId", tutorId)
                        .mapToBean(Review.class)
                        .list()
        );
    }

    /**
     * Tách môn học ra từng item riêng
     * DB lưu dạng "Toán, Tiếng Việt" → tách thành ["Toán", "Tiếng Việt"]
     * Trả về danh sách unique, đã trim, đã sort
     */
    public List<String> getAllDistinctSubjects() {
        List<String> rawList = DBConnect.get().withHandle(h ->
                h.createQuery("SELECT DISTINCT teaching_subject FROM tutors WHERE teaching_subject IS NOT NULL AND teaching_subject != '' AND verification_status = 'APPROVED'")
                        .mapTo(String.class)
                        .list()
        );

        return rawList.stream()
                .flatMap(raw -> Arrays.stream(raw.split(",")))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .distinct()
                .sorted()
                .collect(Collectors.toList());
    }

    /**
     * Tách khu vực ra từng item riêng
     * DB lưu dạng "Quận 1, Quận 2, Hóc Môn" → tách thành ["Quận 1", "Quận 2", "Hóc Môn"]
     * Trả về danh sách unique, đã trim, đã sort
     */
    public List<String> getAllDistinctAreas() {
        List<String> rawList = DBConnect.get().withHandle(h ->
                h.createQuery("SELECT DISTINCT teaching_area FROM tutors WHERE teaching_area IS NOT NULL AND teaching_area != '' AND verification_status = 'APPROVED'")
                        .mapTo(String.class)
                        .list()
        );

        return rawList.stream()
                .flatMap(raw -> Arrays.stream(raw.split(",")))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .distinct()
                .sorted()
                .collect(Collectors.toList());
    }

    /**
     * HÀM TÌM KIẾM NÂNG CAO — ĐÃ TÍCH HỢP BỘ LỌC GIỚI TÍNH (GENDER) TRƠN TRU
     */
    public List<TutorSearchResult> searchAndFilterTutorsAdvanced(
            String keyword, String minRateStr, String maxRateStr, String district,
            String subject, String grade, String gender, String[] degreeLevels, String[] scheduleSlots, String sortBy) {

        return DBConnect.get().withHandle(h -> {
            StringBuilder sql = new StringBuilder("""
                SELECT 
                    t.id            AS tutorId,
                    u.fullname      AS fullName,
                    u.avatar_url    AS avatarUrl,
                    t.qualification AS qualification,
                    t.school        AS school,
                    t.major         AS major,
                    t.teaching_subject AS teachingSubject,
                    t.teaching_grade   AS teachingGrade,
                    t.teaching_area    AS teachingArea,
                    t.experience_summary AS experienceSummary,
                    t.hourly_rate      AS hourlyRate,
                    t.rating_average   AS ratingAverage,
                    t.birth_date       AS birthDate,
                    (SELECT GROUP_CONCAT(ts.slot_name SEPARATOR ', ') 
                     FROM tutor_schedules tsch
                     JOIN time_slots ts ON tsch.time_slot_id = ts.id
                     WHERE tsch.tutor_id = t.id) AS availableSchedules
                FROM tutors t
                JOIN users u ON t.user_id = u.id
                WHERE t.verification_status = 'APPROVED'
            """);

            // ĐIỀU KIỆN 1: TỪ KHÓA
            if (keyword != null && !keyword.trim().isEmpty()) {
                sql.append(" AND (u.fullname LIKE :keywordKey OR t.school LIKE :keywordKey OR t.major LIKE :keywordKey OR t.teaching_subject LIKE :keywordKey) ");
            }

            // ĐIỀU KIỆN 2: KHOẢNG GIÁ
            if (minRateStr != null && !minRateStr.trim().isEmpty()) {
                sql.append(" AND t.hourly_rate >= :minRate ");
            }
            if (maxRateStr != null && !maxRateStr.trim().isEmpty()) {
                sql.append(" AND t.hourly_rate <= :maxRate ");
            }

            // ĐIỀU KIỆN 3: MÔN HỌC
            if (subject != null && !subject.trim().isEmpty()) {
                sql.append(" AND FIND_IN_SET(:subject, REPLACE(t.teaching_subject, ', ', ',')) > 0 ");
            }

            // ĐIỀU KIỆN 4: KHU VỰC
            if (district != null && !district.trim().isEmpty()) {
                sql.append(" AND FIND_IN_SET(:district, REPLACE(t.teaching_area, ', ', ',')) > 0 ");
            }

            // ĐIỀU KIỆN 5: CẤP HỌC
            if (grade != null && !grade.trim().isEmpty()) {
                if ("Tiểu Học".equals(grade)) {
                    sql.append(" AND (t.teaching_grade LIKE '%Lớp 1%' OR t.teaching_grade LIKE '%Lớp 2%' OR t.teaching_grade LIKE '%Lớp 3%' OR t.teaching_grade LIKE '%Lớp 4%' OR t.teaching_grade LIKE '%Lớp 5%' OR t.teaching_grade LIKE '%Tiểu học%') ");
                } else if ("THCS".equals(grade)) {
                    sql.append(" AND (t.teaching_grade LIKE '%Lớp 6%' OR t.teaching_grade LIKE '%Lớp 7%' OR t.teaching_grade LIKE '%Lớp 8%' OR t.teaching_grade LIKE '%Lớp 9%' OR t.teaching_grade LIKE '%Cấp 2%' OR t.teaching_grade LIKE '%THCS%') ");
                } else if ("THPT".equals(grade)) {
                    sql.append(" AND (t.teaching_grade LIKE '%Lớp 10%' OR t.teaching_grade LIKE '%Lớp 11%' OR t.teaching_grade LIKE '%Lớp 12%' OR t.teaching_grade LIKE '%Cấp 3%' OR t.teaching_grade LIKE '%THPT%') ");
                } else {
                    sql.append(" AND t.teaching_grade LIKE :grade ");
                }
            }

            // ĐIỀU KIỆN THÊM MỚI: GIỚI TÍNH (Lọc theo trường t.gender)
            if (gender != null && !gender.trim().isEmpty()) {
                sql.append(" AND t.gender = :gender ");
            }

            // ĐIỀU KIỆN 6: TRÌNH ĐỘ CHUYÊN MÔN
            boolean hasDegrees = (degreeLevels != null && degreeLevels.length > 0);
            if (hasDegrees) {
                sql.append(" AND t.qualification IN (<degreeLevels>) ");
            }

            // ĐIỀU KIỆN 7: ĐA LỊCH HỌC
            boolean hasSchedules = (scheduleSlots != null && scheduleSlots.length > 0);
            if (hasSchedules) {
                sql.append(" AND ( ");
                for (int i = 0; i < scheduleSlots.length; i++) {
                    sql.append(" (SELECT COUNT(*) FROM tutor_schedules tsch2 JOIN time_slots ts2 ON tsch2.time_slot_id = ts2.id WHERE tsch2.tutor_id = t.id AND ts2.slot_name = :slot_").append(i).append(") > 0 ");
                    if (i < scheduleSlots.length - 1) sql.append(" OR ");
                }
                sql.append(" ) ");
            }

            // ĐIỀU KIỆN 8: SẮP XẾP
            if ("rate_asc".equals(sortBy) || "rateAsc".equals(sortBy)) {
                sql.append(" ORDER BY t.hourly_rate ASC ");
            } else if ("rate_desc".equals(sortBy) || "rateDesc".equals(sortBy)) {
                sql.append(" ORDER BY t.hourly_rate DESC ");
            } else {
                sql.append(" ORDER BY t.rating_average DESC, t.id DESC ");
            }

            var query = h.createQuery(sql.toString());

            if (keyword != null && !keyword.trim().isEmpty()) {
                query.bind("keywordKey", "%" + keyword.trim() + "%");
            }
            if (minRateStr != null && !minRateStr.trim().isEmpty()) {
                try { query.bind("minRate", Integer.parseInt(minRateStr.trim())); } catch (Exception ignored) {}
            }
            if (maxRateStr != null && !maxRateStr.trim().isEmpty()) {
                try { query.bind("maxRate", Integer.parseInt(maxRateStr.trim())); } catch (Exception ignored) {}
            }
            if (subject != null && !subject.trim().isEmpty()) {
                query.bind("subject", subject.trim());
            }
            if (district != null && !district.trim().isEmpty()) {
                query.bind("district", district.trim());
            }
            if (grade != null && !grade.trim().isEmpty() && !"Tiểu Học".equals(grade) && !"THCS".equals(grade) && !"THPT".equals(grade)) {
                query.bind("grade", "%" + grade.trim() + "%");
            }

            // Thực hiện bind dữ liệu giới tính an toàn
            if (gender != null && !gender.trim().isEmpty()) {
                query.bind("gender", gender.trim());
            }

            if (hasDegrees) {
                query.bindList("degreeLevels", Arrays.asList(degreeLevels));
            }
            if (hasSchedules) {
                for (int i = 0; i < scheduleSlots.length; i++) {
                    query.bind("slot_" + i, scheduleSlots[i]);
                }
            }

            return query.mapToBean(TutorSearchResult.class).list();
        });
    }

    public List<String> getAllDistinctGrades() {
        List<String> rawList = DBConnect.get().withHandle(h ->
                h.createQuery("""
                SELECT DISTINCT teaching_grade
                FROM tutors
                WHERE teaching_grade IS NOT NULL
                AND teaching_grade != ''
                AND verification_status = 'APPROVED'
            """)
                        .mapTo(String.class)
                        .list()
        );

        return rawList.stream()
                .flatMap(raw -> Arrays.stream(raw.split(",")))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .distinct()
                .sorted()
                .collect(Collectors.toList());
    }

    public List<String> getAllDistinctDegrees() {
        return DBConnect.get().withHandle(h ->
                h.createQuery("""
                SELECT DISTINCT qualification
                FROM tutors
                WHERE qualification IS NOT NULL
                AND qualification != ''
                AND verification_status = 'APPROVED'
                ORDER BY qualification
            """)
                        .mapTo(String.class)
                        .list()
        );
    }

    public List<String> getAllTimeSlots() {
        return DBConnect.get().withHandle(h ->
                h.createQuery("""
                SELECT slot_name
                FROM time_slots
                ORDER BY id
            """)
                        .mapTo(String.class)
                        .list()
        );
    }

    /**
     * 🌟 HÀM MỚI BỔ SUNG: Lấy thông tin tóm tắt của 1 gia sư theo ID phục vụ cho Giỏ hàng tạm thời
     */
    public TutorSearchResult getTutorSearchResultById(long tutorId) {
        return DBConnect.get().withHandle(h ->
                h.createQuery("""
                SELECT 
                    t.id            AS tutorId,
                    u.fullname      AS fullName,
                    u.avatar_url    AS avatarUrl,
                    t.qualification AS qualification,
                    t.school        AS school,
                    t.major         AS major,
                    t.teaching_subject AS teachingSubject,
                    t.teaching_grade   AS teachingGrade,
                    t.teaching_area    AS teachingArea,
                    t.experience_summary AS experienceSummary,
                    t.hourly_rate      AS hourlyRate,
                    t.rating_average   AS ratingAverage,
                    t.birth_date       AS birthDate,
                    (SELECT GROUP_CONCAT(ts.slot_name SEPARATOR ', ') 
                     FROM tutor_schedules tsch
                     JOIN time_slots ts ON tsch.time_slot_id = ts.id
                     WHERE tsch.tutor_id = t.id) AS availableSchedules
                FROM tutors t
                JOIN users u ON t.user_id = u.id
                WHERE t.id = :tutorId
            """)
                        .bind("tutorId", tutorId)
                        .mapToBean(TutorSearchResult.class)
                        .findOne()
                        .orElse(null)
        );
    }
    public List<Booking> getBookingsByParent(long parentId) {
        // Định nghĩa danh sách các trạng thái cần hiển thị
        List<String> validStatuses = List.of(
                "ACTIVE", "PAID", "PENDING_COMPLETED", "DISPUTED", "COMPLETED", "REFUNDED"
        );

        return DBConnect.get().withHandle(h ->
                h.createQuery("""
            SELECT * FROM bookings 
            WHERE parent_id = :parentId 
            AND status IN (<statuses>)
            ORDER BY created_at DESC
        """)
                        .bind("parentId", parentId)
                        .bindList("statuses", validStatuses) // JDBI sẽ tự động xử lý chuỗi IN ('...', '...')
                        .mapToBean(Booking.class)
                        .list()
        );
    }
    /**
     * Cập nhật thông tin cơ bản / Hồ sơ năng lực
     */
    public void updateTutorProfile(long tutorId, String school, String major, String experienceSummary) {
        DBConnect.get().withHandle(h ->
                h.createUpdate("""
                UPDATE tutors 
                SET school = :school, major = :major, experience_summary = :experienceSummary 
                WHERE id = :tutorId
            """)
                        .bind("tutorId", tutorId)
                        .bind("school", school)
                        .bind("major", major)
                        .bind("experienceSummary", experienceSummary)
                        .execute()
        );
    }

    /**
     * Cập nhật thiết lập học phí theo giờ
     */
    public void updateHourlyRate(long tutorId, int hourlyRate) {
        DBConnect.get().withHandle(h ->
                h.createUpdate("UPDATE tutors SET hourly_rate = :hourlyRate WHERE id = :tutorId")
                        .bind("tutorId", tutorId)
                        .bind("hourlyRate", hourlyRate)
                        .execute()
        );
    }

    /**
     * Cập nhật đa lịch học trống (Xóa hết lịch cũ của gia sư rồi chèn loạt lịch mới chọn vào)
     */
    public void updateTutorSchedules(long tutorId, List<String> newSlotNames) {
        DBConnect.get().useTransaction(handle -> {
            // 1. Kiểm tra: Chỉ chặn nếu khung giờ bị xóa NẰM TRONG chuỗi schedule của đơn hàng đang chạy
            boolean isBlocking = handle.createQuery("""
            SELECT COUNT(*) 
            FROM bookings b
            JOIN tutor_schedules ts ON b.tutor_id = ts.tutor_id
            JOIN time_slots slot ON ts.time_slot_id = slot.id
            WHERE b.tutor_id = :tutorId 
              AND b.status IN ('ACTIVE', 'PAID', 'PENDING_COMPLETED')
              AND slot.slot_name NOT IN (<newSlotNames>)
              AND FIND_IN_SET(slot.slot_name, REPLACE(b.schedule, ', ', ',')) > 0
        """)
                    .bind("tutorId", tutorId)
                    .bindList("newSlotNames", newSlotNames.isEmpty() ? List.of("") : newSlotNames)
                    .mapTo(Integer.class)
                    .one() > 0;

            if (isBlocking) {
                throw new RuntimeException("KHÔNG THỂ CẬP NHẬT: Khung giờ bạn muốn xóa hiện đang có lớp học diễn ra hoặc chờ xác nhận!");
            }

            // 2. Nếu hợp lệ, thực hiện xóa cũ - chèn mới
            handle.createUpdate("DELETE FROM tutor_schedules WHERE tutor_id = :tutorId")
                    .bind("tutorId", tutorId)
                    .execute();

            if (newSlotNames != null && !newSlotNames.isEmpty()) {
                var batch = handle.prepareBatch("""
                INSERT INTO tutor_schedules (tutor_id, time_slot_id) 
                VALUES (:tutorId, (SELECT id FROM time_slots WHERE slot_name = :slotName LIMIT 1))
            """);
                for (String name : newSlotNames) {
                    batch.bind("tutorId", tutorId).bind("slotName", name).add();
                }
                batch.execute();
            }
        });
    }
    /**
     * Lấy tutorId dựa vào userId từ session đăng nhập
     */
    public Long getTutorIdByUserId(long userId) {
        return DBConnect.get().withHandle(h ->
                h.createQuery("SELECT id FROM tutors WHERE user_id = :userId")
                        .bind("userId", userId)
                        .mapTo(Long.class)
                        .findOne()
                        .orElse(null)
        );
    }
}