package model;

import java.util.Date;

/**
 * StudentMark model class representing student examination records
 */
public class StudentMark {
    private int studentId;
    private String studentName;
    private String subject;
    private int marks;
    private Date examDate;
    
    // Default constructor
    public StudentMark() {
    }
    
    // Parameterized constructor
    public StudentMark(int studentId, String studentName, String subject, int marks, Date examDate) {
        this.studentId = studentId;
        this.studentName = studentName;
        this.subject = subject;
        this.marks = marks;
        this.examDate = examDate;
    }
    
    // Getters and Setters
    public int getStudentId() {
        return studentId;
    }
    
    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }
    
    public String getStudentName() {
        return studentName;
    }
    
    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }
    
    public String getSubject() {
        return subject;
    }
    
    public void setSubject(String subject) {
        this.subject = subject;
    }
    
    public int getMarks() {
        return marks;
    }
    
    public void setMarks(int marks) {
        this.marks = marks;
    }
    
    public Date getExamDate() {
        return examDate;
    }
    
    public void setExamDate(Date examDate) {
        this.examDate = examDate;
    }
    
    @Override
    public String toString() {
        return "StudentMark [studentId=" + studentId + ", studentName=" + studentName + ", subject=" + subject
                + ", marks=" + marks + ", examDate=" + examDate + "]";
    }
}