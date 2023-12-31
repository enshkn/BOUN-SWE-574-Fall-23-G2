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

import static com.SWE573.dutluk_backend.service.CommentService.commentListToCommentResponseList;
import static com.SWE573.dutluk_backend.service.CommentService.commentToCommentResponse;


@RestController
@RequestMapping("/api/comment")
public class CommentController {

    @Autowired
    UserService userService;

    @Autowired
    StoryService storyService;

    @Autowired
    CommentService commentService;


    @PostMapping("/add")
    public ResponseEntity<?> addComment(@RequestBody CommentRequest commentRequest, HttpServletRequest request) {
        User user = userService.validateTokenizedUser(request);
        Story story = storyService.getStoryByStoryId(commentRequest.getStoryId());
        return IntegrationService.mobileCheck(request, commentService.createComment(commentRequest, user, story));
    }

    @GetMapping("/byStory/{storyId}")
    public ResponseEntity<?> getCommentsByStoryId(@PathVariable Long storyId, HttpServletRequest request) {
        List<Comment> foundComments = commentService.getCommentsByStoryId(storyId);
        if (foundComments != null) {
            return IntegrationService.mobileCheck(request, commentListToCommentResponseList(foundComments));
        }
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/{commentId}")
    public ResponseEntity<?> getByCommentId(@PathVariable Long commentId, HttpServletRequest request) {
        Comment foundComment = commentService.getCommentById(commentId);
        if (foundComment != null) {
            return IntegrationService.mobileCheck(request,commentToCommentResponse(foundComment));
        }
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/delete/{commentId}")
    public ResponseEntity<?> deleteByCommentId(@PathVariable Long commentId, HttpServletRequest request) {
        Comment foundComment = commentService.getCommentById(commentId);
        String deletionStatus = commentService.deleteComment(foundComment);
        return IntegrationService.mobileCheck(request, deletionStatus);
    }

    @PostMapping("/like")
    public ResponseEntity<?> likeComment(@RequestBody LikeRequest likeRequest, HttpServletRequest request) {
        User tokenizedUser = userService.validateTokenizedUser(request);
        return IntegrationService.mobileCheck(request, commentToCommentResponse(commentService.likeComment(likeRequest.getLikedEntityId(), tokenizedUser.getId())));
    }

    @GetMapping("/isLiked/{commentId}")
    public ResponseEntity<?> isCommentLiked(@PathVariable Long commentId, HttpServletRequest request) {
        User tokenizedUser = userService.validateTokenizedUser(request);
        return IntegrationService.mobileCheck(request, commentService.isCommentLikedByUser(commentId, tokenizedUser.getId()));
    }

}