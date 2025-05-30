package servlet;

import java.io.*;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.MarkDAO;
import model.StudentMark;

/**
 * Servlet implementation for generating student mark reports
 */
public class ReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    /**
     * Handle GET requests to show the report form
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/report_form.jsp").forward(request, response);
    }
    
    /**
     * Handle POST requests to generate reports
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String reportType = request.getParameter("reportType");
        MarkDAO markDAO = new MarkDAO();
        List<StudentMark> reportResults = null;
        String reportTitle = "";
        
        if (reportType != null) {
            switch (reportType) {
                case "aboveThreshold":
                    String thresholdStr = request.getParameter("threshold");
                    if (thresholdStr != null && !thresholdStr.trim().isEmpty()) {
                        try {
                            int threshold = Integer.parseInt(thresholdStr);
                            reportResults = markDAO.getStudentsAboveThreshold(threshold);
                            reportTitle = "Students with Marks Above " + threshold;
                        } catch (NumberFormatException e) {
                            request.setAttribute("errorMessage", "Invalid threshold value. Please enter a numeric value.");
                        }
                    } else {
                        request.setAttribute("errorMessage", "Threshold value is required.");
                    }
                    break;
                    
                case "bySubject":
                    String subject = request.getParameter("subject");
                    if (subject != null && !subject.trim().isEmpty()) {
                        reportResults = markDAO.getStudentsBySubject(subject);
                        reportTitle = "Students Scored in Subject: " + subject;
                    } else {
                        request.setAttribute("errorMessage", "Subject is required.");
                    }
                    break;
                    
                case "topStudents":
                    String countStr = request.getParameter("count");
                    if (countStr != null && !countStr.trim().isEmpty()) {
                        try {
                            int count = Integer.parseInt(countStr);
                            if (count > 0) {
                                reportResults = markDAO.getTopStudents(count);
                                reportTitle = "Top " + count + " Students Based on Marks";
                            } else {
                                request.setAttribute("errorMessage", "Count must be a positive number.");
                            }
                        } catch (NumberFormatException e) {
                            request.setAttribute("errorMessage", "Invalid count value. Please enter a numeric value.");
                        }
                    } else {
                        request.setAttribute("errorMessage", "Count value is required.");
                    }
                    break;
            }
        }
        
        markDAO.close();
        
        request.setAttribute("reportResults", reportResults);
        request.setAttribute("reportTitle", reportTitle);
        request.getRequestDispatcher("/report_result.jsp").forward(request, response);
    }
}