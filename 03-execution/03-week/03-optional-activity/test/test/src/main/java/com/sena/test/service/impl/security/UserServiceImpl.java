package com.sena.test.service.impl.security;

import org.springframework.stereotype.Service;
import java.util.List;

import com.sena.test.entity.Security.User;
import com.sena.test.repository.security.IUserRepository;
import com.sena.test.service.security.IUserService;

@Service
public class UserServiceImpl implements IUserService {

    private final IUserRepository repository;

    public UserServiceImpl(IUserRepository repository) {
        this.repository = repository;
    }

    @Override
    public List<User> findAll() {
        return repository.findAll();
    }

    @Override
    public User save(User user) {
        return repository.save(user);
    }

    @Override
    public void delete(Long id) {
        repository.deleteById(id);
    }
}