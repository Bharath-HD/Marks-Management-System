package servlet;

import java.io.*;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.MarkDAO;
import model.StudentMark;

/**
 * Servlet implementation for displaying student marks
 */
public class DisplayMarksServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    /**
     * Handle GET requests to display all student marks or search by ID
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get student ID parameter for search
        String studentIdStr = request.getParameter("studentId");
        MarkDAO markDAO = new MarkDAO();
        
        if (studentIdStr != null && !studentIdStr.trim().isEmpty()) {
            try {
                int studentId = Integer.parseInt(studentIdStr);
                
                // Get student mark from database
                StudentMark studentMark = markDAO.getStudentMarkById(studentId);
                
                if (studentMark != null) {
                    // Put student mark in request attribute
                    request.setAttribute("studentMark", studentMark);
                    request.setAttribute("searchPerformed", true);
                } else {
                    request.setAttribute("errorMessage", "Student with ID " + studentId + " not found.");
                    request.setAttribute("searchPerformed", true);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid Student ID. Please enter a numeric value.");
            }
        } else {
            // Get all student marks
            List<StudentMark> marksList = markDAO.getAllStudentMarks();
            request.setAttribute("marksList", marksList);
        }
        
        markDAO.close();
        request.getRequestDispatcher("/markdisplay.jsp").forward(request, response);
    }
}