package com.sena.test.repository.security;

import com.sena.test.entity.Security.UserRole;
import org.springframework.data.jpa.repository.JpaRepository;

public interface IUserRoleRepository extends JpaRepository<UserRole, Long> {
}
