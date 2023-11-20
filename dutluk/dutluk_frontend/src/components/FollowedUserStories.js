import axios from "axios";
import { useState, useEffect } from "react";
import "./css/AllStories.css";
import StoryList from "./StoryList";

function FollowedUserStories() {
  const [followedUserStories, setFollowedUserStories] = useState([]);

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
      .get(`${process.env.REACT_APP_BACKEND_URL}/api/story/following`, {
        withCredentials: true,
      })
      .then((response) => {
        setFollowedUserStories(response.data);
      })
      .catch((error) => {
        console.log(error);
      });
  }, []);

  return (
    <div className="all-stories">
      <h1>Story Feed</h1>
      {followedUserStories.map((story) => (
        StoryList(story = { story })
      ))}
    </div>
  );
}

export default FollowedUserStories;
