package com.expense.app.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RestController;

import com.expense.app.repos.DailyDetailRepository;

@RestController
public class MainRestController {
	@Autowired
	DailyDetailRepository repo;
}
