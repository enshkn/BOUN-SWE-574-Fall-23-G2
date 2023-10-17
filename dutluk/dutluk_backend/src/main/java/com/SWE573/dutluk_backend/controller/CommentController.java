package com.SWE573.dutluk_backend.controller;


import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.request.CommentRequest;
import com.SWE573.dutluk_backend.request.LikeRequest;
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
@RequestMapping("/api/comment")
public class CommentController {

    @Autowired
    private UserService userService;

    @Autowired
    private StoryService storyService;

    @Autowired
    private CommentService commentService;


    @PostMapping("/add")
    public ResponseEntity<?> addComment(@RequestBody CommentRequest commentRequest, HttpServletRequest request){
        User user = userService.validateTokenizedUser(request);
        Story story = storyService.getStoryByStoryId(commentRequest.getStoryId());
        return ResponseEntity.ok(commentService.createComment(commentRequest,user,story));
    }
    @PostMapping("/like")
    public ResponseEntity<?> likeComment(@RequestBody LikeRequest likeRequest, HttpServletRequest request){
        User tokenizedUser = userService.validateTokenizedUser(request);

        return ResponseEntity.ok(commentService.likeComment(likeRequest.getLikedEntityId(),tokenizedUser.getId()));
    }
}
