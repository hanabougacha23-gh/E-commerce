package com.example.backend.controller;

import com.example.backend.model.Order;
import com.example.backend.model.OrderItem;
import com.example.backend.model.Product;
import com.example.backend.repository.OrderRepository;
import com.example.backend.repository.ProductRepository;
import com.example.backend.repository.UserRepository;
import com.example.backend.service.NotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/orders")
public class OrderController {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private NotificationService notificationService;

    @PostMapping
    public ResponseEntity<?> createOrder(@RequestBody Order orderRequest) {
        try {
            Order order = new Order();
            
            // 1. Lier l'utilisateur (Compte test par défaut pour le bypass)
            userRepository.findByEmail("test@test.com").ifPresent(order::setUser);
            if (order.getUser() == null) {
                return ResponseEntity.badRequest().body(Map.of("error", "Utilisateur test@test.com introuvable"));
            }

            order.setTotal(orderRequest.getTotal());
            order.setStatus("PAID");
            
            // 2. Traiter les articles de la commande
            List<OrderItem> items = new ArrayList<>();
            for (OrderItem itemRequest : orderRequest.getItems()) {
                OrderItem item = new OrderItem();
                
                // On récupère le VRAI produit de la base pour éviter les erreurs JPA
                Product product = productRepository.findById(itemRequest.getProduct().getId())
                        .orElseThrow(() -> new RuntimeException("Produit non trouvé ID: " + itemRequest.getProduct().getId()));
                
                item.setProduct(product);
                item.setQuantity(itemRequest.getQuantity());
                item.setPrice(itemRequest.getPrice());
                item.setOrder(order);
                items.add(item);
            }
            order.setItems(items);

            // 3. Sauvegarder
            Order savedOrder = orderRepository.save(order);
            System.out.println(">>> COMMANDE ENREGISTRÉE: #" + savedOrder.getId());

            // 4. Notification
            if (savedOrder.getUser().getFcmToken() != null) {
                notificationService.sendNotification(
                    savedOrder.getUser().getFcmToken(),
                    "Paiement Confirmé",
                    "Merci ! Votre commande #" + savedOrder.getId() + " est en préparation."
                );
            }

            return ResponseEntity.ok(savedOrder);
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("error", e.getMessage() != null ? e.getMessage() : "Erreur interne serveur");
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }

    @GetMapping
    public List<Order> getAllOrders() {
        return orderRepository.findAll();
    }
}
