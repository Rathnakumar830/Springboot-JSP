<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Family Expense Dashboard</title>
    <link href="/webjars/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
            transition: transform 0.3s ease;
        }
        .card:hover {
            transform: translateY(-3px);
        }
        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .expense-card {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }
        .budget-card {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            color: white;
        }
        .family-card {
            background: linear-gradient(135deg, #17a2b8 0%, #6f42c1 100%);
            color: white;
        }
        .welcome-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 25px;
            padding: 10px 25px;
        }
        .progress-circle {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin: 0 auto;
        }
        .chart-container {
            position: relative;
            height: 400px;
        }
        .recent-activity {
            max-height: 400px;
            overflow-y: auto;
        }
        .expense-item {
            border-left: 4px solid #667eea;
            padding: 1rem;
            margin-bottom: 0.5rem;
            background: white;
            border-radius: 0 10px 10px 0;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand fw-bold" href="/">
                <i class="fas fa-chart-line me-2"></i>Family Expense Tracker
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="/expenses/dashboard">
                            <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/expenses/add">
                            <i class="fas fa-plus-circle me-1"></i>Add Expense
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/expenses/monthly-report">
                            <i class="fas fa-chart-bar me-1"></i>Monthly Report
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/expenses/family-summary">
                            <i class="fas fa-users me-1"></i>Family Summary
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/expenses/budget-planning">
                            <i class="fas fa-calculator me-1"></i>Budget Planning
                        </a>
                    </li>
                </ul>
                
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="/">
                            <i class="fas fa-home me-1"></i>Home
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container mt-4">
        <!-- Welcome Section -->
        <div class="welcome-section">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="display-6 fw-bold mb-2">
                        <i class="fas fa-home me-3"></i>Family Expense Dashboard
                    </h1>
                    <p class="lead mb-0">
                        Track and analyze your family's spending patterns for 
                        <strong><fmt:formatDate value="${currentMonth}" pattern="MMMM yyyy" /></strong>
                    </p>
                </div>
                <div class="col-md-4 text-center">
                    <i class="fas fa-chart-pie fa-5x opacity-50"></i>
                </div>
            </div>
        </div>

        <!-- Stats Cards -->
        <div class="row mb-4">
            <div class="col-md-3 mb-3">
                <div class="card stats-card">
                    <div class="card-body text-center">
                        <i class="fas fa-users fa-2x mb-2"></i>
                        <h3 class="fw-bold">${summary.totalFamilyMembers}</h3>
                        <p class="mb-0">Family Members</p>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3 mb-3">
                <div class="card expense-card">
                    <div class="card-body text-center">
                        <i class="fas fa-calendar-day fa-2x mb-2"></i>
                        <h3 class="fw-bold">₹<fmt:formatNumber value="${summary.todayTotal}" pattern="#,##0.00"/></h3>
                        <p class="mb-0">Today's Expenses</p>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3 mb-3">
                <div class="card budget-card">
                    <div class="card-body text-center">
                        <i class="fas fa-calendar-alt fa-2x mb-2"></i>
                        <h3 class="fw-bold">₹<fmt:formatNumber value="${summary.currentMonthTotal}" pattern="#,##0.00"/></h3>
                        <p class="mb-0">This Month</p>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3 mb-3">
                <div class="card family-card">
                    <div class="card-body text-center">
                        <i class="fas fa-wallet fa-2x mb-2"></i>
                        <h3 class="fw-bold">₹<fmt:formatNumber value="${summary.totalBudget}" pattern="#,##0.00"/></h3>
                        <p class="mb-0">Total Budget</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Budget Analysis and Charts -->
        <div class="row mb-4">
            <!-- Budget vs Actual -->
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-balance-scale me-2"></i>Budget vs Actual
                        </h5>
                    </div>
                    <div class="card-body">
                        <c:forEach var="analysis" items="${budgetAnalysis}">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <div>
                                    <strong>${analysis.name}</strong>
                                    <br>
                                    <small class="text-muted">
                                        ₹<fmt:formatNumber value="${analysis.actualSpent}" pattern="#,##0"/> / 
                                        ₹<fmt:formatNumber value="${analysis.budget}" pattern="#,##0"/>
                                    </small>
                                </div>
                                <div class="text-end">
                                    <div class="progress-circle ${analysis.isOverBudget ? 'bg-danger' : 'bg-success'}" 
                                         style="width: 60px; height: 60px; font-size: 0.8rem;">
                                        <fmt:formatNumber value="${analysis.percentageUsed}" pattern="#0"/>%
                                    </div>
                                </div>
                            </div>
                            <div class="progress mb-3" style="height: 8px;">
                                <div class="progress-bar ${analysis.isOverBudget ? 'bg-danger' : 'bg-success'}" 
                                     role="progressbar" 
                                     style="width: ${analysis.percentageUsed > 100 ? 100 : analysis.percentageUsed}%">
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <!-- Category Chart -->
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-chart-pie me-2"></i>Expense Categories
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="chart-container">
                            <canvas id="categoryChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Activity and Quick Actions -->
        <div class="row">
            <!-- Recent Expenses -->
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-history me-2"></i>Recent Expenses
                        </h5>
                        <a href="/expenses/list" class="btn btn-sm btn-outline-primary">View All</a>
                    </div>
                    <div class="card-body recent-activity">
                        <c:choose>
                            <c:when test="${not empty summary.recentExpenses}">
                                <c:forEach var="expense" items="${summary.recentExpenses}">
                                    <div class="expense-item">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div>
                                                <strong>${expense.familyMember.name}</strong>
                                                <span class="badge bg-primary ms-2">${expense.category}</span>
                                                <br>
                                                <small class="text-muted">${expense.description}</small>
                                                <br>
                                                <small class="text-muted">
                                                    <i class="fas fa-calendar me-1"></i>
                                                    <fmt:formatDate value="${expense.expenseDate}" pattern="MMM dd, yyyy"/>
                                                </small>
                                            </div>
                                            <div class="text-end">
                                                <h6 class="mb-0 text-success">₹<fmt:formatNumber value="${expense.amount}" pattern="#,##0.00"/></h6>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-4">
                                    <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                    <h6 class="text-muted">No recent expenses</h6>
                                    <p class="text-muted">Start adding expenses to see them here</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <!-- Quick Actions -->
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-bolt me-2"></i>Quick Actions
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="d-grid gap-2">
                            <a href="/expenses/add" class="btn btn-primary">
                                <i class="fas fa-plus-circle me-2"></i>Add New Expense
                            </a>
                            <a href="/expenses/monthly-report" class="btn btn-outline-primary">
                                <i class="fas fa-chart-bar me-2"></i>Monthly Report
                            </a>
                            <a href="/expenses/budget-planning" class="btn btn-outline-primary">
                                <i class="fas fa-calculator me-2"></i>Budget Planning
                            </a>
                            <a href="/" class="btn btn-outline-secondary">
                                <i class="fas fa-home me-2"></i>Back to Home
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Family Members Quick View -->
                <div class="card mt-3">
                    <div class="card-header">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-users me-2"></i>Family Members
                        </h5>
                    </div>
                    <div class="card-body">
                        <c:forEach var="member" items="${familyMembers}">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <div>
                                    <strong>${member.name}</strong>
                                    <br>
                                    <small class="text-muted">${member.relationship}</small>
                                </div>
                                <div class="text-end">
                                    <small class="text-muted">Budget:</small>
                                    <br>
                                    <strong>₹<fmt:formatNumber value="${member.monthlyBudget}" pattern="#,##0"/></strong>
                                </div>
                            </div>
                            <hr class="my-2">
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="/webjars/bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
    <script>
        // Category Chart
        const categoryData = {
            <c:forEach var="category" items="${summary.topCategories}" varStatus="status">
                '${category.key}': ${category.value}<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        };

        const ctx = document.getElementById('categoryChart').getContext('2d');
        const categoryChart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: Object.keys(categoryData),
                datasets: [{
                    data: Object.values(categoryData),
                    backgroundColor: [
                        '#667eea', '#764ba2', '#28a745', '#ffc107', 
                        '#dc3545', '#17a2b8', '#6f42c1', '#fd7e14',
                        '#20c997', '#e83e8c', '#6c757d', '#495057'
                    ],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });
    </script>
</body>
</html>