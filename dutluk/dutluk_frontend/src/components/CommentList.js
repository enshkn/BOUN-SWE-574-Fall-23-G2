import axios from "axios";
import { useEffect, useState, useCallback } from "react";
import { Space, message } from 'antd';
import { LikeTwoTone, DeleteTwoTone, LikeFilled } from '@ant-design/icons';

import "./css/AllStories.css";
    

const CommentList = ({ story, comment }) => {
    const [messageApi, contextHolder] = message.useMessage();
    const [commentIsLiked, setCommentIsLiked] = useState(false);
    const currentUserId = sessionStorage.getItem('currentUserId');
  
    const fetchCommentLikeStatus = useCallback(async () => {
      try {
        const response = await axios.get(
          `${process.env.REACT_APP_BACKEND_URL}/api/comment/isLiked/${comment.id}`,
          {
            withCredentials: true,
          }
        );
        setCommentIsLiked(response.data);
      } catch (error) {
        console.error('Like status API error:', error.message);
        messageApi.open({ type: "error", content: "Error occurred while fetching comment likes!" });
      }
    }, [messageApi]); // Include id in the dependency array
  
    useEffect(() => {
      fetchCommentLikeStatus();
    }, [fetchCommentLikeStatus]);
  
    const handleLikeComment = async (id) => {
      try {
        const response = await axios.post(
          `${process.env.REACT_APP_BACKEND_URL}/api/comment/like`,
          { likedEntityId: id },
          {
            withCredentials: true,
          }
        ); 
        setCommentIsLiked(!commentIsLiked);
        const updatedLikeSize = response.data.likeSize;
        comment.likeSize = updatedLikeSize;
        
        if (commentIsLiked === true) {
          messageApi.open({ type: "success", content: "You unliked the comment." });

        } else if (commentIsLiked === false) {
          messageApi.open({ type: "success", content: "You liked the comment!" });
        }
      } catch (error) {
        console.log(error);
        messageApi.open({
          type: "error",
          content: "Error occurred while liking the comment!",
        });
      }
    };
    
      const handleDeleteComment = async (commentId) => {
        try {
          const response = await axios.get(
            `${process.env.REACT_APP_BACKEND_URL}/api/comment/delete/${commentId}`,
            {
              withCredentials: true,
            });
          if (response.status === 200) {
            messageApi.open({ type: "success", content: "Comment deleted." });
          }
          else {
            messageApi.open({ type: "error", content: "Error occured while trying to delete comment!" });
          }
        } catch (error) {
          console.log(error);
          messageApi.open({ type: "error", content: "Error occured while trying to delete comment!" });
        }
      }

      return (
        <Space
          direction="vertical"
          style={{
            width: '100%',
          }}
        >
        {contextHolder}
            <div className="comment-container">
                <div className="comment-body">
                  <img src={comment.user.profilePhoto} className="profile-picture" alt="profile-pic" />
                  <div className="comment-info">
                    <div className="comment-header">
                      <div className="comment-user">
                        <a href={`/user/${comment.user.id}`} className="username">@{comment.user.username}</a>
                      </div>
                      <div className="comment-like-delete">
                        <p>
                          <b>Likes:</b> {comment.likeSize}
                          {commentIsLiked ? (
                            <LikeFilled
                              onClick={() => handleLikeComment(comment.id)}
                              style={{ color: "#ff5500ca", margin: "5px" }}
                            />
                          ) : (
                            <LikeTwoTone
                              twoToneColor="#ff5500ca"
                              style={{ margin: "5px" }}
                              onClick={() => handleLikeComment(comment.id)}
                            />
                          )}
                          {comment.user.id == currentUserId && (
                          <DeleteTwoTone 
                            twoToneColor="red" 
                            style={{ margin: "5px" }}
                            onClick={() => handleDeleteComment(comment.id)}
                          />)}
                        </p>
                      </div>
                    </div>
                    <div className="comment-text">
                      <span>{comment.text}</span>
                    </div>
                  </div>
                </div>
            </div>

        </Space>
    );
};

export default CommentList;
