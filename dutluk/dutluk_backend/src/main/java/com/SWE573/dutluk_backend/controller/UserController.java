package com.SWE573.dutluk_backend.controller;


import com.SWE573.dutluk_backend.configuration.JwtUtil;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.request.FollowRequest;
import com.SWE573.dutluk_backend.request.LoginRequest;
import com.SWE573.dutluk_backend.request.RegisterRequest;
import com.SWE573.dutluk_backend.request.UserUpdateRequest;
import com.SWE573.dutluk_backend.response.Response;
import com.SWE573.dutluk_backend.response.SuccessfulResponse;
import com.SWE573.dutluk_backend.service.UserService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.security.auth.login.AccountNotFoundException;
import java.io.IOException;


@RestController
@RequestMapping("/api/user")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private JwtUtil jwtUtil;

    private Response successfulResponse = new SuccessfulResponse();


    @GetMapping("/test")
    public String helloWorld(){
        return "<h1>Hello world!</h1>";
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getUserById(@PathVariable Long id,HttpServletRequest request) throws AccountNotFoundException {
        User user = userService.findByUserId(id);
        if(user != null){
            successfulResponse.setEntity(user);
            return ResponseEntity.ok(successfulResponse);
        }
        else{
            throw new AccountNotFoundException();
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest loginRequest,
                                   HttpServletResponse response) throws AccountNotFoundException {
        User foundUser = userService.findByIdentifierAndPassword(loginRequest.getIdentifier(), loginRequest.getPassword());
        Cookie cookie = new Cookie("Bearer", userService.generateUserToken(foundUser));
        cookie.setPath("/api");
        response.addCookie(cookie);
        foundUser.setProfilePhoto(null);
        successfulResponse.setEntity(foundUser);
        return ResponseEntity.ok(successfulResponse);
    }
    @GetMapping("/logout")
    public ResponseEntity<?> logout(HttpServletResponse response) {
        Cookie cookie = new Cookie("Bearer", null);
        cookie.setPath("/api");
        cookie.setMaxAge(0);
        response.addCookie(cookie);
        successfulResponse.setEntity("Logged out");
        return ResponseEntity.ok(successfulResponse);
    }

    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@RequestBody RegisterRequest registerRequest) {
        User newUser = User.builder()
                .email(registerRequest.getEmail())
                .username(registerRequest.getUsername())
                .password(registerRequest.getPassword())
                .build();
        User registeredUser = userService.addUser(newUser);
        successfulResponse.setEntity(registeredUser);
        return ResponseEntity.ok(successfulResponse);
    }
    @PostMapping("/update")
    public ResponseEntity<?> updateUser(@RequestBody UserUpdateRequest updateRequest, HttpServletRequest request){
        User user = userService.validateTokenizedUser(request);
        successfulResponse.setEntity(userService.updateUser(user,updateRequest));
        return ResponseEntity.ok(successfulResponse);
    }

    @PostMapping(value= "/photo", consumes = "multipart/form-data")
    public ResponseEntity<?> uploadPhoto(@RequestParam("photo") MultipartFile file,HttpServletRequest request) throws Exception{
        if (file.isEmpty()) {
            return ResponseEntity.badRequest().body("Please select a file to upload!");
        }
        try {
            byte[] uploadedPhoto = file.getBytes();
            User foundUser = userService.validateTokenizedUser(request);
            successfulResponse.setEntity(userService.updateUserPhoto(foundUser,uploadedPhoto));
            return ResponseEntity.ok(successfulResponse);
        } catch (IOException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }


    @GetMapping("/all")
    @CrossOrigin
    public ResponseEntity<?> findAllUsers(){
        successfulResponse.setEntity(userService.findAll());
        return ResponseEntity.ok(successfulResponse);
    }

    @PostMapping("/follow")
    public ResponseEntity<?> followUser(@RequestBody FollowRequest followRequest, HttpServletRequest request){
        User foundUser = userService.validateTokenizedUser(request);
        successfulResponse.setEntity(userService.followUser(foundUser, followRequest.getUserId()));
        return ResponseEntity.ok(successfulResponse);
    }

    @GetMapping("/profile")
    public ResponseEntity<?> showUserProfile(HttpServletRequest request){
        successfulResponse.setEntity(userService.validateTokenizedUser(request));
        return ResponseEntity.ok(successfulResponse);
    }







}
