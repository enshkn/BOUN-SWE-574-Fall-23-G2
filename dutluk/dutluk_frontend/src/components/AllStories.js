import axios from "axios";
import { useState, useEffect } from "react";
import { Space, message } from 'antd';
import "./css/AllStories.css";
import StoryList from "./StoryList";

function AllStories() {
  const [allStories, setAllStories] = useState([]);
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
      .get(`${process.env.REACT_APP_BACKEND_URL}/api/story/all`, {
        withCredentials: true,
      })
      .then((response) => {
        setAllStories(response.data);
      })
      .catch((error) => {
        console.log(error);
        messageApi.open({ type: "error", content: "Error occured while loading stories"});
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
      <h1>All Stories</h1>
      {allStories.map((story) => (
        StoryList(story={story})
      ))}
    </div>
    </Space>
  );
}

export default AllStories;
