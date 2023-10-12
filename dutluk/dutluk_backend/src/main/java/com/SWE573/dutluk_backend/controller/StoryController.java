package com.SWE573.dutluk_backend.controller;

import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.request.LikeRequest;
import com.SWE573.dutluk_backend.request.StoryCreateRequest;
import com.SWE573.dutluk_backend.response.SuccessfulResponse;
import com.SWE573.dutluk_backend.service.StoryService;
import com.SWE573.dutluk_backend.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.text.ParseException;
import java.time.LocalDate;
import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

@RestController
@RequestMapping("/api/story")
public class StoryController {

    @Autowired
    StoryService storyService;
    @Autowired
    private UserService userService;

    private SuccessfulResponse successfulResponse = new SuccessfulResponse();

    @GetMapping("/all")
    @CrossOrigin
    public ResponseEntity<?> findAllStories(HttpServletRequest request){
        successfulResponse.setEntity(storyService.findAll());
        successfulResponse.setCount(storyService.findAll().size());
        return ResponseEntity.ok(successfulResponse);
    }

    @PostMapping("/add")
    @CrossOrigin
    public ResponseEntity<?> addStory(@RequestBody StoryCreateRequest storyCreateRequest,HttpServletRequest request) throws ParseException {
        User user = userService.validateTokenizedUser(request);
        successfulResponse.setEntity(storyService.createStory(user,storyCreateRequest));
        return ResponseEntity.ok(successfulResponse);
    }

    @GetMapping("/fromUser")
    public ResponseEntity<?> findAllStoriesfromUser(HttpServletRequest request){
        User user = userService.validateTokenizedUser(request);
        successfulResponse.setEntity(storyService.findAllStoriesByUserId(user.getId()));
        successfulResponse.setCount(storyService.findAllStoriesByUserId(user.getId()).size());
        return ResponseEntity.ok(successfulResponse);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getStoryById(@PathVariable Long id,HttpServletRequest request){
        Story foundStory = storyService.getStoryByStoryId(id);
        if (foundStory!=null) {
            successfulResponse.setEntity(foundStory);
            return ResponseEntity.ok(successfulResponse);
        }
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/following")
    public ResponseEntity<?> findAllStoriesfromFollowings(HttpServletRequest request){
        User tokenizedUser = userService.validateTokenizedUser(request);
        successfulResponse.setEntity(storyService.findFollowingStories(tokenizedUser));
        successfulResponse.setCount(storyService.findFollowingStories(tokenizedUser).size());
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
        successfulResponse.setEntity(Objects.requireNonNullElse(storySet, "No stories with this search is found!"));
        successfulResponse.setCount(storySet.size());
        return ResponseEntity.ok(successfulResponse);
    }
    @PostMapping("/like/")
    public ResponseEntity<?> likeStory(@RequestBody LikeRequest likeRequest, HttpServletRequest request){
        User tokenizedUser = userService.validateTokenizedUser(request);
        return ResponseEntity.ok(storyService.likeStory(likeRequest.getLikedEntityId(),tokenizedUser.getId()));
    }
    @GetMapping("/delete/{storyId}")
    public ResponseEntity<?> deleteStory(@PathVariable Long storyId, HttpServletRequest request) {
        User tokenizedUser = userService.validateTokenizedUser(request);
        successfulResponse.setEntity(storyService.deleteByStoryId(storyService.getStoryByStoryId(storyId)));
        return ResponseEntity.ok(successfulResponse);

    }
}
