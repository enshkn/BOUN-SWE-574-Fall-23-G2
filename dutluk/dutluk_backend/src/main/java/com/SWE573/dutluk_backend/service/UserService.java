package com.SWE573.dutluk_backend.service;

import com.SWE573.dutluk_backend.configuration.JwtUtil;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.repository.UserRepository;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import org.apache.commons.validator.routines.EmailValidator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.security.auth.login.AccountNotFoundException;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Objects;
import java.util.Optional;

@Service
public class UserService{


    @Autowired
    UserRepository userRepository;

    @Autowired
    private JwtUtil jwtUtil;

    private final EmailValidator emailValidator = EmailValidator.getInstance();


    public User addUser(User user){
        return userRepository.save(user);
    }
    public User validateTokenizedUser(HttpServletRequest request){
        String token = getTokenFromEndpoint(request);
        return findByUserToken(token);
    }

    public List<User> findAll(){
        return userRepository.findAll();
    }

    public User findByUserId(Long id) throws NoSuchElementException {
        Optional<User> optionalUser = userRepository.findById(id);
        if (optionalUser.isEmpty()) {
            throw new NoSuchElementException("User with id '" + id + "' not found");
        }
        return optionalUser.get();
    }

    public User findByUserToken(String token){
        return findByUserId(jwtUtil.extractId(token));
    }

    public User findByUsernameAndPassword(String username, String password) throws AccountNotFoundException {

        if(userRepository.findByUsername(username) != null){
            User user = userRepository.findByUsername(username);
            if (user.getPassword().equals(password)) {
                return user;
            }
            else{
                throw new AccountNotFoundException("Incorrect password");
            }

        }
        else{
            throw new AccountNotFoundException("User with username '"+username+"' not found");
        }
        }



    public String updateUserToken(User user){

        return jwtUtil.generateToken(user.getId());
    }
    public boolean validateToken(String token, User user) {
        return jwtUtil.validateToken(token,user);
    }

    public User updateUser(User user){
        User foundUser = findByUserId(user.getId());
        if(!Objects.equals(user.getBiography(), foundUser.getBiography())){
            foundUser.setBiography(user.getBiography());
        }
        if (user.getFollowers() != foundUser.getFollowers()) {
            foundUser.setFollowers(user.getFollowers());
        }
        if(user.getPhoto() != foundUser.getPhoto()){
            foundUser.setPhoto(user.getPhoto());
        }
        return userRepository.save(foundUser);
    }
    public String getTokenFromEndpoint(HttpServletRequest request) throws IllegalArgumentException, NullPointerException, IllegalStateException, SecurityException {

        if (request == null) {
            throw new IllegalArgumentException("Request parameter cannot be null");
        }
        // Get the cookie from the request
        Cookie[] cookies = request.getCookies();
        if (cookies == null) {
            // Handle case where no cookies are present
            throw new IllegalArgumentException("Cookies cannot be null");
        }
        // Loop through cookies to find the one with the token
        for (Cookie cookie : cookies) {
            if (cookie.getName().equals("Bearer")) {
                // Return the token as a response
                return cookie.getValue();
            }
        }
        // Handle case where no cookie with token is present
        throw new IllegalArgumentException("Bearer value cannot be null");
    }


    public User findByEmailAndPassword(String email,String password) throws AccountNotFoundException {
        User user = userRepository.findByEmail(email);
        if (user.getPassword().equals(password)) {
            //updateUserToken(user);
            return user;
        }
        else {
            throw new AccountNotFoundException("The account has not been found");
        }
    }
    public User findByIdentifierAndPassword(String identifier,String password) throws AccountNotFoundException {

        if (emailValidator.isValid(identifier)) {
            return findByEmailAndPassword(identifier,password);
        } else {
            return findByUsernameAndPassword(identifier,password);
        }
    }
}

