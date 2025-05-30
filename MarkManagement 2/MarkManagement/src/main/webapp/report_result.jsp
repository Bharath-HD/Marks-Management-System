<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.StudentMark" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Report Results</title>
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
            max-width: 900px;
            margin: 0 auto;
        }
        h1, h2 {
            color: #2c3e50;
            text-align: center;
        }
        .report-header {
            margin-bottom: 20px;
            padding: 10px;
            background-color: #f8f9fa;
            border-radius: 5px;
            text-align: center;
        }
        .report-header p {
            margin: 5px 0;
        }
        .report-meta {
            font-size: 14px;
            color: #666;
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #2c3e50;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #e8f4f8;
        }
        .no-data {
            text-align: center;
            padding: 20px;
            background-color: #f8d7da;
            color: #721c24;
            border-radius: 5px;
            margin: 20px 0;
        }
        .report-summary {
            margin: 20px 0;
            padding: 15px;
            background-color: #e8f4f8;
            border-radius: 5px;
        }
        .summary-item {
            margin: 10px 0;
        }
        .summary-label {
            font-weight: bold;
            color: #2c3e50;
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
        .print-btn {
            background-color: #2c3e50;
            color: white;
            border: none;
            padding: 10px 15px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            margin: 10px 0;
            cursor: pointer;
            border-radius: 4px;
        }
        .print-btn:hover {
            background-color: #1a252f;
        }
        
        @media print {
            .navigation, .print-btn {
                display: none;
            }
            body {
                margin: 0;
                background-color: white;
            }
            .container {
                box-shadow: none;
                max-width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <% 
        String reportType = (String) request.getAttribute("reportType");
        if (reportType == null) {
            reportType = "unknown";
        }
        
        String reportTitle = "";
        String reportDescription = "";
        
        switch(reportType) {
            case "threshold":
                reportTitle = "Students Above Marks Threshold";
                int threshold = (Integer) request.getAttribute("threshold");
                String subjectFilter = (String) request.getAttribute("subjectFilter");
                
                reportDescription = "Students who scored above " + threshold + " marks";
                if (subjectFilter != null && !subjectFilter.isEmpty()) {
                    reportDescription += " in " + subjectFilter;
                } else {
                    reportDescription += " in any subject";
                }
                break;
                
            case "subject":
                reportTitle = "Subject Performance Report";
                String subject = (String) request.getAttribute("subject");
                String sortOrder = (String) request.getAttribute("sortOrder");
                
                reportDescription = "All students who took " + subject;
                if (sortOrder != null) {
                    if (sortOrder.equals("marks_desc")) {
                        reportDescription += " (sorted by highest marks)";
                    } else if (sortOrder.equals("marks_asc")) {
                        reportDescription += " (sorted by lowest marks)";
                    } else if (sortOrder.equals("name")) {
                        reportDescription += " (sorted by student name)";
                    } else if (sortOrder.equals("id")) {
                        reportDescription += " (sorted by student ID)";
                    }
                }
                break;
                
            case "topn":
                reportTitle = "Top Performers Report";
                int topCount = (Integer) request.getAttribute("topCount");
                String topSubjectFilter = (String) request.getAttribute("subjectFilter");
                
                reportDescription = "Top " + topCount + " students";
                if (topSubjectFilter != null && !topSubjectFilter.isEmpty()) {
                    reportDescription += " in " + topSubjectFilter;
                } else {
                    reportDescription += " across all subjects";
                }
                break;
                
            default:
                reportTitle = "Custom Report";
                reportDescription = "Custom report results";
        }
        %>
        
        <h1><%= reportTitle %></h1>
        
        <div class="report-header">
            <p><%= reportDescription %></p>
            <p class="report-meta">Generated on: <%= new java.text.SimpleDateFormat("dd-MM-yyyy HH:mm:ss").format(new java.util.Date()) %></p>
        </div>
        
        <button class="print-btn" onclick="window.print();">Print Report</button>
        
        <% 
        List<StudentMark> results = (List<StudentMark>) request.getAttribute("reportResults");
        
        if (results != null && !results.isEmpty()) { 
            // Calculate summary statistics for threshold and topn reports
            if ("threshold".equals(reportType) || "topn".equals(reportType)) {
                int count = results.size();
                int totalMarks = 0;
                int highestMark = Integer.MIN_VALUE;
                int lowestMark = Integer.MAX_VALUE;
                String highestStudent = "";
                String lowestStudent = "";
                
                for (StudentMark mark : results) {
                    totalMarks += mark.getMarks();
                    
                    if (mark.getMarks() > highestMark) {
                        highestMark = mark.getMarks();
                        highestStudent = mark.getStudentName();
                    }
                    
                    if (mark.getMarks() < lowestMark) {
                        lowestMark = mark.getMarks();
                        lowestStudent = mark.getStudentName();
                    }
                }
                
                double averageMark = (double) totalMarks / count;
        %>
            <div class="report-summary">
                <div class="summary-item">
                    <span class="summary-label">Total Students:</span> <%= count %>
                </div>
                <div class="summary-item">
                    <span class="summary-label">Average Marks:</span> <%= String.format("%.2f", averageMark) %>
                </div>
                <div class="summary-item">
                    <span class="summary-label">Highest Marks:</span> <%= highestMark %> (by <%= highestStudent %>)
                </div>
                <div class="summary-item">
                    <span class="summary-label">Lowest Marks:</span> <%= lowestMark %> (by <%= lowestStudent %>)
                </div>
            </div>
        <% } %>
        
        <table>
            <thead>
                <tr>
                    <th>Student ID</th>
                    <th>Student Name</th>
                    <th>Subject</th>
                    <th>Marks</th>
                    <th>Exam Date</th>
                </tr>
            </thead>
            <tbody>
                <% for (StudentMark mark : results) { %>
                <tr>
                    <td><%= mark.getStudentId() %></td>
                    <td><%= mark.getStudentName() %></td>
                    <td><%= mark.getSubject() %></td>
                    <td><%= mark.getMarks() %></td>
                    <td><%= mark.getExamDate() %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        
        <% } else { %>
        <div class="no-data">
            <p>No data found matching the report criteria.</p>
        </div>
        <% } %>
        
        <div class="navigation">
            <a href="report_form.jsp?type=<%= reportType %>">Modify Report</a>
            <a href="reports.jsp">Back to Reports</a>
            <a href="index.jsp">Home</a>
            <a href="markdisplay.jsp">Display Marks</a>
        </div>
    </div>
    
    <script>
        // Highlight rows based on marks
        document.addEventListener('DOMContentLoaded', function() {
            const rows = document.querySelectorAll('tbody tr');
            rows.forEach(row => {
                const marksCell = row.cells[3];
                const marks = parseInt(marksCell.textContent);
                
                if (marks >= 85) {
                    marksCell.style.backgroundColor = '#c8e6c9'; // Light green for high marks
                    marksCell.style.fontWeight = 'bold';
                } else if (marks < 40) {
                    marksCell.style.backgroundColor = '#ffcdd2'; // Light red for low marks
                    marksCell.style.fontWeight = 'bold';
                }
            });
        });
    </script>
</body>
</html>