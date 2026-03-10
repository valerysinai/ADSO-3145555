package com.sena.test.controller.security;

import java.util.List;
import org.springframework.web.bind.annotation.*;

import com.sena.test.entity.Security.Role;
import com.sena.test.service.security.IRoleService;

@RestController
@RequestMapping("/api/roles")
public class RoleController {

    private final IRoleService service;

    public RoleController(IRoleService service) {
        this.service = service;
    }

    @GetMapping
    public List<Role> getAll() {
        return service.findAll();
    }

    @PostMapping
    public Role save(@RequestBody Role role) {
        return service.save(role);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        service.delete(id);
    }
}