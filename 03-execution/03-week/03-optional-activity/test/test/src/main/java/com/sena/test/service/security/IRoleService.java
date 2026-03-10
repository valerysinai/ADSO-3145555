package com.sena.test.service.security;

import java.util.List;
import com.sena.test.entity.Security.Role;

public interface IRoleService {
    List<Role> findAll();
    Role save(Role role);
    void delete(Long id);
}
