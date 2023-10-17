package com.SWE573.dutluk_backend.controller;

import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.request.CommentRequest;
import com.SWE573.dutluk_backend.request.LikeRequest;
import com.SWE573.dutluk_backend.response.Response;
import com.SWE573.dutluk_backend.response.SuccessfulResponse;
import com.SWE573.dutluk_backend.service.CommentService;
import com.SWE573.dutluk_backend.service.StoryService;
import com.SWE573.dutluk_backend.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/mobile/comment")
public class CommentMobileController {
    @Autowired
    private UserService userService;

    @Autowired
    private StoryService storyService;

    @Autowired
    private CommentService commentService;

    private Response successfulResponse = new SuccessfulResponse();

    @PostMapping("/add")
    public ResponseEntity<?> addComment(@RequestBody CommentRequest commentRequest, HttpServletRequest request){
        User user = userService.validateTokenizedUser(request);
        Story story = storyService.getStoryByStoryId(commentRequest.getStoryId());
        successfulResponse.setEntity(commentService.createComment(commentRequest,user,story));
        return ResponseEntity.ok(successfulResponse);
    }
    @PostMapping("/like/")
    public ResponseEntity<?> likeComment(@RequestBody LikeRequest likeRequest, HttpServletRequest request){
        User tokenizedUser = userService.validateTokenizedUser(request);
        successfulResponse.setEntity(commentService.likeComment(likeRequest.getLikedEntityId(),tokenizedUser.getId()));
        return ResponseEntity.ok(successfulResponse);
    }
}
