package com.SWE573.dutluk_backend.controller;

import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.security.auth.login.AccountNotFoundException;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/user")
public class UserController {

    @Autowired
    UserService userService;

    @GetMapping("/test")
    public String helloWorld(){
        return "<h1>Hello world!</h1>";
    }

    @PostMapping("/register")
    public User registerUser(String email, String username, String password){
        User user = new User();
        user.setEmail(email);
        user.setPassword(password);
        user.setUsername(username);
        User registeredUser = userService.register(user);
        return registeredUser;
    }

    @PostMapping("/login")
    public User loginUser(String username,String password) throws AccountNotFoundException {


        return userService.findByUserId(userService.findByUsernameAndPassword(username,password).getId());
    }


}
