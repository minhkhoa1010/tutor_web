package vn.edu.nlu.fit.tutorweb.entity;

import java.sql.Timestamp;

public class SavedTutor {
    private long id;
    private long parentId;
    private long tutorId;
    private Timestamp savedAt;

    public SavedTutor() {}

    // Getter và Setter
    public long getId() { return id; }
    public void setId(long id) { this.id = id; }
    public long getParentId() { return parentId; }
    public void setParentId(long parentId) { this.parentId = parentId; }
    public long getTutorId() { return tutorId; }
    public void setTutorId(long tutorId) { this.tutorId = tutorId; }
    public java.sql.Timestamp getSavedAt() { return savedAt; }
    public void setSavedAt(Timestamp savedAt) { this.savedAt = savedAt; }
}