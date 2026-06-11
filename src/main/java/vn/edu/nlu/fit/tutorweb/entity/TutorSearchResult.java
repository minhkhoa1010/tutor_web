package vn.edu.nlu.fit.tutorweb.entity;

public class TutorSearchResult {
    private long tutorId;
    private String fullName;
    private String avatarUrl;
    private String teachingSubject;
    private String teachingArea;
    private double ratingAverage;
    private long hourlyRate;
    private String qualification;

    // 1. BỔ SUNG: Thuộc tính hứng trạng thái phê duyệt từ Database
    private String verificationStatus;

    // CONSTRUCTOR MẶC ĐỊNH (Bắt buộc phải có để JDBI .mapToBean hoạt động ổn định)
    public TutorSearchResult() {
    }

    // Getters & Setters
    public long getTutorId()          { return tutorId; }
    public void setTutorId(long v)    { tutorId = v; }

    public String getFullName()           { return fullName; }
    public void setFullName(String v)     { fullName = v; }

    public String getAvatarUrl()          { return avatarUrl; }
    public void setAvatarUrl(String v)    { avatarUrl = v; }

    public String getTeachingSubject()        { return teachingSubject; }
    public void setTeachingSubject(String v)  { teachingSubject = v; }

    public String getTeachingArea()           { return teachingArea; }
    public void setTeachingArea(String v)     { teachingArea = v; }

    public double getRatingAverage()          { return ratingAverage; }
    public void setRatingAverage(double v)    { ratingAverage = v; }

    public long getHourlyRate()           { return hourlyRate; }
    public void setHourlyRate(long v)     { hourlyRate = v; }

    public String getQualification()          { return qualification; }
    public void setQualification(String v)    { qualification = v; }
    private String phone;


    // Getter & Setter cho phone
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }



    // 2. BỔ SUNG: Cặp hàm Getter/Setter viết đúng chuẩn CamelCase cho JSTL
    public String getVerificationStatus() {
        return verificationStatus;
    }

    public void setVerificationStatus(String verificationStatus) {
        this.verificationStatus = verificationStatus;
    }
}