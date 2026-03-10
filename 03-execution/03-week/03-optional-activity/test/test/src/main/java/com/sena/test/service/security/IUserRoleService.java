package com.sena.test.service.security;

import java.util.List;
import com.sena.test.entity.Security.UserRole;

public interface IUserRoleService {
    List<UserRole> findAll();
    UserRole save(UserRole userRole);
    void delete(Long id);
}