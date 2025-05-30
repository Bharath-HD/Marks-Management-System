<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Mark Management System</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Bootstrap CSS & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f6f8;
        }
        .sidebar {
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            width: 240px;
            background-color: #343a40;
            padding-top: 60px;
        }
        .sidebar .nav-link {
            color: #fff;
            font-weight: 500;
            padding: 15px 20px;
        }
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            background-color: #495057;
            border-left: 5px solid #0d6efd;
            color: #fff;
        }
        .main-content {
            margin-left: 250px;
            padding: 40px 30px;
        }
        .feature-card {
            transition: transform 0.2s ease;
        }
        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>

    <!-- Sidebar Navigation -->
    <div class="sidebar d-flex flex-column position-fixed">
        <h4 class="text-white text-center mb-4">Student System</h4>
        <a class="nav-link active" href="index.jsp"><i class="bi bi-house-door me-2"></i> Home</a>
        <a class="nav-link" href="markadd.jsp"><i class="bi bi-plus-circle me-2"></i> Add Marks</a>
        <a class="nav-link" href="markupdate.jsp"><i class="bi bi-pencil-square me-2"></i> Update Marks</a>
        <a class="nav-link" href="markdelete.jsp"><i class="bi bi-trash me-2"></i> Delete Marks</a>
        <a class="nav-link" href="DisplayMarksServlet"><i class="bi bi-table me-2"></i> Display Marks</a>
        <a class="nav-link" href="report_form.jsp"><i class="bi bi-bar-chart-line me-2"></i> Reports</a>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="container-fluid">
            <div class="text-center mb-5">
                <h1 class="display-5 fw-bold">Student Mark Management System</h1>
                <p class="text-muted">Manage, update, and analyze student performance efficiently</p>
            </div>

            <div class="row g-4">
                <!-- Add Marks -->
                <div class="col-md-4">
                    <div class="card feature-card text-center p-4">
                        <div class="card-body">
                            <div class="fs-1 text-primary mb-3"><i class="bi bi-pencil-square"></i></div>
                            <h5>Add Marks</h5>
                            <p>Add new student records easily.</p>
                            <a href="markadd.jsp" class="btn btn-outline-primary btn-sm">Go</a>
                        </div>
                    </div>
                </div>
                <!-- Update Marks -->
                <div class="col-md-4">
                    <div class="card feature-card text-center p-4">
                        <div class="card-body">
                            <div class="fs-1 text-warning mb-3"><i class="bi bi-arrow-repeat"></i></div>
                            <h5>Update Marks</h5>
                            <p>Make changes to existing records.</p>
                            <a href="markupdate.jsp" class="btn btn-outline-warning btn-sm">Go</a>
                        </div>
                    </div>
                </div>
                <!-- Delete Marks -->
                <div class="col-md-4">
                    <div class="card feature-card text-center p-4">
                        <div class="card-body">
                            <div class="fs-1 text-danger mb-3"><i class="bi bi-x-circle"></i></div>
                            <h5>Delete Marks</h5>
                            <p>Remove records permanently.</p>
                            <a href="markdelete.jsp" class="btn btn-outline-danger btn-sm">Go</a>
                        </div>
                    </div>
                </div>
                <!-- Display Marks -->
                <div class="col-md-4">
                    <div class="card feature-card text-center p-4">
                        <div class="card-body">
                            <div class="fs-1 text-info mb-3"><i class="bi bi-layout-text-window-reverse"></i></div>
                            <h5>Display Marks</h5>
                            <p>Search or view all student data.</p>
                            <a href="DisplayMarksServlet" class="btn btn-outline-info btn-sm">Go</a>
                        </div>
                    </div>
                </div>
                <!-- Reports -->
                <div class="col-md-4">
                    <div class="card feature-card text-center p-4">
                        <div class="card-body">
                            <div class="fs-1 text-success mb-3"><i class="bi bi-graph-up-arrow"></i></div>
                            <h5>Generate Reports</h5>
                            <p>Analyze student performance trends.</p>
                            <a href="report_form.jsp" class="btn btn-outline-success btn-sm">Go</a>
                        </div>
                    </div>
                </div>
                <!-- About Modal Trigger -->
                <div class="col-md-4">
                    <div class="card feature-card text-center p-4">
                        <div class="card-body">
                            <div class="fs-1 text-secondary mb-3"><i class="bi bi-info-circle"></i></div>
                            <h5>About System</h5>
                            <p>Learn about how this system works.</p>
                            <button class="btn btn-outline-secondary btn-sm" data-bs-toggle="modal" data-bs-target="#aboutModal">More</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- About Modal -->
    <div class="modal fade" id="aboutModal" tabindex="-1" aria-labelledby="aboutModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">About This System</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>This system manages student exam marks using JSP, Servlets, and JDBC. It follows the MVC architecture for clean code separation and maintainability.</p>
                    <ul>
                        <li>Add, update, delete student marks</li>
                        <li>Search and display records</li>
                        <li>Generate detailed reports</li>
                    </ul>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
