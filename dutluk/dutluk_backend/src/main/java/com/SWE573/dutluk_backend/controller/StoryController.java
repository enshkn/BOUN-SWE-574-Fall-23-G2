package com.SWE573.dutluk_backend.controller;

import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.request.LikeRequest;
import com.SWE573.dutluk_backend.request.SaveRequest;
import com.SWE573.dutluk_backend.request.StoryCreateRequest;
import com.SWE573.dutluk_backend.request.StoryEditRequest;
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
    @Autowired
    RecommendationService recService;

    @GetMapping("/all")
    public ResponseEntity<?> findAllStories(HttpServletRequest request){
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),storyService.findAllByOrderByIdDesc());
    }

    //MOCK UNTIL RECOMMENDED LOGIC IS ESTABLISHED
    @GetMapping("/recommended")
    public ResponseEntity<?> findFeedStories(HttpServletRequest request){
        User user = userService.validateTokenizedUser(request);
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),storyService.recommendedStories(user));
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
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),storyService.findByUserIdOrderByIdDesc(user.getId()));

    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getStoryById(@PathVariable Long id,HttpServletRequest request){
        Story foundStory = storyService.getStoryByStoryId(id);
        if (foundStory!=null) {
            return IntegrationService.mobileCheck(request.getHeader("User-Agent"),foundStory);
        }
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/following")
    public ResponseEntity<?> findAllStoriesfromFollowings(HttpServletRequest request){
        User tokenizedUser = userService.validateTokenizedUser(request);
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),storyService.findFollowingStories(tokenizedUser));
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
        Set<Story> storySet = new HashSet<>();
        if(query != null){
            if(!query.equalsIgnoreCase("") && !query.equalsIgnoreCase("null")){
                storySet.addAll(storyService.searchStoriesWithQuery(query));
            }
        }
        if(latitude != null && longitude != null && (radius != null)){
            if (query != null && !query.equalsIgnoreCase("null")){
                storySet.addAll(storyService.searchStoriesWithLocation(query,radius,latitude,longitude));
            }
            else{
                storySet.addAll(storyService.searchStoriesWithLocationOnly(radius,latitude,longitude));
            }
        }
        if(startTimeStamp != null && !startTimeStamp.equalsIgnoreCase("null")){
            if(endTimeStamp != null && !endTimeStamp.equalsIgnoreCase("null")){
                storySet.addAll(storyService.searchStoriesWithMultipleDate(startTimeStamp,endTimeStamp));
            }
            else{
                storySet.addAll(storyService.searchStoriesWithSingleDate(startTimeStamp));
            }
        }
        if(decade != null && !decade.equalsIgnoreCase("null")){
            storySet.addAll(storyService.searchStoriesWithDecade(decade));
        }
        if(season != null && !season.equalsIgnoreCase("null")){
            storySet.addAll(storyService.searchStoriesWithSeason(season));
        }
        if(storySet.isEmpty()){
            Set<String> nullSet = new HashSet<>();
            return IntegrationService.mobileCheck(request.getHeader("User-Agent"),nullSet);
        }
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),Objects.requireNonNullElse(storySet, "No stories with this search is found!"));
    }

    @GetMapping("/search/label")
    public ResponseEntity<?> searchStoriesByLabel(@RequestParam(required = false) String label,
                                                  HttpServletRequest request){
        List<Story> labelResults = storyService.searchStoriesWithLabel(label);
        if(labelResults.isEmpty()){
            Set<String> nullSet = new HashSet<>();
            return IntegrationService.mobileCheck(request.getHeader("User-Agent"),nullSet);
        }
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),Objects.requireNonNullElse(storyService.sortStoriesByDescending(labelResults),"No story found!"));
    }

    @GetMapping("/nearby")
    public ResponseEntity<?> nearbyStories(
            @RequestParam(required = false) Integer radius,
            @RequestParam(required = false) Double latitude,
            @RequestParam(required = false) Double longitude,
            HttpServletRequest request) throws ParseException {
        Set<Story> storySet = new HashSet<>();

        if(latitude != null && longitude != null && (radius != null || radius != 0)){
            storySet.addAll(storyService.searchStoriesWithLocationOnly(radius,latitude,longitude));
        }
        if(storySet.isEmpty()){
            Set<String> nullSet = new HashSet<>();
            return IntegrationService.mobileCheck(request.getHeader("User-Agent"),nullSet);
        }
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),Objects.requireNonNullElse(storySet, "No stories with this search is found!"));
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

        Set<Story> titleSet = new HashSet<>();
        Set<Story> labelsSet = new HashSet<>();
        Set<Story> locationSet = new HashSet<>();
        Set<Story> dateSet = new HashSet<>();
        Set<Story> decadeSet = new HashSet<>();
        Set<Story> seasonSet = new HashSet<>();
        Set<Story> storySet = new HashSet<>(storyService.findAll());
        if(title != null){
            if(!title.equalsIgnoreCase("") && !title.equalsIgnoreCase("null")){
                titleSet.addAll(storyService.searchStoriesWithTitle(title));
                if(storyService.searchStoriesWithTitle(title) != null){
                    storySet.retainAll(titleSet);
                }
            }
        }
        if(labels != null){
            if(!labels.equalsIgnoreCase("") && !labels.equalsIgnoreCase("null")){
                labelsSet.addAll(storyService.searchStoriesWithLabel(labels));
                if(storyService.searchStoriesWithTitle(title) != null){
                    storySet.retainAll(labelsSet);
                }
            }
        }
        if(latitude != null && longitude != null && radius != null){
            locationSet.addAll(storyService.searchStoriesWithLocationOnly(radius,latitude,longitude));
            storySet.retainAll(locationSet);
        }
        if(startTimeStamp != null && !startTimeStamp.equalsIgnoreCase("null")){
            if(endTimeStamp != null && !endTimeStamp.equalsIgnoreCase("null")){
                dateSet.addAll(storyService.searchStoriesWithMultipleDate(startTimeStamp,endTimeStamp));
                if(storyService.searchStoriesWithMultipleDate(startTimeStamp,endTimeStamp) != null){
                    storySet.retainAll(dateSet);
                }
            }
            else{
                dateSet.addAll(storyService.searchStoriesWithSingleDate(startTimeStamp));
                if(storyService.searchStoriesWithSingleDate(startTimeStamp) != null){
                    storySet.retainAll(dateSet);
                }
            }
        }
        if(decade != null && !decade.equalsIgnoreCase("null")){
            decadeSet.addAll(storyService.searchStoriesWithDecade(decade));
            if(storyService.searchStoriesWithDecade(decade) != null){
                storySet.retainAll(decadeSet);
            }
        }
        if(season != null && !season.equalsIgnoreCase("null")){
            seasonSet.addAll(storyService.searchStoriesWithSeason(season));
            if(storyService.searchStoriesWithSeason(season) != null){
                storySet.retainAll(seasonSet);
            }
        }
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),Objects.requireNonNullElse(storySet, "No stories with this search is found!"));
    }

    @PostMapping("/like/")
    public ResponseEntity<?> likeStory(@RequestBody LikeRequest likeRequest, HttpServletRequest request) throws JsonProcessingException {
        User tokenizedUser = userService.validateTokenizedUser(request);
        Story likedStory = storyService.likeStory(likeRequest.getLikedEntityId(),tokenizedUser.getId());
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
        Story editedStory = storyService.editStory(storyEditRequest,tokenizedUser,storyId);
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),editedStory);

    }

    @GetMapping("/liked")
    public ResponseEntity<?> likedStories(HttpServletRequest request){
        User tokenizedUser = userService.validateTokenizedUser(request);
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),storyService.likedStories(tokenizedUser));

    }

    @GetMapping("/recent")
    public ResponseEntity<?> findRecentStories(HttpServletRequest request){
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),storyService.findRecentStories());
    }

    @GetMapping("/fromUserId/{userId}")
    public ResponseEntity<?> findAllStoriesbyUserId(@PathVariable Long userId, HttpServletRequest request){
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),storyService.findByUserIdOrderByIdDesc(userId));

    }

    @PostMapping("/save")
    public ResponseEntity<?> saveStory(@RequestBody SaveRequest saveRequest, HttpServletRequest request){
        User tokenizedUser = userService.validateTokenizedUser(request);
        Story savedStory = storyService.saveStory(saveRequest.getSavedEntityId(),tokenizedUser.getId());
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),savedStory);
    }

    @GetMapping("/saved")
    public ResponseEntity<?> savedStories(HttpServletRequest request){
        User tokenizedUser = userService.validateTokenizedUser(request);
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),storyService.savedStories(tokenizedUser));

    }

    @GetMapping("/savedByUser/{userId}")
    public ResponseEntity<?> savedStoriesByUser(@PathVariable Long userId, HttpServletRequest request){
        User foundUser = userService.findByUserId(userId);
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),storyService.savedStories(foundUser));

    }

    @GetMapping("/recEndPoint")
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
