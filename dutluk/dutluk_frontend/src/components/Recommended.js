import axios from "axios";
import { useState, useEffect } from "react";
import "./css/AllStories.css";
import StoryList from "./StoryList";

function RecommendedStories() {
  const [recommendedStories, setRecommendedStories] = useState([]);

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
      });
  }, []);

  return (
    <div className="all-stories">
      <h1>Recommended Strories</h1>
      {recommendedStories.map((story) => (
        StoryList(story={story})
      ))}
    </div>
  );
}

export default RecommendedStories;
