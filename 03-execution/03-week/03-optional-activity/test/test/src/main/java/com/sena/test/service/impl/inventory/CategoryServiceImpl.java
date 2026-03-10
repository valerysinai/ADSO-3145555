package com.sena.test.service.impl.inventory;

import org.springframework.stereotype.Service;
import java.util.List;

import com.sena.test.entity.inventory.Category;
import com.sena.test.repository.inventory.ICategoryRepository;
import com.sena.test.service.inventory.ICategoryService;

@Service
public class CategoryServiceImpl implements ICategoryService {

    private final ICategoryRepository repository;

    public CategoryServiceImpl(ICategoryRepository repository) {
        this.repository = repository;
    }

    @Override
    public List<Category> findAll() {
        return repository.findAll();
    }

    @Override
    public Category save(Category category) {
        return repository.save(category);
    }

    @Override
    public void delete(Long id) {
        repository.deleteById(id);
    }
}