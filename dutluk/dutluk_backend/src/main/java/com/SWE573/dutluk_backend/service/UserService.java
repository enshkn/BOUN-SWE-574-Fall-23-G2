package com.SWE573.dutluk_backend.service;

import com.SWE573.dutluk_backend.configuration.JwtUtil;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.security.auth.login.AccountNotFoundException;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

@Service
public class UserService{


    @Autowired
    UserRepository userRepository;

    @Autowired
    private JwtUtil jwtUtil;


    public User login(String username, String password) {
        User user = userRepository.findByUsername(username);
        if (user != null && user.getPassword().equals(password)) {
            String token = jwtUtil.generateToken(user);
            user.setToken(token);
            userRepository.save(user);
            return user;
        }
        return null;
    }


    public User addUser(User user){
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
    public User updateUserToken(User user){
        User foundUser = findByUserId(user.getId());
        foundUser.setToken(jwtUtil.generateToken(foundUser));
        return userRepository.save(foundUser);
    }

    public boolean validateToken(String token, User user) {
        return jwtUtil.validateToken(token,user);
    }
}

