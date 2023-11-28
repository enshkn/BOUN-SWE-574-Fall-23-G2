import axios from "axios";
import { useState, useEffect } from "react";
import "./css/AllStories.css";
import StoryList from "./StoryList";

function AllStories() {
  const [allStories, setAllStories] = useState([]);

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
      });
  }, []);

  return (
    <div className="all-stories">
      <h1>All Stories</h1>
      {allStories.map((story) => (
        StoryList(story={story})
      ))}
    </div>
  );
}

export default AllStories;
