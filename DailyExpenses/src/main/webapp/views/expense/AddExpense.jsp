<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Expense - Family Expense Tracker</title>
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
        .form-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px 15px 0 0;
            padding: 2rem;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 25px;
            padding: 12px 30px;
            font-weight: 600;
        }
        .btn-outline-secondary {
            border-radius: 25px;
            padding: 12px 30px;
        }
        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .alert {
            border-radius: 15px;
            border: none;
        }
        .category-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            margin-right: 1rem;
        }
        .expense-type-card {
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 1rem;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .expense-type-card:hover {
            border-color: #667eea;
            background-color: #f8f9ff;
        }
        .expense-type-card.active {
            border-color: #667eea;
            background-color: #667eea;
            color: white;
        }
        .quick-amounts {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }
        .quick-amount {
            padding: 0.5rem 1rem;
            border: 1px solid #667eea;
            border-radius: 20px;
            background: white;
            color: #667eea;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .quick-amount:hover {
            background: #667eea;
            color: white;
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
                        <a class="nav-link" href="/expenses/dashboard">
                            <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="/expenses/add">
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
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <!-- Form Header -->
                    <div class="form-header text-center">
                        <i class="fas fa-plus-circle fa-3x mb-3"></i>
                        <h2 class="fw-bold mb-1">Add New Expense</h2>
                        <p class="mb-0">Record a detailed expense with category and description</p>
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

                        <form action="/expenses/add" method="post" id="expenseForm">
                            <!-- Family Member Selection -->
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="familyMemberId" class="form-label">
                                            <i class="fas fa-user me-2"></i>Family Member *
                                        </label>
                                        <select class="form-select" id="familyMemberId" name="familyMemberId" required>
                                            <option value="">Select Family Member</option>
                                            <c:forEach var="member" items="${familyMembers}">
                                                <option value="${member.id}">${member.name} (${member.relationship})</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="expenseDate" class="form-label">
                                            <i class="fas fa-calendar me-2"></i>Date *
                                        </label>
                                        <input type="date" class="form-control" id="expenseDate" name="expenseDate" required>
                                    </div>
                                </div>
                            </div>

                            <!-- Amount and Quick Amounts -->
                            <div class="mb-3">
                                <label for="amount" class="form-label">
                                    <i class="fas fa-rupee-sign me-2"></i>Amount *
                                </label>
                                <input type="number" class="form-control" id="amount" name="amount" 
                                       step="0.01" min="0.01" placeholder="Enter amount" required>
                                <div class="mt-2">
                                    <small class="text-muted">Quick amounts:</small>
                                    <div class="quick-amounts mt-1">
                                        <span class="quick-amount" onclick="setAmount(50)">₹50</span>
                                        <span class="quick-amount" onclick="setAmount(100)">₹100</span>
                                        <span class="quick-amount" onclick="setAmount(200)">₹200</span>
                                        <span class="quick-amount" onclick="setAmount(500)">₹500</span>
                                        <span class="quick-amount" onclick="setAmount(1000)">₹1000</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Category Selection -->
                            <div class="mb-3">
                                <label for="category" class="form-label">
                                    <i class="fas fa-tags me-2"></i>Category *
                                </label>
                                <select class="form-select" id="category" name="category" required>
                                    <option value="">Select Category</option>
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat}">${cat}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Description -->
                            <div class="mb-3">
                                <label for="description" class="form-label">
                                    <i class="fas fa-comment me-2"></i>Description
                                </label>
                                <textarea class="form-control" id="description" name="description" 
                                          rows="3" placeholder="Enter expense description (optional)"></textarea>
                            </div>

                            <!-- Payment Method -->
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="paymentMethod" class="form-label">
                                            <i class="fas fa-credit-card me-2"></i>Payment Method
                                        </label>
                                        <select class="form-select" id="paymentMethod" name="paymentMethod">
                                            <option value="">Select Payment Method</option>
                                            <c:forEach var="method" items="${paymentMethods}">
                                                <option value="${method}">${method}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="expenseType" class="form-label">
                                            <i class="fas fa-flag me-2"></i>Expense Type
                                        </label>
                                        <select class="form-select" id="expenseType" name="expenseType">
                                            <option value="PERSONAL">Personal</option>
                                            <option value="FAMILY_SHARED">Family Shared</option>
                                            <option value="HOUSEHOLD">Household</option>
                                            <option value="EMERGENCY">Emergency</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <!-- Recurring Expense -->
                            <div class="mb-3">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="isRecurring" name="recurring">
                                    <label class="form-check-label" for="isRecurring">
                                        <i class="fas fa-repeat me-2"></i>This is a recurring expense
                                    </label>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <div class="d-flex justify-content-between">
                                <a href="/expenses/dashboard" class="btn btn-outline-secondary">
                                    <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                                </a>
                                <div>
                                    <button type="button" class="btn btn-outline-primary me-2" onclick="resetForm()">
                                        <i class="fas fa-redo me-2"></i>Reset
                                    </button>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save me-2"></i>Add Expense
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Category Quick Reference -->
                <div class="card mt-4">
                    <div class="card-header">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-lightbulb me-2"></i>Category Quick Reference
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h6><i class="fas fa-utensils me-2"></i>Food & Dining</h6>
                                <small class="text-muted">Restaurants, fast food, dining out</small>
                                
                                <h6 class="mt-3"><i class="fas fa-car me-2"></i>Transportation</h6>
                                <small class="text-muted">Fuel, taxi, public transport, parking</small>
                                
                                <h6 class="mt-3"><i class="fas fa-shopping-bag me-2"></i>Shopping</h6>
                                <small class="text-muted">Clothing, electronics, personal items</small>
                                
                                <h6 class="mt-3"><i class="fas fa-film me-2"></i>Entertainment</h6>
                                <small class="text-muted">Movies, games, hobbies, recreation</small>
                            </div>
                            <div class="col-md-6">
                                <h6><i class="fas fa-heartbeat me-2"></i>Healthcare</h6>
                                <small class="text-muted">Medical, pharmacy, doctor visits</small>
                                
                                <h6 class="mt-3"><i class="fas fa-file-invoice me-2"></i>Bills & Utilities</h6>
                                <small class="text-muted">Electricity, water, phone, internet</small>
                                
                                <h6 class="mt-3"><i class="fas fa-graduation-cap me-2"></i>Education</h6>
                                <small class="text-muted">Books, courses, school fees</small>
                                
                                <h6 class="mt-3"><i class="fas fa-shopping-cart me-2"></i>Groceries</h6>
                                <small class="text-muted">Food items, household supplies</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="/webjars/bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
    <script>
        // Set today's date as default
        document.getElementById('expenseDate').value = new Date().toISOString().split('T')[0];

        // Quick amount selection
        function setAmount(amount) {
            document.getElementById('amount').value = amount;
        }

        // Reset form
        function resetForm() {
            document.getElementById('expenseForm').reset();
            document.getElementById('expenseDate').value = new Date().toISOString().split('T')[0];
        }

        // Form validation
        document.getElementById('expenseForm').addEventListener('submit', function(e) {
            const familyMemberId = document.getElementById('familyMemberId').value;
            const amount = document.getElementById('amount').value;
            const category = document.getElementById('category').value;
            const date = document.getElementById('expenseDate').value;
            
            if (!familyMemberId || !amount || !category || !date) {
                e.preventDefault();
                alert('Please fill in all required fields!');
                return false;
            }
            
            if (parseFloat(amount) <= 0) {
                e.preventDefault();
                alert('Please enter a valid amount!');
                return false;
            }

            // Show loading state
            const submitButton = document.querySelector('button[type="submit"]');
            submitButton.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Adding...';
            submitButton.disabled = true;
        });

        // Auto-dismiss alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);

        // Category-based description suggestions
        document.getElementById('category').addEventListener('change', function() {
            const category = this.value;
            const descriptionField = document.getElementById('description');
            
            const suggestions = {
                'Food & Dining': 'Restaurant bill, lunch, dinner...',
                'Transportation': 'Fuel, taxi fare, bus ticket...',
                'Shopping': 'Clothes, electronics, books...',
                'Entertainment': 'Movie tickets, games, music...',
                'Healthcare': 'Medicine, doctor visit, checkup...',
                'Bills & Utilities': 'Electricity bill, phone bill...',
                'Education': 'School fees, books, courses...',
                'Groceries': 'Vegetables, milk, rice...',
                'Travel': 'Hotel, flight, train ticket...',
                'Personal Care': 'Haircut, cosmetics, salon...'
            };
            
            if (suggestions[category]) {
                descriptionField.placeholder = suggestions[category];
            } else {
                descriptionField.placeholder = 'Enter expense description (optional)';
            }
        });
    </script>
</body>
</html>