import axios from "axios";
import { useState, useEffect } from "react";
import { Space, message } from 'antd';
import "./css/AllStories.css";
import StoryList from "./StoryList";

function RecommendedStories() {
  const [recommendedStories, setRecommendedStories] = useState([]);
  const [messageApi, contextHolder] = message.useMessage();

  useEffect(() => {
    axios
      .get(`${process.env.REACT_APP_BACKEND_URL}/api/story/recommended`, {
        withCredentials: true,
      })
      .then((response) => {
        setRecommendedStories(response.data);
      })
      .catch((error) => {
        console.log(error);
        messageApi.open({ type: "error", content: "Error occured while loading stories from feed!"});
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
      <center><h1>Recommended Stories</h1></center>
      {recommendedStories.map((story) => (
        <StoryList story={story} key={story.id} />
      ))}
    </div>
    </Space>
  );
}

export default RecommendedStories;
