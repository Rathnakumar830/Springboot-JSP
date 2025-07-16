package com.expense.app.controllers;

import com.expense.app.entities.User;
import com.expense.app.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*")
public class UserRestController {

    @Autowired
    private UserService userService;

    // Register new user
    @PostMapping("/register")
    public ResponseEntity<Map<String, Object>> registerUser(@RequestBody User user) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            User registeredUser = userService.registerUser(user);
            response.put("success", true);
            response.put("message", "User registered successfully");
            response.put("user", registeredUser);
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (RuntimeException e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
        }
    }

    // Login user
    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> loginUser(@RequestBody Map<String, String> loginRequest) {
        Map<String, Object> response = new HashMap<>();
        
        String username = loginRequest.get("username");
        String password = loginRequest.get("password");
        
        Optional<User> user = userService.loginUser(username, password);
        
        if (user.isPresent()) {
            response.put("success", true);
            response.put("message", "Login successful");
            response.put("user", user.get());
            return ResponseEntity.ok(response);
        } else {
            response.put("success", false);
            response.put("message", "Invalid credentials");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }
    }

    // Get all active users
    @GetMapping("/")
    public ResponseEntity<List<User>> getAllUsers() {
        List<User> users = userService.getAllActiveUsers();
        return ResponseEntity.ok(users);
    }

    // Get user by ID
    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> getUserById(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        Optional<User> user = userService.findById(id);
        
        if (user.isPresent()) {
            response.put("success", true);
            response.put("user", user.get());
            return ResponseEntity.ok(response);
        } else {
            response.put("success", false);
            response.put("message", "User not found");
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
        }
    }

    // Update user
    @PutMapping("/{id}")
    public ResponseEntity<Map<String, Object>> updateUser(@PathVariable Long id, @RequestBody User user) {
        Map<String, Object> response = new HashMap<>();
        
        Optional<User> existingUser = userService.findById(id);
        if (existingUser.isPresent()) {
            User userToUpdate = existingUser.get();
            userToUpdate.setFirstName(user.getFirstName());
            userToUpdate.setLastName(user.getLastName());
            userToUpdate.setPhoneNumber(user.getPhoneNumber());
            
            User updatedUser = userService.updateUser(userToUpdate);
            response.put("success", true);
            response.put("message", "User updated successfully");
            response.put("user", updatedUser);
            return ResponseEntity.ok(response);
        } else {
            response.put("success", false);
            response.put("message", "User not found");
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
        }
    }

    // Deactivate user
    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> deactivateUser(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        
        Optional<User> user = userService.findById(id);
        if (user.isPresent()) {
            userService.deactivateUser(id);
            response.put("success", true);
            response.put("message", "User deactivated successfully");
            return ResponseEntity.ok(response);
        } else {
            response.put("success", false);
            response.put("message", "User not found");
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
        }
    }

    // Check username availability
    @GetMapping("/check-username/{username}")
    public ResponseEntity<Map<String, Object>> checkUsernameAvailability(@PathVariable String username) {
        Map<String, Object> response = new HashMap<>();
        boolean available = userService.isUsernameAvailable(username);
        
        response.put("available", available);
        response.put("message", available ? "Username is available" : "Username is already taken");
        
        return ResponseEntity.ok(response);
    }

    // Check email availability
    @GetMapping("/check-email/{email}")
    public ResponseEntity<Map<String, Object>> checkEmailAvailability(@PathVariable String email) {
        Map<String, Object> response = new HashMap<>();
        boolean available = userService.isEmailAvailable(email);
        
        response.put("available", available);
        response.put("message", available ? "Email is available" : "Email is already registered");
        
        return ResponseEntity.ok(response);
    }

    // Search users by name
    @GetMapping("/search")
    public ResponseEntity<List<User>> searchUsers(@RequestParam String name) {
        List<User> users = userService.searchUsersByName(name);
        return ResponseEntity.ok(users);
    }

    // Get user statistics
    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getUserStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalActiveUsers", userService.getActiveUserCount());
        stats.put("allUsers", userService.getAllActiveUsers().size());
        
        return ResponseEntity.ok(stats);
    }
}