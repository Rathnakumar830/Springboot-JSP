<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Family Expense Tracker</title>
<link href="/webjars/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style>
body {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.main-container {
    background: rgba(255, 255, 255, 0.95);
    border-radius: 20px;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
    backdrop-filter: blur(10px);
    margin-top: 2rem;
    padding: 2rem;
}

.header-section {
    text-align: center;
    margin-bottom: 2rem;
}

.header-section h1 {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    font-weight: bold;
    font-size: 2.5rem;
    margin-bottom: 0.5rem;
}

.header-section p {
    color: #666;
    font-size: 1.1rem;
}

.card {
    border: none;
    border-radius: 15px;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
    transition: transform 0.3s ease;
}

.card:hover {
    transform: translateY(-5px);
}

.btn-primary {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border: none;
    border-radius: 25px;
    padding: 12px 30px;
    font-weight: 600;
    transition: all 0.3s ease;
}

.btn-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
}

.btn-outline-primary {
    border: 2px solid #667eea;
    color: #667eea;
    border-radius: 25px;
    padding: 12px 30px;
    font-weight: 600;
}

.form-control:focus {
    border-color: #667eea;
    box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
}

.quick-actions {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 1rem;
    margin-top: 2rem;
}

.action-card {
    background: white;
    border-radius: 15px;
    padding: 1.5rem;
    text-align: center;
    text-decoration: none;
    color: inherit;
    transition: all 0.3s ease;
    border: 2px solid transparent;
}

.action-card:hover {
    transform: translateY(-3px);
    border-color: #667eea;
    text-decoration: none;
    color: inherit;
}

.action-card i {
    font-size: 2.5rem;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    margin-bottom: 1rem;
}

.legacy-section {
    background: #f8f9fa;
    border-radius: 15px;
    padding: 1.5rem;
    margin-top: 2rem;
    border-left: 4px solid #667eea;
}
</style>
</head>
<body>
    <div class="container">
        <div class="main-container">
            <!-- Header Section -->
            <div class="header-section">
                <h1><i class="fas fa-chart-line me-3"></i>Family Expense Tracker</h1>
                <p>Track daily expenses for each family member and plan your monthly budget</p>
            </div>

            <!-- Quick Add Expense Form -->
            <div class="row">
                <div class="col-lg-6 mx-auto">
                    <div class="card">
                        <div class="card-header bg-gradient" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border-radius: 15px 15px 0 0;">
                            <h5 class="mb-0">
                                <i class="fas fa-plus-circle me-2"></i>Quick Add Expense
                            </h5>
                        </div>
                        <div class="card-body">
                            <form action="/redirect/saveData" method="POST">
                                <div class="mb-3">
                                    <label for="name" class="form-label">
                                        <i class="fas fa-user me-2"></i>Family Member
                                    </label>
                                    <select class="form-control" id="name" name="name" required>
                                        <option value="">Select Family Member</option>
                                        <c:forEach var="member" items="${familyMembers}">
                                            <option value="${member.name}">${member.name} (${member.relationship})</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label for="sdate" class="form-label">
                                        <i class="fas fa-calendar me-2"></i>Date
                                    </label>
                                    <input class="form-control" id="sdate" name="sdate" type="date" required>
                                </div>

                                <div class="mb-3">
                                    <label for="amount" class="form-label">
                                        <i class="fas fa-rupee-sign me-2"></i>Amount
                                    </label>
                                    <input class="form-control" id="amount" name="amount" type="number" 
                                           step="0.01" placeholder="Enter amount" required>
                                </div>

                                <div class="d-grid gap-2">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save me-2"></i>Add Expense
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="quick-actions">
                <a href="/expenses/dashboard" class="action-card">
                    <i class="fas fa-tachometer-alt"></i>
                    <h5>Expense Dashboard</h5>
                    <p>View comprehensive expense analytics and summaries</p>
                </a>

                <a href="/expenses/add" class="action-card">
                    <i class="fas fa-plus-square"></i>
                    <h5>Add Detailed Expense</h5>
                    <p>Add expenses with categories and descriptions</p>
                </a>

                <a href="/expenses/monthly-report" class="action-card">
                    <i class="fas fa-chart-bar"></i>
                    <h5>Monthly Reports</h5>
                    <p>View monthly expense reports by family member</p>
                </a>

                <a href="/expenses/family-summary" class="action-card">
                    <i class="fas fa-users"></i>
                    <h5>Family Summary</h5>
                    <p>See overall family expense trends and comparisons</p>
                </a>

                <a href="/expenses/budget-planning" class="action-card">
                    <i class="fas fa-calculator"></i>
                    <h5>Budget Planning</h5>
                    <p>Set and track monthly budgets for each member</p>
                </a>

                <a href="/expenses/list" class="action-card">
                    <i class="fas fa-list"></i>
                    <h5>View All Expenses</h5>
                    <p>Browse and search through all recorded expenses</p>
                </a>
            </div>

            <!-- Legacy System Access -->
            <div class="legacy-section">
                <h6><i class="fas fa-history me-2"></i>Legacy System</h6>
                <p class="mb-3">Access the original simple reporting system:</p>
                <form action="/getDataAll" method="GET" class="d-inline">
                    <button type="submit" class="btn btn-outline-primary">
                        <i class="fas fa-file-alt me-2"></i>View Legacy Report
                    </button>
                </form>
            </div>
        </div>
    </div>

    <script src="/webjars/bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
    <script>
        // Set today's date as default
        document.getElementById('sdate').value = new Date().toISOString().split('T')[0];
        
        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const name = document.getElementById('name').value;
            const amount = document.getElementById('amount').value;
            const date = document.getElementById('sdate').value;
            
            if (!name || !amount || !date) {
                e.preventDefault();
                alert('Please fill in all required fields!');
                return false;
            }
            
            if (parseFloat(amount) <= 0) {
                e.preventDefault();
                alert('Please enter a valid amount!');
                return false;
            }
        });
    </script>
</body>
</html>