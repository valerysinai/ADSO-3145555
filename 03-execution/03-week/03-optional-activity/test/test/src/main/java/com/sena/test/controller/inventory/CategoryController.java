package com.sena.test.controller.inventory;

import java.util.List;
import org.springframework.web.bind.annotation.*;

import com.sena.test.entity.inventory.Category;
import com.sena.test.service.inventory.ICategoryService;

@RestController
@RequestMapping("/api/categories")
public class CategoryController {

    private final ICategoryService service;

    public CategoryController(ICategoryService service) {
        this.service = service;
    }

    @GetMapping
    public List<Category> getAll() {
        return service.findAll();
    }

    @PostMapping
    public Category save(@RequestBody Category category) {
        return service.save(category);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        service.delete(id);
    }
}