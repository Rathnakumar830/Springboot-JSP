package com.expense.app.services;

import com.expense.app.entities.Expense;
import com.expense.app.entities.FamilyMember;
import com.expense.app.repos.ExpenseRepository;
import com.expense.app.repos.FamilyMemberRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class ExpenseService {

    @Autowired
    private ExpenseRepository expenseRepository;

    @Autowired
    private FamilyMemberRepository familyMemberRepository;

    // Basic CRUD Operations
    public Expense createExpense(Expense expense) {
        expense.setCreatedAt(LocalDateTime.now());
        expense.setUpdatedAt(LocalDateTime.now());
        return expenseRepository.save(expense);
    }

    public Expense createExpense(Long familyMemberId, Double amount, String category, 
                               String description, LocalDate expenseDate) {
        Optional<FamilyMember> familyMember = familyMemberRepository.findById(familyMemberId);
        if (!familyMember.isPresent()) {
            throw new RuntimeException("Family member not found");
        }

        Expense expense = new Expense();
        expense.setFamilyMember(familyMember.get());
        expense.setAmount(amount);
        expense.setCategory(category);
        expense.setDescription(description);
        expense.setExpenseDate(expenseDate != null ? expenseDate : LocalDate.now());

        return createExpense(expense);
    }

    public Optional<Expense> getExpenseById(Long id) {
        return expenseRepository.findById(id);
    }

    public List<Expense> getAllExpenses() {
        return expenseRepository.findAll();
    }

    public Expense updateExpense(Expense expense) {
        expense.setUpdatedAt(LocalDateTime.now());
        return expenseRepository.save(expense);
    }

    public void deleteExpense(Long id) {
        expenseRepository.deleteById(id);
    }

    // Monthly Expense Analysis
    public List<Expense> getMonthlyExpenses(Long familyMemberId, int year, int month) {
        return expenseRepository.findMonthlyExpensesByFamilyMember(familyMemberId, year, month);
    }

    public Double getMonthlyTotal(Long familyMemberId, int year, int month) {
        Double total = expenseRepository.getMonthlyTotalByFamilyMember(familyMemberId, year, month);
        return total != null ? total : 0.0;
    }

    public Double getFamilyMonthlyTotal(int year, int month) {
        Double total = expenseRepository.getFamilyMonthlyTotal(year, month);
        return total != null ? total : 0.0;
    }

    // Current month convenience methods
    public List<Expense> getCurrentMonthExpenses(Long familyMemberId) {
        YearMonth currentMonth = YearMonth.now();
        return getMonthlyExpenses(familyMemberId, currentMonth.getYear(), currentMonth.getMonthValue());
    }

    public Double getCurrentMonthTotal(Long familyMemberId) {
        YearMonth currentMonth = YearMonth.now();
        return getMonthlyTotal(familyMemberId, currentMonth.getYear(), currentMonth.getMonthValue());
    }

    public Double getCurrentFamilyMonthlyTotal() {
        YearMonth currentMonth = YearMonth.now();
        return getFamilyMonthlyTotal(currentMonth.getYear(), currentMonth.getMonthValue());
    }

    // Category-wise Analysis
    public Map<String, Double> getMonthlyCategoryExpenses(Long familyMemberId, int year, int month) {
        List<Object[]> results = expenseRepository.getMonthlyCategoryWiseExpenses(familyMemberId, year, month);
        Map<String, Double> categoryMap = new LinkedHashMap<>();
        
        for (Object[] result : results) {
            String category = (String) result[0];
            Double amount = (Double) result[1];
            categoryMap.put(category, amount);
        }
        
        return categoryMap;
    }

    public Map<String, Double> getFamilyCategoryExpenses(int year, int month) {
        List<Object[]> results = expenseRepository.getFamilyCategoryWiseExpenses(year, month);
        Map<String, Double> categoryMap = new LinkedHashMap<>();
        
        for (Object[] result : results) {
            String category = (String) result[0];
            Double amount = (Double) result[1];
            categoryMap.put(category, amount);
        }
        
        return categoryMap;
    }

    // Daily Expense Tracking
    public List<Expense> getTodayExpenses() {
        return expenseRepository.getDailyExpenses(LocalDate.now());
    }

    public Double getTodayTotal() {
        Double total = expenseRepository.getDailyTotal(LocalDate.now());
        return total != null ? total : 0.0;
    }

    public List<Expense> getDailyExpenses(LocalDate date) {
        return expenseRepository.getDailyExpenses(date);
    }

    // Budget vs Actual Analysis
    public List<Map<String, Object>> getBudgetAnalysis(int year, int month) {
        List<Object[]> results = expenseRepository.getBudgetVsActualComparison(year, month);
        List<Map<String, Object>> analysis = new ArrayList<>();
        
        for (Object[] result : results) {
            Map<String, Object> memberAnalysis = new HashMap<>();
            memberAnalysis.put("name", result[0]);
            memberAnalysis.put("budget", result[1] != null ? result[1] : 0.0);
            memberAnalysis.put("actualSpent", result[2] != null ? result[2] : 0.0);
            
            Double budget = (Double) memberAnalysis.get("budget");
            Double spent = (Double) memberAnalysis.get("actualSpent");
            memberAnalysis.put("remaining", budget - spent);
            memberAnalysis.put("percentageUsed", budget > 0 ? (spent / budget) * 100 : 0);
            memberAnalysis.put("isOverBudget", spent > budget);
            
            analysis.add(memberAnalysis);
        }
        
        return analysis;
    }

    // Family Member Expense Summary
    public Map<String, Double> getMonthlyFamilyMemberExpenses(int year, int month) {
        List<Object[]> results = expenseRepository.getMonthlyExpensesByFamilyMember(year, month);
        Map<String, Double> memberExpenses = new LinkedHashMap<>();
        
        for (Object[] result : results) {
            String name = (String) result[0];
            Double amount = (Double) result[1];
            memberExpenses.put(name, amount);
        }
        
        return memberExpenses;
    }

    // Recent Expenses
    public List<Expense> getRecentExpenses(int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return expenseRepository.findRecentExpenses().stream()
                .limit(limit)
                .collect(Collectors.toList());
    }

    public List<Expense> getRecentExpensesByFamilyMember(Long familyMemberId, int limit) {
        return expenseRepository.findRecentExpensesByFamilyMember(familyMemberId).stream()
                .limit(limit)
                .collect(Collectors.toList());
    }

    // Search Functionality
    public List<Expense> searchExpenses(String searchTerm) {
        return expenseRepository.searchExpenses(searchTerm);
    }

    // Date Range Analysis
    public List<Expense> getExpensesByDateRange(Long familyMemberId, LocalDate startDate, LocalDate endDate) {
        Optional<FamilyMember> familyMember = familyMemberRepository.findById(familyMemberId);
        if (!familyMember.isPresent()) {
            throw new RuntimeException("Family member not found");
        }
        
        return expenseRepository.findByExpenseDateBetween(startDate, endDate).stream()
                .filter(expense -> expense.getFamilyMember().getId().equals(familyMemberId))
                .collect(Collectors.toList());
    }

    public Double getTotalByDateRange(Long familyMemberId, LocalDate startDate, LocalDate endDate) {
        Double total = expenseRepository.getTotalExpensesByFamilyMemberAndDateRange(familyMemberId, startDate, endDate);
        return total != null ? total : 0.0;
    }

    // Top Categories Analysis
    public List<Map<String, Object>> getTopCategories(int year, int month, int limit) {
        List<Object[]> results = expenseRepository.getTopCategoriesWithStats(year, month);
        List<Map<String, Object>> topCategories = new ArrayList<>();
        
        int count = 0;
        for (Object[] result : results) {
            if (count >= limit) break;
            
            Map<String, Object> categoryStats = new HashMap<>();
            categoryStats.put("category", result[0]);
            categoryStats.put("transactionCount", result[1]);
            categoryStats.put("totalAmount", result[2]);
            
            topCategories.add(categoryStats);
            count++;
        }
        
        return topCategories;
    }

    // Summary Statistics
    public Map<String, Object> getExpenseSummary() {
        Map<String, Object> summary = new HashMap<>();
        YearMonth currentMonth = YearMonth.now();
        
        summary.put("totalFamilyMembers", familyMemberRepository.countActiveFamilyMembers());
        summary.put("currentMonthTotal", getCurrentFamilyMonthlyTotal());
        summary.put("todayTotal", getTodayTotal());
        summary.put("totalBudget", familyMemberRepository.getTotalFamilyBudget());
        
        List<Expense> recentExpenses = getRecentExpenses(5);
        summary.put("recentExpenses", recentExpenses);
        
        Map<String, Double> categoryExpenses = getFamilyCategoryExpenses(
            currentMonth.getYear(), currentMonth.getMonthValue());
        summary.put("topCategories", categoryExpenses);
        
        return summary;
    }

    // Predefined expense categories
    public List<String> getExpenseCategories() {
        return Arrays.asList(
            "Food & Dining",
            "Transportation",
            "Shopping",
            "Entertainment",
            "Healthcare",
            "Bills & Utilities",
            "Education",
            "Travel",
            "Personal Care",
            "Groceries",
            "Home & Garden",
            "Gifts & Donations",
            "Professional Services",
            "Other"
        );
    }

    // Payment methods
    public List<String> getPaymentMethods() {
        return Arrays.asList("Cash", "Credit Card", "Debit Card", "UPI", "Net Banking", "Wallet", "Other");
    }
}