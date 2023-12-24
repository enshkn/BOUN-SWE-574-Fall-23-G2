import axios from "axios";
import { useState, useEffect } from "react";
import { Space, message } from 'antd';
import "./css/AllStories.css";
import StoryList from "./StoryList";

function AllStories() {
  const [allStories, setAllStories] = useState([]);
  const [messageApi, contextHolder] = message.useMessage();


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
      <h1>All Stories</h1>
      {allStories.map((story) => (
        <StoryList story={story} key={story.id} />
      ))}
    </div>
    </Space>
  );
}

export default AllStories;
