<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Student Mark - Mark Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background-color: #f4f6f9;
            font-family: 'Segoe UI', sans-serif;
        }
        .sidebar {
            height: 100vh;
            background-color: #2c3e50;
            color: #fff;
            position: fixed;
            padding-top: 2rem;
            width: 250px;
        }
        .sidebar a {
            color: #ecf0f1;
            display: block;
            padding: 12px 20px;
            text-decoration: none;
            transition: 0.3s;
        }
        .sidebar a:hover, .sidebar .active {
            background-color: #34495e;
        }
        .main-content {
            margin-left: 260px;
            padding: 30px;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 0 12px rgba(0, 0, 0, 0.1);
        }
        .card-header {
            background-color: #3498db;
            color: white;
            font-weight: 600;
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
        }
        .btn-primary {
            background-color: #3498db;
            border: none;
        }
        .btn-primary:hover {
            background-color: #2980b9;
        }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <div class="sidebar">
        <h4 class="text-center mb-4">Navigation</h4>
        <a href="index.jsp">🏠 Home</a>
        <a class="active" href="markadd.jsp">➕ Add Marks</a>
        <a href="markupdate.jsp">✏️ Update Marks</a>
        <a href="markdelete.jsp">🗑️ Delete Marks</a>
        <a href="DisplayMarksServlet">📊 Display Marks</a>
        <a href="report_form.jsp">📈 Generate Reports</a>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="container-fluid">
            <div class="card">
                <div class="card-header text-center">
                    <h4>Add New Student Mark</h4>
                </div>
                <div class="card-body">

                    <% if (request.getAttribute("successMessage") != null) { %>
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <%= request.getAttribute("successMessage") %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    <% } %>
                    <% if (request.getAttribute("errorMessage") != null) { %>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <%= request.getAttribute("errorMessage") %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    <% } %>

                    <form action="AddMarkServlet" method="post" class="row g-3 needs-validation" novalidate>
                        <div class="col-md-6">
                            <label for="studentId" class="form-label">Student ID</label>
                            <input type="number" class="form-control" id="studentId" name="studentId" required>
                            <div class="invalid-feedback">Please enter a valid Student ID.</div>
                        </div>

                        <div class="col-md-6">
                            <label for="studentName" class="form-label">Student Name</label>
                            <input type="text" class="form-control" id="studentName" name="studentName" required maxlength="100">
                            <div class="invalid-feedback">Please enter a valid name.</div>
                        </div>

                        <div class="col-md-6">
                            <label for="subject" class="form-label">Subject</label>
                            <select class="form-select" id="subject" name="subject" required>
                                <option value="" selected disabled>Choose...</option>
                                <option value="Mathematics">Mathematics</option>
                                <option value="Physics">Physics</option>
                                <option value="Chemistry">Chemistry</option>
                                <option value="Biology">Biology</option>
                                <option value="Computer Science">Computer Science</option>
                                <option value="English">English</option>
                                <option value="History">History</option>
                                <option value="Geography">Geography</option>
                            </select>
                            <div class="invalid-feedback">Please choose a subject.</div>
                        </div>

                        <div class="col-md-6">
                            <label for="marks" class="form-label">Marks</label>
                            <input type="number" class="form-control" id="marks" name="marks" min="0" max="100" required>
                            <div class="invalid-feedback">Enter marks between 0 and 100.</div>
                        </div>

                        <div class="col-md-6">
                            <label for="examDate" class="form-label">Exam Date</label>
                            <input type="date" class="form-control" id="examDate" name="examDate" required>
                            <div class="invalid-feedback">Please select a valid date.</div>
                        </div>

                        <div class="col-12 d-flex justify-content-end">
                            <button type="submit" class="btn btn-primary me-2">Add Mark</button>
                            <button type="reset" class="btn btn-secondary">Reset</button>
                        </div>
                    </form>

                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        (() => {
            'use strict';
            const forms = document.querySelectorAll('.needs-validation');
            Array.from(forms).forEach(form => {
                form.addEventListener('submit', event => {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        })();

        // Prevent future exam dates
        document.getElementById('examDate').addEventListener('change', function () {
            const selected = new Date(this.value);
            const today = new Date();
            if (selected > today) {
                this.setCustomValidity('Exam date cannot be in the future');
            } else {
                this.setCustomValidity('');
            }
        });
    </script>
</body>
</html>
