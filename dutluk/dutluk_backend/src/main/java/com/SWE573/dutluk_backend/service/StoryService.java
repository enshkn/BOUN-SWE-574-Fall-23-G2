package com.SWE573.dutluk_backend.service;

import com.SWE573.dutluk_backend.model.Comment;
import com.SWE573.dutluk_backend.model.Location;
import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.repository.StoryRepository;
import com.SWE573.dutluk_backend.request.StoryCreateRequest;
import com.SWE573.dutluk_backend.request.StoryEditRequest;
import com.SWE573.dutluk_backend.response.StoryListResponse;
import com.SWE573.dutluk_backend.response.StoryResponse;
import com.fasterxml.jackson.core.JsonProcessingException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

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

    @Autowired
    RecommendationService recService;

    public List<Story> findAll(){
        List<Story> storyList = storyRepository.findAll();
        return (storyList != null) ? storyList : Collections.emptyList();
    }

    public List<Story> findAllByOrderByIdDesc(){
        List<Story> storyList = optimizeStoryLists(storyRepository.findAllByOrderByIdDesc());
        return (!storyList.isEmpty()) ? storyList : Collections.emptyList();
    }

    public Story createStory(User foundUser, StoryCreateRequest storyCreateRequest) throws ParseException, IOException {
        Story createdStory = Story.builder()
                .title(storyCreateRequest.getTitle())
                .labels(storyCreateRequest.getLabels())
                .text(imageService.parseAndSaveImages(storyCreateRequest.getText()))
                .startTimeStamp(storyCreateRequest.getStartTimeStamp())
                .endTimeStamp(storyCreateRequest.getEndTimeStamp())
                .season(storyCreateRequest.getSeason())
                .startHourFlag(storyCreateRequest.getStartHourFlag())
                .endHourFlag(storyCreateRequest.getEndHourFlag())
                .startDateFlag(storyCreateRequest.getStartDateFlag())
                .endDateFlag(storyCreateRequest.getEndDateFlag())
                .user(foundUser)
                .decade(storyCreateRequest.getDecade())
                .likes(new HashSet<>())
                .build();
        ArrayList<Location> allLocations = storyCreateRequest.getLocations();
        for (Location location : allLocations) {
            location.setStory(createdStory);
        }
        createdStory.setLocations(allLocations);
        Story committedStory = storyRepository.save(createdStory);
        if(recService.isRecEngineStatus()){
            recService.vectorizeRequest(committedStory);
        }
        return committedStory;

    }

    public List<Story> findAllStoriesByUserId(Long userId){
        List<Story> storyList = optimizeStoryLists(storyRepository.findByUserId(userId));
        return (!storyList.isEmpty()) ? storyList : Collections.emptyList();
    }

    public List<Story> findByUserIdOrderByIdDesc(Long userId){
        List<Story> storyList = optimizeStoryLists(storyRepository.findByUserIdOrderByIdDesc(userId));
        return (!storyList.isEmpty()) ? storyList : Collections.emptyList();
    }


    public Story getStoryByStoryId(Long id) {
        Optional<Story> optionalStory = storyRepository.findById(id);
        return optionalStory.orElse(null);
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
        return optimizeStoryLists(sortStoriesByDescending(storyList));

    }


    public Story likeStory(Long storyId,Long userId) throws JsonProcessingException {
        Story story = getStoryByStoryId(storyId);
        User user = userService.findByUserId(userId);
        Set<Long> likesList = story.getLikes();
        Set<Long> likedList = user.getLikedStories();
        int likedListSize;
        if(!likesList.contains(user.getId())){
            likesList.add(user.getId());
            likedList.add(storyId);
            likedListSize = likedList.size();
            if(recService.isRecEngineStatus()){
                recService.likedStory(story,user,likedListSize);
            }
        }
        else{
            likesList.remove(user.getId());
            likedList.remove(storyId);
            likedListSize = likedList.size();
            if(recService.isRecEngineStatus()){
                recService.dislikedStory(story,user,likedListSize);
            }
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

    public List<Story> searchStoriesWithQuery(String query) {
        Set<Story> results = new HashSet<>();
        results.addAll(storyRepository.findByTitleContainingIgnoreCase(query));
        results.addAll(searchStoriesWithLabel(query));
        return results.stream().toList();
    }
    public List<Story> searchStoriesWithTitle(String title) {
        Set<Story> results = new HashSet<>();
        results.addAll(storyRepository.findByTitleContainingIgnoreCase(title));
        return results.stream().toList();
    }

    public List<Story> searchStoriesWithLabel(String label){
        List<Story> results = storyRepository.findByLabelsContainingIgnoreCase(label);
        if(results == null || results.isEmpty()){
            return null;
        }
        return results.stream().toList();
    }

    public List<Story> searchStoriesWithDecade(String decade){
        Set<Story> results = new HashSet<>();
        results.addAll(storyRepository.findByDecadeContainingIgnoreCase(decade));
        try {
            Date startDecadeDate = convertToStartDate(decade);
            Date endDecadeDate = convertToEndDate(decade);
            results.addAll(storyRepository.findByStartTimeStampBetween(startDecadeDate,endDecadeDate));
            results.addAll(storyRepository.findByEndTimeStampBetween(startDecadeDate,endDecadeDate));
            for(Story story: results){
                story.setDecade(decade);
                results.add(story);
            }
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

    public Story enterStory(User foundUser, StoryEditRequest storyEditRequest) throws ParseException, IOException {
        Story createdStory = Story.builder()
                .title(storyEditRequest.getTitle())
                .labels(storyEditRequest.getLabels())
                .text(imageService.parseAndSaveImages(storyEditRequest.getText()))
                .startTimeStamp(storyEditRequest.getStartTimeStamp())
                .endTimeStamp(storyEditRequest.getEndTimeStamp())
                .season(storyEditRequest.getSeason())
                .startHourFlag(storyEditRequest.getStartHourFlag())
                .endHourFlag(storyEditRequest.getEndHourFlag())
                .startDateFlag(storyEditRequest.getStartDateFlag())
                .endDateFlag(storyEditRequest.getEndDateFlag())
                .user(foundUser)
                .decade(storyEditRequest.getDecade())
                .likes(new HashSet<>())
                .build();
        ArrayList<Location> allLocations = storyEditRequest.getLocations();
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
            Story committedStory;
            if(recService.isRecEngineStatus()){
                committedStory = storyRepository.save(enteredStory);
                recService.vectorizeEditRequest(committedStory);
            }
            else{
                committedStory = storyRepository.save(enteredStory);
            }
            return committedStory;
        }
        return getStoryByStoryId(storyId);
    }

    public List<Story> likedStories(User foundUser) {
        Set<Long> likeSet = foundUser.getLikedStories();
        List<Long> deletedStoryIdList = new ArrayList<>();
        List<Story> storyList = new ArrayList<>();
        for (Long storyId : likeSet) {
            Story story = getStoryByStoryId(storyId);
            if (story != null) {
                storyList.add(story);
            }
            else{
                deletedStoryIdList.add(storyId);
            }
        }
        deletedStoryIdList.forEach(likeSet::remove);
        foundUser.setLikedStories(likeSet);
        userService.editUser(foundUser);
        return optimizeStoryLists(sortStoriesByDescending(storyList));
    }

    public List<Story> findRecentStories() {
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.DAY_OF_MONTH, -7);
        Date date = calendar.getTime();
        return optimizeStoryLists(storyRepository.findByCreatedAtAfterOrderByIdDesc(date));
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

    public Story saveStory(Long storyId,Long userId){
        Story story = getStoryByStoryId(storyId);
        User user = userService.findByUserId(userId);
        Set<Long> storySavedByList = story.getSavedBy();
        Set<Long> savedList = user.getSavedStories();
        if(!storySavedByList.contains(user.getId())){
            storySavedByList.add(user.getId());
            savedList.add(storyId);
        }
        else{
            storySavedByList.remove(user.getId());
            savedList.remove(storyId);
        }
        story.setSavedBy(storySavedByList);
        user.setSavedStories(savedList);
        userService.editUser(user);
        return storyRepository.save(story);
    }

    public List<Story> savedStories(User foundUser) {
        Set<Long> savedSet = foundUser.getSavedStories();
        List<Long> deletedStoryIdList = new ArrayList<>();
        List<Story> storyList = new ArrayList<>();
        for (Long storyId : savedSet) {
            Story story = getStoryByStoryId(storyId);
            if (story != null) {
                storyList.add(story);
            }
            else{
                deletedStoryIdList.add(storyId);
            }
        }
        deletedStoryIdList.forEach(savedSet::remove);
        foundUser.setSavedStories(savedSet);
        userService.editUser(foundUser);
        return optimizeStoryLists(sortStoriesByDescending(storyList));
    }

    public List<Story> recommendedStories(User foundUser) {
        List<Long> recommendationList = new ArrayList<>(foundUser.getRecommendedStories());
        if(foundUser.getRecommendedStories() == null || foundUser.getRecommendedStories().isEmpty()){
            return findRecentStories();
        }
        List<Story> storyList = new ArrayList<>();
        for (Long storyId : recommendationList) {
            Story story = getStoryByStoryId(storyId);
            if (story != null) {
                storyList.add(story);
            }
        }
        return optimizeStoryLists(sortStoriesByDescending(storyList));
    }

    public List<Story> sortStoriesByDescending(List<Story> storyList) {
        if (storyList != null && !storyList.isEmpty()) {
            List<Story> sortedList = new ArrayList<>(storyList);
            sortedList.sort(Comparator.comparingLong(Story::getId).reversed());
            return sortedList;
        }
        return Collections.emptyList();
    }

    public Boolean isLikedByUser(Long storyId, User user){
        Set<Long> userLikedStories = user.getLikedStories();
        return userLikedStories.contains(storyId);
    }

    public Boolean isSavedByUser(Long storyId, User user){
        Set<Long> userSavedStories = user.getSavedStories();
        return userSavedStories.contains(storyId);
    }

    private List<Story> optimizeStoryLists(List<Story> storyList){
        List<Story> editedStoryList = new ArrayList<>();
        for(Story story : storyList){
            editedStoryList.add(story);
        }
        return (!editedStoryList.isEmpty()) ? editedStoryList : Collections.emptyList();
    }

    public StoryResponse storyAsStoryResponse(Story story){
        return new StoryResponse(story);
    }

    public List<StoryListResponse> storyListAsStoryListResponse(List<Story> storyList){
        List<StoryListResponse> storyResponseList = new ArrayList<>();
        for(Story story: storyList){
            storyResponseList.add(new StoryListResponse(story));
        }
        return storyResponseList;
    }

    public static String dateToStringBasedOnFlags(Date date, Integer hourFlag,Integer dateFlag) {
        if(date == null){
            return null;
        }

        SimpleDateFormat formatter;

        if (hourFlag == null || hourFlag == -1 || hourFlag == 1) {
            formatter = new SimpleDateFormat("dd/MM/yyyy HH:mm");
        } else {
            if(dateFlag == null){
                formatter = new SimpleDateFormat("dd/MM/yyyy");
            }
            else{
                if(dateFlag == 1){
                    formatter = new SimpleDateFormat("yyyy");
                }
                else if (dateFlag == 2) {
                    formatter = new SimpleDateFormat("MM/yyyy");
                }
                else{
                    formatter = new SimpleDateFormat("dd/MM/yyyy");
                }
            }


        }

        formatter.setTimeZone(TimeZone.getTimeZone("Europe/Istanbul"));

        return formatter.format(date);
    }
}
