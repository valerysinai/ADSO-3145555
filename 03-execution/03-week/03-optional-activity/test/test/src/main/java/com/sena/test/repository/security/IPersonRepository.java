package com.sena.test.repository.security;

import com.sena.test.entity.Security.Person;
import org.springframework.data.jpa.repository.JpaRepository;

public interface IPersonRepository extends JpaRepository<Person, Long> {
}