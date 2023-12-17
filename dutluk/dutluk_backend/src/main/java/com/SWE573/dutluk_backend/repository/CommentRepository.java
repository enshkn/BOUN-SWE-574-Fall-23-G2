package com.SWE573.dutluk_backend.repository;

import com.SWE573.dutluk_backend.model.Comment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CommentRepository extends JpaRepository<Comment, Long> {
    List<Comment> findAllByStoryId(Long storyId);

    Comment getCommentById(Long commentId);
}
