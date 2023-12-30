package com.SWE573.dutluk_backend.service;

import com.SWE573.dutluk_backend.model.Comment;
import com.SWE573.dutluk_backend.model.Location;
import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.repository.StoryRepository;
import com.SWE573.dutluk_backend.request.StoryEnterRequest;
import com.SWE573.dutluk_backend.response.MyStoryListResponse;
import com.SWE573.dutluk_backend.response.StoryListResponse;
import com.SWE573.dutluk_backend.response.StoryResponse;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.text.ParseException;
import java.util.*;

import static com.SWE573.dutluk_backend.service.DateService.*;

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

    @Autowired
    LocationService locationService;



    public List<Story> findAll(){
        List<Story> storyList = storyRepository.findAll();
        return (storyList != null) ? storyList : Collections.emptyList();
    }

    public List<Story> findAllByOrderByIdDesc(){
        List<Story> storyList = storyRepository.findAllByOrderByIdDesc();
        return (!storyList.isEmpty()) ? storyList : Collections.emptyList();
    }

    public Story createStory(User foundUser, StoryEnterRequest storyEnterRequest) throws IOException {
        Story createdStory = Story.builder()
                .title(storyEnterRequest.getTitle())
                .labels(storyEnterRequest.getLabels())
                .text(imageService.parseAndSaveImages(storyEnterRequest.getText()))
                .startTimeStamp(storyEnterRequest.getStartTimeStamp())
                .endTimeStamp(storyEnterRequest.getEndTimeStamp())
                .season(storyEnterRequest.getSeason())
                .endSeason(storyEnterRequest.getEndSeason())
                .startHourFlag(storyEnterRequest.getStartHourFlag())
                .endHourFlag(storyEnterRequest.getEndHourFlag())
                .startDateFlag(storyEnterRequest.getStartDateFlag())
                .endDateFlag(storyEnterRequest.getEndDateFlag())
                .user(foundUser)
                .decade(storyEnterRequest.getDecade())
                .endDecade(storyEnterRequest.getEndDecade())
                .timeType(storyEnterRequest.getTimeType())
                .timeExpression(storyEnterRequest.getTimeExpression())
                .likes(new HashSet<>())
                .build();
        List<Location> allLocations = storyEnterRequest.getLocations();
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
        return addPercentageToStory(getStoryByStoryId(storyId),user.getRecommendedStoriesMap().get(storyId));
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


    public Story likeStory(Long storyId, Long userId) {
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
        double longDegreeDiffForRadius = radius / (111.0 * Math.cos(Math.toRadians(latitude)));
        minLongitude = longitude - longDegreeDiffForRadius;
        maxLongitude = longitude + longDegreeDiffForRadius;
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
            double longDegreeDiffForRadius = 111.0 * Math.cos(Math.toRadians(latitude));
            minLongitude = longitude - (radius / longDegreeDiffForRadius);
            maxLongitude = longitude + (radius / longDegreeDiffForRadius);
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
        Set<Story> results = new HashSet<>(storyRepository.findByTitleContainingIgnoreCase(title));
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
        Set<Story> results = new HashSet<>(storyRepository.findByDecadeContainingIgnoreCase(decade));
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

    public List<Story> searchStoriesWithMultipleDecades(String decade,String endDecade){
        Set<Story> results = new HashSet<>();
        int startYear = Integer.parseInt(decade.substring(0, 4));
        int endYear = Integer.parseInt(endDecade.substring(0, 4));
        for (int year = startYear; year <= endYear; year += 10) {
            String searchDecade = year + "s";
            results.addAll(storyRepository.findByDecadeContainingIgnoreCase(searchDecade));
        }
        try {
            Date startDecadeDate = convertToStartDate(decade);
            Date endDecadeDate = convertToEndDate(endDecade);
            results.addAll(storyRepository.findByStartTimeStampBetween(startDecadeDate,endDecadeDate));
            results.addAll(storyRepository.findByEndTimeStampBetween(startDecadeDate,endDecadeDate));
            for(Story story: results){
                story.setDecade(decade);
                story.setEndDecade(endDecade);
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

    public List<Story> searchStoriesWithMultipleSeasons(String season,String endSeason){
        List<Story> storyList = storyRepository.findBySeasonContainingIgnoreCase(season);
        storyList.retainAll(storyRepository.findByEndSeasonContainingIgnoreCase(endSeason));
        return storyList;
    }

    public List<Story> searchStoriesWithSingleDate(String startTimeStamp) throws ParseException {
        Date formattedStartDate = stringToDate(startTimeStamp);
        Date formattedEndDate = switch (startTimeStamp.length()) {
            case 4 -> // yyyy
                    incrementDateByOneYear(formattedStartDate);
            case 7 -> // yyyy-MM
                    incrementDateByOneMonth(formattedStartDate);
            case 10 -> // yyyy-MM-dd
                    incrementDateByOneDay(formattedStartDate);
            default -> throw new ParseException("Invalid date format", 0);
        };
        return storyRepository.findByStartTimeStampBetween(formattedStartDate,formattedEndDate);
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
        if(recService.isRecEngineStatus()){
            storyRepository.deleteById(story.getId());
            recService.deleteStoryRequest(story.getId());
            return "deleted";
        }
        storyRepository.deleteById(story.getId());
        return "deleted";
    }



    public Story enterStory(StoryEnterRequest storyEditRequest,Story foundStory) throws IOException {

        foundStory.setLabels(storyEditRequest.getLabels());
        foundStory.setTitle(storyEditRequest.getTitle());
        foundStory.setText(imageService.parseAndSaveImages(storyEditRequest.getText()));
        foundStory.setStartTimeStamp(storyEditRequest.getStartTimeStamp());
        foundStory.setEndTimeStamp(storyEditRequest.getEndTimeStamp());
        foundStory.setStartHourFlag(storyEditRequest.getStartHourFlag());
        foundStory.setDecade(storyEditRequest.getDecade());
        foundStory.setEndDecade(storyEditRequest.getEndDecade());
        foundStory.setSeason(storyEditRequest.getSeason());
        foundStory.setEndSeason(storyEditRequest.getEndSeason());
        foundStory.setStartHourFlag(storyEditRequest.getStartHourFlag());
        foundStory.setEndHourFlag(storyEditRequest.getEndHourFlag());
        foundStory.setStartDateFlag(storyEditRequest.getStartDateFlag());
        foundStory.setEndDateFlag(storyEditRequest.getEndDateFlag());
        locationService.deleteAllLocationsByStoryId(foundStory.getId());
        if (storyEditRequest.getLocations() != null) {
            List<Location> newLocationsList = storyEditRequest.getLocations();
            for (Location location : newLocationsList) {
                location.setStory(foundStory);
            }
            foundStory.setLocations(storyEditRequest.getLocations());
        }
        return foundStory;
    }

    public Story editStory(StoryEnterRequest request, User user, Long storyId) throws IOException {
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
        Map<Long,Integer> recommendationMap;
        if(recService.isRecEngineStatus() && foundUser.getRecommendedStoriesMap().isEmpty()){
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
            else{
                recommendationMap.remove(storyId);
            }
        }
        foundUser.setRecommendedStoriesMap(recommendationMap);
        userService.editUser(foundUser);
        return sortStoriesByDescending(storyList);
    }

    public Story addPercentageToStory(Story story, Integer percentage) {
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

    public static StoryResponse storyAsStoryResponse(Story story){
        return new StoryResponse(story);
    }

    public static List<StoryListResponse> storyListAsStoryListResponse(List<Story> storyList){
        if(storyList.isEmpty()){
            return new ArrayList<>();
        }
        List<StoryListResponse> storyResponseList = new ArrayList<>();
        for(Story story: storyList){
            storyResponseList.add(new StoryListResponse(story));
        }
        return storyResponseList;
    }

    public static List<MyStoryListResponse> storyListAsMyStoryListResponse(List<Story> storyList){
        if(storyList.isEmpty()){
            return new ArrayList<>();
        }
        List<MyStoryListResponse> storyResponseList = new ArrayList<>();
        for(Story story: storyList){
            storyResponseList.add(new MyStoryListResponse(story));
        }
        return storyResponseList;
    }



    public List<Story> searchStoriesWithCombination(
            String query,
            Integer radius,
            Double latitude,
            Double longitude,
            String startTimeStamp,
            String endTimeStamp,
            String decade,
            String endDecade,
            String season,
            String endSeason) throws ParseException {
        Set<Story> storySet = new HashSet<>();
        if(isStringApplicable(query)){
            storySet.addAll(searchStoriesWithQuery(query));
        }
        if(latitude != null && longitude != null && (radius != null)){
            if (isStringApplicable(query)){
                storySet.addAll(searchStoriesWithLocation(query,radius,latitude,longitude));
            }
            else{
                storySet.addAll(searchStoriesWithLocationOnly(radius,latitude,longitude));
            }
        }
        if(isStringApplicable(startTimeStamp)){
            if(isStringApplicable(endTimeStamp)){
                storySet.addAll(searchStoriesWithMultipleDate(startTimeStamp,endTimeStamp));
            }
            else{
                storySet.addAll(searchStoriesWithSingleDate(startTimeStamp));
            }
        }
        if(isStringApplicable(decade)){
            if (isStringApplicable(endDecade)) {
                storySet.addAll(searchStoriesWithMultipleDecades(decade, endDecade));
            } else {
                storySet.addAll(searchStoriesWithDecade(decade));
            }
        }
        if(isStringApplicable(season)){
            if(isStringApplicable(endSeason)){
                storySet.addAll(searchStoriesWithMultipleSeasons(season,endSeason));
            }
            else{
                storySet.addAll(searchStoriesWithSeason(season));
            }
        }
        return sortStoriesByDescending(storySet.stream().toList());
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
            String endDecade,
            String season,
            String endSeason) throws ParseException {
        List<Story> dateList = new ArrayList<>();
        List<Story> decadeList = new ArrayList<>();
        List<Story> seasonList = new ArrayList<>();
        List<Story> storyList = new ArrayList<>(findAll());
        if(isStringApplicable(title)){
            List<Story> titleSet = new ArrayList<>(searchStoriesWithTitle(title));
            if(searchStoriesWithTitle(title) != null){
                storyList.retainAll(titleSet);
            }
        }
        if(isStringApplicable(labels)){
            List<Story> labelsSet = new ArrayList<>(searchStoriesWithLabel(labels));
            if(searchStoriesWithLabel(labels) != null){
                storyList.retainAll(labelsSet);
            }
        }
        if(latitude != null && longitude != null && radius != null){
            List<Story> locationSet = new ArrayList<>(searchStoriesWithLocationOnly(radius, latitude, longitude));
            storyList.retainAll(locationSet);
        }
        if(isStringApplicable(startTimeStamp)){
            if(isStringApplicable(endTimeStamp)){
                dateList.addAll(searchStoriesWithMultipleDate(startTimeStamp, endTimeStamp));
                if(searchStoriesWithMultipleDate(startTimeStamp,endTimeStamp) != null){
                    storyList.retainAll(dateList);
                }
            }
            else{
                dateList.addAll(searchStoriesWithSingleDate(startTimeStamp));
                if(searchStoriesWithSingleDate(startTimeStamp) != null){
                    storyList.retainAll(dateList);
                }
            }
        }
        if(isStringApplicable(decade)){
            if(isStringApplicable(endDecade)){
                decadeList.addAll(searchStoriesWithMultipleDecades(decade, endDecade));
                if(searchStoriesWithMultipleDecades(decade,endDecade) != null){
                    storyList.retainAll(decadeList);
                }
            }
            else{
                decadeList.addAll(searchStoriesWithDecade(decade));
                if(searchStoriesWithDecade(decade) != null){
                    storyList.retainAll(decadeList);
                }
            }

        }
        if(isStringApplicable(season)){
            if(isStringApplicable(endSeason)){
                seasonList.addAll(searchStoriesWithMultipleSeasons(season, endSeason));
            }
            else{
                seasonList.addAll(searchStoriesWithSeason(season));
            }
            if (!seasonList.isEmpty()) {
                storyList.retainAll(seasonList);
            }
        }
        if (storyList.isEmpty()) {
            return new ArrayList<>();
        }
        return storyList;
    }


    public static String removeHtmlFormatting(String text) {
        Document document = Jsoup.parse(text);
        return document.text();
    }

    public static String getSubstring(String text){
        if(removeHtmlFormatting(text).length() < 100){
            return removeHtmlFormatting(text);
        }
        return removeHtmlFormatting(text).substring(0,100)+"...";
    }

    public static String generateVerbalExpression(Story story) {

        String timeType = story.getTimeType();
        String timeExpression = story.getTimeExpression();
        String startTimeStamp = dateToStringBasedOnFlags(story.getStartTimeStamp(), story.getStartHourFlag(), story.getEndDateFlag());
        String endTimeStamp = dateToStringBasedOnFlags(story.getEndTimeStamp(), story.getEndHourFlag(), story.getEndDateFlag());
        String startYear = getYearValueFromString(startTimeStamp);
        String endYear = getYearValueFromString(endTimeStamp);
        String startMonth = getMonthValueFromString(startTimeStamp);
        String endMonth = getMonthValueFromString(endTimeStamp);
        String decade = story.getDecade();
        String endDecade = story.getEndDecade();
        String season = story.getSeason();
        String endSeason = story.getEndSeason();

        if (timeType == null || timeExpression == null) {
            return null;
        }
        return switch (timeType) {
            case "timePoint" -> switch (timeExpression) {
                case "moment" -> "At the moment " + startTimeStamp + ".";
                case "day" -> "On the day " + startTimeStamp + ".";
                case "month" -> "On the month " + startMonth + " of the year " + startYear + ".";
                case "year" -> "On the year of " + startYear + ".";
                case "decade" -> "In the decade of " + decade + ".";
                case "season" -> "On the season of " + season + " of the year " + startYear + ".";
                case "decade+season" -> "On the " + season + " of the decade " + decade + ".";
                default -> null;
            };
            case "timeInterval" -> switch (timeExpression) {
                case "moment" -> "Between " + startTimeStamp + " and " + endTimeStamp + ".";
                case "day" -> "Between the days " + startTimeStamp + " and " + endTimeStamp + ".";
                case "month" ->
                        "Between the month of " + startMonth + " of " + startYear + " and " + endMonth + " of " + endYear + ".";
                case "year" -> "Between the year of " + startYear + " and " + endYear + ".";
                case "decade" -> "Between " + decade + " and " + endDecade + ".";
                case "season" ->
                        "Between " + season + " of the year " + startYear + " and the " + endSeason + " of the year " + endYear + ".";
                case "decade+season" ->
                        "Between the " + season + " of " + decade + " and " + endSeason + " of " + endDecade + ".";
                default -> null;
            };
            default -> null;
        };
    }

    public Boolean isStringApplicable(String value){
        return value != null && !value.equalsIgnoreCase("") && !value.isBlank() && !value.equalsIgnoreCase("null");
    }

    public String sendBatchofStories(String password) {

        if (password.equals("password")) {
            if (recService.isRecEngineStatus()) {
                List<Story> storyList = findAll();
                for (Story story : storyList) {
                    recService.vectorizeRequest(story);
                }
                return "Data sent to karadut";
            }
        }
        return "Karadut not active";
    }


}
