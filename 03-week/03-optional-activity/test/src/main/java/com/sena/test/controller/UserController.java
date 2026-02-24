package com.sena.test.controller;

import com.sena.test.entity.User;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/api/user")
public class UserController {

    @GetMapping
    public List<User> findAll() {
        return new ArrayList<>();
    }

    @PostMapping
    public User save(@RequestBody User user) {
        return user;
    }
}
