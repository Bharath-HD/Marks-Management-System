package servlet;

import java.io.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.MarkDAO;
import model.StudentMark;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
/**
 * Servlet implementation for updating student marks
 */
public class UpdateMarkServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    /**
     * Handle GET requests to get student details for updating
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get student ID parameter
        String studentIdStr = request.getParameter("studentId");
        
        if (studentIdStr != null && !studentIdStr.trim().isEmpty()) {
            try {
                int studentId = Integer.parseInt(studentIdStr);
                
                // Get student mark from database
                MarkDAO markDAO = new MarkDAO();
                StudentMark studentMark = markDAO.getStudentMarkById(studentId);
                markDAO.close();
                
                if (studentMark != null) {
                    // Put student mark in request attribute
                    request.setAttribute("studentMark", studentMark);
                    request.getRequestDispatcher("/markupdate.jsp").forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "Student with ID " + studentId + " not found.");
                    request.getRequestDispatcher("/markupdate.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid Student ID. Please enter a numeric value.");
                request.getRequestDispatcher("/markupdate.jsp").forward(request, response);
            }
        } else {
            // If no ID provided, just show the empty form
            request.getRequestDispatcher("/markupdate.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle POST requests to update student marks
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get parameters from the request
        String studentIdStr = request.getParameter("studentId");
        String studentName = request.getParameter("studentName");
        String subject = request.getParameter("subject");
        String marksStr = request.getParameter("marks");
        String examDateStr = request.getParameter("examDate");
        
        // Validate input
        StringBuilder errors = new StringBuilder();
        
        if (studentIdStr == null || studentIdStr.trim().isEmpty()) {
            errors.append("Student ID is required.<br>");
        }
        
        if (studentName == null || studentName.trim().isEmpty()) {
            errors.append("Student Name is required.<br>");
        } else if (studentName.length() > 100) {
            errors.append("Student Name must be less than 100 characters.<br>");
        }
        
        if (subject == null || subject.trim().isEmpty()) {
            errors.append("Subject is required.<br>");
        } else if (subject.length() > 50) {
            errors.append("Subject must be less than 50 characters.<br>");
        }
        
        if (marksStr == null || marksStr.trim().isEmpty()) {
            errors.append("Marks are required.<br>");
        }
        
        if (examDateStr == null || examDateStr.trim().isEmpty()) {
            errors.append("Exam Date is required.<br>");
        }
        
        // Check if we have any validation errors
        if (errors.length() > 0) {
            request.setAttribute("errorMessage", errors.toString());
            request.getRequestDispatcher("/markupdate.jsp").forward(request, response);
            return;
        }
        
        try {
            // Parse the values
            int studentId = Integer.parseInt(studentIdStr);
            int marks = Integer.parseInt(marksStr);
            
            // Validate numeric values
            if (studentId <= 0) {
                errors.append("Student ID must be a positive number.<br>");
            }
            
            if (marks < 0 || marks > 100) {
                errors.append("Marks must be between 0 and 100.<br>");
            }
            
            // Parse the date
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            dateFormat.setLenient(false);
            Date examDate;
            
            try {
                examDate = dateFormat.parse(examDateStr);
                
                // Check if the date is in the future
                if (examDate.after(new Date())) {
                    errors.append("Exam Date cannot be in the future.<br>");
                }
            } catch (ParseException e) {
                errors.append("Invalid Exam Date format. Use YYYY-MM-DD.<br>");
                examDate = null;
            }
            
            // Check for additional validation errors
            if (errors.length() > 0) {
                request.setAttribute("errorMessage", errors.toString());
                request.getRequestDispatcher("/markupdate.jsp").forward(request, response);
                return;
            }
            
            // Verify student exists
            MarkDAO markDAO = new MarkDAO();
            StudentMark existingMark = markDAO.getStudentMarkById(studentId);
            
            if (existingMark == null) {
                markDAO.close();
                request.setAttribute("errorMessage", "Student with ID " + studentId + " does not exist.");
                request.getRequestDispatcher("/markupdate.jsp").forward(request, response);
                return;
            }
            
            // Create StudentMark object
            StudentMark studentMark = new StudentMark();
            studentMark.setStudentId(studentId);
            studentMark.setStudentName(studentName);
            studentMark.setSubject(subject);
            studentMark.setMarks(marks);
            studentMark.setExamDate(examDate);
            
            // Update in database
            boolean success = markDAO.updateStudentMark(studentMark);
            markDAO.close();
            
            if (success) {
                request.setAttribute("successMessage", "Student mark updated successfully!");
                request.setAttribute("studentMark", studentMark);
                request.getRequestDispatcher("/markupdate.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Failed to update student mark.");
                request.getRequestDispatcher("/markupdate.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid Student ID or Marks. Please enter numeric values.");
            request.getRequestDispatcher("/markupdate.jsp").forward(request, response);
        }
    }
}