package com.sena.test.service;

import com.sena.test.entity.Person;
import java.util.List;

public interface IPersonService {

    Person save(Person person);

    List<Person> findAll();
}