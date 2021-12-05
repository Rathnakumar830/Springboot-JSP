package com.expense.app.repos;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.expense.app.entities.DailyDetails;

@Repository
public interface DailyDetailRepository extends JpaRepository<DailyDetails,Long>{

}
