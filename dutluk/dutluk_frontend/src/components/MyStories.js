import axios from "axios";
import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import "./css/AllStories.css";
import StoryList from "./StoryList";

function MyStories() {
  const [myStories, setMyStories] = useState([]);
  const BACKEND_URL = process.env.REACT_APP_BACKEND_URL;
  const navigate = useNavigate();

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
      });
  }, [BACKEND_URL]);

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
      });
  };

  const handleEdit = (storyId) => {
    navigate(`/story/edit/${storyId}`);
  };

  return (
    <div className="all-stories">
      <h1>My Stories</h1>
      {myStories.map((story) => (
        <StoryList story={story}>
          <button
            className="edit-button"
            onClick={() => handleEdit(story.id)}
          >
            Edit Story
          </button>
          <br></br><br></br>
          <button
            className="delete-button"
            onClick={() => handleDelete(story.id)}
          >
            Delete
          </button>
        </StoryList>
      ))}
    </div>
  );
}

export default MyStories;
