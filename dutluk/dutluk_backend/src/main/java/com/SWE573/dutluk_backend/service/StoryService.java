package com.SWE573.dutluk_backend.service;

import com.SWE573.dutluk_backend.model.Comment;
import com.SWE573.dutluk_backend.model.Location;
import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.repository.StoryRepository;
import com.SWE573.dutluk_backend.request.StoryCreateRequest;
import com.SWE573.dutluk_backend.request.StoryEditRequest;
import com.SWE573.dutluk_backend.response.MyStoryListResponse;
import com.SWE573.dutluk_backend.response.StoryListResponse;
import com.SWE573.dutluk_backend.response.StoryResponse;
import com.fasterxml.jackson.core.JsonProcessingException;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
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
        List<Story> storyList = storyRepository.findAllByOrderByIdDesc();
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
        List<Story> storyList = storyRepository.findByUserId(userId);
        return (!storyList.isEmpty()) ? storyList : Collections.emptyList();
    }

    public List<Story> findByUserIdOrderByIdDesc(Long userId){
        List<Story> storyList = storyRepository.findByUserIdOrderByIdDesc(userId);
        return (!storyList.isEmpty()) ? storyList : Collections.emptyList();
    }


    public Story getStoryByStoryId(Long id) {
        Optional<Story> optionalStory = storyRepository.findById(id);
        return optionalStory.orElse(null);
    }

    public Story getStoryByStoryIdWithPercentage(Long storyId,User user) {
        Story story = addPercentageToStory(getStoryByStoryId(storyId),user.getRecommendedStoriesMap().get(storyId));
        return story;
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
        return sortStoriesByDescending(storyList);

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

    public List<Story> searchStoriesWithLocationOnly(Integer radius, Double latitude, Double longitude) {
        if(latitude != null && longitude != null && (radius != null && radius != 0)){
            double minLatitude, maxLatitude, minLongitude, maxLongitude;
            minLatitude = latitude - (radius / 111.0);
            maxLatitude = latitude + (radius / 111.0);
            minLongitude = longitude - (radius / (111.0 * Math.cos(Math.toRadians(latitude))));
            maxLongitude = longitude + (radius / (111.0 * Math.cos(Math.toRadians(latitude))));
            List<Story> storyList = storyRepository.findByLocations_LatitudeBetweenAndLocations_LongitudeBetween(
                    minLatitude, maxLatitude, minLongitude, maxLongitude);
            if(storyList.isEmpty()){
                return new ArrayList<>();
            }
            return storyList;
        }
        return null;
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
            return new ArrayList<>();
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
        Date formattedStartDate = stringToDate(startTimeStamp);
        Date formattedEndDate;
        switch (startTimeStamp.length()) {
            case 4: // yyyy
                formattedEndDate = incrementDateByOneYear(formattedStartDate);
                break;
            case 7: // yyyy-MM
                formattedEndDate = incrementDateByOneMonth(formattedStartDate);
                break;
            case 10: // yyyy-MM-dd
                formattedEndDate = incrementDateByOneDay(formattedStartDate);
                break;
            default:
                throw new ParseException("Invalid date format", 0);
        }
        return storyRepository.findByStartTimeStampBetween(formattedStartDate,formattedEndDate);
    }
    public List<Story> searchStoriesWithMultipleDate(String startTimeStamp,String endTimeStamp) throws ParseException {
        Date formattedStartDate = stringToDate(startTimeStamp);
        Date formattedEndDate = stringToDate(endTimeStamp);
        return storyRepository.findByStartTimeStampBetween(formattedStartDate, formattedEndDate);
    }

    public static String getDecadeString(Story story) {
        Calendar calendar = Calendar.getInstance();
        if(story.getDecade() == null && story.getStartTimeStamp() != null){
            calendar.setTime(story.getStartTimeStamp());
            int year = calendar.get(Calendar.YEAR);
            int decadeStart = year - (year % 10);
            return decadeStart + "s";
        }
        return story.getDecade();
    }

    public String deleteByStoryId(Story story) {
        List<Comment> commentList = story.getComments();
        for (Comment comment: commentList) {
            commentService.deleteComment(comment);
        }
        if(recService.isRecEngineStatus()){
            storyRepository.deleteById(story.getId());
            recService.deleteStoryRequest(story.getId());
            return "deleted";
        }
        storyRepository.deleteById(story.getId());
        return "deleted";
    }

    public Date stringToDate(String timeStamp) throws ParseException {

        if (timeStamp.length() == 4) { // yyyy
            timeStamp += "-01-01";
        } else if (timeStamp.length() == 7) { // yyyy-MM
            timeStamp += "-01";
        }
        // yyyy-MM-dd format will remain unchanged
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        return dateFormat.parse(timeStamp);
    }

    public Story enterStory(StoryEditRequest storyEditRequest,Story foundStory) throws ParseException, IOException {

        foundStory.setLabels(storyEditRequest.getLabels());
        foundStory.setTitle(storyEditRequest.getTitle());
        foundStory.setText(imageService.parseAndSaveImages(storyEditRequest.getText()));
        foundStory.setStartTimeStamp(storyEditRequest.getStartTimeStamp());
        foundStory.setEndTimeStamp(storyEditRequest.getEndTimeStamp());
        foundStory.setStartHourFlag(storyEditRequest.getStartHourFlag());
        foundStory.setDecade(storyEditRequest.getDecade());
        foundStory.setSeason(storyEditRequest.getSeason());
        foundStory.setLocations(storyEditRequest.getLocations());
        foundStory.setStartHourFlag(storyEditRequest.getStartHourFlag());
        foundStory.setEndHourFlag(storyEditRequest.getEndHourFlag());
        foundStory.setStartDateFlag(storyEditRequest.getStartDateFlag());
        foundStory.setEndDateFlag(storyEditRequest.getEndDateFlag());
        List<Location> storyLocations = foundStory.getLocations();
        storyLocations.clear();
        foundStory.setLocations(storyLocations);
        storyRepository.save(foundStory);
        storyLocations.addAll(storyEditRequest.getLocations());
        foundStory.setLocations(storyLocations);
        return foundStory;
    }

    public Story editStory(StoryEditRequest request, User user, Long storyId) throws ParseException, IOException {
        Story story = getStoryByStoryId(storyId);
        if(Objects.equals(story.getUser().getId(),user.getId())){
            Story enteredStory = enterStory(request,story);
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
        return story;
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
        return sortStoriesByDescending(storyList);
    }

    public List<Story> findRecentStories() {
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.DAY_OF_MONTH, -7);
        Date date = calendar.getTime();
        return storyRepository.findByCreatedAtAfterOrderByIdDesc(date);
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
        return sortStoriesByDescending(storyList);
    }

    public List<Story> recommendedStories(User foundUser) {
        Map<Long,String> recommendationMap;
        if(recService.isRecEngineStatus()){
            recommendationMap = recService.recommendStory(foundUser);
        }
        else{
            recommendationMap = foundUser.getRecommendedStoriesMap();
        }
        List<Long> recommendationList = new ArrayList<>(recommendationMap.keySet());
        if(foundUser.getRecommendedStoriesMap() == null || recommendationMap.isEmpty()){
            return findRecentStories();
        }
        List<Story> storyList = new ArrayList<>();
        for (Long storyId : recommendationList) {
            Story story = getStoryByStoryId(storyId);
            if (story != null) {
                Story storyWithPercentage = addPercentageToStory(story, foundUser.getRecommendedStoriesMap().get(storyId));
                storyList.add(storyWithPercentage);
            }
        }
        return sortStoriesByDescending(storyList);
    }

    public Story addPercentageToStory(Story story, String percentage) {
        if(percentage != null){
            story.setPercentage(percentage);
        }
        return story;
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

    public StoryResponse storyAsStoryResponse(Story story){
        return new StoryResponse(story);
    }

    public List<StoryListResponse> storyListAsStoryListResponse(List<Story> storyList){
        if(storyList.isEmpty()){
            return new ArrayList<>();
        }
        List<StoryListResponse> storyResponseList = new ArrayList<>();
        for(Story story: storyList){
            storyResponseList.add(new StoryListResponse(story));
        }
        return storyResponseList;
    }

    public List<MyStoryListResponse> storyListAsMyStoryListResponse(List<Story> storyList){
        if(storyList.isEmpty()){
            return new ArrayList<>();
        }
        List<MyStoryListResponse> storyResponseList = new ArrayList<>();
        for(Story story: storyList){
            storyResponseList.add(new MyStoryListResponse(story));
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

    public Date incrementDateByOneYear(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.add(Calendar.YEAR, 1);
        return calendar.getTime();
    }

    public Date incrementDateByOneMonth(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.add(Calendar.MONTH, 1);
        return calendar.getTime();
    }

    public Date incrementDateByOneDay(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.add(Calendar.DATE, 1);
        return calendar.getTime();
    }



    public List<Story> searchStoriesWithCombination(
            String query,
            Integer radius,
            Double latitude,
            Double longitude,
            String startTimeStamp,
            String endTimeStamp,
            String decade,
            String season) throws ParseException {
        Set<Story> storySet = new HashSet<>();
        if(query != null){
            if(!query.equalsIgnoreCase("") && !query.equalsIgnoreCase("null")){
                storySet.addAll(searchStoriesWithQuery(query));
            }
        }
        if(latitude != null && longitude != null && (radius != null)){
            if (query != null && !query.equalsIgnoreCase("null")){
                storySet.addAll(searchStoriesWithLocation(query,radius,latitude,longitude));
            }
            else{
                storySet.addAll(searchStoriesWithLocationOnly(radius,latitude,longitude));
            }
        }
        if(startTimeStamp != null && !startTimeStamp.equalsIgnoreCase("null")){
            if(endTimeStamp != null && !endTimeStamp.equalsIgnoreCase("null")){
                storySet.addAll(searchStoriesWithMultipleDate(startTimeStamp,endTimeStamp));
            }
            else{
                storySet.addAll(searchStoriesWithSingleDate(startTimeStamp));
            }
        }
        if(decade != null && !decade.equalsIgnoreCase("null")){
            storySet.addAll(searchStoriesWithDecade(decade));
        }
        if(season != null && !season.equalsIgnoreCase("null")){
            storySet.addAll(searchStoriesWithSeason(season));
        }
        if(storySet.isEmpty()){
            return new ArrayList<>();
        }
        return storySet.stream().toList();
    }

    public List<Story> searchStoriesWithIntersection(
            String title,
            String labels,
            Integer radius,
            Double latitude,
            Double longitude,
            String startTimeStamp,
            String endTimeStamp,
            String decade,
            String season) throws ParseException {
        Set<Story> titleSet = new HashSet<>();
        Set<Story> labelsSet = new HashSet<>();
        Set<Story> locationSet = new HashSet<>();
        Set<Story> dateSet = new HashSet<>();
        Set<Story> decadeSet = new HashSet<>();
        Set<Story> seasonSet = new HashSet<>();
        Set<Story> storySet = new HashSet<>(findAll());
        if(title != null){
            if(!title.equalsIgnoreCase("") && !title.equalsIgnoreCase("null")){
                titleSet.addAll(searchStoriesWithTitle(title));
                if(searchStoriesWithTitle(title) != null){
                    storySet.retainAll(titleSet);
                }
            }
        }
        if(labels != null){
            if(!labels.equalsIgnoreCase("") && !labels.equalsIgnoreCase("null")){
                labelsSet.addAll(searchStoriesWithLabel(labels));
                if(searchStoriesWithTitle(title) != null){
                    storySet.retainAll(labelsSet);
                }
            }
        }
        if(latitude != null && longitude != null && radius != null){
            locationSet.addAll(searchStoriesWithLocationOnly(radius,latitude,longitude));
            storySet.retainAll(locationSet);
        }
        if(startTimeStamp != null && !startTimeStamp.equalsIgnoreCase("null")){
            if(endTimeStamp != null && !endTimeStamp.equalsIgnoreCase("null")){
                dateSet.addAll(searchStoriesWithMultipleDate(startTimeStamp,endTimeStamp));
                if(searchStoriesWithMultipleDate(startTimeStamp,endTimeStamp) != null){
                    storySet.retainAll(dateSet);
                }
            }
            else{
                dateSet.addAll(searchStoriesWithSingleDate(startTimeStamp));
                if(searchStoriesWithSingleDate(startTimeStamp) != null){
                    storySet.retainAll(dateSet);
                }
            }
        }
        if(decade != null && !decade.equalsIgnoreCase("null")){
            decadeSet.addAll(searchStoriesWithDecade(decade));
            if(searchStoriesWithDecade(decade) != null){
                storySet.retainAll(decadeSet);
            }
        }
        if(season != null && !season.equalsIgnoreCase("null")){
            seasonSet.addAll(searchStoriesWithSeason(season));
            if(searchStoriesWithSeason(season) != null){
                storySet.retainAll(seasonSet);
            }
        }
        if(storySet.isEmpty()){
            return new ArrayList<>();
        }
        return storySet.stream().toList();
    }


    public static String removeHtmlFormatting(String text) {
        Document document = Jsoup.parse(text);
        return document.text();
    }

    public static String getSubstring(String text){
        if(removeHtmlFormatting(text).length() < 100){
            return removeHtmlFormatting(text);
        }
        return removeHtmlFormatting(text).substring(0,100);
    }



}
