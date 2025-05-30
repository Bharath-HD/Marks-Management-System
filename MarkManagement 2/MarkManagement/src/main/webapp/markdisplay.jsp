<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.StudentMark" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Marks Dashboard</title>
    <style>
        :root {
            --primary-color: #008080;
            --accent-color: #004d4d;
            --bg-light: #f4f8f9;
            --white: #ffffff;
            --danger: #dc3545;
            --success: #28a745;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--bg-light);
            margin: 0;
            padding: 0;
        }

        .container {
            background-color: var(--white);
            max-width: 1000px;
            margin: 30px auto;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.05);
        }

        h1 {
            color: var(--primary-color);
            text-align: center;
            margin-bottom: 30px;
        }

        .search-form {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            background-color: #e8f6f6;
            padding: 20px;
            border-radius: 8px;
            border: 1px solid #cce0e0;
            margin-bottom: 25px;
        }

        .search-form select,
        .search-form input[type="text"],
        .search-form input[type="number"] {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            flex: 1;
            min-width: 200px;
        }

        .search-form input[type="submit"] {
            background-color: var(--primary-color);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .search-form input[type="submit"]:hover {
            background-color: var(--accent-color);
        }

        .message {
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-weight: bold;
        }

        .success-message {
            background-color: #d1f5d3;
            color: var(--success);
        }

        .error-message {
            background-color: #f8d7da;
            color: var(--danger);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 14px 18px;
            border-bottom: 1px solid #e0e0e0;
            text-align: left;
        }

        th {
            background-color: var(--primary-color);
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f1fdfd;
        }

        tr:hover {
            background-color: #e6ffff;
        }

        .actions a {
            text-decoration: none;
            margin-right: 10px;
            color: var(--primary-color);
            font-weight: 500;
        }

        .actions a:hover {
            text-decoration: underline;
        }

        .empty-results {
            text-align: center;
            padding: 30px;
            background-color: #ffe6e6;
            border-radius: 6px;
            color: #b30000;
        }

        .navigation {
            margin-top: 30px;
            text-align: center;
        }

        .navigation a {
            margin: 0 12px;
            text-decoration: none;
            font-weight: bold;
            color: var(--primary-color);
        }

        .navigation a:hover {
            color: var(--accent-color);
        }

        @media (max-width: 768px) {
            .search-form {
                flex-direction: column;
            }

            table, thead, tbody, th, td, tr {
                display: block;
            }

            tr {
                margin-bottom: 15px;
                border-bottom: 1px solid #ccc;
            }

            td {
                padding: 10px;
                text-align: right;
                position: relative;
            }

            td::before {
                content: attr(data-label);
                position: absolute;
                left: 10px;
                top: 10px;
                font-weight: bold;
                text-align: left;
            }

            th {
                display: none;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Student Marks</h1>

    <%-- Message Handling --%>
    <% 
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
    if (successMessage != null && !successMessage.isEmpty()) { 
    %>
        <div class="message success-message"><%= successMessage %></div>
    <% } else if (errorMessage != null && !errorMessage.isEmpty()) { %>
        <div class="message error-message"><%= errorMessage %></div>
    <% } %>

    <%-- Search Form --%>
    <form class="search-form" action="DisplayMarksServlet" method="get">
        <select name="searchType" id="searchType">
            <option value="all" selected>All Students</option>
            <option value="id">Student ID</option>
            <option value="name">Student Name</option>
            <option value="subject">Subject</option>
        </select>

        <input type="text" name="searchValue" placeholder="Enter search value" id="searchValue">
        <input type="submit" value="Search">
    </form>

    <script>
        const searchType = document.getElementById('searchType');
        const searchValue = document.getElementById('searchValue');

        function toggleSearchInput() {
            if (searchType.value === 'all') {
                searchValue.style.display = 'none';
                searchValue.required = false;
            } else {
                searchValue.style.display = 'inline-block';
                searchValue.required = true;
                searchValue.placeholder = `Enter ${searchType.options[searchType.selectedIndex].text}`;
            }
        }

        searchType.addEventListener('change', toggleSearchInput);
        window.onload = toggleSearchInput;
    </script>

    <%-- Student Marks Table --%>
    <%
    List<StudentMark> studentMarks = (List<StudentMark>) request.getAttribute("marksList");

    if (studentMarks != null && !studentMarks.isEmpty()) {
    %>
        <table>
            <thead>
                <tr>
                    <th>Student ID</th>
                    <th>Name</th>
                    <th>Subject</th>
                    <th>Marks</th>
                    <th>Exam Date</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <% for (StudentMark mark : studentMarks) { %>
                <tr>
                    <td data-label="Student ID"><%= mark.getStudentId() %></td>
                    <td data-label="Name"><%= mark.getStudentName() %></td>
                    <td data-label="Subject"><%= mark.getSubject() %></td>
                    <td data-label="Marks"><%= mark.getMarks() %></td>
                    <td data-label="Exam Date"><%= mark.getExamDate() %></td>
                    <td data-label="Actions" class="actions">
                        <a href="UpdateMarkServlet?id=<%= mark.getStudentId() %>&subject=<%= mark.getSubject() %>">Edit</a>
                        <a href="DeleteMarkServlet?id=<%= mark.getStudentId() %>&subject=<%= mark.getSubject() %>"
                           onclick="return confirm('Are you sure you want to delete this record?')">Delete</a>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
    <% } else { %>
        <div class="empty-results">No student records found.</div>
    <% } %>

    <%-- Navigation --%>
    <div class="navigation">
        <a href="index.jsp">Home</a>
        <a href="markadd.jsp">Add Mark</a>
        <a href="markupdate.jsp">Update Mark</a>
        <a href="reports.jsp">Reports</a>
    </div>
</div>
</body>
</html>
