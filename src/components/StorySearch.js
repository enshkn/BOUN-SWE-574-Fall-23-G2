import React, { useState,
                useCallback
              } from "react";
import axios from "axios";
import {  GoogleMap,
          LoadScript,
          Marker
        } from "@react-google-maps/api";
import {  Space,
          message,
          Col,
          Row,
          Input,
          Button
        } from 'antd';
import "./css/StorySearch.css";
import 'bootstrap/dist/css/bootstrap.min.css';
import StoryList from "./StoryList";


const StorySearch = () => {
  const [searchQuery, setSearchQuery] = useState(null);
  const [searchResults, setSearchResults] = useState([]);
  const [radius, setRadius] = useState(null);
  const [selectedLocation, setSelectedLocation] = useState(null);
  const [searchSeason, setSearchSeason] = useState(null);
  const [searchDecade, setSearchDecade] = useState(null);
  const [messageApi, contextHolder] = message.useMessage();
  const [searchDate, setSearchDate] = useState({
    type: null,
    value: {
      startDate: 2000, // Set the initial value to 2000
      endDate: 2023, // You can set the initial value for endDate if needed
    },
  });


  const handleSearch = useCallback(async () => {
    if (searchQuery && searchQuery.length < 4) {
      return;
    }

    try {
      let startDate = null;
      let endDate = null;

      switch (searchDate.type) {
        case "absolute-date":
          startDate = searchDate.value;
          endDate = searchDate.value;
          break;
        case "interval-date":
          startDate = searchDate.value.startDate;
          endDate = searchDate.value.endDate;
          break;
        case "absolute-year":
          startDate = `${searchDate.value}-01-01`;
          endDate = `${searchDate.value}-12-31`;
          break;
        case "interval-year":
          startDate = `${searchDate.value.startDate}-01-01`;
          endDate = `${searchDate.value.endDate}-12-31`;
          break;
        default:
          break;
      }

      const response = await axios.get(
        `${process.env.REACT_APP_BACKEND_URL}/api/story/search`,
        {
          params: {
            query: searchQuery,
            radius: radius,
            latitude: selectedLocation ? selectedLocation.lat : null,
            longitude: selectedLocation ? selectedLocation.lng : null,
            startTimeStamp: startDate,
            endTimeStamp: endDate,
            season: searchSeason,
            decade: searchDecade,
          },
          withCredentials: true,
        }
      );

      setSearchResults(response.data);
    } catch (error) {
      console.log(error);
      messageApi.open({ type: "error", content: "Error occured while searching stories!" });
    }
  }, [
    messageApi,
    searchQuery,
    radius,
    selectedLocation,
    searchDate,
    searchSeason,
    searchDecade,
  ]);

  const handleMapClick = (event) => {
    const clickedLat = event.latLng.lat();
    const clickedLng = event.latLng.lng();
    setSelectedLocation({ lat: clickedLat, lng: clickedLng });
  };

  const handleMarkerReClick = () => {
    setSelectedLocation(null);
  };

  const handleDateTypeChange = (event) => {
    const type = event.target.value;
    setSearchDate({ type, value: null });
  };

  const handleSeasonChange = (event) => {
    const season = event.target.value;
    setSearchSeason(season);
  };

  const handleDecadeChange = (event) => {
    const decade = event.target.value;
    setSearchDecade(decade);
  };

  return (
    <Space
      direction="vertical"
      style={{
        width: '100%',
      }}
    >
       
      {contextHolder}
      
      <div className="story-search">

        {/* Story Exploration Page - Title Part*/}
        <Row justify="center">
          <Col span={12} className="text-center">
            <h2>Explore Stories</h2>
          </Col>
        </Row>

        {/* Explore Stories Page Inputs are asked in this row*/}
        <Row justify="center" align="middle" style={{ minHeight: '70vh' }}>

          {/* Empty column for aligning*/}
          <Col span={4}></Col>

          {/* Form Inputs are asked in This Column*/}
          <Col span={8} className="text-center">
            <div className="search-form">
              <form className="row g-3">

                <div className="col-md-6">
                  <Input
                    placeholder="Type your keywords"
                    id="searchQuery"
                    type="text"
                    className="form-control"
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                    onKeyDown={(e) => {
                      if (e.key === 'Enter') {
                        e.preventDefault();
                        handleSearch();
                      }
                    }}
                  />
                </div>
              </form>

              {/* Radius Element */}
              <div className="col-md-6">
                <Input
                  placeholder="Radius (in km)"
                  id="radius"
                  type="number"
                  className="form-control"
                  value={radius}
                  onChange={(e) => setRadius(parseInt(e.target.value))}
                />
              </div>

              {/* Time Type Picker Element */}
              <div className="col-md-6">
                <select
                  id="dateType"
                  className="form-select"
                  value={searchDate.type}
                  onChange={handleDateTypeChange}
                >
                  <option value="">Select a Date Type</option>
                  <option value="absolute-date">Absolute Date</option>
                  <option value="interval-date">Interval Date</option>
                  <option value="absolute-year">Absolute Year</option>
                  <option value="interval-year">Interval Year</option>
                </select>
              </div>

              {/* Absolute Day Picker Element */}
              {searchDate.type === "absolute-date" && (
                <label>
                  Date:
                  <Input
                    type="date"
                    value={searchDate.value || ""}
                    onChange={(e) =>
                      setSearchDate({ ...searchDate, value: e.target.value })
                    }
                  />
                </label>
              )}

              {/* Interval Date Picker Element */}
              {searchDate.type === "interval-date" && (
                <>
                  <label>
                    Start Date:
                    <Input
                      type="date"
                      value={searchDate.value?.startDate || ""}
                      onChange={(e) =>
                        setSearchDate({
                          ...searchDate,
                          value: { ...searchDate.value, startDate: e.target.value },
                        })
                      }
                    />
                  </label>
                  <label>
                    End Date:
                    <Input
                      type="date"
                      value={searchDate.value?.endDate || ""}
                      onChange={(e) =>
                        setSearchDate({
                          ...searchDate,
                          value: { ...searchDate.value, endDate: e.target.value },
                        })
                      }
                    />
                  </label>
                </>
              )}

              {/* Absolute Year Picker Element */}
              {searchDate.type === "absolute-year" && (

                  <Input
                    type="number"
                    value={searchDate.value || ""}
                    onChange={(e) =>
                      setSearchDate({ ...searchDate, value: e.target.value })
                    }
                    min={1930}
                    max={2023}
                    placeholder="Enter your year here"
                  />

              )}

              {/* Interval Year Picker Element */}
              {searchDate.type === "interval-year" && (
                <>

                    <Input
                      type="number"
                      value={searchDate.value?.startDate || ""}
                      onChange={(e) =>
                        setSearchDate({
                          ...searchDate,
                          value: { ...searchDate.value, startDate: e.target.value },
                        })
                      }
                      min={1930}
                      max={2023}
                      placeholder="Enter your start year here"
                    />

                    <Input
                      type="number"
                      value={searchDate.value?.endDate || ""}
                      onChange={(e) =>
                        setSearchDate({
                          ...searchDate,
                          value: { ...searchDate.value, endDate: e.target.value },
                        })
                      }
                      min={1930}
                      max={2023}
                      placeholder="Enter your end year here"
                    />

                </>
              )}

              {/* Season Picker Element */}
              <div className="col-md-6">
                <select
                  id="season"
                  className="form-select"
                  value={searchSeason}
                  onChange={handleSeasonChange}
                >
                  <option value="">Select a Season</option>
                  <option value="spring">Spring</option>
                  <option value="summer">Summer</option>
                  <option value="fall">Fall</option>
                  <option value="winter">Winter</option>
                </select>
              </div>

              {/* Decade Picker Element */}
              <div className="col-md-6">
                <select
                  id="decade"
                  className="form-select"
                  value={searchDecade}
                  onChange={handleDecadeChange}
                >
                  <option value="">Select a Decade</option>
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
              </div>

              {/* Exploration Button  Element */}
              <div className="col-md-6 mt-3">
                <Button
                  type="button"
                  className="btn btn-primary"
                  onClick={handleSearch}
                >
                  Explore
                </Button>
              </div>

            </div>
          </Col>

          {/* Google Map is in this column */}
          <Col span={12}>
            <LoadScript
              googleMapsApiKey={process.env.REACT_APP_GOOGLE_MAPS_API_KEY}
            >
              <GoogleMap
                mapContainerStyle={{ width: "80%", height: "400px" , margin: "0 auto"}}
                center={{ lat: 41.085064, lng: 29.044687 }}
                zoom={10}
                onClick={handleMapClick}
              >
                {selectedLocation && (
                  <Marker
                  position={{
                    lat: selectedLocation.lat,
                    lng: selectedLocation.lng,
                  }}
                  onClick={handleMarkerReClick}
                />
                )}
              </GoogleMap>
            </LoadScript>
          </Col>

        </Row>

        {/* Explore Results are listed in this row */}
        <Row>
          <div className="search-results">
            <div style={{ marginBottom: "20px" }} />
            {searchResults.length > 0 && (
              <div className="all-stories">
                <h1>Search Results</h1>
                {searchResults.map((story) => (
                  <StoryList story={story} key={story.id} />
                ))}
              </div>
            )}
          </div>
        </Row>

      </div>
    </Space>
  );
};

export default StorySearch;
