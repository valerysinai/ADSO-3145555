package com.sena.test.repository.security;

import com.sena.test.entity.Security.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface IUserRepository extends JpaRepository<User, Long> {
}
