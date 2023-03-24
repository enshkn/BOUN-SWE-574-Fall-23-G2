package com.SWE573.dutluk_backend.service;

import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.security.auth.login.AccountNotFoundException;
import java.util.List;
import java.util.Optional;

@Service
public class UserService {


    @Autowired
    UserRepository userRepository;


    public User register(User user){
        return userRepository.save(user);
    }

    public List<User> findAll(){
        return userRepository.findAll();
    }

    public User findByUserId(Long id){
        Optional<User> optionalUser = userRepository.findById(id);
        User user = optionalUser.get();
        return user;
    }

    public User findByUsernameAndPassword(String username, String password) throws AccountNotFoundException {

        User user = userRepository.findByUsername(username);

        try {
            if (user.getPassword().equals(password)) {
                return user;
            }
        }
                catch(Exception e){
                throw new AccountNotFoundException();
            }
        return null;
        }
    }
