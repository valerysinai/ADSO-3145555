package com.sena.test.controller;

import com.sena.test.entity.UserRole;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/api/user-role")
public class UserRoleController {

    @GetMapping
    public List<UserRole> findAll() {
        return new ArrayList<>();
    }

    @PostMapping
    public UserRole save(@RequestBody UserRole role) {
        return role;
    }
}
