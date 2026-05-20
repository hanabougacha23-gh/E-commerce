package com.example.backend;

import com.example.backend.model.Product;
import com.example.backend.model.User;
import com.example.backend.repository.*;
import com.example.backend.service.AuthService;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.Bean;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Arrays;

@SpringBootApplication
@EnableAsync
@EnableCaching
public class BackendApplication {

	public static void main(String[] args) {
		SpringApplication.run(BackendApplication.class, args);
	}

	@Bean
	@Transactional
	CommandLineRunner init(UserRepository userRepository, AuthService authService, 
						   ProductRepository productRepository, OrderItemRepository orderItemRepository,
						   CartItemRepository cartItemRepository, OrderRepository orderRepository) {
		return args -> {
			System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
			System.out.println("LANCEMENT DE L'INITIALISATION FORCÉE");
			
			try {
				// 1. Nettoyer la base (Ordre strict pour les clés étrangères)
				orderItemRepository.deleteAllInBatch();
				orderRepository.deleteAllInBatch();
				cartItemRepository.deleteAllInBatch();
				userRepository.deleteAllInBatch();
				productRepository.deleteAllInBatch();
				
				System.out.println(">>> BASE DE DONNÉES VIDE ET PROPRE");

				// 2. Créer l'utilisateur
				User testUser = new User();
				testUser.setName("User Test");
				testUser.setEmail("test@test.com");
				testUser.setPassword("password123");
				authService.register(testUser);
				System.out.println(">>> COMPTE test@test.com CRÉÉ");

				// 3. Créer les produits (Images Unsplash)
				Product p1 = new Product(null, "iPhone 15 Pro", "Titanium design", new BigDecimal("1299.99"), 50, "https://images.unsplash.com/photo-1695048133142-1a20484d2569?q=80&w=400", "Electronics", null);
				Product p2 = new Product(null, "Samsung S24", "AI Smartphone", new BigDecimal("999.00"), 30, "https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?q=80&w=400", "Electronics", null);
				Product p3 = new Product(null, "Sony Headphones", "ANC Audio", new BigDecimal("349.50"), 20, "https://images.unsplash.com/photo-1618366712010-f4ae9c647dcb?q=80&w=400", "Electronics", null);
				Product p4 = new Product(null, "Nike Air", "Shoes comfort", new BigDecimal("150.00"), 100, "https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=400", "Shoes", null);
				Product p5 = new Product(null, "Desk Lamp", "LED light", new BigDecimal("45.00"), 10, "https://images.unsplash.com/photo-1534073828943-f801091bb18c?q=80&w=400", "Furniture", null);

				productRepository.saveAll(Arrays.asList(p1, p2, p3, p4, p5));
				
				System.out.println(">>> " + productRepository.count() + " PRODUITS RÉELLEMENT EN BASE");
			} catch (Exception e) {
				System.err.println("ERREUR GRAVE INITIALISATION: " + e.getMessage());
			}
			System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
		};
	}
}
