package vn.edu.nlu.fit.tutorweb.entity;

public class TutorSearchResult {
    // 1. Khai báo đầy đủ các thuộc tính (Fields) tương thích với DB
    private long tutorId;
    private String fullName;
    private String avatarUrl;
    private String teachingSubject;
    private String teachingArea;
    private long hourlyRate;
    private double ratingAverage;
    private String qualification;
    private String verificationStatus;
    private String school;
    private String major;
    private String experienceSummary;
    private String teachingGrade;
    private String availableSchedules;

    // 2. Constructor mặc định bắt buộc phải có cho BeanMapper
    public TutorSearchResult() {}

    // 3. Toàn bộ các hàm Getter và Setter chuẩn hóa cho JDBI và JSTL
    public long getTutorId() { return tutorId; }
    public void setTutorId(long tutorId) { this.tutorId = tutorId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }

    public String getTeachingSubject() { return teachingSubject; }
    public void setTeachingSubject(String teachingSubject) { this.teachingSubject = teachingSubject; }

    public String getTeachingArea() { return teachingArea; }
    public void setTeachingArea(String teachingArea) { this.teachingArea = teachingArea; }

    public long getHourlyRate() { return hourlyRate; }
    public void setHourlyRate(long hourlyRate) { this.hourlyRate = hourlyRate; }

    public double getRatingAverage() { return ratingAverage; }
    public void setRatingAverage(double ratingAverage) { this.ratingAverage = ratingAverage; }

    public String getQualification() { return qualification; }
    public void setQualification(String qualification) { this.qualification = qualification; }

    public String getVerificationStatus() { return verificationStatus; }
    public void setVerificationStatus(String verificationStatus) { this.verificationStatus = verificationStatus; }

    public String getSchool() { return school; }
    public void setSchool(String school) { this.school = school; }

    public String getMajor() { return major; }
    public void setMajor(String major) { this.major = major; }

    public String getExperienceSummary() { return experienceSummary; }
    public void setExperienceSummary(String experienceSummary) { this.experienceSummary = experienceSummary; }

    public String getTeachingGrade() { return teachingGrade; }
    public void setTeachingGrade(String teachingGrade) { this.teachingGrade = teachingGrade; }

    // Thêm Getter và Setter chuẩn cho BeanMapper
    public String getAvailableSchedules() {
        return availableSchedules;
    }
    public void setAvailableSchedules(String availableSchedules) {
        this.availableSchedules = availableSchedules;
    }
}