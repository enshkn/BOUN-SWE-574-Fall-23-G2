package com.SWE573.dutluk_backend.repository;


import com.SWE573.dutluk_backend.model.User;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface UserRepository extends CrudRepository<User,Long> {
    List<User> findAll();
    User findByUsername(String username);
}
