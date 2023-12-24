import axios from "axios";
import { useState, useEffect } from "react";
import { Space, message } from 'antd';
import "./css/AllStories.css";
import StoryList from "./StoryList";

function MyStories() {
  const [myStories, setMyStories] = useState([]);
  const BACKEND_URL = process.env.REACT_APP_BACKEND_URL;
  const [messageApi, contextHolder] = message.useMessage();

  useEffect(() => {
    axios
      .get(
        `${process.env.REACT_APP_BACKEND_URL}/api/story/fromUser`,
        {
          withCredentials: true,
        }
      )
      .then((response) => {
        setMyStories(response.data);
      })
      .catch((error) => {
        console.log(error);
        messageApi.open({ type: "error", content: "Error occured while loading your stories"});
      });
  }, [BACKEND_URL, messageApi]);


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
      <center><h1>My Stories</h1></center>
      {myStories.map((story) => (
        <StoryList story={story} key={story.id} isMyStoriesPage={true}>
        </StoryList>
      ))}
    </div>
    </Space>
  );
}

export default MyStories;
