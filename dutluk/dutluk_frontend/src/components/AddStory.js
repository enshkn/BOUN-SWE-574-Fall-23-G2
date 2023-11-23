import React, { useState, useEffect } from "react";
import axios from "axios";
import { GoogleMap, LoadScript, Marker, StandaloneSearchBox } from "@react-google-maps/api";
import ReactQuill from "react-quill";
import "react-quill/dist/quill.snow.css";
import "quill-emoji/dist/quill-emoji.css";
import DatePicker from "react-datetime-picker";
import "react-datetime-picker/dist/DateTimePicker.css";
import { format, getYear } from "date-fns";
import { useNavigate } from "react-router-dom";
import { Space, message } from 'antd';
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
  const [searchBox, setSearchBox] = useState(null);

  const [currentShape, setCurrentShape] = useState(null);
  const [tempPoints, setTempPoints] = useState([]);
  const [circleRadius, setCircleRadius] = useState(5000);

  const [markers, setMarkers] = useState([]);
  const [circles, setCircles] = useState([]);
  const [polygons, setPolygons] = useState([]);
  const [polylines, setPolylines] = useState([]);
  const [timeResolution, setTimeResolution] = useState("");

  const [messageApi, contextHolder] = message.useMessage();
  const onSearchBoxLoad = (ref) => {
    setSearchBox(ref);
  };

  const onPlacesChanged = () => {
    const places = searchBox.getPlaces();
    const place = places[0];
    if (!place.geometry) return;

    const newLocation = {
      latitude: place.geometry.location.lat(),
      longitude: place.geometry.location.lng(),
      name: place.formatted_address,
    };

    setLocations([...locations, newLocation]);
    setGeocodedLocations([...geocodedLocations, place.formatted_address]);
  };


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

  const navigate = useNavigate(); // Create history object

  const handleSubmit = async (event) => {
    event.preventDefault();
    // Text validation
    if (!text || text.trim() === '' || text === '<p><br></p>') { // Check for empty or only whitespace
      messageApi.open({ type: "error", content: "Story body cannot be empty. Please try again."});
      return; // Prevent form submission if story body is empty
    }
    if (!startTimeStamp && !decade && !season) {
      messageApi.open({ type: "error", content: "Please select at least one: Start Date, Decade, or Season"});
      return; // Prevent form submission if no date is picked
    }
    // Location validation
    if (markers.length === 0 && circles.length === 0 && polygons.length === 0 && polylines.length === 0) {
      messageApi.open({ type: "error", content: "Please pick at least one location."});
      return; // Prevent form submission if no location is set
    }
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
      formattedStartTimeStamp = format(startTimeStamp, "yyyy-MM-dd HH:mm");
      formattedEndTimeStamp = endTimeStamp
        ? format(endTimeStamp, "yyyy-MM-dd HH:mm")
        : null;
    } else {
      formattedStartTimeStamp = format(startTimeStamp, "yyyy-MM-dd HH:mm");
      formattedEndTimeStamp = null;
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
        `${process.env.REACT_APP_BACKEND_URL}/api/story/add`,
        story,
        {
          withCredentials: true,
        }
      );
      console.log(response);
      await messageApi.open({ type: "success", content: "Story added successfully!"});
      navigate('/');
    } catch (error) {
      console.log(error);
      messageApi.open({ type: "error", content: "Failed to add story. Please try again."});
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
    let locationName = "";

    try {
      const response = await axios.get(
        `https://maps.googleapis.com/maps/api/geocode/json?latlng=${clickedLat},${clickedLng}&key=${process.env.REACT_APP_GOOGLE_MAPS_API_KEY}`
      );
      const locationName = response.data.results[0]?.formatted_address || "";
      console.log(response.data.results);
    }  catch (error) {
      console.error("Error in reverse geocoding:", error);
      messageApi.open({ type: "warning", content: "Failed to fetch location name, it will be saved as unknown!"});
      locationName = "Unknown Location"
    }

    if (currentShape === 'marker') {

      const newMarker = {
        latitude: clickedLat,
        longitude: clickedLng,
        name: locationName,
        id: markers.length, // Unique identifier based on the current length of the array
      };
      setMarkers([...markers, newMarker]);

    } else if (currentShape === 'circle') {
      const newCircle = {
        center: { lat: clickedLat, lng: clickedLng, name: locationName },
        radius: circleRadius,
        name: locationName,
        id: circles.length // Unique identifier based on the current length of the array
      };
      setCircles([...circles, newCircle]);
    }

    else {
      // For polygons and polylines, add temporary points
      setTempPoints([...tempPoints, { lat: clickedLat, lng: clickedLng, name: locationName }]);
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
  };

  const handleEndDateChange = (date) => {
    setEndTimeStamp(date);
  };

  const handleRemoveLocation = (index) => {
    const updatedLocations = [...locations];
    const updatedGeocodedLocations = [...geocodedLocations];

    updatedLocations.splice(index, 1); // Remove the location at the specified index
    updatedGeocodedLocations.splice(index, 1); // Remove the corresponding geocoded location

    setLocations(updatedLocations);
    setGeocodedLocations(updatedGeocodedLocations);
  };

  return (
    <Space
    direction="vertical"
    style={{
      width: '50%',
    }}
    >
    {contextHolder}
    <form className="add-story-form" onSubmit={handleSubmit}>
      <LoadScript googleMapsApiKey={process.env.REACT_APP_GOOGLE_MAPS_API_KEY}
        libraries={["places"]}>
        <StandaloneSearchBox onLoad={onSearchBoxLoad} onPlacesChanged={onPlacesChanged}>
          <input type="text" placeholder="Search" style={{ width: "80%", height: "40px" }} />
        </StandaloneSearchBox>
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
                <button
                  type="button"
                  className="remove-location-button"
                  onClick={() => handleRemoveLocation(index)}
                >
                  Remove
                </button>
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
          required={true}
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
          required={true}
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
        Start Date and Time:
        <DatePicker
          value={startTimeStamp}
          onChange={handleStartDateChange}
          className="add-story-datepicker"
        />
      </label>
      <br />
      <label className="add-story-label">
        End Date and Time:
        <DatePicker
          value={endTimeStamp}
          onChange={handleEndDateChange}
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
    </Space>
  );
};

export default AddStoryForm;
