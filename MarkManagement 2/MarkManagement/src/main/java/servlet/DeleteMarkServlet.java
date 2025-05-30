package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.MarkDAO;
import model.StudentMark;

/**
 * Servlet implementation for deleting student marks
 */
public class DeleteMarkServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    /**
     * Handle GET requests to get student details for confirmation
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
                    request.getRequestDispatcher("/markdelete.jsp").forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "Student with ID " + studentId + " not found.");
                    request.getRequestDispatcher("/markdelete.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid Student ID. Please enter a numeric value.");
                request.getRequestDispatcher("/markdelete.jsp").forward(request, response);
            }
        } else {
            // If no ID provided, just show the empty form
            request.getRequestDispatcher("/markdelete.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle POST requests to delete student marks
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get student ID parameter
        String studentIdStr = request.getParameter("studentId");
        String confirmation = request.getParameter("confirmation");
        
        // Check if confirmation is provided
        if (!"yes".equals(confirmation)) {
            request.setAttribute("errorMessage", "Deletion was not confirmed.");
            request.getRequestDispatcher("/markdelete.jsp").forward(request, response);
            return;
        }
        
        if (studentIdStr != null && !studentIdStr.trim().isEmpty()) {
            try {
                int studentId = Integer.parseInt(studentIdStr);
                
                // Delete from database
                MarkDAO markDAO = new MarkDAO();
                boolean success = markDAO.deleteStudentMark(studentId);
                markDAO.close();
                
                if (success) {
                    request.setAttribute("successMessage", "Student mark deleted successfully!");
                    request.getRequestDispatcher("/markdelete.jsp").forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "Failed to delete student mark. Student may not exist.");
                    request.getRequestDispatcher("/markdelete.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid Student ID. Please enter a numeric value.");
                request.getRequestDispatcher("/markdelete.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("errorMessage", "Student ID is required.");
            request.getRequestDispatcher("/markdelete.jsp").forward(request, response);
        }
    }
}