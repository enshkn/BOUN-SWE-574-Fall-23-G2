package com.SWE573.dutluk_backend.controller;


import com.SWE573.dutluk_backend.model.Comment;
import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.request.CommentRequest;
import com.SWE573.dutluk_backend.request.LikeRequest;
import com.SWE573.dutluk_backend.service.CommentService;
import com.SWE573.dutluk_backend.service.IntegrationService;
import com.SWE573.dutluk_backend.service.StoryService;
import com.SWE573.dutluk_backend.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


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
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),commentService.createComment(commentRequest,user,story));
    }

    @GetMapping("/{commentId}")
    public ResponseEntity<?> getByCommentId(@PathVariable Long commentId,HttpServletRequest request){
        Comment foundComment = commentService.getCommentById(commentId);
        if (foundComment!=null) {
            return IntegrationService.mobileCheck(request.getHeader("User-Agent"),foundComment);
        }
        return ResponseEntity.notFound().build();
    }
    @PostMapping("/like")
    public ResponseEntity<?> likeComment(@RequestBody LikeRequest likeRequest, HttpServletRequest request){
        User tokenizedUser = userService.validateTokenizedUser(request);
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),commentService.likeComment(likeRequest.getLikedEntityId(),tokenizedUser.getId()));

    }

    @GetMapping("/byStory/{storyId}")
    public ResponseEntity<?> getCommentsByStoryId(@PathVariable Long storyId,HttpServletRequest request){
        List<Comment> foundComments = commentService.getCommentsByStoryId(storyId);
        if (foundComments!=null) {
            return IntegrationService.mobileCheck(request.getHeader("User-Agent"),foundComments);
        }
        return ResponseEntity.notFound().build();
    }


    @GetMapping("/delete/{commentId}")
    public ResponseEntity<?> deleteByCommentId(@PathVariable Long commentId,HttpServletRequest request){
        Comment foundComment = commentService.getCommentById(commentId);
        String deletionStatus = commentService.deleteComment(foundComment);
        return IntegrationService.mobileCheck(request.getHeader("User-Agent"),deletionStatus);
    }
}
