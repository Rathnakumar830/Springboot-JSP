package com.expense.app.services;

import org.springframework.stereotype.Service;

import com.expense.app.entities.DailyDetails;
import com.expense.app.repos.DailyDetailRepository;

@Service
public class MyServices {

	public boolean savetoDBdetails(String name, String sdate, int amount, DailyDetailRepository repo) {
		boolean b = false;
		DailyDetails d = new DailyDetails();
		d.setName(name);
		d.setSdate(sdate);
		d.setAmount(amount);
		repo.save(d);
		b=true;
		return b;
	}

}
