package com.expense.app.controllers;

import com.expense.app.entities.User;
import com.expense.app.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    // Show registration form
    @GetMapping("/register")
    public String showRegistrationForm(Model model) {
        model.addAttribute("user", new User());
        return "UserRegistration";
    }

    // Handle registration form submission
    @PostMapping("/register")
    public String registerUser(@ModelAttribute User user, 
                             RedirectAttributes redirectAttributes) {
        try {
            userService.registerUser(user);
            redirectAttributes.addFlashAttribute("successMessage", 
                "Registration successful! Please login with your credentials.");
            return "redirect:/user/login";
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/user/register";
        }
    }

    // Show login form
    @GetMapping("/login")
    public String showLoginForm() {
        return "UserLogin";
    }

    // Handle login form submission
    @PostMapping("/login")
    public String loginUser(@RequestParam String username,
                           @RequestParam String password,
                           HttpSession session,
                           RedirectAttributes redirectAttributes) {
        Optional<User> user = userService.loginUser(username, password);
        
        if (user.isPresent()) {
            session.setAttribute("loggedInUser", user.get());
            return "redirect:/user/dashboard";
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", 
                "Invalid username/email or password");
            return "redirect:/user/login";
        }
    }

    // Show user dashboard
    @GetMapping("/dashboard")
    public String showDashboard(HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/user/login";
        }
        
        model.addAttribute("user", loggedInUser);
        model.addAttribute("totalUsers", userService.getActiveUserCount());
        return "UserDashboard";
    }

    // Show user profile
    @GetMapping("/profile")
    public String showProfile(HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/user/login";
        }
        
        model.addAttribute("user", loggedInUser);
        return "UserProfile";
    }

    // Handle profile update
    @PostMapping("/profile")
    public String updateProfile(@ModelAttribute User user,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/user/login";
        }

        // Update only allowed fields
        loggedInUser.setFirstName(user.getFirstName());
        loggedInUser.setLastName(user.getLastName());
        loggedInUser.setPhoneNumber(user.getPhoneNumber());
        
        try {
            User updatedUser = userService.updateUser(loggedInUser);
            session.setAttribute("loggedInUser", updatedUser);
            redirectAttributes.addFlashAttribute("successMessage", "Profile updated successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error updating profile: " + e.getMessage());
        }
        
        return "redirect:/user/profile";
    }

    // Show all users (admin functionality)
    @GetMapping("/list")
    public String listUsers(HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/user/login";
        }
        
        List<User> users = userService.getAllActiveUsers();
        model.addAttribute("users", users);
        model.addAttribute("currentUser", loggedInUser);
        return "UserList";
    }

    // Handle logout
    @GetMapping("/logout")
    public String logout(HttpSession session, RedirectAttributes redirectAttributes) {
        session.invalidate();
        redirectAttributes.addFlashAttribute("successMessage", "You have been logged out successfully!");
        return "redirect:/user/login";
    }
}