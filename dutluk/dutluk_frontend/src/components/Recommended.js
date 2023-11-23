import axios from "axios";
import { useState, useEffect } from "react";
import { Space, message } from 'antd';
import "./css/AllStories.css";
import StoryList from "./StoryList";

function RecommendedStories() {
  const [recommendedStories, setRecommendedStories] = useState([]);
  const [messageApi, contextHolder] = message.useMessage();

  function formatDate(dateString) {
    const date = new Date(dateString);
    const day = date.getDate();
    const month = date.getMonth() + 1;
    const year = date.getFullYear();
    const hours = date.getHours();
    const minutes = date.getMinutes().toString().padStart(2, "0");

    const formattedDate = `${day}/${month}/${year} ${hours}:${minutes}`;

    return formattedDate;
  }

  useEffect(() => {
    axios
      .get(`${process.env.REACT_APP_BACKEND_URL}/api/story/feed`, {
        withCredentials: true,
      })
      .then((response) => {
        setRecommendedStories(response.data);
      })
      .catch((error) => {
        console.log(error);
        messageApi.open({ type: "error", content: "Error occured while loading stories from feed!"});
      });
  }, []);

  return (
    <Space
    direction="vertical"
    style={{
      width: '50%',
    }}
    >
    {contextHolder}
    <div className="all-stories">
      <h1>Recommended Strories</h1>
      {recommendedStories.map((story) => (
        StoryList(story={story})
      ))}
    </div>
    </Space>
  );
}

export default RecommendedStories;
