package com.example.backend.controller;

import com.example.backend.service.StripeService;
import com.stripe.exception.StripeException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/payments")
public class PaymentController {

    @Autowired
    private StripeService stripeService;

    @PostMapping("/create-payment-intent")
    public ResponseEntity<Map<String, String>> createPaymentIntent(@RequestBody Map<String, Object> data) {
        try {
            Long amount = Long.valueOf(data.get("amount").toString());
            String currency = (String) data.get("currency");
            Map<String, String> response = stripeService.createPaymentIntent(amount, currency);
            return ResponseEntity.ok(response);
        } catch (StripeException e) {
            System.err.println("STRIPE ERROR: " + e.getMessage());
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        } catch (Exception e) {
            System.err.println("GENERAL ERROR: " + e.getMessage());
            return ResponseEntity.internalServerError().body(Map.of("error", e.getMessage()));
        }
    }
}
