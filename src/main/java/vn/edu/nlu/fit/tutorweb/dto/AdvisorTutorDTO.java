package vn.edu.nlu.fit.tutorweb.dto;

import java.util.ArrayList;
import java.util.List;

public class AdvisorTutorDTO {
    private long id;
    private String name;
    private String subjects;
    private String grades;
    private String experience;
    private int hourlyRate;
    private double rating;
    private String location;
    private String teachingMode;
    private List<String> availableSchedules = new ArrayList<>();

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getSubjects() { return subjects; }
    public void setSubjects(String subjects) { this.subjects = subjects; }

    public String getGrades() { return grades; }
    public void setGrades(String grades) { this.grades = grades; }

    public String getExperience() { return experience; }
    public void setExperience(String experience) { this.experience = experience; }

    public int getHourlyRate() { return hourlyRate; }
    public void setHourlyRate(int hourlyRate) { this.hourlyRate = hourlyRate; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getTeachingMode() { return teachingMode; }
    public void setTeachingMode(String teachingMode) { this.teachingMode = teachingMode; }

    public List<String> getAvailableSchedules() { return availableSchedules; }
    public void setAvailableSchedules(List<String> availableSchedules) {
        this.availableSchedules = availableSchedules != null ? availableSchedules : new ArrayList<>();
    }
}
