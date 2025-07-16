package com.expense.app.repos;

import com.expense.app.entities.Expense;
import com.expense.app.entities.FamilyMember;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Repository
public interface ExpenseRepository extends JpaRepository<Expense, Long> {
    
    // Basic queries
    List<Expense> findByFamilyMember(FamilyMember familyMember);
    
    List<Expense> findByFamilyMemberOrderByExpenseDateDesc(FamilyMember familyMember);
    
    List<Expense> findByCategory(String category);
    
    List<Expense> findByExpenseDate(LocalDate expenseDate);
    
    List<Expense> findByExpenseDateBetween(LocalDate startDate, LocalDate endDate);
    
    // Monthly expenses
    @Query("SELECT e FROM Expense e WHERE e.familyMember.id = :familyMemberId " +
           "AND YEAR(e.expenseDate) = :year AND MONTH(e.expenseDate) = :month " +
           "ORDER BY e.expenseDate DESC")
    List<Expense> findMonthlyExpensesByFamilyMember(@Param("familyMemberId") Long familyMemberId, 
                                                   @Param("year") int year, 
                                                   @Param("month") int month);
    
    // Sum calculations
    @Query("SELECT SUM(e.amount) FROM Expense e WHERE e.familyMember.id = :familyMemberId " +
           "AND YEAR(e.expenseDate) = :year AND MONTH(e.expenseDate) = :month")
    Double getMonthlyTotalByFamilyMember(@Param("familyMemberId") Long familyMemberId, 
                                        @Param("year") int year, 
                                        @Param("month") int month);
    
    @Query("SELECT SUM(e.amount) FROM Expense e WHERE e.familyMember.id = :familyMemberId " +
           "AND e.expenseDate BETWEEN :startDate AND :endDate")
    Double getTotalExpensesByFamilyMemberAndDateRange(@Param("familyMemberId") Long familyMemberId,
                                                     @Param("startDate") LocalDate startDate,
                                                     @Param("endDate") LocalDate endDate);
    
    // Category-wise analysis
    @Query("SELECT e.category, SUM(e.amount) FROM Expense e WHERE e.familyMember.id = :familyMemberId " +
           "AND YEAR(e.expenseDate) = :year AND MONTH(e.expenseDate) = :month " +
           "GROUP BY e.category ORDER BY SUM(e.amount) DESC")
    List<Object[]> getMonthlyCategoryWiseExpenses(@Param("familyMemberId") Long familyMemberId,
                                                 @Param("year") int year,
                                                 @Param("month") int month);
    
    @Query("SELECT e.category, SUM(e.amount) FROM Expense e " +
           "WHERE YEAR(e.expenseDate) = :year AND MONTH(e.expenseDate) = :month " +
           "GROUP BY e.category ORDER BY SUM(e.amount) DESC")
    List<Object[]> getFamilyCategoryWiseExpenses(@Param("year") int year, @Param("month") int month);
    
    // Daily expenses
    @Query("SELECT e FROM Expense e WHERE e.expenseDate = :date ORDER BY e.createdAt DESC")
    List<Expense> getDailyExpenses(@Param("date") LocalDate date);
    
    @Query("SELECT SUM(e.amount) FROM Expense e WHERE e.expenseDate = :date")
    Double getDailyTotal(@Param("date") LocalDate date);
    
    // Family-wide statistics
    @Query("SELECT SUM(e.amount) FROM Expense e WHERE YEAR(e.expenseDate) = :year AND MONTH(e.expenseDate) = :month")
    Double getFamilyMonthlyTotal(@Param("year") int year, @Param("month") int month);
    
    @Query("SELECT fm.name, SUM(e.amount) FROM Expense e JOIN e.familyMember fm " +
           "WHERE YEAR(e.expenseDate) = :year AND MONTH(e.expenseDate) = :month " +
           "GROUP BY fm.id, fm.name ORDER BY SUM(e.amount) DESC")
    List<Object[]> getMonthlyExpensesByFamilyMember(@Param("year") int year, @Param("month") int month);
    
    // Recent expenses
    @Query("SELECT e FROM Expense e ORDER BY e.createdAt DESC")
    List<Expense> findRecentExpenses();
    
    @Query("SELECT e FROM Expense e WHERE e.familyMember.id = :familyMemberId ORDER BY e.createdAt DESC")
    List<Expense> findRecentExpensesByFamilyMember(@Param("familyMemberId") Long familyMemberId);
    
    // Search functionality
    @Query("SELECT e FROM Expense e WHERE e.description LIKE %:searchTerm% OR e.category LIKE %:searchTerm%")
    List<Expense> searchExpenses(@Param("searchTerm") String searchTerm);
    
    // Budget vs actual analysis
    @Query("SELECT fm.name, fm.monthlyBudget, COALESCE(SUM(e.amount), 0) as actualSpent " +
           "FROM FamilyMember fm LEFT JOIN fm.expenses e " +
           "WHERE fm.isActive = true AND (e.expenseDate IS NULL OR " +
           "(YEAR(e.expenseDate) = :year AND MONTH(e.expenseDate) = :month)) " +
           "GROUP BY fm.id, fm.name, fm.monthlyBudget")
    List<Object[]> getBudgetVsActualComparison(@Param("year") int year, @Param("month") int month);
    
    // Top categories
    @Query("SELECT e.category, COUNT(e), SUM(e.amount) FROM Expense e " +
           "WHERE YEAR(e.expenseDate) = :year AND MONTH(e.expenseDate) = :month " +
           "GROUP BY e.category ORDER BY SUM(e.amount) DESC")
    List<Object[]> getTopCategoriesWithStats(@Param("year") int year, @Param("month") int month);
}