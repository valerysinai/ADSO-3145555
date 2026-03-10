package com.sena.test.controller.security;

import java.util.List;
import org.springframework.web.bind.annotation.*;

import com.sena.test.entity.Security.UserRole;
import com.sena.test.service.security.IUserRoleService;

@RestController
@RequestMapping("/api/user-roles")
public class UserRoleController {

    private final IUserRoleService service;

    public UserRoleController(IUserRoleService service) {
        this.service = service;
    }

    @GetMapping
    public List<UserRole> getAll() {
        return service.findAll();
    }

    @PostMapping
    public UserRole save(@RequestBody UserRole userRole) {
        return service.save(userRole);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        service.delete(id);
    }
}