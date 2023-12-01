package com.SWE573.dutluk_backend.service;

import com.SWE573.dutluk_backend.request.RecStoryLikeOrDislikeRequest;
import com.SWE573.dutluk_backend.request.RecVectorizeOrEditRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.net.URI;

@Service
public class RecommendationService {
    @Value("${REC_URL}")
    private URI recUrl;

    public String testEndpoint() {
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> response = restTemplate.getForEntity(recUrl+"/test", String.class);
        return response.getBody();
    }


    public RecVectorizeOrEditRequest vectorizeRequest(){
        return null;
    }

    public RecVectorizeOrEditRequest vectorizeEditRequest(){
        return null;
    }

    public RecStoryLikeOrDislikeRequest likeStory(){
        return null;
    }

    public RecStoryLikeOrDislikeRequest dislikeStory(){
        return null;
    }

    public void recommendStory(){
        //RecStoryOrUserRequest builder
        return;
    }

    public Object recommendUser(){
        //RecStoryOrUserRequest builder
        return null;
    }
    public Object storyLiked() {
        //RecStoryOrUserRequest builder
        return null;
    }
}
