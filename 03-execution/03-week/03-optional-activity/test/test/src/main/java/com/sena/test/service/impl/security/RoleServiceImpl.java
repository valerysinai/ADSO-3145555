package com.sena.test.service.impl.security;

import org.springframework.stereotype.Service;
import java.util.List;

import com.sena.test.entity.Security.Role;
import com.sena.test.repository.security.IRoleRepository;
import com.sena.test.service.security.IRoleService;

@Service
public class RoleServiceImpl implements IRoleService {

    private final IRoleRepository repository;

    public RoleServiceImpl(IRoleRepository repository) {
        this.repository = repository;
    }

    @Override
    public List<Role> findAll() {
        return repository.findAll();
    }

    @Override
    public Role save(Role role) {
        return repository.save(role);
    }

    @Override
    public void delete(Long id) {
        repository.deleteById(id);
    }
}