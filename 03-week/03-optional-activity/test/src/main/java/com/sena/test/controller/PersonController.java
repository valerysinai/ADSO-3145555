package com.sena.test.controller;

import com.sena.test.entity.Person;
import com.sena.test.service.IPersonService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/person")
public class PersonController {

    private final IPersonService service;

    public PersonController(IPersonService service) {
        this.service = service;
    }

    @PostMapping
    public Person save(@RequestBody Person person) {
        return service.save(person);
    }

    @GetMapping
    public List<Person> findAll() {
        return service.findAll();
    }
}