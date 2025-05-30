<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Delete Student Mark</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #eef4fb;
            margin: 0;
            padding: 0;
        }

        .container {
            background-color: #fff;
            margin: 30px auto;
            padding: 30px;
            max-width: 900px;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }

        h1, h2 {
            text-align: center;
            color: #1a3c70;
        }

        .nav {
            display: flex;
            justify-content: space-around;
            margin-bottom: 30px;
        }

        .nav a {
            color: #1a3c70;
            text-decoration: none;
            font-weight: bold;
            padding: 8px 12px;
            border-radius: 5px;
            transition: 0.3s ease;
        }

        .nav a:hover {
            background-color: #d4e2f2;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            color: #333;
        }

        input[type="text"],
        input[type="number"],
        select {
            width: 100%;
            padding: 10px;
            border-radius: 5px;
            border: 1px solid #ccc;
            font-size: 16px;
        }

        button {
            background-color: #1976d2;
            color: white;
            border: none;
            padding: 12px 20px;
            font-size: 16px;
            border-radius: 6px;
            cursor: pointer;
            transition: background 0.3s;
        }

        button:hover {
            background-color: #155ca5;
        }

        .delete-btn {
            background-color: #e53935;
            padding: 6px 12px;
            font-size: 14px;
        }

        .delete-btn:hover {
            background-color: #c62828;
        }

        .success {
            color: green;
            text-align: center;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .error {
            color: red;
            text-align: center;
            font-weight: bold;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 25px;
        }

        table th, table td {
            padding: 12px;
            border: 1px solid #ddd;
        }

        table th {
            background-color: #1976d2;
            color: white;
        }

        table tr:nth-child(even) {
            background-color: #f4f7fb;
        }

        .confirm-dialog {
            position: fixed;
            display: none;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            justify-content: center;
            align-items: center;
        }

        .confirm-box {
            background: white;
            padding: 30px;
            border-radius: 10px;
            text-align: center;
            width: 350px;
        }

        .confirm-buttons button {
            margin: 10px;
        }

        .confirm-yes {
            background-color: #e53935;
        }

        .confirm-no {
            background-color: #b0bec5;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Delete Student Mark</h1>

    <div class="nav">
        <a href="index.jsp">Home</a>
        <a href="markadd.jsp">Add Mark</a>
        <a href="markupdate.jsp">Update Mark</a>
        <a href="markdisplay.jsp">Display Marks</a>
        <a href="reports.jsp">Reports</a>
    </div>

    <%
    String message = "";
    String errorMessage = "";
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mark_management", "root", "");

        if ("delete".equals(request.getParameter("action"))) {
            String studentId = request.getParameter("studentId");
            String subject = request.getParameter("subject");

            if (studentId != null && !studentId.isEmpty() && subject != null && !subject.isEmpty()) {
                String deleteSql = "DELETE FROM StudentMarks WHERE StudentID = ? AND Subject = ?";
                pstmt = conn.prepareStatement(deleteSql);
                pstmt.setInt(1, Integer.parseInt(studentId));
                pstmt.setString(2, subject);

                int rowsAffected = pstmt.executeUpdate();
                if (rowsAffected > 0) {
                    message = "Student mark deleted successfully!";
                } else {
                    errorMessage = "Failed to delete student mark. Record not found.";
                }
            }
        }
    } catch (Exception e) {
        errorMessage = "Error: " + e.getMessage();
        e.printStackTrace();
    }
    %>

    <% if (!message.isEmpty()) { %>
    <p class="success"><%= message %></p>
    <% } %>

    <% if (!errorMessage.isEmpty()) { %>
    <p class="error"><%= errorMessage %></p>
    <% } %>

    <form method="post" action="markdelete.jsp" onsubmit="return validateForm()">
        <div class="form-group">
            <label for="studentId">Student ID:</label>
            <input type="text" id="studentId" name="studentId" required>
        </div>
        <div class="form-group">
            <label for="subject">Subject:</label>
            <input type="text" id="subject" name="subject" required>
        </div>
        <input type="hidden" name="action" value="delete">
        <button type="submit" onclick="return confirmDelete()">Delete Mark</button>
    </form>

    <h2>Existing Student Marks</h2>
    <table>
        <tr>
            <th>Student ID</th>
            <th>Student Name</th>
            <th>Subject</th>
            <th>Marks</th>
            <th>Exam Date</th>
            <th>Action</th>
        </tr>
        <%
        try {
            if (conn != null) {
                String sql = "SELECT * FROM StudentMarks ORDER BY StudentID";
                pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();
                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("StudentID") %></td>
            <td><%= rs.getString("StudentName") %></td>
            <td><%= rs.getString("Subject") %></td>
            <td><%= rs.getInt("Marks") %></td>
            <td><%= rs.getDate("ExamDate") %></td>
            <td><button class="delete-btn" onclick="setDeleteValues(<%= rs.getInt("StudentID") %>, '<%= rs.getString("Subject") %>')">Delete</button></td>
        </tr>
        <%
                }
            }
        } catch (Exception e) {
            out.println("<tr><td colspan='6' class='error'>Error displaying records: " + e.getMessage() + "</td></tr>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        %>
    </table>
</div>

<div id="confirmDialog" class="confirm-dialog">
    <div class="confirm-box">
        <p>Are you sure you want to delete this student mark?</p>
        <div class="confirm-buttons">
            <button class="confirm-yes" onclick="proceedWithDelete()">Yes, Delete</button>
            <button class="confirm-no" onclick="closeConfirmDialog()">Cancel</button>
        </div>
    </div>
</div>

<script>
    function validateForm() {
        var studentId = document.getElementById("studentId").value.trim();
        var subject = document.getElementById("subject").value.trim();
        if (studentId === "" || subject === "") {
            alert("Both Student ID and Subject are required.");
            return false;
        }
        if (isNaN(studentId)) {
            alert("Student ID must be a valid number.");
            return false;
        }
        return true;
    }

    function confirmDelete() {
        document.getElementById("confirmDialog").style.display = "flex";
        return false;
    }

    function closeConfirmDialog() {
        document.getElementById("confirmDialog").style.display = "none";
    }

    function proceedWithDelete() {
        closeConfirmDialog();
        document.forms[0].submit();
    }

    function setDeleteValues(studentId, subject) {
        document.getElementById("studentId").value = studentId;
        document.getElementById("subject").value = subject;
        confirmDelete();
    }
</script>
</body>
</html>
