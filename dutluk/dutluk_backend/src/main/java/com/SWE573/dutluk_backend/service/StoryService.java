package com.SWE573.dutluk_backend.service;

import com.SWE573.dutluk_backend.model.Location;
import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.repository.StoryRepository;
import com.SWE573.dutluk_backend.request.StoryCreateRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.ParseException;
import java.time.LocalDate;
import java.util.*;

@Service
public class StoryService {

    @Autowired
    StoryRepository storyRepository;
    @Autowired
    private UserService userService;
    public List<Story> findAll(){
        return storyRepository.findAll();
    }

    public Story createStory(User foundUser, StoryCreateRequest storyCreateRequest) throws ParseException{
        Story createdStory = Story.builder()
                .title(storyCreateRequest.getTitle())
                .labels(storyCreateRequest.getLabels())
                .text(storyCreateRequest.getText())
                .startTimeStamp(storyCreateRequest.getStartTimeStamp())
                .endTimeStamp(storyCreateRequest.getEndTimeStamp())
                .season(storyCreateRequest.getSeason())
                .user(foundUser)
                .decade(storyCreateRequest.getDecade())
                .createdAt(new Date())
                .likes(new HashSet<>())
                .build();
        ArrayList<Location> allLocations = storyCreateRequest.getLocations();
        for (Location location : allLocations) {
            location.setStory(createdStory);
        }
        createdStory.setLocations(allLocations);
        return storyRepository.save(createdStory);

    }

    public List<Story> findAllStoriesByUserId(Long userId){
        return storyRepository.findByUserId(userId);
    }

    public Story getStoryByStoryId(Long id) {
        Optional<Story> optionalStory = storyRepository.findById(id);
        if (optionalStory.isEmpty()) {
            throw new NoSuchElementException("Story with id '" + id + "' not found");
        }
        return optionalStory.get();
    }

    public List<Story> findFollowingStories(User foundUser) {
        Set<User> followingList = foundUser.getFollowing();
        List<Long> idList = new ArrayList<>();
        List<Story> storyList = new ArrayList<>();
        for (User user : followingList){
            idList.add(user.getId());
        }
        for(Long id : idList){
            storyList.addAll(findAllStoriesByUserId(id));
        }
        return storyList;

    }

    public Story likeStory(Long storyId,Long userId){
        Story story = getStoryByStoryId(storyId);
        Set<Long> likesList = story.getLikes();
        if(!likesList.contains(userId)){
            likesList.add(userId);
        }
        else{
            likesList.remove(userId);
        }
        story.setLikes(likesList);
        return storyRepository.save(story);
    }
    public List<Story> searchStoriesWithLocation(String query, int radius, Double latitude, Double longitude) {
        double minLatitude, maxLatitude, minLongitude, maxLongitude;
        minLatitude = latitude - (radius / 111.0);
        maxLatitude = latitude + (radius / 111.0);
        minLongitude = longitude - (radius / (111.0 * Math.cos(Math.toRadians(latitude))));
        maxLongitude = longitude + (radius / (111.0 * Math.cos(Math.toRadians(latitude))));
        if (query != null) {
            return storyRepository.findByTitleContainingIgnoreCaseAndLocations_LatitudeBetweenAndLocations_LongitudeBetween(
                    query, minLatitude, maxLatitude, minLongitude, maxLongitude);
        }
        return storyRepository.findByLocations_LatitudeBetweenAndLocations_LongitudeBetween(
                minLatitude, maxLatitude, minLongitude, maxLongitude);
    }

    public Set<Story> searchStoriesWithQuery(String query) {
        Set<Story> storySet = new HashSet<>();
        storySet.addAll(storyRepository.findByTitleContainingIgnoreCase(query));
        storySet.addAll(storyRepository.findByLabelsContainingIgnoreCase(query));
        return storySet;
    }

    public List<Story> searchStoriesWithDecade(String decade){
        return storyRepository.findByDecadeContainingIgnoreCase(decade);
    }

    public List<Story> searchStoriesWithSeason(String season){
        return storyRepository.findBySeasonContainingIgnoreCase(season);
    }

    public List<Story> searchStoriesWithSingleDate(LocalDate startTimeStamp){
        return storyRepository.findByStartTimeStamp(startTimeStamp);
    }
    public List<Story> searchStoriesWithMultipleDate(LocalDate startTimeStamp,LocalDate endTimeStamp){
        return storyRepository.findByStartTimeStampBetween(startTimeStamp, endTimeStamp);
    }
}
