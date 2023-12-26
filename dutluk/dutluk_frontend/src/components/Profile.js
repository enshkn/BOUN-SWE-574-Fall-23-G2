import axios from "axios";
import { useState, useEffect, useCallback } from "react";
import { useParams } from "react-router-dom";
import { Space, message } from 'antd';
import photoPreview from "../profile_pic.png";
import "./css/Profile.css";

function Profile() {
  const { id } = useParams();
  const [user, setUser] = useState(null);
  const [isFollowing, setIsFollowing] = useState();
  const [messageApi, contextHolder] = message.useMessage();

  const fetchFollowStatus = useCallback(async () => {
    try {
        const response = await axios.get( 
            `${process.env.REACT_APP_BACKEND_URL}/api/user/isFollowing/${id}`,
            {
                withCredentials: true,
            }
        );
        setIsFollowing(response.data);  
    } catch (error) {
        console.error('Save status API error:', error.message);
        messageApi.open({ type: "error", content: "Error occurred while fetching followed user data!" });
    }
  }, [id, messageApi]);

  useEffect(() => {
    fetchFollowStatus();
  }, [fetchFollowStatus]);

  useEffect(() => {
    axios
      .get(`${process.env.REACT_APP_BACKEND_URL}/api/user/${id}`, {
        withCredentials: true,
      })
      .then((response) => {
        setUser(response.data);
      })
      .catch((error) => {
        console.log(error);
        messageApi.open({ type: "error", content: "Error occured while loading the profile!"});
      });
  }, [id, messageApi]);

  const handleFollowClick = async () => {
    try {
        const response = await axios.post(
          `${process.env.REACT_APP_BACKEND_URL}/api/user/follow`,
          { userId: id },
          { withCredentials: true }
        );
        setIsFollowing(!isFollowing);
        console.log(response);
        if (isFollowing === true) {
            messageApi.open({ type: "success", content: "You unfollowed the user" });
        } else if (isFollowing === false) {
            messageApi.open({ type: "success", content: "You followed the user" });
        }
    } catch (error) {
        console.error(error);
    }
  };

  if (!user) {
    return <div>User not found!</div>;
  } else {
    return (
      <Space
        direction="vertical"
        align="center"
        style={{
          width: "100%",
        }}
      >
        {contextHolder}
        <div className="profile-container">
          <div className="profile-photo-container">
            <label htmlFor="photo" className="profile-photo-label">
              Photo:
              <p>
                {
                  <img
                    className="profile-photo"
                    src={user.profilePhoto || photoPreview}
                    alt={user.username}
                  />
                }
              </p>
            </label>
          </div>
          <h1 className="profile-username">Username: {user.username}</h1>
          <p className="profile-biography">Biography: {user.biography}</p>
          <button className="follow-button" onClick={handleFollowClick}>
            {isFollowing ? 'Unfollow' : 'Follow'}
          </button>
        </div>
      </Space>
    );
  }
}

export default Profile;
