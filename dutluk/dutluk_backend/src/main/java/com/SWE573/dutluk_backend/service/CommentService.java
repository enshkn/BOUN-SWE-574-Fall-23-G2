package com.SWE573.dutluk_backend.service;

import com.SWE573.dutluk_backend.model.Comment;
import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.repository.CommentRepository;
import com.SWE573.dutluk_backend.request.CommentRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;

@Service
public class CommentService {

    @Autowired
    CommentRepository commentRepository;

    public Comment createComment(CommentRequest commentRequest, User user, Story story) {
        Comment comment = Comment.builder()
                .text(commentRequest.getCommentText())
                .story(story)
                .user(user)
                .likes(new HashSet<>())
                .build();
        return commentRepository.save(comment);
    }

    public Comment likeComment(Long commentId, Long userId) {
        Comment comment = getCommentByCommentId(commentId);
        if (comment.getLikes().contains(userId)) {
            comment.getLikes().remove(userId);
        }
        else{
            comment.getLikes().add(userId);
        }
        return commentRepository.save(comment);
    }

    public Comment getCommentByCommentId(Long commentId) {
        Optional<Comment> optionalComment = commentRepository.findById(commentId);
        if (optionalComment.isEmpty()) {
            throw new NoSuchElementException("Comment with id '" + commentId + "' not found");
        }
        return optionalComment.get();
    }

    public List<Comment> getCommentsByStoryId(Long storyId) {
        return commentRepository.findAllByStoryId(storyId);
    }

    public void deleteComment(Comment comment){
        commentRepository.delete(comment);
    }

    public Comment getCommentById(Long commentId) {
        return commentRepository.getCommentById(commentId);
    }
}
