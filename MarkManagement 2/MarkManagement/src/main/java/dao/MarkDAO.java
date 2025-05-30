package dao;

import java.sql.*;
import java.util.*;
import model.StudentMark;

/**
 * Data Access Object for performing CRUD operations on StudentMarks table
 */
public class MarkDAO {
    private Connection connection;
    
    /**
     * Constructor - initializes database connection
     */
    public MarkDAO() {
        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Establish connection to the database
            connection = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/mark_management", "root", "");
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Add a new student mark record
     * @param studentMark The student mark to add
     * @return true if successful, false otherwise
     */
    public boolean addStudentMark(StudentMark studentMark) {
        String sql = "INSERT INTO StudentMarks (StudentID, StudentName, Subject, Marks, ExamDate) VALUES (?, ?, ?, ?, ?)";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, studentMark.getStudentId());
            pstmt.setString(2, studentMark.getStudentName());
            pstmt.setString(3, studentMark.getSubject());
            pstmt.setInt(4, studentMark.getMarks());
            pstmt.setDate(5, new java.sql.Date(studentMark.getExamDate().getTime()));
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update an existing student mark record
     * @param studentMark The student mark to update
     * @return true if successful, false otherwise
     */
    public boolean updateStudentMark(StudentMark studentMark) {
        String sql = "UPDATE StudentMarks SET StudentName = ?, Subject = ?, Marks = ?, ExamDate = ? WHERE StudentID = ?";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, studentMark.getStudentName());
            pstmt.setString(2, studentMark.getSubject());
            pstmt.setInt(3, studentMark.getMarks());
            pstmt.setDate(4, new java.sql.Date(studentMark.getExamDate().getTime()));
            pstmt.setInt(5, studentMark.getStudentId());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete a student mark record
     * @param studentId The ID of the student mark to delete
     * @return true if successful, false otherwise
     */
    public boolean deleteStudentMark(int studentId) {
        String sql = "DELETE FROM StudentMarks WHERE StudentID = ?";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, studentId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get a student mark by ID
     * @param studentId The ID of the student
     * @return The student mark or null if not found
     */
    public StudentMark getStudentMarkById(int studentId) {
        String sql = "SELECT * FROM StudentMarks WHERE StudentID = ?";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, studentId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    StudentMark mark = new StudentMark();
                    mark.setStudentId(rs.getInt("StudentID"));
                    mark.setStudentName(rs.getString("StudentName"));
                    mark.setSubject(rs.getString("Subject"));
                    mark.setMarks(rs.getInt("Marks"));
                    mark.setExamDate(rs.getDate("ExamDate"));
                    return mark;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get all student marks
     * @return List of all student marks
     */
    public List<StudentMark> getAllStudentMarks() {
        List<StudentMark> marksList = new ArrayList<>();
        String sql = "SELECT * FROM StudentMarks";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                StudentMark mark = new StudentMark();
                mark.setStudentId(rs.getInt("StudentID"));
                mark.setStudentName(rs.getString("StudentName"));
                mark.setSubject(rs.getString("Subject"));
                mark.setMarks(rs.getInt("Marks"));
                mark.setExamDate(rs.getDate("ExamDate"));
                marksList.add(mark);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return marksList;
    }
    
    /**
     * Get students with marks above a specified threshold
     * @param threshold The minimum mark threshold
     * @return List of student marks above the threshold
     */
    public List<StudentMark> getStudentsAboveThreshold(int threshold) {
        List<StudentMark> marksList = new ArrayList<>();
        String sql = "SELECT * FROM StudentMarks WHERE Marks >= ?";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, threshold);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    StudentMark mark = new StudentMark();
                    mark.setStudentId(rs.getInt("StudentID"));
                    mark.setStudentName(rs.getString("StudentName"));
                    mark.setSubject(rs.getString("Subject"));
                    mark.setMarks(rs.getInt("Marks"));
                    mark.setExamDate(rs.getDate("ExamDate"));
                    marksList.add(mark);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return marksList;
    }
    
    /**
     * Get students who scored in a specific subject
     * @param subject The subject to filter by
     * @return List of student marks for the specified subject
     */
    public List<StudentMark> getStudentsBySubject(String subject) {
        List<StudentMark> marksList = new ArrayList<>();
        String sql = "SELECT * FROM StudentMarks WHERE Subject = ?";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, subject);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    StudentMark mark = new StudentMark();
                    mark.setStudentId(rs.getInt("StudentID"));
                    mark.setStudentName(rs.getString("StudentName"));
                    mark.setSubject(rs.getString("Subject"));
                    mark.setMarks(rs.getInt("Marks"));
                    mark.setExamDate(rs.getDate("ExamDate"));
                    marksList.add(mark);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return marksList;
    }
    
    /**
     * Get top N students based on marks
     * @param n The number of top students to retrieve
     * @return List of top N student marks
     */
    public List<StudentMark> getTopStudents(int n) {
        List<StudentMark> marksList = new ArrayList<>();
        String sql = "SELECT * FROM StudentMarks ORDER BY Marks DESC LIMIT ?";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, n);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    StudentMark mark = new StudentMark();
                    mark.setStudentId(rs.getInt("StudentID"));
                    mark.setStudentName(rs.getString("StudentName"));
                    mark.setSubject(rs.getString("Subject"));
                    mark.setMarks(rs.getInt("Marks"));
                    mark.setExamDate(rs.getDate("ExamDate"));
                    marksList.add(mark);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return marksList;
    }
    
    /**
     * Close the database connection
     */
    public void close() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}