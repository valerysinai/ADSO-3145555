package com.sena.test.repository.security;

import com.sena.test.entity.Security.Role;
import org.springframework.data.jpa.repository.JpaRepository;

public interface IRoleRepository extends JpaRepository<Role, Long> {
}
