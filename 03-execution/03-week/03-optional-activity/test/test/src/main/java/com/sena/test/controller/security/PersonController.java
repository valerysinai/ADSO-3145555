package com.sena.test.controller.security;

import java.util.List;
import org.springframework.web.bind.annotation.*;

import com.sena.test.entity.Security.Person;
import com.sena.test.service.security.IPersonService;

@RestController
@RequestMapping("/api/persons")
public class PersonController {

    private final IPersonService service;

    public PersonController(IPersonService service) {
        this.service = service;
    }

    @GetMapping
    public List<Person> getAll() {
        return service.findAll();
    }

    @PostMapping
    public Person save(@RequestBody Person person) {
        return service.save(person);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        service.delete(id);
    }
}