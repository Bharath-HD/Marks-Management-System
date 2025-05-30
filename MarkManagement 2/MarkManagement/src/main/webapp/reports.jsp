<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Marks Reports</title>
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
        h1 {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 20px;
        }
        .report-cards {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
        }
        .report-card {
            width: 260px;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 15px;
            background-color: #f8f9fa;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .report-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        .report-card h2 {
            color: #2c3e50;
            font-size: 18px;
            margin-top: 0;
            margin-bottom: 15px;
            border-bottom: 2px solid #2c3e50;
            padding-bottom: 8px;
        }
        .report-card p {
            color: #555;
            margin-bottom: 20px;
            font-size: 14px;
            height: 60px;
        }
        .report-btn {
            display: block;
            width: 100%;
            padding: 10px 0;
            background-color: #2c3e50;
            color: white;
            text-align: center;
            text-decoration: none;
            border-radius: 4px;
            transition: background-color 0.3s;
        }
        .report-btn:hover {
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
    </style>
</head>
<body>
    <div class="container">
        <h1>Student Marks Reports</h1>
        
        <div class="report-cards">
            <div class="report-card">
                <h2>Marks Above Threshold</h2>
                <p>Find students who scored above a specified marks threshold in any subject.</p>
                <a href="report_form.jsp?type=threshold" class="report-btn">Generate Report</a>
            </div>
            
            <div class="report-card">
                <h2>Subject Performance</h2>
                <p>View all students who took a specific subject along with their performance.</p>
                <a href="report_form.jsp?type=subject" class="report-btn">Generate Report</a>
            </div>
            
            <div class="report-card">
                <h2>Top Performers</h2>
                <p>List the top N students based on their marks across all subjects or in a specific subject.</p>
                <a href="report_form.jsp?type=topn" class="report-btn">Generate Report</a>
            </div>
        </div>
        
        <div class="navigation">
            <a href="index.jsp">Home</a>
            <a href="markadd.jsp">Add New Marks</a>
            <a href="markupdate.jsp">Update Marks</a>
            <a href="markdisplay.jsp">Display Marks</a>
        </div>
    </div>
</body>
</html>