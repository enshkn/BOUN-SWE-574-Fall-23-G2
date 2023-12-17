package com.SWE573.dutluk_backend.controller;


import com.SWE573.dutluk_backend.configuration.JwtUtil;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.request.FollowRequest;
import com.SWE573.dutluk_backend.request.LoginRequest;
import com.SWE573.dutluk_backend.request.RegisterRequest;
import com.SWE573.dutluk_backend.request.UserUpdateRequest;
import com.SWE573.dutluk_backend.service.IntegrationService;
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





    @GetMapping("/test")
    public String helloWorld(){ return "<h1>Hello world!</h1>";}

    @GetMapping("/all")
    public ResponseEntity<?> findAllUsers(HttpServletRequest request){
        return IntegrationService.mobileCheck(request,userService.findAll());
    }

    @PostMapping("/follow")
    public ResponseEntity<?> followUser(@RequestBody FollowRequest followRequest, HttpServletRequest request){
        User foundUser = userService.validateTokenizedUser(request);
        User followingUser = userService.followUser(foundUser, followRequest.getUserId());
        return IntegrationService.mobileCheck(request,followingUser);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getUserById(@PathVariable Long id,HttpServletRequest request) throws AccountNotFoundException {
        User user = userService.findByUserId(id);
        if(user != null){
            return IntegrationService.mobileCheck(request,user);
        }
        else{
            throw new AccountNotFoundException();
        }
    }

    @GetMapping("/isTokenValid")
    public ResponseEntity<?> showTokenValidation(HttpServletRequest request){
        return IntegrationService.mobileCheck(request,userService.validateTokenByRequest(request));
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest loginRequest,
                                   HttpServletRequest request,
                                   HttpServletResponse response){
        if(!userService.existsByEmail(loginRequest.getIdentifier()) && !userService.existsByUsername(loginRequest.getIdentifier())){
            return IntegrationService.mobileCheck(request,"User with identifier "+loginRequest.getIdentifier()+" not found",HttpStatus.NOT_FOUND);
        }
        try {
            User foundUser = userService.findByIdentifierAndPassword(loginRequest.getIdentifier(), loginRequest.getPassword());
            String token = userService.generateUserToken(foundUser);
            Cookie cookie = new Cookie("Bearer", token);
            cookie.setPath("/api");
            response.addCookie(cookie);
            foundUser.setToken(token);
            return IntegrationService.mobileCheck(request,foundUser);
        } catch (AccountNotFoundException e) {
            return IntegrationService.mobileCheck(request,"Wrong password",HttpStatus.NOT_FOUND);
        }
        catch (Exception e) {
            return IntegrationService.mobileCheck(request,"An error occurred on dutluk backend", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }



    @GetMapping("/logout")
    public ResponseEntity<?> logout(HttpServletRequest request,HttpServletResponse response) {
        response = userService.logout(response);
        return IntegrationService.mobileCheck(request,"Logged out");
    }

    @GetMapping("/profile")
    public ResponseEntity<?> showUserProfile(HttpServletRequest request){
        User foundUser = userService.validateTokenizedUser(request);
        return IntegrationService.mobileCheck(request,foundUser);
    }



    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@RequestBody RegisterRequest registerRequest, HttpServletRequest request) throws Exception{
        try {
            if(!userService.validateRegistrationInput(registerRequest)){
                return IntegrationService.mobileCheck(request,"Username or email already exists!",HttpStatus.NOT_FOUND);
            }
            User newUser = User.builder()
                    .email(registerRequest.getEmail())
                    .username(registerRequest.getUsername())
                    .password(registerRequest.getPassword())
                    .build();
            User registeredUser = userService.addUser(newUser);
            return IntegrationService.mobileCheck(request, registeredUser);
        } catch (Exception e) {
            return IntegrationService.mobileCheck(request,"An error occurred during registeration!",HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping(value= "/photo", consumes = "multipart/form-data")
    public ResponseEntity<?> uploadPhoto(@RequestParam("photo") MultipartFile file, HttpServletRequest request) throws Exception{
        if (file.isEmpty()) {
            return ResponseEntity.badRequest().body("Please select a file to upload!");
        }
        try {
            User foundUser = userService.validateTokenizedUser(request);
            User updatedUser = userService.updateUserPhoto(foundUser,file);
            return IntegrationService.mobileCheck(request,updatedUser);
        } catch (IOException e) {
            return IntegrationService.mobileCheck(request,"Photo could not be updated!",HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/update")
    public ResponseEntity<?> updateUser(@RequestBody UserUpdateRequest updateRequest, HttpServletRequest request){
        User user = userService.validateTokenizedUser(request);
        User updatedUser =userService.updateUser(user,updateRequest);
        return IntegrationService.mobileCheck(request,updatedUser);
    }







}
