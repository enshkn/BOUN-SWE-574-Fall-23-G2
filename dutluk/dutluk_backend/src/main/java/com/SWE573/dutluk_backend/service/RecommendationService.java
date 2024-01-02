package com.SWE573.dutluk_backend.service;

import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.request.*;
import com.SWE573.dutluk_backend.response.RecResponse;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.Getter;
import lombok.Setter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.RestTemplate;

import java.net.URI;
import java.util.*;
import java.util.concurrent.CompletableFuture;

@Service
@Getter
@Setter
public class RecommendationService {
    @Value("${REC_URL}")
    private URI recUrl;

    @Autowired
    UserService userService;


    @Value("${REC_ENGINE_STATUS}")
    boolean recEngineStatus;

    private RestTemplate restTemplate = new RestTemplate();

    public String testEndpoint() {
        if(recEngineStatus){
            ResponseEntity<String> response = restTemplate.getForEntity(recUrl+"/test", String.class);
            return response.getBody();
        }
        return "Karadut implementation is offline";
    }

    @Async
    public CompletableFuture<String> vectorizeRequest(Story story){
        RecVectorizeOrEditRequest vectorizeRequest =
                RecVectorizeOrEditRequest.builder()
                        .type("story")
                        .ids(story.getId().toString())
                        .tags(story.getLabels())
                        .text(StoryService.removeHtmlFormatting(story.getText()))
                        .build();
        restTemplate.postForEntity(recUrl + "/vectorize", vectorizeRequest,String.class);
        return CompletableFuture.completedFuture("Data sent to karadut");
    }

    @Async
    public CompletableFuture<String> vectorizeEditRequest(Story story){
        RecVectorizeOrEditRequest vectorizeRequest =
                RecVectorizeOrEditRequest.builder()
                        .type("story")
                        .ids(story.getId().toString())
                        .tags(story.getLabels())
                        .text(StoryService.removeHtmlFormatting(story.getText()))
                        .build();
        restTemplate.postForEntity(recUrl + "/vectorize-edit", vectorizeRequest, String.class);
        return CompletableFuture.completedFuture("Data sent to karadut");
    }

    
    public CompletableFuture<String> likedStory(Story story, User user, Integer likedStorySize) {
        RecStoryLikeOrDislikeRequest likedRequest =
                RecStoryLikeOrDislikeRequest.builder()
                        .type("story")
                        .storyId(story.getId().toString())
                        .userId(user.getId().toString())
                        .userWeight(likedStorySize)
                        .build();
        try {
            restTemplate.postForEntity(recUrl + "/story-liked", likedRequest, String.class);
            user.setRecommendedStoriesMap(recommendStory(user));
            System.out.println("User id: "+user.getId());
            System.out.println("Recommended Stories: " + user.getRecommendedStoriesMap().keySet());
            if(user.getRecommendedStoriesMap() != null){
                System.out.println("Recommended stories received for user: "+user.getId());
                return CompletableFuture.completedFuture("Recommendation complete");
            }
            System.out.println("No stories recommended from karadut to user: "+user.getId());
            return CompletableFuture.completedFuture("No stories recommended");
        }catch (NullPointerException e){
            return CompletableFuture.completedFuture("Recommendation complete");
        }
    }

    
    public CompletableFuture<String> dislikedStory(Story story, User user, Integer likedStorySize) {
        RecStoryLikeOrDislikeRequest dislikedRequest =
                RecStoryLikeOrDislikeRequest.builder()
                        .type("story")
                        .storyId(story.getId().toString())
                        .userId(user.getId().toString())
                        .userWeight(likedStorySize)
                        .build();
        try {
            restTemplate.postForEntity(recUrl + "/story-unliked", dislikedRequest, String.class);
            user.setRecommendedStoriesMap(recommendStory(user));
            if(user.getRecommendedStoriesMap()!= null){
                return CompletableFuture.completedFuture("Recommendation complete");
            }
            return CompletableFuture.completedFuture("No stories recommended");
        }catch (NullPointerException e){
            return CompletableFuture.completedFuture("Recommendation complete");
        }
    }

    public Map<Long,Integer> recommendStory(User user){
        Set<Long> excludedStoryIds  = user.getLikedStories();
        List<Story> userCreatedStories = user.getStories();
        if(userCreatedStories != null && !userCreatedStories.isEmpty()){
            for(Story story : userCreatedStories){
                excludedStoryIds.add(story.getId());
            }
        }
        RecStoryOrUserRequest recStoryRequest =
                RecStoryOrUserRequest.builder()
                        .userId(user.getId().toString())
                        .excludedIds(excludedStoryIds)
                        .vector_type("story")
                        .build();
        ResponseEntity<String> response = restTemplate.postForEntity(recUrl + "/recommend-story", recStoryRequest,String.class);
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            RecResponse recResponse = objectMapper.readValue(response.getBody(), RecResponse.class);
            System.out.println(response);
            Map<Long,Integer> recommendedStoriesMap = getLongStringMap(recResponse);
            user.setRecommendedStoriesMap(recommendedStoriesMap);
            userService.editUser(user);
            return user.getRecommendedStoriesMap();

        } catch (HttpClientErrorException e) {
            System.err.println("Client error: " + e.getStatusCode().value() + " - " + e.getResponseBodyAsString());

        } catch (HttpServerErrorException e) {
            System.err.println("Server error: " + e.getStatusCode().value() + " - " + e.getResponseBodyAsString());
        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        } catch(Exception e){
            System.err.println("An error occured on recommend story api");
        }
        return null;
    }

    private Map<Long, Integer> getLongStringMap(RecResponse recResponse) {
        Map<Long, Integer> recommendedStoriesMap = new HashMap<>();
        if (recResponse.getIds() != null && recResponse.getScores() != null
                && recResponse.getIds().size() == recResponse.getScores().size()) {
            for (int i = 0; i < recResponse.getIds().size(); i++) {
                Long id = recResponse.getIds().get(i);
                Double score = recResponse.getScores().get(i);
                long scoreOutOfHundred = Math.round(score * 100);
                if (scoreOutOfHundred != 0) {
                    recommendedStoriesMap.put(id, (int) scoreOutOfHundred);
                }
            }
        }
        return recommendedStoriesMap;
    }


    /*public Set<Long> recommendUser(Long userId, Set<Long> excludedIds){
        RecStoryOrUserRequest recStoryRequest =
                RecStoryOrUserRequest.builder()
                        .userId(userId.toString())
                        .excludedIds(excludedIds)
                        .vector_type("user")
                        .build();
        restTemplate.postForEntity(recUrl + "/recommend-user", recStoryRequest,String.class);
        return null;
    }*/

    @Async
    public CompletableFuture<String> deleteStoryRequest(Long storyId){
        RecStoryDeleteRequest recDeleteStoryRequest  = new RecStoryDeleteRequest();
        recDeleteStoryRequest.setStoryId(storyId.toString());
        restTemplate.postForEntity(recUrl + "/delete-story", recDeleteStoryRequest,String.class);
        return CompletableFuture.completedFuture("Story deleted on karadut");
    }

    public CompletableFuture<String> deleteAllOnRecEngine(String password){
        RecDeleteAllRequest recDeleteAllRequest = new RecDeleteAllRequest();
        recDeleteAllRequest.setPassWord(password);
        ResponseEntity<?> response = restTemplate.postForEntity(recUrl + "/delete-all", recDeleteAllRequest,String.class);
        return CompletableFuture.completedFuture(Objects.requireNonNull(response.getBody()).toString());
    }


}
