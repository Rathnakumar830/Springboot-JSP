package com.expense.app.controllers;

import com.expense.app.entities.Expense;
import com.expense.app.entities.FamilyMember;
import com.expense.app.services.ExpenseService;
import com.expense.app.services.FamilyMemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/expenses")
public class ExpenseController {

    @Autowired
    private ExpenseService expenseService;

    @Autowired
    private FamilyMemberService familyMemberService;

    // Main expense dashboard
    @GetMapping("/dashboard")
    public String expenseDashboard(Model model) {
        // Initialize family members if none exist
        familyMemberService.initializeDefaultFamilyMembers();
        
        Map<String, Object> summary = expenseService.getExpenseSummary();
        YearMonth currentMonth = YearMonth.now();
        
        model.addAttribute("summary", summary);
        model.addAttribute("currentMonth", currentMonth);
        model.addAttribute("budgetAnalysis", expenseService.getBudgetAnalysis(
            currentMonth.getYear(), currentMonth.getMonthValue()));
        model.addAttribute("familyMembers", familyMemberService.getAllActiveFamilyMembers());
        
        return "expense/Dashboard";
    }

    // Show expense entry form
    @GetMapping("/add")
    public String showAddExpenseForm(Model model) {
        familyMemberService.initializeDefaultFamilyMembers();
        
        model.addAttribute("expense", new Expense());
        model.addAttribute("familyMembers", familyMemberService.getAllActiveFamilyMembers());
        model.addAttribute("categories", expenseService.getExpenseCategories());
        model.addAttribute("paymentMethods", expenseService.getPaymentMethods());
        
        return "expense/AddExpense";
    }

    // Handle expense creation
    @PostMapping("/add")
    public String addExpense(@ModelAttribute Expense expense,
                           @RequestParam Long familyMemberId,
                           RedirectAttributes redirectAttributes) {
        try {
            Optional<FamilyMember> familyMember = familyMemberService.getFamilyMemberById(familyMemberId);
            if (familyMember.isPresent()) {
                expense.setFamilyMember(familyMember.get());
                expenseService.createExpense(expense);
                redirectAttributes.addFlashAttribute("successMessage", 
                    "Expense added successfully!");
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", 
                    "Family member not found!");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", 
                "Error adding expense: " + e.getMessage());
        }
        
        return "redirect:/expenses/add";
    }

    // View all expenses
    @GetMapping("/list")
    public String listExpenses(@RequestParam(required = false) Long familyMemberId,
                             @RequestParam(required = false) String category,
                             @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
                             @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
                             Model model) {
        
        List<Expense> expenses;
        
        if (familyMemberId != null) {
            if (startDate != null && endDate != null) {
                expenses = expenseService.getExpensesByDateRange(familyMemberId, startDate, endDate);
            } else {
                expenses = expenseService.getCurrentMonthExpenses(familyMemberId);
            }
        } else {
            expenses = expenseService.getAllExpenses();
        }
        
        model.addAttribute("expenses", expenses);
        model.addAttribute("familyMembers", familyMemberService.getAllActiveFamilyMembers());
        model.addAttribute("categories", expenseService.getExpenseCategories());
        model.addAttribute("selectedFamilyMemberId", familyMemberId);
        model.addAttribute("selectedCategory", category);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        
        return "expense/ExpenseList";
    }

    // Monthly report for specific family member
    @GetMapping("/monthly-report")
    public String monthlyReport(@RequestParam(required = false) Long familyMemberId,
                              @RequestParam(required = false) Integer year,
                              @RequestParam(required = false) Integer month,
                              Model model) {
        
        YearMonth currentMonth = YearMonth.now();
        int reportYear = year != null ? year : currentMonth.getYear();
        int reportMonth = month != null ? month : currentMonth.getMonthValue();
        
        if (familyMemberId != null) {
            Optional<FamilyMember> familyMember = familyMemberService.getFamilyMemberById(familyMemberId);
            if (familyMember.isPresent()) {
                List<Expense> monthlyExpenses = expenseService.getMonthlyExpenses(familyMemberId, reportYear, reportMonth);
                Double monthlyTotal = expenseService.getMonthlyTotal(familyMemberId, reportYear, reportMonth);
                Map<String, Double> categoryExpenses = expenseService.getMonthlyCategoryExpenses(familyMemberId, reportYear, reportMonth);
                
                model.addAttribute("familyMember", familyMember.get());
                model.addAttribute("monthlyExpenses", monthlyExpenses);
                model.addAttribute("monthlyTotal", monthlyTotal);
                model.addAttribute("categoryExpenses", categoryExpenses);
                model.addAttribute("budget", familyMember.get().getMonthlyBudget());
                model.addAttribute("remaining", familyMember.get().getMonthlyBudget() - monthlyTotal);
            }
        }
        
        model.addAttribute("familyMembers", familyMemberService.getAllActiveFamilyMembers());
        model.addAttribute("reportYear", reportYear);
        model.addAttribute("reportMonth", reportMonth);
        model.addAttribute("selectedFamilyMemberId", familyMemberId);
        
        return "expense/MonthlyReport";
    }

    // Family expense summary
    @GetMapping("/family-summary")
    public String familySummary(@RequestParam(required = false) Integer year,
                               @RequestParam(required = false) Integer month,
                               Model model) {
        
        YearMonth currentMonth = YearMonth.now();
        int reportYear = year != null ? year : currentMonth.getYear();
        int reportMonth = month != null ? month : currentMonth.getMonthValue();
        
        Map<String, Double> familyExpenses = expenseService.getMonthlyFamilyMemberExpenses(reportYear, reportMonth);
        Map<String, Double> categoryExpenses = expenseService.getFamilyCategoryExpenses(reportYear, reportMonth);
        List<Map<String, Object>> budgetAnalysis = expenseService.getBudgetAnalysis(reportYear, reportMonth);
        Double familyTotal = expenseService.getFamilyMonthlyTotal(reportYear, reportMonth);
        Double totalBudget = familyMemberService.getTotalFamilyBudget();
        
        model.addAttribute("familyExpenses", familyExpenses);
        model.addAttribute("categoryExpenses", categoryExpenses);
        model.addAttribute("budgetAnalysis", budgetAnalysis);
        model.addAttribute("familyTotal", familyTotal);
        model.addAttribute("totalBudget", totalBudget);
        model.addAttribute("reportYear", reportYear);
        model.addAttribute("reportMonth", reportMonth);
        model.addAttribute("familyMembers", familyMemberService.getAllActiveFamilyMembers());
        
        return "expense/FamilySummary";
    }

    // Budget planning page
    @GetMapping("/budget-planning")
    public String budgetPlanning(Model model) {
        List<FamilyMember> familyMembers = familyMemberService.getAllActiveFamilyMembers();
        YearMonth currentMonth = YearMonth.now();
        List<Map<String, Object>> budgetAnalysis = expenseService.getBudgetAnalysis(
            currentMonth.getYear(), currentMonth.getMonthValue());
        
        model.addAttribute("familyMembers", familyMembers);
        model.addAttribute("budgetAnalysis", budgetAnalysis);
        model.addAttribute("totalBudget", familyMemberService.getTotalFamilyBudget());
        
        return "expense/BudgetPlanning";
    }

    // Update family member budget
    @PostMapping("/update-budget")
    public String updateBudget(@RequestParam Long familyMemberId,
                             @RequestParam Double budget,
                             RedirectAttributes redirectAttributes) {
        try {
            familyMemberService.updateMonthlyBudget(familyMemberId, budget);
            redirectAttributes.addFlashAttribute("successMessage", 
                "Budget updated successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", 
                "Error updating budget: " + e.getMessage());
        }
        
        return "redirect:/expenses/budget-planning";
    }

    // Edit expense form
    @GetMapping("/edit/{id}")
    public String editExpenseForm(@PathVariable Long id, Model model) {
        Optional<Expense> expense = expenseService.getExpenseById(id);
        if (expense.isPresent()) {
            model.addAttribute("expense", expense.get());
            model.addAttribute("familyMembers", familyMemberService.getAllActiveFamilyMembers());
            model.addAttribute("categories", expenseService.getExpenseCategories());
            model.addAttribute("paymentMethods", expenseService.getPaymentMethods());
            return "expense/EditExpense";
        }
        return "redirect:/expenses/list";
    }

    // Update expense
    @PostMapping("/edit/{id}")
    public String updateExpense(@PathVariable Long id,
                              @ModelAttribute Expense expense,
                              RedirectAttributes redirectAttributes) {
        try {
            expense.setId(id);
            expenseService.updateExpense(expense);
            redirectAttributes.addFlashAttribute("successMessage", 
                "Expense updated successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", 
                "Error updating expense: " + e.getMessage());
        }
        
        return "redirect:/expenses/list";
    }

    // Delete expense
    @PostMapping("/delete/{id}")
    public String deleteExpense(@PathVariable Long id,
                              RedirectAttributes redirectAttributes) {
        try {
            expenseService.deleteExpense(id);
            redirectAttributes.addFlashAttribute("successMessage", 
                "Expense deleted successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", 
                "Error deleting expense: " + e.getMessage());
        }
        
        return "redirect:/expenses/list";
    }

    // Search expenses
    @GetMapping("/search")
    public String searchExpenses(@RequestParam String searchTerm, Model model) {
        List<Expense> expenses = expenseService.searchExpenses(searchTerm);
        model.addAttribute("expenses", expenses);
        model.addAttribute("searchTerm", searchTerm);
        model.addAttribute("familyMembers", familyMemberService.getAllActiveFamilyMembers());
        
        return "expense/SearchResults";
    }
}