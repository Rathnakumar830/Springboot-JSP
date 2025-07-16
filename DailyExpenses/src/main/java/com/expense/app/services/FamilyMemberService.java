package com.expense.app.services;

import com.expense.app.entities.FamilyMember;
import com.expense.app.repos.FamilyMemberRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class FamilyMemberService {

    @Autowired
    private FamilyMemberRepository familyMemberRepository;

    public List<FamilyMember> getAllActiveFamilyMembers() {
        return familyMemberRepository.findAllActiveFamilyMembersOrderByName();
    }

    public Optional<FamilyMember> getFamilyMemberById(Long id) {
        return familyMemberRepository.findById(id);
    }

    public Optional<FamilyMember> getFamilyMemberByName(String name) {
        return familyMemberRepository.findByName(name);
    }

    public FamilyMember createFamilyMember(FamilyMember familyMember) {
        if (familyMemberRepository.existsByName(familyMember.getName())) {
            throw new RuntimeException("Family member with this name already exists");
        }
        
        familyMember.setCreatedAt(LocalDateTime.now());
        familyMember.setUpdatedAt(LocalDateTime.now());
        familyMember.setActive(true);
        
        return familyMemberRepository.save(familyMember);
    }

    public FamilyMember updateFamilyMember(FamilyMember familyMember) {
        familyMember.setUpdatedAt(LocalDateTime.now());
        return familyMemberRepository.save(familyMember);
    }

    public void deactivateFamilyMember(Long id) {
        Optional<FamilyMember> familyMember = familyMemberRepository.findById(id);
        if (familyMember.isPresent()) {
            familyMember.get().setActive(false);
            familyMember.get().setUpdatedAt(LocalDateTime.now());
            familyMemberRepository.save(familyMember.get());
        }
    }

    public boolean isNameAvailable(String name) {
        return !familyMemberRepository.existsByName(name);
    }

    public long getActiveFamilyMemberCount() {
        return familyMemberRepository.countActiveFamilyMembers();
    }

    public Double getTotalFamilyBudget() {
        Double total = familyMemberRepository.getTotalFamilyBudget();
        return total != null ? total : 0.0;
    }

    public List<FamilyMember> searchFamilyMembers(String name) {
        return familyMemberRepository.findActiveFamilyMembersByNameContaining(name);
    }

    public FamilyMember updateMonthlyBudget(Long id, Double budget) {
        Optional<FamilyMember> familyMember = familyMemberRepository.findById(id);
        if (familyMember.isPresent()) {
            familyMember.get().setMonthlyBudget(budget);
            familyMember.get().setUpdatedAt(LocalDateTime.now());
            return familyMemberRepository.save(familyMember.get());
        }
        throw new RuntimeException("Family member not found");
    }

    // Initialize default family members if none exist
    public void initializeDefaultFamilyMembers() {
        if (familyMemberRepository.countActiveFamilyMembers() == 0) {
            // Create default family members based on existing data
            createFamilyMember(new FamilyMember("Rathna", "Mother"));
            createFamilyMember(new FamilyMember("Suresh", "Father"));
            createFamilyMember(new FamilyMember("Papa", "Grandfather"));
            createFamilyMember(new FamilyMember("Amma", "Grandmother"));
        }
    }
}