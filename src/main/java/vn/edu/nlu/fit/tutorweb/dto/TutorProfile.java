package vn.edu.nlu.fit.tutorweb.entity;

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

    // BỔ SUNG: 3 trường lưu tài liệu phục vụ trang chi tiết duyệt hồ sơ
    private final String portraitUrl;
    private final List<String> degreeUrls;
    private final List<String> idCardUrls;

    // Cập nhật lại Constructor
    public TutorProfile(long id, String fullName, String gender, String degreeLevel,
                        Integer minRate, Integer maxRate, String subjects, String grades,
                        String provinceName, String districtName,
                        String portraitUrl, List<String> degreeUrls, List<String> idCardUrls) {
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
    }

    // ... Giữ nguyên các hàm getter cũ của bạn ...

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

    // BỔ SUNG: Getter cho 3 trường ảnh mới
    public String getPortraitUrl() { return portraitUrl; }
    public List<String> getDegreeUrls() { return degreeUrls; }
    public List<String> getIdCardUrls() { return idCardUrls; }

    // ... Giữ nguyên các hàm helper Label cực tiện của bạn ...
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
}