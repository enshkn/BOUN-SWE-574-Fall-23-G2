import React, { useState, useEffect, useRef } from "react";
import axios from "axios";
import { Circle, GoogleMap, LoadScript, Marker, Polygon, Polyline, StandaloneSearchBox } from "@react-google-maps/api";
import ReactQuill from "react-quill";
import "react-quill/dist/quill.snow.css";
import "quill-emoji/dist/quill-emoji.css";
import DatePicker from "react-datetime-picker";
import "react-datetime-picker/dist/DateTimePicker.css";
import { format, getYear, set } from "date-fns";
import { useNavigate } from "react-router-dom";
import { Space, message, Input, Tag, Tooltip} from 'antd';
import "./css/AddStory.css";
import 'bootstrap/dist/css/bootstrap.min.css';
import 'react-quill/dist/quill.snow.css'; // Örnek olarak Quill editörünün varsayılan stillerini ekliyoruz
import DateTimerPicker from "./DateTimerPicker";


const AddStoryForm = () => {
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
  const [currentShape, setCurrentShape] = useState(null);
  const [tempPoints, setTempPoints] = useState([]);
  const [circleRadius, setCircleRadius] = useState(5000);

  const [markers, setMarkers] = useState([]);
  const [circles, setCircles] = useState([]);
  const [polygons, setPolygons] = useState([]);
  const [polylines, setPolylines] = useState([]);
  const [timeResolution, setTimeResolution] = useState("");
 
  const [messageApi, contextHolder] = message.useMessage();

  const [tags, setTags] = useState([]);
  const [inputVisible, setInputVisible] = useState(false);
  const [inputValue, setInputValue] = useState('');
  const [editInputIndex, setEditInputIndex] = useState(-1);
  const [editInputValue, setEditInputValue] = useState('');
  const inputRef = useRef(null);
  const editInputRef = useRef(null);

  const onSearchBoxLoad = (ref) => {
    setSearchBox(ref);
  };

  // Location related event handlers
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


  const handleEditorChange = (value) => {
    setText(value);
  };

  const Navigate = useNavigate();

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
    

   

    // Create story object to be sent to backend
    const story = {
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
      formattedStartTimeStamp,
      formattedEndTimeStamp,
      season,
      endSeason,
      decade,
      endDecade,
      timeType,
      timeExpression,
      startHourFlag,
      startDateFlag,
      endHourFlag: endHourFlag,
      endDateFlag: endDateFlag

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
      const newStoryId = response.data.id;
      Navigate(`/story/${newStoryId}`);
    } catch (error) {
      console.log(error);
      messageApi.open({ type: "error", content: "Failed to add story. Please try again."});
    }
  };

  const mapContainerStyle = {
    width: "100%",
    height: "100%",
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


  // TimeResolution Handlers
  {/* 
  const handleStartDateChange = (date) => {
    setStartTimeStamp(date);
    const startYear = getYear(date);
    const startDecade = startYear - (startYear % 10);
    setDecade(`${startDecade}s`);
  };
  */}


  {/* 
  const handleDecadeChange = (e) => {
    setDecade(e.target.value);
  };
  

  const handleEndDateChange = (date) => {
    setEndTimeStamp(date);
  };

  */}
  

  {/*
  useEffect(() => {
    if (startTimeStamp) {
      const startYear = getYear(startTimeStamp);
      const startDecade = startYear - (startYear % 10);
      setDecade(`${startDecade}s`);
    } else {
      setDecade("");
    }
  }, [startTimeStamp]);
  
  */}

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

  // state handlers for DateTimerPicker component
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
    //setStartTimeStamp(timeStampStart);
    console.log('Selected TimeStamp Start String:', timeStampStart);
  }
  const handleTimeStampEndChange = (timeStampEnd) => {
    // setEndTimeStamp(timeStampEnd);
    console.log('Selected TimeStamp End String:', timeStampEnd);
  }
  const handleSelectedSeasonStart = (selectedSeasonStart) => {
    setSeason(selectedSeasonStart);
    console.log('Selected Season Start:', season);
  }
  const handleSelectedSeasonEnd = (selectedSeasonEnd) => {
    setEndSeason(selectedSeasonEnd);
    console.log('Selected Season End:', endSeason);
  }
  const handleSelectedDecadeStart = (selectedDecadeStart) => {
    setDecade(`${selectedDecadeStart}s`);
    console.log('Selected Decade Start:', decade);
  }
  const handleSelectedDecadeEnd = (selectedDecadeEnd) => {
    setEndDecade(`${selectedDecadeEnd}s`);
    console.log('Selected Decade End:', endDecade);
  }
  const handleSelectedDateTimeStart = (selectedDateTimeStart) => {
    setStartTimeStamp(selectedDateTimeStart);
    console.log(typeof startTimeStamp)
    console.log('Selected DateTime Start Object:', startTimeStamp);
  }
  const handleSelectedDateTimeEnd = (selectedDateTimeEnd) => {
    setEndTimeStamp(selectedDateTimeEnd);
    console.log(typeof endTimeStamp)
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
    <form className="add-story-form" onSubmit={handleSubmit}>
      <div className="d-flex">
        <div style={{ flexGrow: 3, minWidth: 800, minHeight: 600 }}> {/* Allow map container to grow and take available space */}
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
                  radius={circle.radius}
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
              <input type="text" placeholder="Search" style={{ width: "100%", height: "40px" }} className="form-control"/>
            </StandaloneSearchBox>
          </LoadScript>
        </div>
        <div className="map-controls d-flex flex-column align-items-left-b"
          style={{ width: 'auto', height: 'auto', marginLeft: '5px' }}> {/* Added margin here */}
          <button type="button" className="btn btn-primary mb-2" style={{ width: "50px" }} onClick={() => setCurrentShape('marker')}>
            <i class="bi bi-geo-alt-fill"></i> {/* Marker Icon */}
          </button>
          <div class="d-flex align-items-center mb-2">
            <button type="button" className="btn btn-primary " style={{ width: "50px" }} onClick={() => setCurrentShape('circle')}>
              <i class="bi bi-circle"></i> {/* Circle Icon */}
            </button>
            <input type="number" className="form-control"
              style={{ width: "150px", marginLeft: "5px" }}
              onChange={(e) => setCircleRadius(Number(e.target.value))}
              placeholder="Radius (m)"
            >
            </input>
          </div>

          <button type="button" className="btn btn-primary mb-2" style={{ width: "50px" }} onClick={() => setCurrentShape('polygon')}>
            <i className="bi bi-hexagon"></i> {/* Polygon Icon */}
          </button>
          <button type="button" className="btn btn-primary mb-2" style={{ width: "50px" }} onClick={() => setCurrentShape('polyline')}>
            <i className="bi bi-arrow-right"></i> {/* Polyline Icon */}
          </button>
          <button type="button" className="btn btn-primary mb-2" style={{ width: "50px" }} onClick={finishShape} disabled={tempPoints.length < 2}>
            <i className="bi bi-check-lg"></i> {/* Finish Icon */}
          </button>
        </div>
      </div>

      <br />
      <br />
      <div className="add-story-locations">
        <label className="add-story-label">Locations:</label>
        <ul className="add-story-location-list">
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
              Circle {index + 1} - {circle.name} (Radius:{circle.radius}m)
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
      <label className="add-story-label">
        Title:
        <input
          type="text"
          className="form-control"
          value={title}
          onChange={(e) => setTitle(e.target.value)}
          required={true}
        />
      </label>
      <br />
      <div className="add-story-tags">
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
      
        
      <DateTimerPicker 
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
      {/* <label className="add-story-label">


Time Resolution:
<select
  value={timeResolution}
  onChange={(e) => setTimeResolution(e.target.value)}
  className="add-story-select add-story-time-resolution-select"
>
  <option value="">Select Time Resolution</option>
  <option value="exactDate">Exact Date</option>
  <option value="season">Season</option>
  <option value="decade">Decade</option>
  <option value="seasonAndDecade">Season and Decade</option>
</select>
</label>
<br />

{timeResolution === "exactDate" && (
<>
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
    End Date and Time (optional):
    <DatePicker
      value={endTimeStamp}
      onChange={handleEndDateChange}
      className="add-story-datepicker"
    />
  </label>
</>
 )}
{timeResolution === "season" && (
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
)}
{timeResolution === "decade" && (
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
)}
{timeResolution === "seasonAndDecade" && (
  <>
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
        onChange={(e) => setDecade(e.target.value)}
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
  </>
)} */}


<div className="d-flex justify-content-center mt-3">
      <button type="submit" className="btn btn-primary">
        Add Story
      </button>
    </div>
    </form>
    </Space>
  );
};



export default AddStoryForm;

