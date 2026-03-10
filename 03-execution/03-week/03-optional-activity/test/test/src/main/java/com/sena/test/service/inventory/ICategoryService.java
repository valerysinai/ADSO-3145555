package com.sena.test.service.inventory;

import java.util.List;
import com.sena.test.entity.inventory.Category;

public interface ICategoryService {

    List<Category> findAll();

    Category save(Category category);

    void delete(Long id);
}