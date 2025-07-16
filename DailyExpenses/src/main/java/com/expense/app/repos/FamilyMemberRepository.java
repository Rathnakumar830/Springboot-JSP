package com.expense.app.repos;

import com.expense.app.entities.FamilyMember;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FamilyMemberRepository extends JpaRepository<FamilyMember, Long> {
    
    Optional<FamilyMember> findByName(String name);
    
    List<FamilyMember> findByIsActiveTrue();
    
    List<FamilyMember> findByRelationship(String relationship);
    
    boolean existsByName(String name);
    
    @Query("SELECT fm FROM FamilyMember fm WHERE fm.isActive = true ORDER BY fm.name")
    List<FamilyMember> findAllActiveFamilyMembersOrderByName();
    
    @Query("SELECT COUNT(fm) FROM FamilyMember fm WHERE fm.isActive = true")
    long countActiveFamilyMembers();
    
    @Query("SELECT SUM(fm.monthlyBudget) FROM FamilyMember fm WHERE fm.isActive = true")
    Double getTotalFamilyBudget();
    
    @Query("SELECT fm FROM FamilyMember fm WHERE fm.isActive = true AND fm.name LIKE %:name%")
    List<FamilyMember> findActiveFamilyMembersByNameContaining(@Param("name") String name);
}