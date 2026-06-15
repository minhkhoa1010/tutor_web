package vn.edu.nlu.fit.tutorweb.entity;

public class Review {
    private long   id;
    private long   bookingId;
    private long   parentId;
    private long   tutorId;
    private int    rating;
    private String comment;
    private String createdAt;
    private String studentName;
    /** Môn học của gia sư — dùng cho testimonial trên trang chủ */
    private String teachingSubject;

    public Review() {}

    public long   getId()              { return id; }
    public void   setId(long id)       { this.id = id; }

    public long   getBookingId()             { return bookingId; }
    public void   setBookingId(long bookingId){ this.bookingId = bookingId; }

    public long   getParentId()              { return parentId; }
    public void   setParentId(long parentId) { this.parentId = parentId; }

    public long   getTutorId()               { return tutorId; }
    public void   setTutorId(long tutorId)   { this.tutorId = tutorId; }

    public int    getRating()                { return rating; }
    public void   setRating(int rating)      { this.rating = rating; }

    public String getComment()               { return comment; }
    public void   setComment(String c)       { this.comment = c; }

    public String getCreatedAt()             { return createdAt; }
    public void   setCreatedAt(String s)     { this.createdAt = s; }

    public String getStudentName()           { return studentName; }
    public void   setStudentName(String s)   { this.studentName = s; }

    public String getTeachingSubject()           { return teachingSubject; }
    public void   setTeachingSubject(String s)   { this.teachingSubject = s; }
}