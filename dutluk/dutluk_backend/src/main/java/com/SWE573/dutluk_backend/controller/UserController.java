package com.SWE573.dutluk_backend.controller;


import com.SWE573.dutluk_backend.configuration.JwtUtil;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.repository.UserRepository;
import com.SWE573.dutluk_backend.service.UserService;
import org.apache.tomcat.util.net.openssl.ciphers.Authentication;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.naming.AuthenticationException;
import javax.security.auth.login.AccountNotFoundException;


@RestController
@RequestMapping("/api/user")
public class UserController {

    @Autowired
    private UserService userService;



    @GetMapping("/test")
    public String helloWorld(){
        return "<h1>Hello world!</h1>";
    }

    @GetMapping("/{id}")
    public User getUserById(@PathVariable Long id, @RequestHeader("Authorization") String tokenHeader) throws AccountNotFoundException {
        String token = tokenHeader.substring(7); // remove "Bearer " prefix
        User user = userService.findByUserId(id);
        if(userService.validateToken(token, user)){
            return user;
        }
        else{
            throw new AccountNotFoundException();
        }

    }


    @PostMapping("/register")
    public User registerUser(@RequestParam("username") String username,
                             @RequestParam("email") String email,
                             @RequestParam("password") String password) {
        User newUser = new User();
        newUser.setEmail(email);
        newUser.setUsername(username);
        newUser.setPassword(password);
        User registeredUser = userService.addUser(newUser);
        User tokenizedUser = userService.updateUserToken(registeredUser);
        return tokenizedUser;
    }
    @PostMapping("/login")
    public ResponseEntity<String> login(@RequestParam("username") String username,
                                   @RequestParam("password") String password) throws AuthenticationException, AccountNotFoundException {
        // verify user credentials against database or authentication service
        User foundUser = userService.findByUsernameAndPassword(username,password);
        // return JWT token to client
        return ResponseEntity.ok(foundUser.getToken());
    }







}
