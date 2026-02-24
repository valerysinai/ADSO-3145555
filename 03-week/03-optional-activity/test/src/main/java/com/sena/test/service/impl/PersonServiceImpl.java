package com.sena.test.service.impl;

import com.sena.test.entity.Person;
import com.sena.test.repository.IPersonRepository;
import com.sena.test.service.IPersonService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PersonServiceImpl implements IPersonService {

    private final IPersonRepository repository;

    public PersonServiceImpl(IPersonRepository repository) {
        this.repository = repository;
    }

    @Override
    public Person save(Person person) {
        return repository.save(person);
    }

    @Override
    public List<Person> findAll() {
        return repository.findAll();
    }
}