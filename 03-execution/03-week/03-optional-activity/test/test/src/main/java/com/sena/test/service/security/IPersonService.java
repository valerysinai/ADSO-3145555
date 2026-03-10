package com.sena.test.service.security;

import java.util.List;
import com.sena.test.entity.Security.Person;

public interface IPersonService {
    List<Person> findAll();
    Person save(Person person);
    void delete(Long id);
}
