import axios from "axios";
import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { Space, message } from 'antd';
import "./css/AllStories.css";
import StoryList from "./StoryList";

function MyStories() {
  const [myStories, setMyStories] = useState([]);
  const BACKEND_URL = process.env.REACT_APP_BACKEND_URL;
  const navigate = useNavigate();
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

  const handleDelete = (storyId) => {
    axios
      .get(
        `${process.env.REACT_APP_BACKEND_URL}/api/story/delete/${storyId}`,
        {
          withCredentials: true,
        }
      )
      .then(() => {
        setMyStories((prevStories) =>
          prevStories.filter((story) => story.id !== storyId)
        );
      })
      .catch((error) => {
        console.log(error);
        messageApi.open({ type: "error", content: "Error occured while deleting the story!"});
      });
  };

  const handleEdit = (storyId) => {
    navigate(`/story/edit/${storyId}`);
  };

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
      <h1>My Stories</h1>
      {myStories.map((story) => (
        <StoryList story={story}>
          {/* <button
            className="edit-button"
            onClick={() => handleEdit(story.id)}
          >
            Edit Story
          </button>
          <br></br><br></br> */}
          <button
            className="delete-button"
            onClick={() => handleDelete(story.id)}
          >
            Delete
          </button>
        </StoryList>
      ))}
    </div>
    </Space>
  );
}

export default MyStories;
