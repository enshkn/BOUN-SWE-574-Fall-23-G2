package com.SWE573.dutluk_backend.controller;

import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.request.LikeRequest;
import com.SWE573.dutluk_backend.request.StoryCreateRequest;
import com.SWE573.dutluk_backend.service.StoryService;
import com.SWE573.dutluk_backend.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.text.ParseException;
import java.time.LocalDate;
import java.util.HashSet;
import java.util.List;
import java.util.Objects;
import java.util.Set;

@RestController
@RequestMapping("/api/story")
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
    public ResponseEntity<?> addStory(@RequestBody StoryCreateRequest storyCreateRequest,HttpServletRequest request) throws ParseException {
        User user = userService.validateTokenizedUser(request);
        return ResponseEntity.ok(storyService.createStory(user,storyCreateRequest));
    }

    @GetMapping("/fromUser")
    public ResponseEntity<?> findAllStoriesfromUser(HttpServletRequest request){
        User user = userService.validateTokenizedUser(request);
        return ResponseEntity.ok(storyService.findAllStoriesByUserId(user.getId()));
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getStoryById(@PathVariable Long id,HttpServletRequest request){
        Story foundStory = storyService.getStoryByStoryId(id);
        if (foundStory!=null) {
            return ResponseEntity.ok(foundStory);
        }
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/following")
    public ResponseEntity<?> findAllStoriesfromFollowings(HttpServletRequest request){
        User tokenizedUser = userService.validateTokenizedUser(request);
        return ResponseEntity.ok(storyService.findFollowingStories(tokenizedUser));
    }

    @GetMapping("/search")
    public ResponseEntity<?> searchStories(
            @RequestParam(required = false) String query,
            @RequestParam(required = false) Integer radius,
            @RequestParam(required = false) Double latitude,
            @RequestParam(required = false) Double longitude,
            @RequestParam(required = false) LocalDate startTimeStamp,
            @RequestParam(required = false) LocalDate endTimeStamp,
            @RequestParam(required = false) String decade,
            @RequestParam(required = false) String season) {
        Set<Story> storySet = new HashSet<>();
        if(query != null){
            if(latitude != null && longitude != null && (radius != null || radius != 0)){
                storySet.addAll(storyService.searchStoriesWithLocation(query,radius,latitude,longitude));
            }else if(!query.equalsIgnoreCase("")){
                storySet.addAll(storyService.searchStoriesWithQuery(query));
            }
        }
        if(startTimeStamp != null){
            if(endTimeStamp != null){
                storySet.addAll(storyService.searchStoriesWithMultipleDate(startTimeStamp, endTimeStamp));
            }
            else{
                storySet.addAll(storyService.searchStoriesWithSingleDate(startTimeStamp));
            }
        }
        if(decade != null){
            storySet.addAll(storyService.searchStoriesWithDecade(decade));
        }
        if(season != null){
            storySet.addAll(storyService.searchStoriesWithSeason(season));
        }
        if(storySet.isEmpty()){
            Set<String> nullSet = new HashSet<>();
            nullSet.add("No story found!");
            return ResponseEntity.ok(nullSet);
        }
        return ResponseEntity.ok(Objects.requireNonNullElse(storySet, "No stories with this search is found!"));
    }
    @PostMapping("/like/")
    public ResponseEntity<?> likeStory(@RequestBody LikeRequest likeRequest, HttpServletRequest request){
        User tokenizedUser = userService.validateTokenizedUser(request);
        return ResponseEntity.ok(storyService.likeStory(likeRequest.getLikedEntityId(),tokenizedUser.getId()));
    }
}
