package com.sena.test.controller.security;

import java.util.List;
import org.springframework.web.bind.annotation.*;

import com.sena.test.entity.Security.User;
import com.sena.test.service.security.IUserService;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final IUserService service;

    public UserController(IUserService service) {
        this.service = service;
    }

    @GetMapping
    public List<User> getAll() {
        return service.findAll();
    }

    @PostMapping
    public User save(@RequestBody User user) {
        return service.save(user);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        service.delete(id);
    }
}