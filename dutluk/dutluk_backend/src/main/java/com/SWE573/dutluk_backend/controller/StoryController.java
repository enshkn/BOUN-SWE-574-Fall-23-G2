package com.SWE573.dutluk_backend.controller;

import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.request.LikeRequest;
import com.SWE573.dutluk_backend.request.StoryCreateRequest;
import com.SWE573.dutluk_backend.request.StoryEditRequest;
import com.SWE573.dutluk_backend.service.StoryService;
import com.SWE573.dutluk_backend.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.*;

@RestController
@RequestMapping("/api/story")
public class StoryController {

    @Autowired
    StoryService storyService;
    @Autowired
    private UserService userService;

    @GetMapping("/all")
    public ResponseEntity<?> findAllStories(HttpServletRequest request){
        return ResponseEntity.ok(storyService.findAllByOrderByIdDesc());
    }

    //MOCK UNTIL ACTIVITY FEED LOGIC IS ESTABLISHED
    @GetMapping("/feed")
    public ResponseEntity<?> findFeedStories(HttpServletRequest request){
        return ResponseEntity.ok(storyService.findAllByOrderByIdDesc());
    }

    @PostMapping("/add")
    @CrossOrigin
    public ResponseEntity<?> addStory(@RequestBody StoryCreateRequest storyCreateRequest,HttpServletRequest request) throws ParseException, IOException {
        User user = userService.validateTokenizedUser(request);
        return ResponseEntity.ok(storyService.createStory(user,storyCreateRequest));
    }

    @GetMapping("/fromUser")
    public ResponseEntity<?> findAllStoriesfromUser(HttpServletRequest request){
        User user = userService.validateTokenizedUser(request);
        return ResponseEntity.ok(storyService.findByUserIdOrderByIdDesc(user.getId()));
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
            @RequestParam(required = false) String startTimeStamp,
            @RequestParam(required = false) String endTimeStamp,
            @RequestParam(required = false) String decade,
            @RequestParam(required = false) String season) throws ParseException {
        Set<Story> storySet = new HashSet<>();
        if(query != null){
            if(!query.equalsIgnoreCase("")){
                storySet.addAll(storyService.searchStoriesWithQuery(query));
            }
        }
        if(latitude != null && longitude != null && (radius != null)){
            if (query == null){
                storySet.addAll(storyService.searchStoriesWithLocationOnly(radius,latitude,longitude));
            }
            else{
                storySet.addAll(storyService.searchStoriesWithLocation(query,radius,latitude,longitude));
            }
        }
        if(startTimeStamp != null){
            if(endTimeStamp != null){
                storySet.addAll(storyService.searchStoriesWithMultipleDate(startTimeStamp,endTimeStamp));
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

    @GetMapping("/search/label")
    public ResponseEntity<?> searchStoriesByLabel(@RequestParam(required = false) String label){
        List<Story> labelResults = storyService.searchStoriesWithLabel(label);
        return ResponseEntity.ok(labelResults);
    }

    @GetMapping("/nearby")
    public ResponseEntity<?> nearbyStories(
            @RequestParam(required = false) Integer radius,
            @RequestParam(required = false) Double latitude,
            @RequestParam(required = false) Double longitude) throws ParseException {
        Set<Story> storySet = new HashSet<>();
        String query = null;
        if(latitude != null && longitude != null && (radius != null || radius != 0)){
            storySet.addAll(storyService.searchStoriesWithLocation(query,radius,latitude,longitude));
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
    @GetMapping("/delete/{storyId}")
    public ResponseEntity<?> deleteStory(@PathVariable Long storyId, HttpServletRequest request) {
        User tokenizedUser = userService.validateTokenizedUser(request);
        return ResponseEntity.ok(storyService.deleteByStoryId(storyService.getStoryByStoryId(storyId)));

    }

    @PostMapping("/edit/{storyId}")
    public ResponseEntity<?> editStory(@PathVariable Long storyId, @RequestBody StoryEditRequest storyEditRequest, HttpServletRequest request) throws ParseException, IOException {
        User tokenizedUser = userService.validateTokenizedUser(request);
        return ResponseEntity.ok(storyService.editStory(storyEditRequest,tokenizedUser,storyId));

    }

    @GetMapping("/liked")
    public ResponseEntity<?> likedStories(HttpServletRequest request){
        User tokenizedUser = userService.validateTokenizedUser(request);
        return ResponseEntity.ok(storyService.likedStories(tokenizedUser));
    }

    @GetMapping("/recent")
    public ResponseEntity<?> findRecentStories(HttpServletRequest request){
        return ResponseEntity.ok(storyService.findRecentStories());
    }
}
