package com.sena.test.controller.inventory;

import java.util.List;
import org.springframework.web.bind.annotation.*;

import com.sena.test.entity.inventory.Product;
import com.sena.test.service.inventory.IProductService;

@RestController
@RequestMapping("/api/products")
public class ProductController {

    private final IProductService service;

    public ProductController(IProductService service) {
        this.service = service;
    }

    @GetMapping
    public List<Product> getAll() {
        return service.findAll();
    }

    @PostMapping
    public Product save(@RequestBody Product product) {
        return service.save(product);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        service.delete(id);
    }
}
