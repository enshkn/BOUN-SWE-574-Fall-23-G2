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
    UserService userService;

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
        User user = userService.findByUserId(userId);
        Set<Long> likesList = story.getLikes();
        Set<Long> likedList = user.getLikedStories();
        if(!likesList.contains(user.getId())){
            likesList.add(user.getId());
            likedList.add(storyId);
        }
        else{
            likesList.remove(user.getId());
            likedList.remove(storyId);
        }
        story.setLikes(likesList);
        user.setLikedStories(likedList);
        userService.editUser(user);
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

    public List<Story> searchStoriesWithLocationOnly(int radius, Double latitude, Double longitude) {
        double minLatitude, maxLatitude, minLongitude, maxLongitude;
        minLatitude = latitude - (radius / 111.0);
        maxLatitude = latitude + (radius / 111.0);
        minLongitude = longitude - (radius / (111.0 * Math.cos(Math.toRadians(latitude))));
        maxLongitude = longitude + (radius / (111.0 * Math.cos(Math.toRadians(latitude))));
        return storyRepository.findByLocations_LatitudeBetweenAndLocations_LongitudeBetween(
                minLatitude, maxLatitude, minLongitude, maxLongitude);
    }

    public Set<Story> searchStoriesWithQuery(String query) {
        Set<Story> storySet = new HashSet<>();
        storySet.addAll(storyRepository.findByTitleContainingIgnoreCase(query));
        storySet.addAll(searchStoriesWithLabel(query));
        return storySet;
    }

    public List<Story> searchStoriesWithLabel(String label){
        return storyRepository.findByLabelsContainingIgnoreCase(label);
    }

    public List<Story> searchStoriesWithDecade(String decade){
        Set<Story> results = new HashSet<>();
        results.addAll(storyRepository.findByDecadeContainingIgnoreCase(decade));
        try {
            Date startDecadeDate = convertToStartDate(decade);
            Date endDecadeDate = convertToEndDate(decade);
            results.addAll(storyRepository.findByStartTimeStampBetween(startDecadeDate,endDecadeDate));
            results.addAll(storyRepository.findByEndTimeStampBetween(startDecadeDate,endDecadeDate));
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }

        return results.stream().toList();
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

    public List<Story> likedStories(User foundUser) {
        List<Long> likeList = new ArrayList<>(foundUser.getLikedStories());
        List<Story> storyList = new ArrayList<>();
        for (Long storyId : likeList) {
            Story story = getStoryByStoryId(storyId);
            if (story != null) {
                storyList.add(story);
            }
        }
        return storyList;
    }

    public List<Story> findRecentStories() {
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.DAY_OF_MONTH, -7);
        Date date = calendar.getTime();
        return storyRepository.findByCreatedAtAfterOrderByCreatedAtDesc(date);
    }

    private static Date convertToStartDate(String decadeString) throws ParseException {

        int decade = Integer.parseInt(decadeString.substring(0, 4));
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.YEAR, decade);
        calendar.set(Calendar.MONTH, Calendar.JANUARY);
        calendar.set(Calendar.DAY_OF_MONTH, 1);
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);

        return calendar.getTime();
    }

    private static Date convertToEndDate(String decadeString) throws ParseException {

        int decade = Integer.parseInt(decadeString.substring(0, 4));
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.YEAR, decade);
        calendar.set(Calendar.MONTH, Calendar.DECEMBER);
        calendar.set(Calendar.DAY_OF_MONTH, 31);
        calendar.set(Calendar.HOUR_OF_DAY, 23);
        calendar.set(Calendar.MINUTE, 59);
        calendar.set(Calendar.SECOND, 59);
        calendar.set(Calendar.MILLISECOND, 0);
        calendar.add(Calendar.YEAR,9);

        return calendar.getTime();
    }
}
