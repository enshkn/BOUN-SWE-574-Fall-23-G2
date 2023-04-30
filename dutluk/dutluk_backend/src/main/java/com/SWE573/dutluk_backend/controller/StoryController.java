package com.SWE573.dutluk_backend.controller;

import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.request.StoryCreateRequest;
import com.SWE573.dutluk_backend.service.StoryService;
import com.SWE573.dutluk_backend.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/story")
@CrossOrigin(origins = "http://localhost:3000", allowCredentials = "true")
public class StoryController {

    @Autowired
    StoryService storyService;
    @Autowired
    private UserService userService;
    @GetMapping("/all")
    @CrossOrigin
    public List<Story> findAllStories(HttpServletRequest request){
        return storyService.findAll();
    }

    @PostMapping("/add")
    @CrossOrigin
    public ResponseEntity<?> addStory(@RequestBody StoryCreateRequest storyCreateRequest,HttpServletRequest request){
        User user = userService.validateTokenizedUser(request);
        return ResponseEntity.ok(storyService.createStory(user,storyCreateRequest));
    }

    @GetMapping("/fromUser")
    @CrossOrigin
    public ResponseEntity<?> findAllStoriesfromUser(HttpServletRequest request){
        User user = userService.validateTokenizedUser(request);
        return ResponseEntity.ok(storyService.findAllStoriesByUserId(user.getId()));
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getStoryById(@PathVariable Long id, HttpServletRequest request){
        Story foundStory = storyService.getStoryByStoryId(id);
        if (foundStory!=null) {
            return ResponseEntity.ok(foundStory);
        }
        return ResponseEntity.notFound().build();
    }

}
