package com.sena.test.service.inventory;

import java.util.List;
import com.sena.test.entity.inventory.Product;

public interface IProductService {

    List<Product> findAll();

    Product save(Product product);

    void delete(Long id);
}