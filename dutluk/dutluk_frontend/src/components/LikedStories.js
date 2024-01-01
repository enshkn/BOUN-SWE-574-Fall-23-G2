import axios from "axios";
import { useState, useEffect } from "react";
import { Space, message } from 'antd';
import "./css/AllStories.css";
import StoryList from "./StoryList";

function LikedStories() {
  const [likedStories, setLikedStories] = useState([]);
  const [messageApi, contextHolder] = message.useMessage();

  useEffect(() => {
    axios
      .get(`${process.env.REACT_APP_BACKEND_URL}/api/story/liked`, {
        withCredentials: true,
      })
      .then((response) => {
        setLikedStories(response.data);
      })
      .catch((error) => {
        console.log(error);
        messageApi.open({ type: "error", content: "Error occured while loading your saved stories."});
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
        <center><h1>Stories You Liked</h1></center>
        {likedStories.map((story) => (
          <StoryList key={story.id} story={story} />
        ))}
    </div>
    </Space>
  );
}

export default LikedStories;
