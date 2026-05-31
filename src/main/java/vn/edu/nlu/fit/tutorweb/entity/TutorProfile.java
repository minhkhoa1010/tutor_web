package vn.edu.nlu.fit.tutorweb.entity;

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

    public TutorProfile(long id, String fullName, String gender, String degreeLevel,
                        Integer minRate, Integer maxRate, String subjects, String grades,
                        String provinceName, String districtName) {
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
    }

    public long getId() {
        return id;
    }

    public String getFullName() {
        return fullName;
    }

    public String getGender() {
        return gender;
    }

    public String getDegreeLevel() {
        return degreeLevel;
    }

    public Integer getMinRate() {
        return minRate;
    }

    public Integer getMaxRate() {
        return maxRate;
    }

    public String getSubjects() {
        return subjects;
    }

    public String getGrades() {
        return grades;
    }

    public String getProvinceName() {
        return provinceName;
    }

    public String getDistrictName() {
        return districtName;
    }

    public String getGenderLabel() {
        if (gender == null) return "Chua cap nhat";
        return switch (gender) {
            case "MALE" -> "Nam";
            case "FEMALE" -> "Nu";
            default -> "Khac";
        };
    }

    public String getRateLabel() {
        if (minRate == null && maxRate == null) return "Hoc phi: Dang cap nhat";
        if (minRate != null && maxRate != null) {
            return String.format("%d - %d vnd/buoi", minRate, maxRate);
        }
        if (minRate != null) {
            return String.format("Tu %d vnd/buoi", minRate);
        }
        return String.format("Den %d vnd/buoi", maxRate);
    }

    public String getAreaLabel() {
        if (districtName != null && provinceName != null) {
            return districtName + ", " + provinceName;
        }
        if (provinceName != null) return provinceName;
        return "Khu vuc dang cap nhat";
    }

    public String getSubjectsLabel() {
        if (subjects == null || subjects.isBlank()) return "Chua cap nhat mon";
        return subjects;
    }
}
