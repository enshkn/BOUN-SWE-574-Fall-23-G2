import axios from "axios";
import { useState, useEffect } from "react";
import { Space, message } from 'antd';
import "./css/AllStories.css";
import StoryList from "./StoryList";

// This component contains old name but it is changed in order to avoid confusion on the user side.
// Component and api names remains same.

function SavedStories() {
  const [savedStories, setSavedStories] = useState([]);
  const [messageApi, contextHolder] = message.useMessage();

  useEffect(() => {
    axios
      .get(`${process.env.REACT_APP_BACKEND_URL}/api/story/saved`, {
        withCredentials: true,
      })
      .then((response) => {
        setSavedStories(response.data);
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
        <center><h1>Your Stashed Stories</h1></center>
        {savedStories.map((story) => (
          <StoryList key={story.id} story={story} />
        ))}
    </div>
    </Space>
  );
}

export default SavedStories;
