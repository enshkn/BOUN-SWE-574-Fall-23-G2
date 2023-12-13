package com.SWE573.dutluk_backend.controller;

import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.request.LikeRequest;
import com.SWE573.dutluk_backend.request.SaveRequest;
import com.SWE573.dutluk_backend.request.StoryCreateRequest;
import com.SWE573.dutluk_backend.request.StoryEditRequest;
import com.SWE573.dutluk_backend.response.StoryListResponse;
import com.SWE573.dutluk_backend.response.StoryResponse;
import com.SWE573.dutluk_backend.service.IntegrationService;
import com.SWE573.dutluk_backend.service.RecommendationService;
import com.SWE573.dutluk_backend.service.StoryService;
import com.SWE573.dutluk_backend.service.UserService;
import com.fasterxml.jackson.core.JsonProcessingException;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.text.ParseException;
import java.util.List;
import java.util.Objects;

@RestController
@RequestMapping("/api/story")
public class StoryController {

    @Autowired
    StoryService storyService;
    @Autowired
    private UserService userService;
    @Autowired
    RecommendationService recService;

    @GetMapping("/all")
    public ResponseEntity<?> findAllStories(HttpServletRequest request){
        List<StoryListResponse> storyListResponse = storyService.storyListAsStoryListResponse(storyService.findAllByOrderByIdDesc());
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),storyListResponse);
    }


    @GetMapping("/recommended")
    public ResponseEntity<?> findFeedStories(HttpServletRequest request){
        User user = userService.validateTokenizedUser(request);
        List<StoryListResponse> storyListResponse = storyService.storyListAsStoryListResponse(storyService.recommendedStories(user));
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),storyListResponse);
    }

    @PostMapping("/add")
    @CrossOrigin
    public ResponseEntity<?> addStory(@RequestBody StoryCreateRequest storyCreateRequest,HttpServletRequest request) throws ParseException, IOException {
        User user = userService.validateTokenizedUser(request);
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),storyService.createStory(user,storyCreateRequest));
    }

    @GetMapping("/fromUser")
    public ResponseEntity<?> findAllStoriesfromUser(HttpServletRequest request){
        User user = userService.validateTokenizedUser(request);
        List<Story> storyList = storyService.findByUserIdOrderByIdDesc(user.getId());
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),storyList);

    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getStoryById(@PathVariable Long id,HttpServletRequest request){
        Story foundStory = storyService.getStoryByStoryId(id);
        if (foundStory!=null) {
            StoryResponse storyResponse = storyService.storyAsStoryResponse(foundStory);
            return IntegrationService.mobileCheck(request.getHeader("User-Agent"),storyResponse);
        }
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/following")
    public ResponseEntity<?> findAllStoriesfromFollowings(HttpServletRequest request){
        User tokenizedUser = userService.validateTokenizedUser(request);
        List<StoryListResponse> storyListResponse = storyService.storyListAsStoryListResponse(storyService.findFollowingStories(tokenizedUser));
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),storyListResponse);
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
            @RequestParam(required = false) String season,
            HttpServletRequest request) throws ParseException {
        List<Story> storyList = storyService.searchStoriesWithCombination(
                query,
                radius,
                latitude,
                longitude,
                startTimeStamp,
                endTimeStamp,
                decade,
                season);
        List<StoryListResponse> storyListResponse = storyService.storyListAsStoryListResponse(storyList);
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),Objects.requireNonNullElse(storyListResponse, "[]"));
    }

    @GetMapping("/search/label")
    public ResponseEntity<?> searchStoriesByLabel(@RequestParam(required = false) String label,
                                                  HttpServletRequest request){
        List<StoryListResponse> storyListResponse = storyService.storyListAsStoryListResponse(storyService.searchStoriesWithLabel(label));
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),Objects.requireNonNullElse(storyListResponse,"No story found!"));
    }

    @GetMapping("/nearby")
    public ResponseEntity<?> nearbyStories(
            @RequestParam(required = false) Integer radius,
            @RequestParam(required = false) Double latitude,
            @RequestParam(required = false) Double longitude,
            HttpServletRequest request){
        List<StoryListResponse> storyListResponse = storyService.storyListAsStoryListResponse(storyService.searchStoriesWithLocationOnly(radius,latitude,longitude).stream().toList());
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),Objects.requireNonNullElse(storyListResponse, "No stories with this search is found!"));
    }

    @GetMapping("/search/timeline")
    public ResponseEntity<?> timelineSearchStories(
            @RequestParam(required = false) String title,
            @RequestParam(required = false) String labels,
            @RequestParam(required = false) Integer radius,
            @RequestParam(required = false) Double latitude,
            @RequestParam(required = false) Double longitude,
            @RequestParam(required = false) String startTimeStamp,
            @RequestParam(required = false) String endTimeStamp,
            @RequestParam(required = false) String decade,
            @RequestParam(required = false) String season,
            HttpServletRequest request) throws ParseException {
        List<Story> storyList = storyService.searchStoriesWithIntersection(
                title,
                labels,
                radius,
                latitude,
                longitude,
                startTimeStamp,
                endTimeStamp,
                decade,
                season);
        List<StoryListResponse> storyListResponse = storyService.storyListAsStoryListResponse(storyList);
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),Objects.requireNonNullElse(storyListResponse, "No stories with this search is found!"));
    }

    @PostMapping("/like/")
    public ResponseEntity<?> likeStory(@RequestBody LikeRequest likeRequest, HttpServletRequest request) throws JsonProcessingException {
        User tokenizedUser = userService.validateTokenizedUser(request);
        StoryResponse likedStory = storyService.storyAsStoryResponse(storyService.likeStory(likeRequest.getLikedEntityId(),tokenizedUser.getId()));
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),likedStory);
    }
    @GetMapping("/delete/{storyId}")
    public ResponseEntity<?> deleteStory(@PathVariable Long storyId, HttpServletRequest request) {
        User tokenizedUser = userService.validateTokenizedUser(request);
        String deletedStory = storyService.deleteByStoryId(storyService.getStoryByStoryId(storyId));
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),deletedStory);

    }

    @PostMapping("/edit/{storyId}")
    public ResponseEntity<?> editStory(@PathVariable Long storyId, @RequestBody StoryEditRequest storyEditRequest, HttpServletRequest request) throws ParseException, IOException {
        User tokenizedUser = userService.validateTokenizedUser(request);
        StoryResponse editedStory = storyService.storyAsStoryResponse(storyService.editStory(storyEditRequest,tokenizedUser,storyId));
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),editedStory);

    }

    @GetMapping("/liked")
    public ResponseEntity<?> likedStories(HttpServletRequest request){
        User tokenizedUser = userService.validateTokenizedUser(request);
        List<StoryListResponse> storyListResponse = storyService.storyListAsStoryListResponse(storyService.likedStories(tokenizedUser));
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),storyListResponse);

    }

    @GetMapping("/recent")
    public ResponseEntity<?> findRecentStories(HttpServletRequest request){
        List<StoryListResponse> storyListResponse = storyService.storyListAsStoryListResponse(storyService.findRecentStories());
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),storyListResponse);
    }

    @GetMapping("/fromUserId/{userId}")
    public ResponseEntity<?> findAllStoriesbyUserId(@PathVariable Long userId, HttpServletRequest request){
        List<StoryListResponse> storyListResponse = storyService.storyListAsStoryListResponse(storyService.findByUserIdOrderByIdDesc(userId));
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),storyListResponse);

    }

    @PostMapping("/save")
    public ResponseEntity<?> saveStory(@RequestBody SaveRequest saveRequest, HttpServletRequest request){
        User tokenizedUser = userService.validateTokenizedUser(request);
        StoryResponse savedStory = storyService.storyAsStoryResponse(storyService.saveStory(saveRequest.getSavedEntityId(),tokenizedUser.getId()));
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),savedStory);
    }

    @GetMapping("/saved")
    public ResponseEntity<?> savedStories(HttpServletRequest request){
        User tokenizedUser = userService.validateTokenizedUser(request);
        List<StoryListResponse> storyListResponse = storyService.storyListAsStoryListResponse(storyService.savedStories(tokenizedUser));
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),storyListResponse);

    }

    @GetMapping("/savedByUser/{userId}")
    public ResponseEntity<?> savedStoriesByUser(@PathVariable Long userId, HttpServletRequest request){
        User foundUser = userService.findByUserId(userId);
        List<StoryListResponse> storyListResponse = storyService.storyListAsStoryListResponse(storyService.savedStories(foundUser));
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),storyListResponse);

    }

    @GetMapping("/karadutStatusCheck")
    public ResponseEntity<?> recommendationEndpointTest(HttpServletRequest request){
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),recService.testEndpoint());
    }

    @GetMapping("/isLikedByUser/{storyId}")
    public ResponseEntity<?> isStoryLikedByUser(@PathVariable Long storyId,HttpServletRequest request){
        User tokenizedUser = userService.validateTokenizedUser(request);
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),storyService.isLikedByUser(storyId,tokenizedUser));
    }

    @GetMapping("/isSavedByUser/{storyId}")
    public ResponseEntity<?> isStorySavedByUser(@PathVariable Long storyId,HttpServletRequest request){
        User tokenizedUser = userService.validateTokenizedUser(request);
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),storyService.isSavedByUser(storyId,tokenizedUser));
    }
}
