<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Users - Daily Expenses</title>
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
        .table-responsive {
            border-radius: 15px;
            overflow: hidden;
        }
        .table th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            font-weight: 600;
        }
        .table td {
            vertical-align: middle;
            border-color: #dee2e6;
        }
        .user-avatar {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
        }
        .search-box {
            border-radius: 25px;
            border: 2px solid #667eea;
            padding: 10px 20px;
        }
        .search-box:focus {
            border-color: #764ba2;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 25px;
            padding: 10px 25px;
        }
        .badge {
            border-radius: 20px;
            padding: 8px 12px;
            font-size: 0.75rem;
        }
        .user-card {
            transition: transform 0.3s ease;
        }
        .user-card:hover {
            transform: translateY(-2px);
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
                        <a class="nav-link active" href="/user/list">
                            <i class="fas fa-users me-1"></i>Users
                        </a>
                    </li>
                </ul>
                
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user-circle me-1"></i>
                            <c:choose>
                                <c:when test="${not empty currentUser.firstName}">
                                    ${currentUser.firstName} ${currentUser.lastName}
                                </c:when>
                                <c:otherwise>
                                    ${currentUser.username}
                                </c:otherwise>
                            </c:choose>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="/user/profile">
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
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-bold text-dark">
                <i class="fas fa-users me-2"></i>Registered Users
            </h2>
            <div class="d-flex gap-2">
                <a href="/user/register" class="btn btn-primary">
                    <i class="fas fa-user-plus me-2"></i>Add User
                </a>
            </div>
        </div>

        <!-- Search and Filters -->
        <div class="card mb-4">
            <div class="card-body">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="fas fa-search"></i>
                            </span>
                            <input type="text" class="form-control search-box" 
                                   placeholder="Search users by name or username..." 
                                   id="searchInput">
                        </div>
                    </div>
                    <div class="col-md-6 text-end">
                        <span class="text-muted">
                            <i class="fas fa-info-circle me-1"></i>
                            Total Users: <strong>${users.size()}</strong>
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Users Table -->
        <div class="card">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead>
                            <tr>
                                <th scope="col">
                                    <i class="fas fa-user me-2"></i>User
                                </th>
                                <th scope="col">
                                    <i class="fas fa-envelope me-2"></i>Email
                                </th>
                                <th scope="col">
                                    <i class="fas fa-phone me-2"></i>Phone
                                </th>
                                <th scope="col">
                                    <i class="fas fa-calendar me-2"></i>Joined
                                </th>
                                <th scope="col">
                                    <i class="fas fa-shield-alt me-2"></i>Status
                                </th>
                                <th scope="col">
                                    <i class="fas fa-cogs me-2"></i>Actions
                                </th>
                            </tr>
                        </thead>
                        <tbody id="usersTableBody">
                            <c:forEach var="user" items="${users}">
                                <tr class="user-row">
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="user-avatar me-3">
                                                <c:choose>
                                                    <c:when test="${not empty user.firstName}">
                                                        ${user.firstName.substring(0,1).toUpperCase()}
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${user.username.substring(0,1).toUpperCase()}
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div>
                                                <div class="fw-bold">
                                                    <c:choose>
                                                        <c:when test="${not empty user.firstName}">
                                                            ${user.firstName} ${user.lastName}
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${user.username}
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <c:if test="${user.id == currentUser.id}">
                                                        <span class="badge bg-primary ms-2">You</span>
                                                    </c:if>
                                                </div>
                                                <small class="text-muted">@${user.username}</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="user-email">${user.email}</span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty user.phoneNumber}">
                                                ${user.phoneNumber}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">-</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${user.createdAt}" pattern="MMM dd, yyyy" />
                                        <br>
                                        <small class="text-muted">
                                            <fmt:formatDate value="${user.createdAt}" pattern="hh:mm a" />
                                        </small>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${user.active}">
                                                <span class="badge bg-success">
                                                    <i class="fas fa-check-circle me-1"></i>Active
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">
                                                    <i class="fas fa-pause-circle me-1"></i>Inactive
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="dropdown">
                                            <button class="btn btn-sm btn-outline-secondary dropdown-toggle" 
                                                    type="button" data-bs-toggle="dropdown">
                                                <i class="fas fa-ellipsis-v"></i>
                                            </button>
                                            <ul class="dropdown-menu">
                                                <li>
                                                    <a class="dropdown-item" href="#" data-user-id="${user.id}">
                                                        <i class="fas fa-eye me-2"></i>View Details
                                                    </a>
                                                </li>
                                                <c:if test="${user.id != currentUser.id}">
                                                    <li><hr class="dropdown-divider"></li>
                                                    <li>
                                                        <a class="dropdown-item text-warning" href="#" data-user-id="${user.id}">
                                                            <i class="fas fa-pause me-2"></i>Deactivate
                                                        </a>
                                                    </li>
                                                </c:if>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Empty State -->
        <c:if test="${empty users}">
            <div class="card">
                <div class="card-body text-center py-5">
                    <i class="fas fa-users fa-4x text-muted mb-4"></i>
                    <h4 class="text-muted">No Users Found</h4>
                    <p class="text-muted mb-4">There are no registered users yet.</p>
                    <a href="/user/register" class="btn btn-primary">
                        <i class="fas fa-user-plus me-2"></i>Add First User
                    </a>
                </div>
            </div>
        </c:if>
    </div>

    <script src="/webjars/bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
    <script>
        // Search functionality
        document.getElementById('searchInput').addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            const userRows = document.querySelectorAll('.user-row');
            
            userRows.forEach(function(row) {
                const userName = row.querySelector('.fw-bold').textContent.toLowerCase();
                const userEmail = row.querySelector('.user-email').textContent.toLowerCase();
                
                if (userName.includes(searchTerm) || userEmail.includes(searchTerm)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });

        // Placeholder for user actions
        document.querySelectorAll('[data-user-id]').forEach(function(element) {
            element.addEventListener('click', function(e) {
                e.preventDefault();
                const userId = this.getAttribute('data-user-id');
                const action = this.textContent.trim();
                
                if (action.includes('View Details')) {
                    alert('View user details functionality - User ID: ' + userId);
                } else if (action.includes('Deactivate')) {
                    if (confirm('Are you sure you want to deactivate this user?')) {
                        alert('Deactivate user functionality - User ID: ' + userId);
                    }
                }
            });
        });
    </script>
</body>
</html>