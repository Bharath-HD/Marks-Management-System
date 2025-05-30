package servlet;

import java.io.*;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.MarkDAO;
import model.StudentMark;

/**
 * Servlet implementation for handling report criteria selection
 */
public class ReportCriteriaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    /**
     * Handle GET requests to get the criteria options
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get the report type parameter
        String reportType = request.getParameter("type");
        
        if ("bySubject".equals(reportType)) {
            // Get unique subjects from the database
            MarkDAO markDAO = new MarkDAO();
            List<StudentMark> allMarks = markDAO.getAllStudentMarks();
            markDAO.close();
            
            Set<String> subjects = new HashSet<>();
            for (StudentMark mark : allMarks) {
                subjects.add(mark.getSubject());
            }
            
            request.setAttribute("subjects", new ArrayList<>(subjects));
            request.getRequestDispatcher("/report_criteria_subjects.jsp").forward(request, response);
        } else {
            // Default response for other types
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            out.println("<p>Enter criteria for the selected report:</p>");
            
            if ("aboveThreshold".equals(reportType)) {
                out.println("<div class='form-group'>");
                out.println("<label for='threshold'>Minimum Marks Threshold:</label>");
                out.println("<input type='number' class='form-control' id='threshold' name='threshold' min='0' max='100' required>");
                out.println("</div>");
            } else if ("topStudents".equals(reportType)) {
                out.println("<div class='form-group'>");
                out.println("<label for='count'>Number of Top Students to Display:</label>");
                out.println("<input type='number' class='form-control' id='count' name='count' min='1' required>");
                out.println("</div>");
            }
        }
    }
}