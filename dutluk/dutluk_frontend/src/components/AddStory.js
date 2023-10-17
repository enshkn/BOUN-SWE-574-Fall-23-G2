import React, { useState, useEffect } from "react";
import axios from "axios";
import { GoogleMap, LoadScript, Marker } from "@react-google-maps/api";
import ReactQuill from "react-quill";
import "react-quill/dist/quill.snow.css";
import "quill-emoji/dist/quill-emoji.css";
import DatePicker from "react-datepicker";
import "react-datepicker/dist/react-datepicker.css";
import { format, getYear } from "date-fns";
import "./css/AddStory.css";

const AddStoryForm = () => {
  const [title, setTitle] = useState("");
  const [labels, setLabels] = useState("");
  const [text, setText] = useState("");
  const [locations, setLocations] = useState([]);
  const [geocodedLocations, setGeocodedLocations] = useState([]);
  const [startTimeStamp, setStartTimeStamp] = useState(null);
  const [endTimeStamp, setEndTimeStamp] = useState(null);
  const [season, setSeason] = useState("");
  const [decade, setDecade] = useState("");

  useEffect(() => {
    if (startTimeStamp) {
      const startYear = getYear(startTimeStamp);
      const startDecade = startYear - (startYear % 10);
      setDecade(`${startDecade}s`);
    } else {
      setDecade("");
    }
  }, [startTimeStamp]);

  const handleEditorChange = (value) => {
    setText(value);
  };

  const handleSubmit = async (event) => {
    event.preventDefault();
    const currentDateTime = new Date();
    if (startTimeStamp && startTimeStamp > currentDateTime) {
      return;
    }

    if (endTimeStamp && endTimeStamp > currentDateTime) {
      return;
    }

    let formattedStartTimeStamp = null;
    let formattedEndTimeStamp = null;

    if (decade) {
      formattedStartTimeStamp = format(
        startTimeStamp,
        "dd/MM/yyyy"
      );
      formattedEndTimeStamp = format(endTimeStamp, "dd/MM/yyyy");
    } else {
      formattedStartTimeStamp = format(startTimeStamp, "dd/MM/yyyy");
      formattedEndTimeStamp = endTimeStamp
        ? format(endTimeStamp, "dd/MM/yyyy")
        : null;
    }

    const story = {
      title,
      labels: labels.split(","),
      text,
      locations: locations.map((location) => ({
        locationName: location.name,
        latitude: location.latitude,
        longitude: location.longitude,
      })),
      startTimeStamp: formattedStartTimeStamp,
      endTimeStamp: formattedEndTimeStamp,
      season,
      decade,
    };

    try {
      const response = await axios.post(
        `http://${process.env.REACT_APP_BACKEND_URL}:8080/api/story/add`,
        story,
        {
          withCredentials: true,
        }
      );
      console.log(response);
      window.location.href = `http://${process.env.REACT_APP_FRONTEND_URL}:3000/user/my-profile`;
    } catch (error) {
      console.log(error);
    }
  };

  const mapContainerStyle = {
    width: "80%",
    height: "400px",
  };

  const center = {
    lat: 41.085064,
    lng: 29.044687,
  };

  const modules = {
    toolbar: [
      [{ header: [1, 2, false] }],
      ["bold", "italic", "underline", "strike", "blockquote"],
      [{ list: "ordered" }, { list: "bullet" }],
      ["link", "image"],
    ],
  };

  const formats = [
    "header",
    "bold",
    "italic",
    "underline",
    "strike",
    "blockquote",
    "list",
    "bullet",
    "indent",
    "link",
    "image",
  ];

  const handleMapClick = async (event) => {
    const clickedLat = event.latLng.lat();
    const clickedLng = event.latLng.lng();

    try {
      const response = await axios.get(
        `https://maps.googleapis.com/maps/api/geocode/json?latlng=${clickedLat},${clickedLng}&key=${process.env.REACT_APP_GOOGLE_MAPS_API_KEY}`
      );
      const locationName = response.data.results[0]?.formatted_address || "";
      console.log(response.data.results);
      const newLocation = {
        latitude: clickedLat,
        longitude: clickedLng,
        name: locationName,
      };
      setLocations([...locations, newLocation]);
      setGeocodedLocations([...geocodedLocations, locationName]);
    } catch (error) {
      console.log("Error:", error);
    }
  };

  const handleStartDateChange = (date) => {
    setStartTimeStamp(date);
    const startYear = getYear(date);
    const startDecade = startYear - (startYear % 10);
    setDecade(`${startDecade}s`);
  };

  const handleDecadeChange = (decade) => {
    setDecade(decade);
  }

  return (
    <form className="add-story-form" onSubmit={handleSubmit}>
      <LoadScript googleMapsApiKey={process.env.REACT_APP_GOOGLE_MAPS_API_KEY}>
        <GoogleMap
          mapContainerStyle={mapContainerStyle}
          center={center}
          zoom={10}
          onClick={handleMapClick}
        >
          {locations.map((location, index) => (
            <Marker
              key={index}
              position={{
                lat: location.latitude,
                lng: location.longitude,
              }}
            />
          ))}
        </GoogleMap>
      </LoadScript>
      <br />
      <br />
      {geocodedLocations.length > 0 && (
        <div className="add-story-locations">
          <label className="add-story-label">Locations:</label>
          <ul className="add-story-location-list">
            {geocodedLocations.map((location, index) => (
              <li key={index} className="add-story-location-item">
                {location}
              </li>
            ))}
          </ul>
        </div>
      )}
      <br />
      <label className="add-story-label">
        Title:
        <input
          type="text"
          className="add-story-input"
          value={title}
          onChange={(e) => setTitle(e.target.value)}
        />
      </label>
      <br />
      <label className="add-story-label">
        Labels:(comma separated)
        <input
          type="text"
          className="add-story-input"
          value={labels}
          onChange={(e) => setLabels(e.target.value)}
        />
      </label>
      <br />
      <label className="add-story-label">
        Text:
        <ReactQuill
          value={text}
          onChange={handleEditorChange}
          modules={modules}
          formats={formats}
          className="add-story-editor"
        />
      </label>
      <label className="add-story-label">
        Start Date:
        <DatePicker
          selected={startTimeStamp}
          onChange={handleStartDateChange}
          dateFormat="dd/MM/yyyy"
          className="add-story-datepicker"
        />
      </label>
      <br />
      <label className="add-story-label">
        End Date:
        <DatePicker
          selected={endTimeStamp}
          onChange={setEndTimeStamp}
          dateFormat="dd/MM/yyyy"
          isClearable
          placeholderText="Optional"
          className="add-story-datepicker"
        />
      </label>
      <br />
      <label className="add-story-label">
        Season:
        <select
          value={season}
          onChange={(e) => setSeason(e.target.value)}
          className="add-story-select"
        >
          <option value="">Select Season</option>
          <option value="Spring">Spring</option>
          <option value="Summer">Summer</option>
          <option value="Fall">Fall</option>
          <option value="Winter">Winter</option>
        </select>
      </label>
      <br />
      <label className="add-story-label">
        Decade:
        <select
          value={decade}
          onChange={handleDecadeChange}
          className="add-story-select"
        >
          <option value="">Select Decade</option>
          <option value="1940s">1940s</option>
          <option value="1950s">1950s</option>
          <option value="1960s">1960s</option>
          <option value="1970s">1970s</option>
          <option value="1980s">1980s</option>
          <option value="1990s">1990s</option>
          <option value="2000s">2000s</option>
          <option value="2010s">2010s</option>
          <option value="2020s">2020s</option>
        </select>
      </label>
      <br />
      <button type="submit" className="add-story-button">
        Add Story
      </button>
    </form>
  );
};

export default AddStoryForm;
