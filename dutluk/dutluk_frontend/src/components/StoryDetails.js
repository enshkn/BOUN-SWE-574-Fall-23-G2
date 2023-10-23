import axios from "axios";
import { useEffect, useState } from "react";
import parse from "html-react-parser";
import { useParams } from "react-router-dom";
import { GoogleMap, LoadScript, Marker } from "@react-google-maps/api";
import "react-quill/dist/quill.snow.css";
import "./css/AllStories.css";

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

function StoryDetails() {
  const { id } = useParams();
  const [story, setStory] = useState(null);
  const [commentText, setCommentText] = useState("");

  useEffect(() => {
    axios
      .get(`${process.env.REACT_APP_BACKEND_URL}/api/story/${id}`, {
        withCredentials: true,
      })
      .then((response) => {
        setStory(response.data);
      })
      .catch((error) => {
        console.log(error);
      });
  }, [id]);

  const handleCommentSubmit = async (event) => {
    event.preventDefault();

    const comment = {
      storyId: story.id,
      commentText: commentText,
    };

    try {
      const response = await axios.post(
        `${process.env.REACT_APP_BACKEND_URL}/api/comment/add`,
        comment,
        {
          withCredentials: true,
        }
      );
      console.log(comment);
      const updatedStory = { ...story };
      updatedStory.comments.push(response.data);
      setStory(updatedStory);
      setCommentText("");
    } catch (error) {
      console.log(error);
    }
  };

  const handleLikeStory = async () => {
    try {
      const response = await axios.post(
        `${process.env.REACT_APP_BACKEND_URL}/api/story/like/`,
        { likedEntityId: story.id },
        {
          withCredentials: true,
        }
      );
      setStory(response.data);
    } catch (error) {
      console.log(error);
    }
  };
  const handleLikeComment = async (commentId) => {
    try {
      const response = await axios.post(
        `${process.env.REACT_APP_BACKEND_URL}/api/comment/like/`,
        { likedEntityId: commentId },
        {
          withCredentials: true,
        }
      );
      const updatedStory = { ...story };
      const updatedComments = updatedStory.comments.map((comment) => {
        if (comment.id === commentId) {
          return response.data;
        }
        return comment;
      });
      updatedStory.comments = updatedComments;
      setStory(updatedStory);
    } catch (error) {
      console.log(error);
    }
  };

  if (!story) {
    return <div>Story Not Found!</div>;
  }

  return (
    <div className="all-stories">
      <h1>Title: {story.title}</h1>
      <p>
        <b>Story:</b>
        <p></p>
        {parse(story.text)}
      </p>
      <p>
        <b>Likes:</b> {story.likes ? story.likes.length : 0}
      </p>
      <button onClick={handleLikeStory}>Like!</button>
      <p>
        <b>Labels:</b> {story.labels.join(", ")}
      </p>
      <b>Written by:</b>
      <a href={"/user/" + story.user.id}>{story.user.username}</a>
      <p>
        <b>Start Date:</b> {story.startTimeStamp}
      </p>
      <p>
        <b>End Date:</b> {story.endTimeStamp}
      </p>
      <p>
        <b>Published at: </b>
        {formatDate(story.createdAt)}
      </p>
      <p>
        <b>Season:</b>
        {story.season}
      </p>
      <p>
        <b>Decade:</b>
        {story.decade}
      </p>
      <label>
        <b>Selected Locations:</b>
        <ul className="locations-list">
          {story.locations.map((location) => (
            <li key={location.id}>{location.locationName}</li>
          ))}
        </ul>
      </label>
      <LoadScript googleMapsApiKey={process.env.REACT_APP_GOOGLE_MAPS_API_KEY}>
        <GoogleMap
          mapContainerStyle={{ width: "80%", height: "400px" }}
          center={{ lat: 41.085064, lng: 29.044687 }}
          zoom={10}
        >
          {story.locations.map((location) => (
            <Marker
              key={location.id}
              position={{ lat: location.latitude, lng: location.longitude }}
            />
          ))}
        </GoogleMap>
      </LoadScript>
      <p>
        <b>Comments:</b>
      </p>
      <ul>
        {story.comments.map((comment) => (
          <li key={comment.id}>
            <b>Comment: </b>
            {comment.text}
            <p>
              <b>Commented by: </b>
              {comment.user.username}
            </p>
            <p>
              <b>Likes:</b> {comment.likes ? comment.likes.length : 0}
              <button onClick={() => handleLikeComment(comment.id)}>
                Like
              </button>
            </p>
          </li>
        ))}
      </ul>
      <form onSubmit={handleCommentSubmit}>
        <label>
          Add Comment:
          <textarea
            value={commentText}
            onChange={(e) => setCommentText(e.target.value)}
          ></textarea>
        </label>
        <button type="submit">Submit</button>
      </form>
    </div>
  );
}

export default StoryDetails;
