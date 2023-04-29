package com.SWE573.dutluk_backend.controller;


import com.SWE573.dutluk_backend.configuration.JwtUtil;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.request.LoginRequest;
import com.SWE573.dutluk_backend.request.RegisterRequest;
import com.SWE573.dutluk_backend.request.UpdateRequest;
import com.SWE573.dutluk_backend.service.UserService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.security.auth.login.AccountNotFoundException;
import java.util.List;


@RestController
@RequestMapping("/api/user")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private JwtUtil jwtUtil;


    @GetMapping("/test")
    @CrossOrigin
    public String helloWorld(){
        return "<h1>Hello world!</h1>";
    }

    @GetMapping("/{id}")
    @CrossOrigin
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

    @PostMapping("/login")
    @CrossOrigin
    public ResponseEntity<?> login(@RequestBody LoginRequest loginRequest,
                                   HttpServletResponse response) throws AccountNotFoundException {
        // verify user credentials against database or authentication service
        User foundUser = userService.findByIdentifierAndPassword(loginRequest.getIdentifier(), loginRequest.getPassword());
        // return JWT token to client
        Cookie cookie = new Cookie("Bearer", userService.updateUserToken(foundUser));
        cookie.setPath("/api");
        response.addCookie(cookie);
        return ResponseEntity.ok(foundUser);
    }
    @PostMapping("/register")
    @CrossOrigin
    public ResponseEntity<?> registerUser(@RequestBody RegisterRequest registerRequest) {
        User newUser = User.builder()
                .email(registerRequest.getEmail())
                .username(registerRequest.getUsername())
                .password(registerRequest.getPassword())
                .build();
        User registeredUser = userService.addUser(newUser);
        return ResponseEntity.ok(registeredUser);
    }
    @PostMapping("/update")
    @CrossOrigin
    public User updateUser(@RequestBody UpdateRequest updateRequest, HttpServletRequest request){
        Long userId = userService.validateTokenizedUser(request);
        return userService.updateUser(userId,updateRequest);
    }

    @GetMapping("/all")
    @CrossOrigin
    public List<User> findAllUsers(){
        return userService.findAll();
    }







}
