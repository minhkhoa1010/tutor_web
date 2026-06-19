package vn.edu.nlu.fit.tutorweb.dto;

import java.util.List;
import java.util.ArrayList;

public class TutorProfile {
    private final long id;
    private final String fullName;
    private final String gender;
    private final String degreeLevel;
    private final Integer minRate;
    private final Integer maxRate;
    private final String subjects;
    private final String grades;
    private final String provinceName;
    private final String districtName;
    private final String portraitUrl;
    private final List<String> degreeUrls;
    private final List<String> idCardUrls;
    private Integer hourlyRate;
    // BỔ SUNG THÊM 3 TRƯỜNG NÀY
    private final String birthDate;
    private final String school;
    private final String major;
    private String experienceSummary;

    public String getExperienceSummary() {
        return experienceSummary;
    }

    public void setExperienceSummary(String experienceSummary) {
        this.experienceSummary = experienceSummary;
    }
    private String availableSchedules;
    // Cập nhật lại Constructor đầy đủ tham số
    public TutorProfile(long id, String fullName, String gender, String degreeLevel,
                        Integer minRate, Integer maxRate, String subjects, String grades,
                        String provinceName, String districtName, String portraitUrl,
                        List<String> degreeUrls, List<String> idCardUrls, Integer hourlyRate,
                        String birthDate, String school, String major) { // Nhận thêm 3 tham số cuối
        this.id = id;
        this.fullName = fullName;
        this.gender = gender;
        this.degreeLevel = degreeLevel;
        this.minRate = minRate;
        this.maxRate = maxRate;
        this.subjects = subjects;
        this.grades = grades;
        this.provinceName = provinceName;
        this.districtName = districtName;
        this.portraitUrl = portraitUrl;
        this.degreeUrls = degreeUrls != null ? degreeUrls : new ArrayList<>();
        this.idCardUrls = idCardUrls != null ? idCardUrls : new ArrayList<>();
        this.hourlyRate = hourlyRate;

        // Gán giá trị
        this.birthDate = birthDate;
        this.school = school;
        this.major = major;
    }

    // --- Các hàm Getter cũ giữ nguyên ---
    public long getId() { return id; }
    public String getFullName() { return fullName; }
    public String getGender() { return gender; }
    public String getDegreeLevel() { return degreeLevel; }
    public Integer getMinRate() { return minRate; }
    public Integer getMaxRate() { return maxRate; }
    public String getSubjects() { return subjects; }
    public String getGrades() { return grades; }
    public String getProvinceName() { return provinceName; }
    public String getDistrictName() { return districtName; }
    public String getPortraitUrl() { return portraitUrl; }
    public List<String> getDegreeUrls() { return degreeUrls; }
    public List<String> getIdCardUrls() { return idCardUrls; }

    // BỔ SUNG 3 GETTER MỚI (Bắt buộc phải viết đúng dạng CamelCase)
    public String getBirthDate() { return birthDate; }
    public String getSchool() { return school; }
    public String getMajor() { return major; }
    // 2. Thêm phương thức Getter
    public Integer getHourlyRate() {
        return hourlyRate;
    }

    // 3. Thêm Setter (nếu cần cập nhật từ Servlet)
    public void setHourlyRate(Integer hourlyRate) {
        this.hourlyRate = hourlyRate;
    }
    // --- Các hàm Label Helper ---
    public String getGenderLabel() {
        if (gender == null) return "Chưa cập nhật";
        return switch (gender) {
            case "MALE" -> "Nam";
            case "FEMALE" -> "Nữ";
            default -> "Khác";
        };
    }

    public String getRateLabel() {
        if (minRate == null && maxRate == null) return "Đang cập nhật";
        if (minRate != null && maxRate != null) {
            return String.format("%,d - %,d VNĐ/buổi", minRate, maxRate);
        }
        if (minRate != null) {
            return String.format("Từ %,d VNĐ/buổi", minRate);
        }
        return String.format("Đến %,d VNĐ/buổi", maxRate);
    }

    public String getAreaLabel() {
        if (districtName != null && provinceName != null) {
            return districtName + ", " + provinceName;
        }
        if (provinceName != null) return provinceName;
        return "Khu vực đang cập nhật";
    }

    public String getSubjectsLabel() {
        if (subjects == null || subjects.isBlank()) return "Chưa cập nhật môn";
        return subjects;
    }
    public String getAvailableSchedules() {
        return availableSchedules;
    }

    public void setAvailableSchedules(String availableSchedules) {
        this.availableSchedules = availableSchedules;
    }
}