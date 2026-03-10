package com.sena.test.service.security;

import java.util.List;
import com.sena.test.entity.Security.User;

public interface IUserService {
    List<User> findAll();
    User save(User user);
    void delete(Long id);
}