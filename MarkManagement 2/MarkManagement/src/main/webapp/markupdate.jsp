<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Student Mark</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f0f4f8;
        }
        .container {
            margin-top: 40px;
        }
        .card {
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .card-header {
            background-color: #007bff;
            color: white;
            font-weight: bold;
            font-size: 1.3rem;
        }
        .form-label {
            font-weight: 500;
        }
        .btn-primary {
            background-color: #007bff;
            border: none;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
        .nav-link {
            color: #007bff;
            font-weight: bold;
        }
        .nav-link:hover {
            text-decoration: underline;
        }
        .table thead {
            background-color: #e9ecef;
        }
        .alert {
            border-radius: 8px;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="mb-4 text-center">
        <h2>Update Student Mark</h2>
    </div>

    <div class="mb-3 d-flex justify-content-center gap-3">
        <a href="index.jsp" class="nav-link">Home</a>
        <a href="markadd.jsp" class="nav-link">Add Mark</a>
        <a href="markdisplay.jsp" class="nav-link">Display Marks</a>
        <a href="markdelete.jsp" class="nav-link">Delete Mark</a>
        <a href="reports.jsp" class="nav-link">Reports</a>
    </div>

    <%
        String message = "";
        String errorMessage = "";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mark_management", "root", "");

            if (request.getMethod().equalsIgnoreCase("post")) {
                String studentId = request.getParameter("studentId");
                String subject = request.getParameter("subject");
                String marks = request.getParameter("marks");
                String examDate = request.getParameter("examDate");

                if (studentId == null || subject == null || marks == null || examDate == null ||
                    studentId.trim().isEmpty() || subject.trim().isEmpty() || marks.trim().isEmpty() || examDate.trim().isEmpty()) {
                    errorMessage = "All fields are required!";
                } else {
                    try {
                        int studentIdInt = Integer.parseInt(studentId);
                        int marksInt = Integer.parseInt(marks);

                        String checkSql = "SELECT * FROM StudentMarks WHERE StudentID = ? AND Subject = ?";
                        pstmt = conn.prepareStatement(checkSql);
                        pstmt.setInt(1, studentIdInt);
                        pstmt.setString(2, subject);
                        rs = pstmt.executeQuery();

                        if (rs.next()) {
                            String updateSql = "UPDATE StudentMarks SET Marks = ?, ExamDate = ? WHERE StudentID = ? AND Subject = ?";
                            pstmt = conn.prepareStatement(updateSql);
                            pstmt.setInt(1, marksInt);
                            pstmt.setDate(2, java.sql.Date.valueOf(examDate));
                            pstmt.setInt(3, studentIdInt);
                            pstmt.setString(4, subject);
                            int rowsAffected = pstmt.executeUpdate();
                            message = (rowsAffected > 0) ? "Student mark updated successfully!" : "Failed to update student mark.";
                        } else {
                            errorMessage = "No record found for the given Student ID and Subject.";
                        }
                    } catch (NumberFormatException e) {
                        errorMessage = "Student ID and Marks must be valid numbers.";
                    }
                }
            }
        } catch (Exception e) {
            errorMessage = "Error: " + e.getMessage();
            e.printStackTrace();
        }
    %>

    <% if (!message.isEmpty()) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <%= message %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>
    <% if (!errorMessage.isEmpty()) { %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <%= errorMessage %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>

    <div class="card mb-4">
        <div class="card-header">Update Mark Form</div>
        <div class="card-body">
            <form method="post" action="markupdate.jsp" onsubmit="return validateForm()">
                <div class="mb-3">
                    <label for="studentId" class="form-label">Student ID</label>
                    <input type="text" id="studentId" name="studentId" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label for="subject" class="form-label">Subject</label>
                    <input type="text" id="subject" name="subject" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label for="marks" class="form-label">Marks</label>
                    <input type="number" id="marks" name="marks" class="form-control" min="0" max="100" required>
                </div>

                <div class="mb-3">
                    <label for="examDate" class="form-label">Exam Date</label>
                    <input type="date" id="examDate" name="examDate" class="form-control" required>
                </div>

                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-primary">Update Mark</button>
                </div>
            </form>
        </div>
    </div>

    <% try {
        if (conn != null) {
            String sql = "SELECT * FROM StudentMarks ORDER BY StudentID";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery(); %>

            <h4>Existing Student Marks</h4>
            <div class="table-responsive">
                <table class="table table-bordered table-striped">
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
                        <% while (rs.next()) { %>
                        <tr>
                            <td><%= rs.getInt("StudentID") %></td>
                            <td><%= rs.getString("StudentName") %></td>
                            <td><%= rs.getString("Subject") %></td>
                            <td><%= rs.getInt("Marks") %></td>
                            <td><%= rs.getDate("ExamDate") %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
    <% } } catch (Exception e) {
        out.println("<p class='text-danger'>Error displaying records: " + e.getMessage() + "</p>");
    } finally {
        try { if (rs != null) rs.close(); if (pstmt != null) pstmt.close(); if (conn != null) conn.close(); } 
        catch (SQLException e) { e.printStackTrace(); }
    } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function validateForm() {
        var studentId = document.getElementById("studentId").value.trim();
        var subject = document.getElementById("subject").value.trim();
        var marks = document.getElementById("marks").value.trim();
        var examDate = document.getElementById("examDate").value.trim();

        if (studentId === "" || subject === "" || marks === "" || examDate === "") {
            alert("All fields are required!");
            return false;
        }

        if (isNaN(studentId) || isNaN(marks)) {
            alert("Student ID and Marks must be numbers!");
            return false;
        }

        var marksInt = parseInt(marks);
        if (marksInt < 0 || marksInt > 100) {
            alert("Marks must be between 0 and 100!");
            return false;
        }

        return true;
    }
</script>
</body>
</html>
