package com.SWE573.dutluk_backend.service;

import com.SWE573.dutluk_backend.model.Comment;
import com.SWE573.dutluk_backend.model.Location;
import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.repository.StoryRepository;
import com.SWE573.dutluk_backend.request.StoryCreateRequest;
import com.SWE573.dutluk_backend.request.StoryEditRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.List;

@Service
public class StoryService {

    @Autowired
    StoryRepository storyRepository;

    @Autowired
    CommentService commentService;

    @Autowired
    ImageService imageService;



    public List<Story> findAll(){
        return storyRepository.findAll();
    }

    public List<Story> findAllByOrderByIdDesc(){
        return storyRepository.findAllByOrderByIdDesc();
    }

    public Story createStory(User foundUser, StoryCreateRequest storyCreateRequest) throws ParseException, IOException {
        Story createdStory = Story.builder()
                .title(storyCreateRequest.getTitle())
                .labels(storyCreateRequest.getLabels())
                .text(imageService.parseAndSaveImages(storyCreateRequest.getText()))
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

    public List<Story> findByUserIdOrderByIdDesc(Long userId){
        return storyRepository.findByUserIdOrderByIdDesc(userId);
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
            storyList.addAll(findByUserIdOrderByIdDesc(id));
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

    public List<Story> searchStoriesWithSingleDate(String startTimeStamp) throws ParseException {
        Date formattedDate = stringToDate(startTimeStamp);
        return storyRepository.findByStartTimeStamp(formattedDate);
    }
    public List<Story> searchStoriesWithMultipleDate(String startTimeStamp,String endTimeStamp) throws ParseException {
        Date formattedStartDate = stringToDate(startTimeStamp);
        Date formattedEndDate = stringToDate(endTimeStamp);
        return storyRepository.findByStartTimeStampBetween(formattedStartDate, formattedEndDate);
    }

    public String deleteByStoryId(Story story) {
        List<Comment> commentList = story.getComments();
        for (Comment comment: commentList) {
            commentService.deleteComment(comment);
        }
        storyRepository.deleteById(story.getId());
        return "deleted";
    }

    public Date stringToDate(String timeStamp) throws ParseException{
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        return dateFormat.parse(timeStamp);
    }

    public Story enterStory(User foundUser, StoryEditRequest storyEditRequestRequest) throws ParseException, IOException {
        Story createdStory = Story.builder()
                .title(storyEditRequestRequest.getTitle())
                .labels(storyEditRequestRequest.getLabels())
                .text(imageService.parseAndSaveImages(storyEditRequestRequest.getText()))
                .startTimeStamp(storyEditRequestRequest.getStartTimeStamp())
                .endTimeStamp(storyEditRequestRequest.getEndTimeStamp())
                .season(storyEditRequestRequest.getSeason())
                .user(foundUser)
                .decade(storyEditRequestRequest.getDecade())
                .createdAt(new Date())
                .likes(new HashSet<>())
                .build();
        ArrayList<Location> allLocations = storyEditRequestRequest.getLocations();
        for (Location location : allLocations) {
            location.setStory(createdStory);
        }
        createdStory.setLocations(allLocations);
        return createdStory;
    }

    public Story editStory(StoryEditRequest request, User user, Long storyId) throws ParseException, IOException {
        Story story = getStoryByStoryId(storyId);
        if(Objects.equals(story.getUser().getId(),user.getId())){
            Story enteredStory = enterStory(user,request);
            enteredStory.setId(storyId);
            enteredStory.setLikes(story.getLikes());
            enteredStory.setId(story.getId());
            enteredStory.setComments(story.getComments());
            return storyRepository.save(enteredStory);
        }
        return null;
    }
}
