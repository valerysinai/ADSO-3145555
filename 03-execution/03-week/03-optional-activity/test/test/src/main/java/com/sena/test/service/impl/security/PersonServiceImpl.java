package com.sena.test.service.impl.security;

import org.springframework.stereotype.Service;
import java.util.List;

import com.sena.test.entity.Security.Person;
import com.sena.test.repository.security.IPersonRepository;
import com.sena.test.service.security.IPersonService;

@Service
public class PersonServiceImpl implements IPersonService {

    private final IPersonRepository repository;

    public PersonServiceImpl(IPersonRepository repository) {
        this.repository = repository;
    }

    @Override
    public List<Person> findAll() {
        return repository.findAll();
    }

    @Override
    public Person save(Person person) {
        return repository.save(person);
    }

    @Override
    public void delete(Long id) {
        repository.deleteById(id);
    }
}