package com.sena.test.repository.inventory;

import com.sena.test.entity.inventory.Category;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ICategoryRepository extends JpaRepository<Category, Long> {
}