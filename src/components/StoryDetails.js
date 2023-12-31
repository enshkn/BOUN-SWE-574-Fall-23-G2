import axios from "axios";
import { useEffect, useState } from "react";
import { Space, message } from 'antd';
import parse from "html-react-parser";
import { useParams } from "react-router-dom";
import { GoogleMap, LoadScript, Marker, Circle, Polygon, Polyline } from "@react-google-maps/api";
import "react-quill/dist/quill.snow.css";
import "./css/AllStories.css";

function StoryDetails() {
  const { id } = useParams();
  const [story, setStory] = useState();
  const [commentText, setCommentText] = useState("");
  const [messageApi, contextHolder] = message.useMessage();

  const [markers, setMarkers] = useState([]);
  const [circles, setCircles] = useState([]);
  const [polygons, setPolygons] = useState([]);
  const [polylines, setPolylines] = useState([]);

  const currentUserId = sessionStorage.getItem('currentUserId');

  const convertLocations = (story) => {

    const tempMarkers = story.locations.filter(location => location.isPoint !== null);
    const tempCircles = story.locations.filter(location => location.isCircle !== null);
    const tempPolygons = story.locations.filter(location => location.isPolygon !== null);
    const tempPolylines = story.locations.filter(location => location.isPolyline !== null);

    // Markers
    tempMarkers.forEach((location) => {
      setMarkers(prevMarkers => [
        ...prevMarkers,
        {
          latitude: location.latitude,
          longitude: location.longitude,
          name: location.locationName,
          id: location.id
        }
      ]);
    });
    // Circles
    tempCircles.forEach((location) => {
      setCircles(prevCircles => [
        ...prevCircles,
        {
          center: { lat: location.latitude, lng: location.longitude, name: location.locationName },
          radius: location.circleRadius,
          id: location.id,
          name: location.locationName,
        }
      ]);
    });
    // Polylines
    // Group polylines by polyline id
    const groupedPolylines = tempPolylines.reduce((acc, location) => {
      if (location.isPolyline !== null) {
        if (!acc[location.isPolyline]) {
          acc[location.isPolyline] = [];
        }
        acc[location.isPolyline].push({
          lat: location.latitude,
          lng: location.longitude
        });
      }
      return acc;
    }, {});

    // Extract polylines by polyline id
    Object.keys(groupedPolylines).forEach(key => {
      setPolylines(prevPolylines => [
        ...prevPolylines,
        {
          id: key,
          path: groupedPolylines[key]
        }
      ]);
    });

    // Polygons
    // Group polygons by polygons id
    const groupedPolygons = tempPolygons.reduce((acc, location) => {
      if (location.isPolygon !== null) {
        if (!acc[location.isPolygon]) {
          acc[location.isPolygon] = [];
        }
        acc[location.isPolygon].push({
          lat: location.latitude,
          lng: location.longitude
        });
      }
      return acc;
    }, {});

    // Extract polygons by polygons id
    Object.keys(groupedPolygons).forEach(key => {
      setPolygons(prevPolygons => [
        ...prevPolygons,
        {
          id: key,
          path: groupedPolygons[key]
        }
      ]);
    });
  };

  useEffect(() => {
    axios
      .get(`${process.env.REACT_APP_BACKEND_URL}/api/story/${id}`, {
        withCredentials: true,
      })
      .then((response) => {
        setStory(response.data);
        convertLocations(response.data);
      })
      .catch((error) => {
        console.log(error);
        messageApi.open({ type: "error", content: "Error occured while loading the story!" });
      });
  }, [id, messageApi]);

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
      messageApi.open({ type: "success", content: "Your comment is posted!" });
    } catch (error) {
      console.log(error);
      messageApi.open({ type: "error", content: "Error occured while posting your comment!" });
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
      messageApi.open({ type: "success", content: "You liked this story!" });
    } catch (error) {
      console.log(error);
      messageApi.open({ type: "error", content: "Error occured while liking this story!" });
    }
  };
  const handleLikeComment = async (commentId) => {
    try {
      const response = await axios.post(
        `${process.env.REACT_APP_BACKEND_URL}/api/comment/like`,
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
      messageApi.open({ type: "success", content: "You liked the comment!" });
    } catch (error) {
      console.log(error);
      messageApi.open({ type: "error", content: "Error occured while liking the comment!" });
    }
  };

  const handleDeleteComment = async (commentId) => {
    try {
      const response = await axios.get(
        `${process.env.REACT_APP_BACKEND_URL}/api/comment/delete/${commentId}`,
        {
          withCredentials: true,
        });
      if (response.status === 200) {
        messageApi.open({ type: "success", content: "Comment deleted." });
        // Filter out the comment with the given id from the current comments array
        const updatedComments = story.comments.filter(comment => comment.id !== commentId);
        // Update the state with the new comments array
        setStory({ ...story, comments: updatedComments });
      }
      else {
        messageApi.open({ type: "error", content: "Error occured while trying to delete comment!" });
      }
    } catch (error) {
      console.log(error);
      messageApi.open({ type: "error", content: "Error occured while trying to delete comment!" });
    }
  }



  if (!story) {
    messageApi.open({ type: "error", content: "Story Not Found!" });
    return <div>Story Not Found!</div>;
  }

  return (
    <Space
      direction="vertical"
      style={{
        width: '100%',
      }}
    >
      {contextHolder}
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
        <button onClick={handleLikeStory} className="btn btn-primary mb-2">Like!</button>
        <p className="story-details">
          <b>Labels:</b>{" "}
          {story.labels.map((label, index) => (
            <span key={index}>
              <a href={"/story/search/label/" + label}>{label}</a>
              {index < story.labels.length - 1 && ", "}
            </span>
          ))}
        </p>
        <b>Written by:</b>
        <a href={"/user/" + story.user.id}>{story.user.username}</a>
        <p>

          <b>Published at: </b>
          {story.createdAt}
        </p>
        {story.season && (
          <p>
            <b>Season:</b> {story.season}
          </p>
        )}
        {story.decade && (
          <p>
            <b>Decade:</b> {story.decade}
          </p>
        )}
        {story.startTimeStamp && (
          <p>
            <b>Start Date:</b> {story.startTimeStamp}
          </p>
        )}
        {story.endTimeStamp && (
          <p>
            <b>End Date:</b> {story.endTimeStamp}
          </p>
        )}

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
            center={{
              lat: story.locations[0].latitude,
              lng: story.locations[0].longitude,
            }}
            zoom={10}
          >
            {markers.map((marker, index) => (
              <Marker
                key={index}
                position={{
                  lat: marker.latitude,
                  lng: marker.longitude,
                }}
              />
            ))}
            {circles.map((circle, index) => (
              <Circle
                key={index}
                center={circle.center}
                radius={circle.radius}
              />
            ))}
            {polygons.map((polygon, index) => (
              <Polygon
                key={index}
                paths={polygon.path}
              />
            ))}
            {polylines.map((polyline, index) => (
              <Polyline
                key={index}
                path={polyline.path}
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
                <button className="btn btn-primary" onClick={() => handleLikeComment(comment.id)}>
                  Like
                </button>
                {comment.user.id == currentUserId && (
                  <button
                    className="btn btn-danger"
                    style={{ marginLeft: '10px' }} // Add some space between the buttons
                    onClick={() => handleDeleteComment(comment.id)}
                  >Delete</button>)
                }
              </p>
            </li>
          ))}
        </ul>
        <form onSubmit={handleCommentSubmit} style={{ width: "80%" }}>
          <div>
            <textarea
              label="Add Comment"
              value={commentText}
              placeholder="Add Comment"
              style={{ width: "100%", height: "100px" }}
              onChange={(e) => setCommentText(e.target.value)}
            ></textarea>
          </div>
          <div style={{ display: "flex", justifyContent: "flex-end" }}>
            <button type="submit" className="btn btn-primary">Submit</button>
          </div>
        </form>


      </div>
    </Space>
  );
}

export default StoryDetails;