package com.SWE573.dutluk_backend.service;

import com.SWE573.dutluk_backend.configuration.JwtUtil;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.repository.UserRepository;
import com.SWE573.dutluk_backend.request.UserUpdateRequest;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import org.apache.commons.validator.routines.EmailValidator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.security.auth.login.AccountNotFoundException;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;
import java.util.Set;

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
        User user = userRepository.findByUsername(username);
        if (user != null && user.getPassword().equals(password)) {
            return user;
        } else {
            throw new AccountNotFoundException("User with username '" + username + "' not found or incorrect password");
        }
    }



    public String generateUserToken(User user){
        return jwtUtil.generateToken(user.getId());
    }

    public User updateUser(User foundUser, UserUpdateRequest updateRequest){
        if(updateRequest.getBiography() != null &&
                !updateRequest.getBiography().equals(foundUser.getBiography())){
            foundUser.setBiography(updateRequest.getBiography());
        }
        return userRepository.save(foundUser);
    }
    public String getTokenFromEndpoint(HttpServletRequest request) throws IllegalArgumentException, NullPointerException, IllegalStateException, SecurityException {


        Cookie[] cookies = request.getCookies();
        if (cookies == null) {
            throw new IllegalArgumentException("Cookies cannot be null");
        }
        for (Cookie cookie : cookies) {
            if (cookie.getName().equals("Bearer")) {
                return cookie.getValue();
            }
        }
        throw new IllegalArgumentException("Bearer value cannot be null");
    }


    public User findByEmailAndPassword(String email,String password) throws AccountNotFoundException {
        User user = userRepository.findByEmail(email);
        if (user.getPassword().equals(password)) {
            return user;
        }
        throw new AccountNotFoundException("The account has not been found");
    }
    public User findByIdentifierAndPassword(String identifier,String password) throws AccountNotFoundException {

        if (emailValidator.isValid(identifier)) {
            return findByEmailAndPassword(identifier,password);
        } else {
            return findByUsernameAndPassword(identifier,password);
        }
    }

    public User followUser(User foundUser,Long userId){
        Set<User> followingList = foundUser.getFollowing();
        User toBeFollowedUser = findByUserId(userId);
        Set<User> followedList = toBeFollowedUser.getFollowers();
        if(followedList.contains(foundUser) && followingList.contains(toBeFollowedUser)){
            followingList.remove(toBeFollowedUser);
            followedList.remove(foundUser);
        }
        else{
            followingList.add(toBeFollowedUser);
            followedList.add(foundUser);
        }
        toBeFollowedUser.setFollowers(followedList);
        foundUser.setFollowing(followingList);
        userRepository.save(foundUser);
        return userRepository.save(toBeFollowedUser);
    }

    public User editUser(User user){
        return userRepository.save(user);
    }

    public User updateUserPhoto(User foundUser, byte[] uploadedPhoto) {
        foundUser.setProfilePhoto(uploadedPhoto);
        return userRepository.save(foundUser);
    }
}

