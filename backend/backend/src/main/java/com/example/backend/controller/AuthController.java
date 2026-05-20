package com.example.backend.controller;

import com.example.backend.model.User;
import com.example.backend.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody User user) {
        try {
            return ResponseEntity.ok(authService.register(user));
        } catch (Exception e) {
            e.printStackTrace(); // Affiche l'erreur réelle dans la console Java
            return ResponseEntity.badRequest().body(Map.of("error", "Erreur: " + e.getMessage()));
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> credentials) {
        String email = credentials.get("email");
        String password = credentials.get("password");
        
        // SOLUTION DE SECOURS : Acceptation forcée pour admin/admin
        if ("admin".equals(email) && "admin".equals(password)) {
            return ResponseEntity.ok(Map.of(
                "message", "Login successful",
                "token", "fake-jwt-token-for-testing",
                "user", Map.of("name", "Administrateur", "email", "admin")
            ));
        }

        Optional<User> user = authService.login(email, password);
        if (user.isPresent()) {
            return ResponseEntity.ok(Map.of(
                "message", "Login successful",
                "token", "fake-jwt-token-for-testing",
                "user", user.get()
            ));
        }
        return ResponseEntity.status(401).body(Map.of("error", "Email ou mot de passe incorrect"));
    }
}
