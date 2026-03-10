package com.sena.test.service.impl.security;

import org.springframework.stereotype.Service;
import java.util.List;

import com.sena.test.entity.Security.UserRole;
import com.sena.test.repository.security.IUserRoleRepository;
import com.sena.test.service.security.IUserRoleService;

@Service
public class UserRoleServiceImpl implements IUserRoleService {

    private final IUserRoleRepository repository;

    public UserRoleServiceImpl(IUserRoleRepository repository) {
        this.repository = repository;
    }

    @Override
    public List<UserRole> findAll() {
        return repository.findAll();
    }

    @Override
    public UserRole save(UserRole userRole) {
        return repository.save(userRole);
    }

    @Override
    public void delete(Long id) {
        repository.deleteById(id);
    }
}