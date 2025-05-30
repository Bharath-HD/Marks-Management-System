<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Generate Report</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            max-width: 700px;
            margin: 0 auto;
        }
        h1 {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 20px;
        }
        form {
            margin-top: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #2c3e50;
        }
        input[type="text"], 
        input[type="number"], 
        select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .error {
            color: #dc3545;
            font-size: 14px;
            margin-top: 5px;
        }
        .btn-container {
            text-align: center;
            margin-top: 20px;
        }
        input[type="submit"] {
            background-color: #2c3e50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        input[type="submit"]:hover {
            background-color: #1a252f;
        }
        .navigation {
            margin-top: 20px;
            text-align: center;
        }
        .navigation a {
            margin: 0 10px;
            text-decoration: none;
            color: #2c3e50;
            font-weight: bold;
        }
        .navigation a:hover {
            text-decoration: underline;
        }
        .report-description {
            background-color: #f8f9fa;
            padding: 10px 15px;
            border-left: 4px solid #2c3e50;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <% 
        String reportType = request.getParameter("type");
        String reportTitle = "";
        String reportDesc = "";
        String servletAction = "";
        
        if (reportType == null) {
            reportType = "threshold";
        }
        
        switch(reportType) {
            case "threshold":
                reportTitle = "Students Above Marks Threshold";
                reportDesc = "This report displays all students who scored above a specified marks threshold in any subject.";
                servletAction = "ReportServlet?report=threshold";
                break;
            case "subject":
                reportTitle = "Subject Performance Report";
                reportDesc = "This report displays all students who took a specific subject, along with their marks.";
                servletAction = "ReportServlet?report=subject";
                break;
            case "topn":
                reportTitle = "Top Performers Report";
                reportDesc = "This report displays the top N students based on their marks, either across all subjects or in a specific subject.";
                servletAction = "ReportServlet?report=topn";
                break;
            default:
                reportTitle = "Custom Report";
                reportDesc = "Please fill in the criteria for your custom report.";
                servletAction = "ReportServlet";
        }
        %>
        
        <h1><%= reportTitle %></h1>
        
        <div class="report-description">
            <p><%= reportDesc %></p>
        </div>
        
        <form action="<%= servletAction %>" method="post" id="reportForm" onsubmit="return validateForm()">
            <% if ("threshold".equals(reportType)) { %>
                <div class="form-group">
                    <label for="threshold">Minimum Marks Threshold:</label>
                    <input type="number" id="threshold" name="threshold" min="0" max="100" required>
                    <div id="thresholdError" class="error"></div>
                </div>
                
                <div class="form-group">
                    <label for="subjectFilter">Subject (Optional):</label>
                    <input type="text" id="subjectFilter" name="subjectFilter" placeholder="Leave blank for all subjects">
                </div>
                
            <% } else if ("subject".equals(reportType)) { %>
                <div class="form-group">
                    <label for="subject">Subject:</label>
                    <input type="text" id="subject" name="subject" required>
                    <div id="subjectError" class="error"></div>
                </div>
                
                <div class="form-group">
                    <label for="sortOrder">Sort By:</label>
                    <select id="sortOrder" name="sortOrder">
                        <option value="marks_desc">Marks (Highest to Lowest)</option>
                        <option value="marks_asc">Marks (Lowest to Highest)</option>
                        <option value="name">Student Name</option>
                        <option value="id">Student ID</option>
                    </select>
                </div>
                
            <% } else if ("topn".equals(reportType)) { %>
                <div class="form-group">
                    <label for="topCount">Number of Top Students:</label>
                    <input type="number" id="topCount" name="topCount" min="1" max="100" value="10" required>
                    <div id="topCountError" class="error"></div>
                </div>
                
                <div class="form-group">
                    <label for="subjectFilter">Subject (Optional):</label>
                    <input type="text" id="subjectFilter" name="subjectFilter" placeholder="Leave blank for all subjects">
                </div>
                
            <% } %>
            
            <div class="btn-container">
                <input type="submit" value="Generate Report">
            </div>
        </form>
        
        <div class="navigation">
            <a href="reports.jsp">Back to Reports</a>
            <a href="index.jsp">Home</a>
            <a href="markdisplay.jsp">Display Marks</a>
        </div>
    </div>
    
    <script>
        function validateForm() {
            let isValid = true;
            
            <% if ("threshold".equals(reportType)) { %>
            const threshold = document.getElementById('threshold').value;
            if (threshold === '' || isNaN(threshold) || threshold < 0 || threshold > 100) {
                document.getElementById('thresholdError').textContent = 'Please enter a valid threshold between 0 and 100.';
                isValid = false;
            } else {
                document.getElementById('thresholdError').textContent = '';
            }
            <% } else if ("subject".equals(reportType)) { %>
            const subject = document.getElementById('subject').value.trim();
            if (subject === '') {
                document.getElementById('subjectError').textContent = 'Please enter a subject name.';
                isValid = false;
            } else {
                document.getElementById('subjectError').textContent = '';
            }
            <% } else if ("topn".equals(reportType)) { %>
            const topCount = document.getElementById('topCount').value;
            if (topCount === '' || isNaN(topCount) || topCount < 1 || topCount > 100) {
                document.getElementById('topCountError').textContent = 'Please enter a valid number between 1 and 100.';
                isValid = false;
            } else {
                document.getElementById('topCountError').textContent = '';
            }
            <% } %>
            
            return isValid;
        }
    </script>
</body>
</html>