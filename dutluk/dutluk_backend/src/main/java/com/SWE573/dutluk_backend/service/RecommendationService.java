package com.SWE573.dutluk_backend.service;

import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.request.RecStoryLikeOrDislikeRequest;
import com.SWE573.dutluk_backend.request.RecStoryOrUserRequest;
import com.SWE573.dutluk_backend.request.RecVectorizeOrEditRequest;
import com.SWE573.dutluk_backend.response.RecResponse;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.Getter;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.RestTemplate;

import java.net.URI;
import java.util.Set;

@Service
@Getter
public class RecommendationService {
    @Value("${REC_URL}")
    private URI recUrl;

    @Autowired
    UserService userService;

    @Value("${REC_ENGINE_STATUS}")
    boolean recEngineStatus = false;

    RestTemplate restTemplate = new RestTemplate();

    public String testEndpoint() {

        ResponseEntity<String> response = restTemplate.getForEntity(recUrl+"/test", String.class);
        return response.getBody();
    }


    public void vectorizeRequest(Story story){
        RecVectorizeOrEditRequest vectorizeRequest =
                RecVectorizeOrEditRequest.builder()
                        .type("story")
                        .ids(story.getId().toString())
                        .tags(story.getLabels())
                        .text(removeHtmlFormatting(story.getText()))
                        .build();
        ResponseEntity<String> response = restTemplate.postForEntity(recUrl + "/vectorize", vectorizeRequest,String.class);
        System.out.println(response.getBody());
    }

    public void vectorizeEditRequest(Story story){
        RecVectorizeOrEditRequest vectorizeRequest =
                RecVectorizeOrEditRequest.builder()
                        .type("story")
                        .ids(story.getId().toString())
                        .tags(story.getLabels())
                        .text(removeHtmlFormatting(story.getText()))
                        .build();
        ResponseEntity<String> response = restTemplate.postForEntity(recUrl + "/vectorize-edit", vectorizeRequest,String.class);
    }

    public String likedStory(Story story, User user, Integer likedStorySize) throws JsonProcessingException {
        RecStoryLikeOrDislikeRequest likedRequest =
                RecStoryLikeOrDislikeRequest.builder()
                        .type("story")
                        .storyId(story.getId().toString())
                        .userId(user.getId().toString())
                        .userWeight(likedStorySize)
                        .build();
        ResponseEntity<String> response = restTemplate.postForEntity(recUrl + "/story-liked", likedRequest,String.class);
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            RecResponse recResponse = objectMapper.readValue(response.getBody(), RecResponse.class);
            user.setRecommendedStories(recommendStory(user,user.getLikedStories()));
            userService.editUser(user);

        } catch (HttpClientErrorException e) {
        System.err.println("Client error: " + e.getRawStatusCode() + " - " + e.getResponseBodyAsString());

    } catch (HttpServerErrorException e) {
        System.err.println("Server error: " + e.getRawStatusCode() + " - " + e.getResponseBodyAsString());
        }
        return user.getRecommendedStories().toString();
    }

    public String dislikedStory(Story story, User user,Integer likedStorySize) throws JsonProcessingException {
        RecStoryLikeOrDislikeRequest dislikedRequest =
                RecStoryLikeOrDislikeRequest.builder()
                        .type("story")
                        .storyId(story.getId().toString())
                        .userId(user.getId().toString())
                        .userWeight(likedStorySize)
                        .build();
        ResponseEntity<String> response = restTemplate.postForEntity(recUrl + "/story-disliked", dislikedRequest,String.class);
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            RecResponse recResponse = objectMapper.readValue(response.getBody(), RecResponse.class);
            user.setRecommendedStories(recommendStory(user,user.getLikedStories()));
            userService.editUser(user);
            return user.getRecommendedStories().toString();

        } catch (HttpClientErrorException e) {
            System.err.println("Client error: " + e.getRawStatusCode() + " - " + e.getResponseBodyAsString());

        } catch (HttpServerErrorException e) {
            System.err.println("Server error: " + e.getRawStatusCode() + " - " + e.getResponseBodyAsString());
        }
        return null;
    }

    public Set<Long> recommendStory(User user, Set<Long> excludedLikedIds){
        //RecStoryOrUserRequest builder
        RecStoryOrUserRequest recStoryRequest =
                RecStoryOrUserRequest.builder()
                        .userId(user.getId().toString())
                        .excludedIds(excludedLikedIds)
                        .vector_type("story")
                        .build();
        ResponseEntity<String> response = restTemplate.postForEntity(recUrl + "/recommend-story", recStoryRequest,String.class);
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            RecResponse recResponse = objectMapper.readValue(response.getBody(), RecResponse.class);
            user.setRecommendedStories(recResponse.getIds());
            userService.editUser(user);
            return user.getRecommendedStories();

        } catch (HttpClientErrorException e) {
            System.err.println("Client error: " + e.getRawStatusCode() + " - " + e.getResponseBodyAsString());

        } catch (HttpServerErrorException e) {
            System.err.println("Server error: " + e.getRawStatusCode() + " - " + e.getResponseBodyAsString());
        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    public Set<Long> recommendUser(Long userId, Set<Long> excludedIds){
        RecStoryOrUserRequest recStoryRequest =
                RecStoryOrUserRequest.builder()
                        .userId(userId.toString())
                        .excludedIds(excludedIds)
                        .vector_type("story")
                        .build();
        ResponseEntity<String> response = restTemplate.postForEntity(recUrl + "/recommend-user", recStoryRequest,String.class);
        //return response.getBody();
        return null;
    }

    private String removeHtmlFormatting(String text) {
        Document document = Jsoup.parse(text);
        return document.text();
    }
}
