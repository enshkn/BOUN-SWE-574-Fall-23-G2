import React, { useState, useEffect, useCallback, useRef } from "react";
import axios from "axios";
import { Circle, GoogleMap, LoadScript, Marker, Polygon, Polyline, StandaloneSearchBox } from "@react-google-maps/api";
import { useParams, useNavigate } from "react-router-dom";
import ReactQuill from "react-quill";
import "react-quill/dist/quill.snow.css";
import "quill-emoji/dist/quill-emoji.css";
import DatePicker from "react-datetime-picker";
import "react-datetime-picker/dist/DateTimePicker.css";
import { format, getYear } from "date-fns";
import { Space, message, Input, Tag, Tooltip, Segmented, InputNumber, Slider } from 'antd';
import "./css/EditStory.css";
import DateTimerPicker from "./DateTimerPicker";
import 'bootstrap/dist/css/bootstrap.min.css';

const EditStoryForm = () => {
  const { id } = useParams();
  const [messageApi, contextHolder] = message.useMessage();
  const Navigate = useNavigate();
  const [prevStory, setPrevStory] = useState([]);

  const [title, setTitle] = useState("");
  const [text, setText] = useState("");
  // time resolution states
  const [startTimeStamp, setStartTimeStamp] = useState(new Date());
  const [endTimeStamp, setEndTimeStamp] = useState(new Date());
  // timeType and timeExpression are used for time resolution
  const [timeType, setTimeType] = useState(null);
  const [timeExpression, setTimeExpression] = useState(null);
  // hourFlag and dateFlag are used for time resolution
  const [startHourFlag, setStartHourFlag] = useState(null);
  const [startDateFlag, setStartDateFlag] = useState(null);
  const [endHourFlag, setEndHourFlag] = useState(null);
  const [endDateFlag, setEndDateFlag] = useState(null);
  // season and decade are used for time resolution
  const [season, setSeason] = useState(null);
  const [endSeason, setEndSeason] = useState(null);
  const [decade, setDecade] = useState(null);
  const [endDecade, setEndDecade] = useState(null);
  // existing states
  const [searchBox, setSearchBox] = useState(null);
  const [currentShape, setCurrentShape] = useState('marker');
  const [tempPoints, setTempPoints] = useState([]);
  const [circleRadius, setCircleRadius] = useState(5);
  const [markers, setMarkers] = useState([]);
  const [circles, setCircles] = useState([]);
  const [polygons, setPolygons] = useState([]);
  const [polylines, setPolylines] = useState([]);
  const [timeResolution, setTimeResolution] = useState("");
  const [tags, setTags] = useState([]);
  const [inputVisible, setInputVisible] = useState(false);
  const [inputValue, setInputValue] = useState('');
  const [editInputIndex, setEditInputIndex] = useState(-1);
  const [editInputValue, setEditInputValue] = useState('');
  const inputRef = useRef(null);
  const editInputRef = useRef(null);
  const [verbalExpression, setVerbalExpression] = useState("");

  const [loading, setLoading] = useState(true); // Loading state
  const [geocodedLocations, setGeocodedLocations] = useState([]);
  const [locations, setLocations] = useState([]);


  const onSearchBoxLoad = (ref) => {
    setSearchBox(ref);
  };

  const seasonsDict = {
    null: null,
    "": null,
    1: 'Winter',
    2: 'Spring',
    3: 'Summer',
    4: 'Fall'
  };

//  ----------------------------------- Location and Fetching related event handlers ----------------------------------- //

// const setLocations = (newLocations) => {
//   const newMarkers = [];
//   const newCircles = [];
//   const newPolygons = [];
//   const newPolylines = [];

//   newLocations.forEach((location) => {
//     const { latitude, longitude, name, isCircle, isPolygon, isPolyline, isPoint } = location;

//     if (isCircle !== null) {
//       newCircles.push({
//         center: { name, lat: latitude, lng: longitude },
//         radius: location.circleRadius,
//       });
//     } else if (isPolygon !== null) {
//       // Find the existing polygon in the state based on index
//       const existingPolygon = newPolygons[isPolygon] || { paths: [] };
//       existingPolygon.paths.push({ name, lat: latitude, lng: longitude });

//       // Update the newPolygons array
//       newPolygons[isPolygon] = existingPolygon;
//     } else if (isPolyline !== null) {
//       // Find the existing polyline in the state based on index
//       const existingPolyline = newPolylines[isPolyline] || { path: [] };
//       existingPolyline.path.push({ name, lat: latitude, lng: longitude });

//       // Update the newPolylines array
//       newPolylines[isPolyline] = existingPolyline;
//     } else if (isPoint !== null) {
//       newMarkers.push({ name, latitude, longitude });
//     }
//   });

//   // Update state variables
//   setMarkers(newMarkers);
//   setCircles(newCircles);
//   setPolygons(newPolygons);
//   setPolylines(newPolylines);
// };

  const fetchStoryData = useCallback(async () => {
    try {
      const response = await axios.get(
        `${process.env.REACT_APP_BACKEND_URL}/api/story/${id}`,
        {
          withCredentials: true,
        }
      );
      const existingStory = response.data;
      setPrevStory(existingStory);
      setTitle(existingStory.title);
      setTags(existingStory.labels || []);
      setText(existingStory.text);
      setLocations(
        existingStory.locations.map((location) => ({
          latitude: location.latitude,
          longitude: location.longitude,
          name: location.locationName,
          circleRadius: location.circleRadius,
          isCircle: location.isCircle,
          isPolyline: location.isPolyline,
          isPolygon: location.isPolygon,
          isPoint: location.isPoint
        }))
      );

      //Previously selected date is gathered from prevStory so below fields are extracted to avoid confusion.

      // setStartTimeStamp(new Date(existingStory.startTimeStamp));
      // setEndTimeStamp(
      //   existingStory.endTimeStamp ? new Date(existingStory.endTimeStamp) : null
      // );
      // setSeason(existingStory.season);
      // setEndSeason(existingStory.endSeason);
      // setDecade(existingStory.decade);
      // setEndDecade(existingStory.endDecade);
      // setStartHourFlag(existingStory.startHourFlag);
      // setEndHourFlag(existingStory.endHourFlag);
      // setStartDateFlag(existingStory.startDateFlag);
      // setEndDateFlag(existingStory.endDateFlag);
      // setTimeType(existingStory.timeType);
      // setTimeExpression(existingStory.timeExpression);
      setVerbalExpression(existingStory.verbalExpression);

    // Initialize arrays to hold location data
    const newMarkers = [];
    const newCircles = [];
    const newPolygons = [];
    const newPolylines = [];

    // Loop through existingStory.locations
    existingStory.locations.map((location, index) => {
      const { latitude, longitude, name, isCircle, isPolygon, isPolyline, isPoint  } = location;

      if (isCircle !== null) {
        newCircles.push({
          center: { name: location.locationName, lat: location.latitude, lng: location.longitude },
          radius: location.circleRadius,
        });
      } else if (isPolygon !== null) {
        // Find the existing polygon in the state based on index
        const existingPolygon = newPolygons[isPolygon] || { paths: [] };
        existingPolygon.paths.push({ name: location.locationName, lat: location.latitude, lng: location.longitude });

        // Update the newPolygons array
        newPolygons[isPolygon] = existingPolygon;
      } else if (isPolyline !== null) {
        // Find the existing polyline in the state based on index
        const existingPolyline = newPolylines[isPolyline] || { path: [] };
        existingPolyline.path.push({ name:location.locationName , lat: location.latitude, lng: location.longitude });

        // Update the newPolylines array
        newPolylines[isPolyline] = existingPolyline;
      } else if (isPoint !== null) {
        newMarkers.push({ name: location.locationName, latitude: location.latitude, longitude: location.longitude });
      }
    });

    // Update state variables
    setMarkers(newMarkers);
    setCircles(newCircles);
    setPolygons(newPolygons);
    setPolylines(newPolylines);

    setLoading(false); // Set loading to false after fetching data

    } catch (error) {
      console.log(error);
      messageApi.open({ type: "error", content: "Error occured while fetching the story data!"});
    }
  }, [id, messageApi]);

  useEffect(() => {
    fetchStoryData();
  }, [id, fetchStoryData]);

  //  ----------------------------------- Location and Editor related event handlers ----------------------------------- //
  const onPlacesChanged = () => {
    const places = searchBox.getPlaces();
    const place = places[0];
    if (!place.geometry) return;

    const newMarker = {
      latitude: place.geometry.location.lat(),
      longitude: place.geometry.location.lng(),
      name: place.formatted_address,
    };

    setMarkers([...markers, newMarker]);
  };

  const handleRemoveShape = (index, type) => {
    if (type === 'marker') {
      setMarkers(markers.filter((_, i) => i !== index));
    }
    else if (type === 'polygon') {
      setPolygons(polygons.filter((_, i) => i !== index));
    } else if (type === 'polyline') {
      setPolylines(polylines.filter((_, i) => i !== index));
    } else if (type === 'circle') {
      setCircles(circles.filter((_, i) => i !== index));
    }
  };

  //  ----------------------------------- Editor and Location related event handlers ----------------------------------- //

  const handleEditorChange = (value) => {
    setText(value);
  };

  const handleEditSubmit = async (event) => {
    event.preventDefault();
    // Text validation
    if (!text || text.trim() === '' || text === '<p><br></p>') { // Check for empty or only whitespace
      messageApi.open({ type: "error", content: "Story body cannot be empty. Please try again."});
      return; // Prevent form submission if story body is empty
    }
    // if (!startTimeStamp && !decade && !season) {
    //   messageApi.open({ type: "error", content: "Please select at least one: Start Date, Decade, or Season"});
    //   return; // Prevent form submission if no date is picked
    // }
    // Location validation
    if (markers.length === 0 && circles.length === 0 && polygons.length === 0 && polylines.length === 0) {
      messageApi.open({ type: "error", content: "Please pick at least one location."});
      return; // Prevent form submission if no location is set
    }

    // Additional location validation (latitude and longitude)
    const invalidLocations = locations.filter(location => !location.latitude || !location.longitude);
    if (invalidLocations.length > 0) {
      messageApi.open({ type: "error", content: "Some locations are missing latitude or longitude. Please refresh and try again." });
      return;
    }

    {/* 
    const currentDateTime = new Date();
    let formattedStartTimeStamp = null;
    let formattedEndTimeStamp = null;

    if(startTimeStamp !== null) {
      if (startTimeStamp && startTimeStamp > currentDateTime) {
        return;
      }

    if(endTimeStamp !== null) {
        if (endTimeStamp && endTimeStamp > currentDateTime) {
          return;
        }

        if (decade) {
          formattedStartTimeStamp = format(startTimeStamp, "yyyy-MM-dd HH:mm");
          formattedEndTimeStamp = endTimeStamp
            ? format(endTimeStamp, "yyyy-MM-dd HH:mm")
            : null;
        } else {
          formattedStartTimeStamp = format(startTimeStamp, "yyyy-MM-dd HH:mm");
          formattedEndTimeStamp = null;
        }
      }
    }
    */}

    const editedStory = {
      title,
      labels: tags, 
      text,
      locations: [
        ...markers.map((point, markerIndex) => ({
          locationName: point.name,
          latitude: point.latitude,
          longitude: point.longitude,
          circleRadius: null,
          isCircle: null,
          isPolyline: null,
          isPolygon: null,
          isPoint: markerIndex, // Index for standalone points
        })),
        ...circles.map((circle, circleIndex) => ({
          locationName: circle.center.name,
          latitude: circle.center.lat,
          longitude: circle.center.lng,
          circleRadius: circle.radius,
          isCircle: circleIndex,
          isPolyline: null,
          isPolygon: null,
          isPoint: null,
        })),
        ...polygons.flatMap((polygon, polygonIndex) =>
          polygon.paths.map(point => ({
            locationName: point.name,
            latitude: point.lat,
            longitude: point.lng,
            circleRadius: null,
            isCircle: null,
            isPolyline: null,
            isPolygon: polygonIndex,
            isPoint: null,
          }))
        ),
        ...polylines.flatMap((polyline, polylineIndex) =>
          polyline.path.map(point => ({
            locationName: point.name,
            latitude: point.lat,
            longitude: point.lng,
            circleRadius: null,
            isCircle: null,
            isPolyline: polylineIndex,
            isPolygon: null,
            isPoint: null,
          }))
        )
      ],
      startTimeStamp,
      endTimeStamp,
      season,
      endSeason,
      decade,
      endDecade,
      startHourFlag,
      endHourFlag,
      startDateFlag,
      endDateFlag,
      timeType,
      timeExpression,
    };
  
    try {
      const response = await axios.post(
        `${process.env.REACT_APP_BACKEND_URL}/api/story/edit/${id}`,
        editedStory,
        {
          withCredentials: true,
        }
      );
      console.log(response);
      await messageApi.open({ type: "success", content: "Story has been edited successfully!"});
      Navigate(`/story/${id}`);
    } catch (error) {
      console.log(error);
      messageApi.open({ type: "error", content: "Error occured while trying to edit the story!"});
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
      locationName = response.data.results[0]?.formatted_address || "Unknown Location";
      console.log(response.data.results);
    } catch (error) {
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

  const finishShape = () => {
    if (currentShape === 'polygon' && tempPoints.length > 2) {
      // Get location name of the last point

      const newPolygon = {
        id: polygons.length, // Unique identifier based on the current length of the array
        paths: tempPoints,
      };
      setPolygons([...polygons, newPolygon]);
    } else if (currentShape === 'polyline' && tempPoints.length > 1) {
      const newPolyline = {
        id: polylines.length, // Unique identifier based on the current length of the array
        path: tempPoints.map(p => ({ lat: p.lat, lng: p.lng, name: p.name })),
      };
      setPolylines([...polylines, newPolyline]);
    }
    setTempPoints([]); // Reset temporary points
  };

  useEffect(() => {
    if (inputVisible) {
      inputRef.current?.focus();
    }
  }, [inputVisible]);

  useEffect(() => {
    editInputRef.current?.focus();
  }, [editInputValue]);

  const handleClose = (removedTag) => {
    const newTags = tags.filter((tag) => tag !== removedTag);
    setTags(newTags);
  };

  const showInput = () => {
    setInputVisible(true);
  };

  const handleInputChange = (e) => {
    setInputValue(e.target.value);
  };

  const handleInputConfirm = () => {
    if (inputValue && !tags.includes(inputValue)) {
      setTags([...tags, inputValue]);
    }
    setInputVisible(false);
    setInputValue('');
  };

  const handleEditInputChange = (e) => {
    setEditInputValue(e.target.value);
  };
  const handleEditInputConfirm = () => {
    const newTags = [...tags];
    newTags[editInputIndex] = editInputValue;
    setTags(newTags);
    setEditInputIndex(-1);
    setEditInputValue('');
  };

  //  ----------------------------------------- TIME PICKER COMPONENT ----------------------------------------- //
  
  const handleTimeTypeChange = (selectedTimeType) => {
    setTimeType(selectedTimeType);
    console.log('Selected Time Type:', timeType);
  };

  const handleTimeExpressionChange = (selectedTimeExpression) => {
    setTimeExpression(selectedTimeExpression);
    console.log('Selected Time Expression:', timeExpression);
  };

  const handleHourFlagChange = (hourFlag) => {
    setStartHourFlag(hourFlag);
    console.log('Selected Hour Flag:', startHourFlag);
  }

  const handleDateFlagChange = (dateFlag) => {
    setStartDateFlag(dateFlag);
    console.log('Selected Date Flag:', startDateFlag);
  }

  const handleEndHourFlagChange = (endHourFlag) => {
    setEndHourFlag(endHourFlag);
    console.log('Selected End Hour Flag:', endHourFlag);
  }

  const handleEndDateFlagChange = (endDateFlag) => {
    setEndDateFlag(endDateFlag);
    console.log('Selected End Date Flag:', endDateFlag);
  }

  const handleTimeStampStartChange = (timeStampStart) => {
    setStartTimeStamp(timeStampStart);
    console.log('Selected TimeStamp Start String:', startTimeStamp);
  }
  const handleTimeStampEndChange = (timeStampEnd) => {
    setEndTimeStamp(timeStampEnd);
    console.log('Selected TimeStamp End String:', endTimeStamp);
  }
  const handleSelectedSeasonStart = (selectedSeasonStart) => {
    if (selectedSeasonStart !== '') {
    setSeason(seasonsDict[selectedSeasonStart]);
    console.log('Selected Season Start:', season);
    }
  
    
  }
  const handleSelectedSeasonEnd = (selectedSeasonEnd) => {
    if (selectedSeasonEnd !== '') {
    setEndSeason(seasonsDict[selectedSeasonEnd]);
    console.log('Selected Season End:', endSeason);
    }
    
  }


  const handleSelectedDecadeStart = (selectedDecadeStart) => {
    if (selectedDecadeStart !== null) {
    setDecade(`${selectedDecadeStart}s`);
    console.log('Selected Decade Start:', decade);
    }
    
  }
  const handleSelectedDecadeEnd = (selectedDecadeEnd) => {
    if (selectedDecadeEnd !== null) {
    setEndDecade(`${selectedDecadeEnd}s`);
    console.log('Selected Decade End:', endDecade);
    }
    
  }
  const handleSelectedDateTimeStart = (selectedDateTimeStart) => {

    setStartTimeStamp(selectedDateTimeStart);
    console.log('Selected DateTime Start Object:', startTimeStamp);
  }
  const handleSelectedDateTimeEnd = (selectedDateTimeEnd) => {
    setEndTimeStamp(selectedDateTimeEnd);
    console.log('Selected DateTime End Object:', endTimeStamp);
  }

  return (
    <Space
    direction="vertical"
    align="center"
    style={{
      width: '100%',
    }}
    >
    {contextHolder}
    <form className="edit-story-form" onSubmit={handleEditSubmit}>
    <div className="d-flex">
          <div style={{ flexGrow: 3, minWidth: 800, minHeight: 600 }}> {/* Allow map container to grow and take available space */}
            <center>
              Select Location Type (You can add multiple!):<br />
              <Segmented className="me-auto" size="large" options={[{ label: 'Marker', value: 'marker' }, { label: 'Circle', value: 'circle' }, { label: 'Polygon', value: 'polygon' }, { label: 'Polyline', value: 'polyline' }]} value={currentShape} onChange={setCurrentShape} />
              {currentShape === 'circle' && (
                <div className="align-items-center mb-2">
                  <Slider
                    min={0}
                    max={99}
                    onChange={(value) => setCircleRadius(value)}
                    value={circleRadius}
                    step={0.01}
                  />
                  <InputNumber
                    addonBefore="Set Radius"
                    min={0}
                    max={9999}
                    size="large"
                    formatter={(value) => `${value}km`}
                    parser={(value) => value.replace('km', '')}
                    style={{
                      width: "200px", margin: "10px"
                    }}
                    value={circleRadius}
                    onChange={(value) => setCircleRadius(value)}
                  />
                </div>
              )}
              {(currentShape === 'polygon' || currentShape === 'polyline') && (
                <div className="align-items-center mb-2">
                  Please select points and approve after finished
                  <button
                    type="button"
                    className="btn btn-primary"
                    style={{ width: "100px", backgroundColor: "#ff5500ca", color: "white", border: "none", margin: "10px" }}
                    onClick={finishShape}
                    disabled={(currentShape === 'polyline' && tempPoints.length < 2) || (currentShape === 'polygon' && tempPoints.length < 3)}
                  >
                    Approve
                  </button>
                </div>
              )}
            </center>

            <LoadScript googleMapsApiKey={process.env.REACT_APP_GOOGLE_MAPS_API_KEY}
              libraries={["places"]}>
              <div style={{
                display: "flex",
                justifyContent: "center",
                boxShadow: "0px 4px 10px rgba(0, 0, 0, 0.1)", // Gölge
                borderRadius: "8px", // Köşeleri yuvarlama
                padding: "10px", // İçeriği çerçeve içine yerleştirme, // Arka plan rengi
              }}>
                <GoogleMap
                  mapContainerStyle={{ width: "90%", height: "450px" }}
                  center={center}
                  zoom={10}
                  onClick={handleMapClick}
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
                      radius={circle.radius*1000}
                    />
                  ))}
                  {polygons.map((polygon, index) => (
                    <Polygon
                      key={index}
                      paths={polygon.paths}
                    />
                  ))}
                  {polylines.map((polyline, index) => (
                    <Polyline
                      key={index}
                      path={polyline.path}
                    />
                  ))}
                  {/* Render temporary polygon or polyline */}
                  {tempPoints.length > 0 && (
                    currentShape === 'polygon' ? (
                      <Polygon
                        paths={[...tempPoints, tempPoints[0]]} // Close the polygon for visualization
                        options={{
                          fillColor: "lightblue",
                          fillOpacity: 0.5,
                          strokeColor: "blue",
                          strokeOpacity: 1,
                          strokeWeight: 2,
                        }}
                      />
                    ) : currentShape === 'polyline' ? (
                      <Polyline
                        path={tempPoints}
                        options={{
                          fillColor: "lightblue",
                          fillOpacity: 0.5,
                          strokeColor: "blue",
                          strokeOpacity: 1,
                          strokeWeight: 2,
                        }}
                      />
                    ) : null
                  )}
                </GoogleMap>
              </div>
              <div className="d-flex justify-content-center mt-3">
                {/* Boşluk bırakmak için */}
                <span style={{ marginRight: '5px' }}></span>
              </div>
              <StandaloneSearchBox onLoad={onSearchBoxLoad} onPlacesChanged={onPlacesChanged}>
                <input type="text" placeholder="Search" style={{ width: "100%", height: "40px" }} className="form-control" />
              </StandaloneSearchBox>
            </LoadScript>
          </div>
        </div>
      <br />
      <br />
      {/* {locations.length > 0 && ( */}
        <div className="edit-story-locations">
          <label className="edit-story-label">Locations:</label>
          <ul className="edit-story-location-list">
          {/* Display marker locations */}
          {markers.map((marker, index) => (
            <li key={`marker-${index}`} className="add-story-location-item">
              Marker: {index + 1} - {marker.name}
              <button
                type="button"
                class="btn btn-danger m-2"
                onClick={() => { handleRemoveShape(index, 'marker') }}
              > Remove
              </button>
            </li>
          ))}
          {/* Display circles */}
          {circles.map((circle, index) => (
            <li key={`circle-${index}`} className="add-story-location-item">
              Circle {index + 1} - {circle.center.name} (Radius: {circle.radius} km)
              <button
                type="button"
                class="btn btn-danger m-1"
                onClick={() => handleRemoveShape(index, 'circle')}
              > Remove
              </button>
            </li>
          ))}
          {/* Display polygons */}
          {polygons.map((polygon, index) => (
            <li key={`polygon-${index}`} className="add-story-location-item">
              Polygon {index + 1} - {polygon.paths[0].name} - Nodes:{polygon.paths.length}
              <button
                type="button"
                class="btn btn-danger m-1"
                onClick={() => handleRemoveShape(index, 'polygon')}
              > Remove
              </button>
            </li>
          ))}

          {/* Display polylines */}
          {polylines.map((polyline, index) => (
            <li key={`polyline-${index}`} className="add-story-location-item">
              Polyline {index + 1} - {polyline.path[0].name} - Nodes:{polyline.path.length}
              <button
                type="button"
                class="btn btn-danger m-1"
                onClick={() => handleRemoveShape(index, 'polyline')}
              >
                Remove
              </button>
            </li>
          ))}
        </ul>
      </div>
      <br />
      <label className="edit-story-label">
        Title:
        <input
          type="text"
          className="edit-story-input"
          value={title}
          onChange={(e) => setTitle(e.target.value)}
        />
      </label>
      <br />
      <div className="edit-story-tags">
        <label className="label">Tags:</label>
        <div>
          {tags.map((tag, index) => {
            if (editInputIndex === index) {
              return (
                <Input
                  ref={editInputRef}
                  key={tag}
                  size="middle"
                  style={{ width: 78 }}
                  value={editInputValue}
                  onChange={handleEditInputChange}
                  onBlur={handleEditInputConfirm}
                  onPressEnter={handleEditInputConfirm}
                />
              );
            }
            const isLongTag = tag.length > 20;
            const tagElem = (
              <Tag
                key={tag}
                closable
                onClose={() => handleClose(tag)}
              >
                <span
                  onDoubleClick={(e) => {
                    setEditInputIndex(index);
                    setEditInputValue(tag);
                    e.preventDefault();
                  }}
                >
                  {isLongTag ? `${tag.slice(0, 20)}...` : tag}
                </span>
              </Tag>
            );
            return isLongTag ? (
              <Tooltip title={tag} key={tag}>
                {tagElem}
              </Tooltip>
            ) : (
              tagElem
            );
          })}
          {inputVisible ? (
            <Input
              ref={inputRef}
              type="text"
              size="middle"
              style={{ width: 78 }}
              value={inputValue}
              onChange={handleInputChange}
              onBlur={handleInputConfirm}
              onPressEnter={handleInputConfirm}
            />
          ) : (
            <Tag style={{ background: '#fff', borderStyle: 'dashed' }} onClick={showInput}>
              + New Tag
            </Tag>
          )}
        </div>
      </div>
      <br />
      <label className="edit-story-label">
        Text:
        <ReactQuill
          value={text}
          onChange={handleEditorChange}
          modules={modules}
          formats={formats}
          className="edit-story-editor"
        />
      </label>

      <br />
        <div className="date-information">
          <h5>Previously selected time:</h5>
          {prevStory.verbalExpression != null ? (
                <   span className="date">{prevStory.verbalExpression}</span>
                ) : (
                <>
                  {/* {prevStory.timeType && <span className="date">Time Type: {prevStory.timeType}</span>}
                  {prevStory.timeExpression && <span className="date">Time Expression: {prevStory.timeExpression}</span>} */}
                  {prevStory.startTimeStamp && <span className="date">Start: {prevStory.startTimeStamp}</span>}
                  {prevStory.endTimeStamp && <span className="date">End: {prevStory.endTimeStamp}</span>}
                  {prevStory.season && <span className="date">Season: {prevStory.season}</span>}
                  {prevStory.endSeason && <span className="date">End Season: {prevStory.endSeason}</span>}
                  {prevStory.decade && <span className="date">Decade: {prevStory.decade}</span>}
                  {prevStory.endDecade && <span className="date">End Decade: {prevStory.endDecade}</span>}
                  {/* You can add more conditional renders for other date fields as needed */}
                </>
                )}<br/><br/>
          <h6>If you want to change the date, please select one from below.</h6>
        </div>
      <DateTimerPicker 
      // Loading previously selected timeType and timeExpression
      // selectedTimeType = {timeType}
      // selectedTimeExpression = {timeExpression}
      // Normal DateTimePicker component
      onTimeTypeSelect = {handleTimeTypeChange}
      onTimeExpressionSelect = {handleTimeExpressionChange}
      onHourFlagSelect = {handleHourFlagChange}
      onDateFlagSelect = {handleDateFlagChange}
      onTimeStampStartSelect = {handleTimeStampStartChange}
      onTimeStampEndSelect = {handleTimeStampEndChange}
      onSelectedSeasonStart = {handleSelectedSeasonStart}
      onSelectedSeasonEnd = {handleSelectedSeasonEnd}
      onSelectedDecadeStart = {handleSelectedDecadeStart}
      onSelectedDecadeEnd = {handleSelectedDecadeEnd}
      onSelectedDateTimeStart = {handleSelectedDateTimeStart}
      onSelectedDateTimeEnd = {handleSelectedDateTimeEnd}
      onEndHourFlagSelect = {handleEndHourFlagChange}
      onEndDateFlagSelect = {handleEndDateFlagChange}
      />
      <div className="d-flex justify-content-center mt-3">
      <button style={{backgroundColor: "#ff5500ca", color: "white", border: "none"}} type="submit" className="btn btn-primary">
        Update Story
      </button>
      </div>
    </form>
    </Space>
  );
};

export default EditStoryForm;
