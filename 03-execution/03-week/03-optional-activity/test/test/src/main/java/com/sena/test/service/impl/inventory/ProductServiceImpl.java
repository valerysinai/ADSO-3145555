package com.sena.test.service.impl.inventory;

import org.springframework.stereotype.Service;
import java.util.List;

import com.sena.test.entity.inventory.Product;
import com.sena.test.repository.inventory.IProductRepository;
import com.sena.test.service.inventory.IProductService;

@Service
public class ProductServiceImpl implements IProductService {

    private final IProductRepository repository;

    public ProductServiceImpl(IProductRepository repository) {
        this.repository = repository;
    }

    @Override
    public List<Product> findAll() {
        return repository.findAll();
    }

    @Override
    public Product save(Product product) {
        return repository.save(product);
    }

    @Override
    public void delete(Long id) {
        repository.deleteById(id);
    }
}
