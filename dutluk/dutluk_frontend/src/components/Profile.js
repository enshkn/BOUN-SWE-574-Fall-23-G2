import axios from "axios";
import { useState, useEffect } from "react";
import { useParams } from "react-router-dom";
import { Space, message } from 'antd';
import photoPreview from "../profile_pic.png";
import "./css/Profile.css";

function Profile() {
  const { id } = useParams();
  const [user, setUser] = useState(null);
  const [isFollowing, setIsFollowing] = useState();
  const [followButtonName, setFollowButtonName] = useState();
  const BACKEND_URL = process.env.REACT_APP_BACKEND_URL;
  const [messageApi, contextHolder] = message.useMessage();

  useEffect(() => {
    axios
      .get(
        `${process.env.REACT_APP_BACKEND_URL}/api/user/profile`,
        {
          withCredentials: true,
        }
      )
      .then((response) => {
        const loggedInUser = response.data;
        if (loggedInUser.following && loggedInUser.following.includes(id)) {
          setFollowButtonName("Unfollow");
          setIsFollowing(true);
        } else {
          setFollowButtonName("Follow");
          setIsFollowing(false);
        }
      })
      .catch((error) => {
        console.log(error);
        messageApi.open({ type: "error", content: "Error occured while loading your profile!"});
      });
  }, [id, messageApi]);

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
  }, [id, BACKEND_URL, messageApi]);

  const handleFollowClick = () => {
    if (isFollowing) {
      axios
        .post(
          `${process.env.REACT_APP_BACKEND_URL}/api/user/follow/`,
          { userId: id },
          { withCredentials: true }
        )
        .then((response) => {
          setFollowButtonName("Follow");
          setIsFollowing(false);
        })
        .catch((error) => {
          console.log(error);
          messageApi.open({ type: "error", content: "Error occured while trying to unfollow this user!"});
        });
    } else {
      axios
        .post(
          `${process.env.REACT_APP_BACKEND_URL}/api/user/follow`,
          { userId: id },
          { withCredentials: true }
        )
        .then((response) => {
          setFollowButtonName("Unfollow");
          setIsFollowing(true);
        })
        .catch((error) => {
          console.log(error);
          messageApi.open({ type: "error", content: "Error occured while trying to follow this user!"});
        });
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
            {followButtonName}
          </button>
        </div>
      </Space>
    );
  }
}

export default Profile;
