package com.SWE573.dutluk_backend.controller;

import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.request.LikeRequest;
import com.SWE573.dutluk_backend.request.StoryCreateRequest;
import com.SWE573.dutluk_backend.request.StoryEditRequest;
import com.SWE573.dutluk_backend.response.SuccessfulResponse;
import com.SWE573.dutluk_backend.service.StoryService;
import com.SWE573.dutluk_backend.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.text.ParseException;
import java.time.LocalDate;
import java.util.*;

@RestController
@RequestMapping("/api/mobile/story")
public class StoryMobileController {

    @Autowired
    StoryService storyService;
    @Autowired
    private UserService userService;

    private SuccessfulResponse successfulResponse = new SuccessfulResponse();

    @GetMapping("/all")
    public ResponseEntity<?> findAllStories(HttpServletRequest request){
        successfulResponse.setEntity(storyService.findAllByOrderByIdDesc());
        successfulResponse.setCount(storyService.findAllByOrderByIdDesc().size());
        return ResponseEntity.ok(successfulResponse);
    }

    //MOCK UNTIL ACTIVITY FEED LOGIC IS ESTABLISHED
    @GetMapping("/feed")
    public ResponseEntity<?> findFeedStories(HttpServletRequest request){
        successfulResponse.setEntity(storyService.findAllByOrderByIdDesc());
        successfulResponse.setCount(storyService.findAllByOrderByIdDesc().size());
        return ResponseEntity.ok(successfulResponse);
    }

    @PostMapping("/add")
    public ResponseEntity<?> addStory(@RequestBody StoryCreateRequest storyCreateRequest, HttpServletRequest request) throws ParseException, IOException {
        User user = userService.validateTokenizedUser(request);
        successfulResponse.setEntity(storyService.createStory(user,storyCreateRequest));
        return ResponseEntity.ok(successfulResponse);
    }

    @GetMapping("/fromUser")
    public ResponseEntity<?> findAllStoriesfromUser(HttpServletRequest request){
        User user = userService.validateTokenizedUser(request);
        successfulResponse.setEntity(storyService.findByUserIdOrderByIdDesc(user.getId()));
        successfulResponse.setCount(storyService.findByUserIdOrderByIdDesc(user.getId()).size());
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
        return ResponseEntity.ok(successfulResponse);
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
            if (query == null ){
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
        successfulResponse.setEntity(Objects.requireNonNullElse(storySet, "No stories with this search is found!"));
        successfulResponse.setCount(storySet.size());
        return ResponseEntity.ok(successfulResponse);
    }
    @GetMapping("/search/label")
    public ResponseEntity<?> searchStoriesByLabel(@RequestParam(required = false) String label){
        List<Story> labelResults = storyService.searchStoriesWithLabel(label);
        successfulResponse.setEntity(labelResults);
        successfulResponse.setCount(labelResults.size());
        return ResponseEntity.ok(successfulResponse);
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
        successfulResponse.setEntity(Objects.requireNonNullElse(storySet, "No stories with this search is found!"));
        successfulResponse.setCount(storySet.size());
        return ResponseEntity.ok(successfulResponse);
    }
    @PostMapping("/like")
    public ResponseEntity<?> likeStory(@RequestBody LikeRequest likeRequest, HttpServletRequest request){
        User tokenizedUser = userService.validateTokenizedUser(request);
        successfulResponse.setEntity(storyService.likeStory(likeRequest.getLikedEntityId(),tokenizedUser.getId()));
        return ResponseEntity.ok(successfulResponse);
    }
    @GetMapping("/delete/{storyId}")
    public ResponseEntity<?> deleteStory(@PathVariable Long storyId, HttpServletRequest request) {
        User tokenizedUser = userService.validateTokenizedUser(request);
        successfulResponse.setEntity(storyService.deleteByStoryId(storyService.getStoryByStoryId(storyId)));
        return ResponseEntity.ok(successfulResponse);

    }

    @PostMapping("/edit/{storyId}")
    public ResponseEntity<?> editStory(@PathVariable Long storyId, @RequestBody StoryEditRequest storyEditRequest, HttpServletRequest request) throws ParseException, IOException {
        User tokenizedUser = userService.validateTokenizedUser(request);
        successfulResponse.setEntity(storyService.editStory(storyEditRequest,tokenizedUser,storyId));
        successfulResponse.setCount(1);
        return ResponseEntity.ok(successfulResponse);
    }

    @GetMapping("/liked")
    public ResponseEntity<?> likedStories(HttpServletRequest request){
        User tokenizedUser = userService.validateTokenizedUser(request);
        successfulResponse.setEntity(storyService.likedStories(tokenizedUser));
        successfulResponse.setCount(storyService.likedStories(tokenizedUser).size());
        return ResponseEntity.ok(successfulResponse);
    }

    @GetMapping("/recent")
    public ResponseEntity<?> findRecentStories(HttpServletRequest request){
        successfulResponse.setEntity(storyService.findRecentStories());
        successfulResponse.setCount(storyService.findRecentStories().size());
        return ResponseEntity.ok(successfulResponse);
    }
}
