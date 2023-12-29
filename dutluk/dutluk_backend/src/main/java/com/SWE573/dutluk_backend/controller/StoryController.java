package com.SWE573.dutluk_backend.controller;

import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.request.LikeRequest;
import com.SWE573.dutluk_backend.request.SaveRequest;
import com.SWE573.dutluk_backend.request.StoryEnterRequest;
import com.SWE573.dutluk_backend.response.MyStoryListResponse;
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

import static com.SWE573.dutluk_backend.service.StoryService.*;

@RestController
@RequestMapping("/api/story")
public class StoryController {

    @Autowired
    StoryService storyService;
    @Autowired
    UserService userService;
    @Autowired
    RecommendationService recService;

    @PostMapping("/add")
    public ResponseEntity<?> addStory(@RequestBody StoryEnterRequest storyEnterRequest, HttpServletRequest request) throws IOException {
        User user = userService.validateTokenizedUser(request);
        return IntegrationService.mobileCheck(request,storyService.createStory(user, storyEnterRequest));
    }

    @GetMapping("/all")
    public ResponseEntity<?> findAllStories(HttpServletRequest request){
        List<StoryListResponse> storyListResponse = storyListAsStoryListResponse(storyService.findAllByOrderByIdDesc());
        return IntegrationService.mobileCheck(request,storyListResponse);
    }

    @GetMapping("/delete/{storyId}")
    public ResponseEntity<?> deleteStory(@PathVariable Long storyId, HttpServletRequest request) {
        String deletedStory = storyService.deleteByStoryId(storyService.getStoryByStoryId(storyId));
        return IntegrationService.mobileCheck(request,deletedStory);

    }

    @PostMapping("delete/all/RecEngine/{password}")
    public ResponseEntity<?> deleteAllStoriesOnRecEngine(@PathVariable String password, HttpServletRequest request){
        return IntegrationService.mobileCheck(request,recService.deleteAllOnRecEngine(password));
    }

    @PostMapping("/edit/{storyId}")
    public ResponseEntity<?> editStory(@PathVariable Long storyId, @RequestBody StoryEnterRequest storyEditRequest, HttpServletRequest request) throws IOException {
        User tokenizedUser = userService.validateTokenizedUser(request);
        StoryResponse editedStory = storyAsStoryResponse(storyService.editStory(storyEditRequest,tokenizedUser,storyId));
        return IntegrationService.mobileCheck(request,editedStory);

    }

    @GetMapping("/editView/{id}")
    public ResponseEntity<?> getStoryEditViewById(@PathVariable Long id,HttpServletRequest request){
        User user = userService.validateTokenizedUser(request);
        Story foundStory = storyService.getStoryByStoryIdWithPercentage(id,user);
        if (foundStory!=null) {
            return IntegrationService.mobileCheck(request,foundStory);
        }
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/following")
    public ResponseEntity<?> findAllStoriesFromFollowings(HttpServletRequest request) {
        User tokenizedUser = userService.validateTokenizedUser(request);
        List<StoryListResponse> storyListResponse = storyListAsStoryListResponse(storyService.findFollowingStories(tokenizedUser));
        return IntegrationService.mobileCheck(request,storyListResponse);
    }

    @GetMapping("/fromUser")
    public ResponseEntity<?> findAllStoriesFromUser(HttpServletRequest request) {
        User user = userService.validateTokenizedUser(request);
        List<MyStoryListResponse> storyList = storyListAsMyStoryListResponse(storyService.findByUserIdOrderByIdDesc(user.getId()));
        return IntegrationService.mobileCheck(request,storyList);

    }

    @GetMapping("/fromUserId/{userId}")
    public ResponseEntity<?> findAllStoriesbyUserId(@PathVariable Long userId, HttpServletRequest request){
        List<StoryListResponse> storyListResponse = storyListAsStoryListResponse(storyService.findByUserIdOrderByIdDesc(userId));
        return IntegrationService.mobileCheck(request,storyListResponse);

    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getStoryById(@PathVariable Long id,HttpServletRequest request){
        User user = userService.validateTokenizedUser(request);
        Story foundStory = storyService.getStoryByStoryIdWithPercentage(id,user);
        if (foundStory!=null) {
            StoryResponse storyResponse = storyAsStoryResponse(foundStory);
            return IntegrationService.mobileCheck(request,storyResponse);
        }
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/isLikedByUser/{storyId}")
    public ResponseEntity<?> isStoryLikedByUser(@PathVariable Long storyId,HttpServletRequest request){
        User tokenizedUser = userService.validateTokenizedUser(request);
        return IntegrationService.mobileCheck(request,storyService.isLikedByUser(storyId,tokenizedUser));
    }

    @GetMapping("/isSavedByUser/{storyId}")
    public ResponseEntity<?> isStorySavedByUser(@PathVariable Long storyId,HttpServletRequest request){
        User tokenizedUser = userService.validateTokenizedUser(request);
        return IntegrationService.mobileCheck(request,storyService.isSavedByUser(storyId,tokenizedUser));
    }

    @GetMapping("/karadutStatusCheck")
    public ResponseEntity<?> recommendationEndpointTest(HttpServletRequest request){
        return IntegrationService.mobileCheck(request,recService.testEndpoint());
    }

    @PostMapping("/like/")
    public ResponseEntity<?> likeStory(@RequestBody LikeRequest likeRequest, HttpServletRequest request) throws JsonProcessingException {
        User tokenizedUser = userService.validateTokenizedUser(request);
        StoryResponse likedStory = storyAsStoryResponse(storyService.likeStory(likeRequest.getLikedEntityId(),tokenizedUser.getId()));
        return IntegrationService.mobileCheck(request,likedStory);
    }

    @GetMapping("/liked")
    public ResponseEntity<?> likedStories(HttpServletRequest request){
        User tokenizedUser = userService.validateTokenizedUser(request);
        List<StoryListResponse> storyListResponse = storyListAsStoryListResponse(storyService.likedStories(tokenizedUser));
        return IntegrationService.mobileCheck(request,storyListResponse);

    }

    @GetMapping("/nearby")
    public ResponseEntity<?> nearbyStories(
            @RequestParam(required = false) Integer radius,
            @RequestParam(required = false) Double latitude,
            @RequestParam(required = false) Double longitude,
            HttpServletRequest request){
        List<StoryListResponse> storyListResponse = storyListAsStoryListResponse(storyService.searchStoriesWithLocationOnly(radius,latitude,longitude).stream().toList());
        return IntegrationService.mobileCheck(request, storyListResponse);
    }

    @GetMapping("/recommended")
    public ResponseEntity<?> findFeedStories(HttpServletRequest request){
        User user = userService.validateTokenizedUser(request);
        List<StoryListResponse> storyListResponse = storyListAsStoryListResponse(storyService.recommendedStories(user));
        return IntegrationService.mobileCheck(request,storyListResponse);
    }

    @GetMapping("/recent")
    public ResponseEntity<?> findRecentStories(HttpServletRequest request){
        List<StoryListResponse> storyListResponse = storyListAsStoryListResponse(storyService.findRecentStories());
        return IntegrationService.mobileCheck(request,storyListResponse);
    }

    @PostMapping("/save")
    public ResponseEntity<?> saveStory(@RequestBody SaveRequest saveRequest, HttpServletRequest request){
        User tokenizedUser = userService.validateTokenizedUser(request);
        StoryResponse savedStory = storyAsStoryResponse(storyService.saveStory(saveRequest.getSavedEntityId(),tokenizedUser.getId()));
        return IntegrationService.mobileCheck(request,savedStory);
    }

    @GetMapping("/saved")
    public ResponseEntity<?> savedStories(HttpServletRequest request){
        User tokenizedUser = userService.validateTokenizedUser(request);
        List<StoryListResponse> storyListResponse = storyListAsStoryListResponse(storyService.savedStories(tokenizedUser));
        return IntegrationService.mobileCheck(request,storyListResponse);

    }

    @GetMapping("/savedByUser/{userId}")
    public ResponseEntity<?> savedStoriesByUser(@PathVariable Long userId, HttpServletRequest request){
        User foundUser = userService.findByUserId(userId);
        List<StoryListResponse> storyListResponse = storyListAsStoryListResponse(storyService.savedStories(foundUser));
        return IntegrationService.mobileCheck(request,storyListResponse);

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
            @RequestParam(required = false) String endDecade,
            @RequestParam(required = false) String season,
            @RequestParam(required = false) String endSeason,
            HttpServletRequest request) throws ParseException {
        List<Story> storyList = storyService.searchStoriesWithCombination(
                query,
                radius,
                latitude,
                longitude,
                startTimeStamp,
                endTimeStamp,
                decade,
                endDecade,
                season,
                endSeason);
        List<StoryListResponse> storyListResponse = storyListAsStoryListResponse(storyList);
        return IntegrationService.mobileCheck(request, storyListResponse);
    }

    @GetMapping("/search/label")
    public ResponseEntity<?> searchStoriesByLabel(@RequestParam(required = false) String label,
                                                  HttpServletRequest request){
        List<StoryListResponse> storyListResponse = storyListAsStoryListResponse(storyService.searchStoriesWithLabel(label));
        return IntegrationService.mobileCheck(request, storyListResponse);
    }

    @GetMapping("/send/allToKaradut")
    public ResponseEntity<?> sendAllStoriesToKaradut(HttpServletRequest request) {
        return IntegrationService.mobileCheck(request, storyService.sendBatchofStories());
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
            @RequestParam(required = false) String endDecade,
            @RequestParam(required = false) String season,
            @RequestParam(required = false) String endSeason,
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
                endDecade,
                season,
                endSeason);
        List<StoryListResponse> storyListResponse = storyListAsStoryListResponse(storyList);
        return IntegrationService.mobileCheck(request, storyListResponse);
    }


}
