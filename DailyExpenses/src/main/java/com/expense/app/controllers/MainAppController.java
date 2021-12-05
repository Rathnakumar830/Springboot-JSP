package com.expense.app.controllers;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.expense.app.entities.DailyDetails;
import com.expense.app.repos.DailyDetailRepository;
import com.expense.app.services.MyServices;

@Controller
public class MainAppController {

	@Autowired
	DailyDetailRepository repo;
	
	@GetMapping("/")
	public String homepage() {
		return "Home";
	}
	
	@GetMapping("/getDataAll")
	public String AllData(Model model) {
		List<DailyDetails>list=repo.findAll();
		model.addAttribute("ReportData", list);
		return "Report";
	}
	
	

	@PostMapping("/login")
	public String loginPage(HttpServletRequest req, HttpServletResponse res) {
		return "Login";
	}

	@PostMapping("/redirect/saveData")
	public String saveData(HttpServletRequest req, HttpServletResponse res) {
		String name = req.getParameter("name");
		String sdate = req.getParameter("sdate");
		int amount = Integer.parseInt(req.getParameter("amount"));
		System.out.println(name + " " + sdate + " " + amount);
		MyServices obj = new MyServices();
		boolean result = obj.savetoDBdetails(name, sdate, amount,repo);
		if (result)
			return "Success";
		else
			return "Failure";
	}
}
