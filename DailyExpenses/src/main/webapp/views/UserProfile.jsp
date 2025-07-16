<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - Daily Expenses</title>
    <link href="/webjars/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            box-shadow: 0 2px 4px rgba(0,0,0,.1);
        }
        .card {
            border-radius: 15px;
            border: none;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        .profile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px 15px 0 0;
            padding: 2rem;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 25px;
            padding: 10px 25px;
        }
        .btn-outline-secondary {
            border-radius: 25px;
            padding: 10px 25px;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .alert {
            border-radius: 15px;
            border: none;
        }
        .avatar-placeholder {
            width: 100px;
            height: 100px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            margin: 0 auto 1rem;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand fw-bold" href="/user/dashboard">
                <i class="fas fa-chart-line me-2"></i>Daily Expenses
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="/user/dashboard">
                            <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/">
                            <i class="fas fa-plus-circle me-1"></i>Add Expense
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/user/list">
                            <i class="fas fa-users me-1"></i>Users
                        </a>
                    </li>
                </ul>
                
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user-circle me-1"></i>
                            <c:choose>
                                <c:when test="${not empty user.firstName}">
                                    ${user.firstName} ${user.lastName}
                                </c:when>
                                <c:otherwise>
                                    ${user.username}
                                </c:otherwise>
                            </c:choose>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item active" href="/user/profile">
                                <i class="fas fa-user me-2"></i>Profile
                            </a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="/user/logout">
                                <i class="fas fa-sign-out-alt me-2"></i>Logout
                            </a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <!-- Profile Header -->
                    <div class="profile-header text-center">
                        <div class="avatar-placeholder">
                            <i class="fas fa-user"></i>
                        </div>
                        <h2 class="fw-bold mb-1">
                            <c:choose>
                                <c:when test="${not empty user.firstName}">
                                    ${user.firstName} ${user.lastName}
                                </c:when>
                                <c:otherwise>
                                    ${user.username}
                                </c:otherwise>
                            </c:choose>
                        </h2>
                        <p class="mb-1">${user.email}</p>
                        <small class="opacity-75">
                            Member since: <fmt:formatDate value="${user.createdAt}" pattern="MMM dd, yyyy" />
                        </small>
                    </div>

                    <div class="card-body p-4">
                        <!-- Display messages -->
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success" role="alert">
                                <i class="fas fa-check-circle me-2"></i>${successMessage}
                            </div>
                        </c:if>

                        <form action="/user/profile" method="post">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="firstName" class="form-label">
                                            <i class="fas fa-user me-2"></i>First Name
                                        </label>
                                        <input type="text" class="form-control" id="firstName" name="firstName" 
                                               value="${user.firstName}" placeholder="Enter first name">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="lastName" class="form-label">
                                            <i class="fas fa-user me-2"></i>Last Name
                                        </label>
                                        <input type="text" class="form-control" id="lastName" name="lastName" 
                                               value="${user.lastName}" placeholder="Enter last name">
                                    </div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="username" class="form-label">
                                    <i class="fas fa-at me-2"></i>Username
                                </label>
                                <input type="text" class="form-control" id="username" value="${user.username}" disabled>
                                <small class="form-text text-muted">Username cannot be changed</small>
                            </div>

                            <div class="mb-3">
                                <label for="email" class="form-label">
                                    <i class="fas fa-envelope me-2"></i>Email Address
                                </label>
                                <input type="email" class="form-control" id="email" value="${user.email}" disabled>
                                <small class="form-text text-muted">Email cannot be changed</small>
                            </div>

                            <div class="mb-3">
                                <label for="phoneNumber" class="form-label">
                                    <i class="fas fa-phone me-2"></i>Phone Number
                                </label>
                                <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" 
                                       value="${user.phoneNumber}" placeholder="Enter phone number">
                            </div>

                            <hr class="my-4">

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">
                                            <i class="fas fa-calendar me-2"></i>Account Created
                                        </label>
                                        <p class="form-control-plaintext">
                                            <fmt:formatDate value="${user.createdAt}" pattern="MMM dd, yyyy 'at' hh:mm a" />
                                        </p>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">
                                            <i class="fas fa-edit me-2"></i>Last Updated
                                        </label>
                                        <p class="form-control-plaintext">
                                            <fmt:formatDate value="${user.updatedAt}" pattern="MMM dd, yyyy 'at' hh:mm a" />
                                        </p>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">
                                    <i class="fas fa-shield-alt me-2"></i>Account Status
                                </label>
                                <p class="form-control-plaintext">
                                    <span class="badge bg-success fs-6">
                                        <i class="fas fa-check-circle me-1"></i>Active
                                    </span>
                                </p>
                            </div>

                            <div class="d-flex justify-content-between">
                                <a href="/user/dashboard" class="btn btn-outline-secondary">
                                    <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-2"></i>Update Profile
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Additional Options -->
                <div class="row mt-4">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-body text-center">
                                <i class="fas fa-key fa-2x text-warning mb-3"></i>
                                <h6>Change Password</h6>
                                <p class="text-muted small">Update your account password</p>
                                <button class="btn btn-outline-warning btn-sm" disabled>
                                    Coming Soon
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-body text-center">
                                <i class="fas fa-trash-alt fa-2x text-danger mb-3"></i>
                                <h6>Delete Account</h6>
                                <p class="text-muted small">Permanently remove your account</p>
                                <button class="btn btn-outline-danger btn-sm" disabled>
                                    Coming Soon
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="/webjars/bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto-dismiss alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>
</body>
</html>