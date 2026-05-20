package com.example.backend.controller;

import com.example.backend.model.Product;
import com.example.backend.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/products")
public class ProductController {

    @Autowired
    private ProductRepository productRepository;

    @GetMapping
    public List<Product> getAllProducts() {
        List<Product> products = productRepository.findAll();
        System.out.println("API: Sending " + products.size() + " products to client");
        return products;
    }

    @PostMapping
    @CacheEvict(value = "products", allEntries = true)
    public Product createProduct(@RequestBody Product product) {
        return productRepository.save(product);
    }
}
