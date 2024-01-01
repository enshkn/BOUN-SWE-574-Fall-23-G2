import axios from "axios";
import { useState, useEffect } from "react";
import { Space, message } from 'antd';
import "./css/AllStories.css";
import StoryList from "./StoryList";

function FollowedUserStories() {
  const [followedUserStories, setFollowedUserStories] = useState([]);
  const [messageApi, contextHolder] = message.useMessage();

  useEffect(() => {
    axios
      .get(`${process.env.REACT_APP_BACKEND_URL}/api/story/following`, {
        withCredentials: true,
      })
      .then((response) => {
        setFollowedUserStories(response.data);
      })
      .catch((error) => {
        console.log(error);
        messageApi.open({ type: "error", content: "Error occured while loading stories from followings!"});
      });
  }, [messageApi]);

  return (
    <Space
    direction="vertical"
    align="center"
    style={{
      width: '100%',
    }}
    >
    {contextHolder}
    <div className="all-stories">
    <center><h1>Story Feed</h1></center>
      {followedUserStories.map((story) => (
        <StoryList story={story} key={story.id} />
      ))}
    </div>
    </Space>
  );
}

export default FollowedUserStories;
