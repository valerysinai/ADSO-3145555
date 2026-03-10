package com.sena.test.repository.inventory;

import com.sena.test.entity.inventory.Product;
import org.springframework.data.jpa.repository.JpaRepository;

public interface IProductRepository extends JpaRepository<Product, Long> {
}