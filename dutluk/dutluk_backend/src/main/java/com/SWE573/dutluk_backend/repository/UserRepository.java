package com.SWE573.dutluk_backend.repository;


import com.SWE573.dutluk_backend.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;


public interface UserRepository extends JpaRepository<User,Long> {
    List<User> findAll();
    User findByUsername(String username);
    User findByEmail(String email);
    Boolean existsByUsername(String username);

    Boolean existsByEmail(String email);

    Boolean existsByEmailAndPassword(String identifier, String password);

    Boolean existsByUsernameAndPassword(String identifier, String password);
}
