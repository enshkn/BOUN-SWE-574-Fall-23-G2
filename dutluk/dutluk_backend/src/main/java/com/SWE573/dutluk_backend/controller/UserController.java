package com.SWE573.dutluk_backend.controller;


import com.SWE573.dutluk_backend.configuration.JwtUtil;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.request.FollowRequest;
import com.SWE573.dutluk_backend.request.LoginRequest;
import com.SWE573.dutluk_backend.request.RegisterRequest;
import com.SWE573.dutluk_backend.request.UserUpdateRequest;
import com.SWE573.dutluk_backend.response.Response;
import com.SWE573.dutluk_backend.response.SuccessfulResponse;
import com.SWE573.dutluk_backend.service.IntegrationService;
import com.SWE573.dutluk_backend.service.UserService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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

    @Value("${FRONTEND_URL}")
    private String FRONTEND_URL;





    @GetMapping("/test")
    public String helloWorld(){ return "<h1>Hello world!</h1>";}



    @GetMapping("/{id}")
    public ResponseEntity<?> getUserById(@PathVariable Long id,HttpServletRequest request) throws AccountNotFoundException {
        User user = userService.findByUserId(id);
        if(user != null){
            return IntegrationService.mobileCheck(request.getHeader("User-Agent"),user);
        }
        else{
            throw new AccountNotFoundException();
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest loginRequest,
                                   HttpServletRequest request,
                                         HttpServletResponse response) throws AccountNotFoundException {
        User foundUser = userService.findByIdentifierAndPassword(loginRequest.getIdentifier(), loginRequest.getPassword());
        String token = userService.generateUserToken(foundUser);
        Cookie cookie = new Cookie("Bearer", token);
        cookie.setPath("/api");
        response.addCookie(cookie);
        foundUser.setProfilePhoto(null);
        foundUser.setToken(token);
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),foundUser);
    }


    @GetMapping("/logout")
    public ResponseEntity<?> logout(HttpServletRequest request,HttpServletResponse response) {
        Cookie cookie = new Cookie("Bearer", null);
        cookie.setPath("/api");
        cookie.setMaxAge(0);
        response.addCookie(cookie);
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),"Logged out");
    }



    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@RequestBody RegisterRequest registerRequest,HttpServletRequest request) {
        User newUser = User.builder()
                .email(registerRequest.getEmail())
                .username(registerRequest.getUsername())
                .password(registerRequest.getPassword())
                .build();
        User registeredUser = userService.addUser(newUser);
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),registeredUser);
    }

    @PostMapping("/update")
    public ResponseEntity<?> updateUser(@RequestBody UserUpdateRequest updateRequest, HttpServletRequest request){
        User user = userService.validateTokenizedUser(request);
        User updatedUser =userService.updateUser(user,updateRequest);
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),updatedUser);
    }

    @PostMapping(value= "/photo", consumes = "multipart/form-data")
    public ResponseEntity<?> uploadPhoto(@RequestParam("photo") MultipartFile file,HttpServletRequest request) throws Exception{
        if (file.isEmpty()) {
            return ResponseEntity.badRequest().body("Please select a file to upload!");
        }
        try {
            byte[] uploadedPhoto = file.getBytes();
            User foundUser = userService.validateTokenizedUser(request);
            return IntegrationService.mobileCheck(request.getHeader("User-Agent"),foundUser);
        } catch (IOException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }


    @GetMapping("/all")
    public ResponseEntity<?> findAllUsers(HttpServletRequest request){
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),userService.findAll());
    }

    @PostMapping("/follow")
    public ResponseEntity<?> followUser(@RequestBody FollowRequest followRequest, HttpServletRequest request){
        User foundUser = userService.validateTokenizedUser(request);
        User followingUser = userService.followUser(foundUser, followRequest.getUserId());
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),followingUser);
    }

    @GetMapping("/profile")
    public ResponseEntity<?> showUserProfile(HttpServletRequest request){
        User foundUser = userService.validateTokenizedUser(request);
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),foundUser);
    }







}
