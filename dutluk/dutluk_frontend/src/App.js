import React, { useState, useEffect } from "react";
import { BrowserRouter as Router, Routes, Route, Link } from "react-router-dom";
import "./App.css";
import DutlukImage from "./dutlukfinal_1.jpg";
import DutlukLogo from "./dutluk_logo.png";
import User from "./components/User";
import Profile from "./components/Profile";
import Login from "./components/Login";
import Register from "./components/Register";
import AddStoryForm from "./components/AddStory";
import MyStories from "./components/MyStories";
import StoryDetails from "./components/StoryDetails";
import AllStories from "./components/AllStories";
import FollowedUserStories from "./components/FollowedUserStories";
import StorySearch from "./components/StorySearch";
import axios from "axios";


function App() {
  const [loggedIn, setLoggedIn] = useState(false);

  useEffect(() => {
    axios
      .get("http://localhost:8080/api/user/profile", { withCredentials: true })
      .then((response) => {
        setLoggedIn(true);
      })
      .catch((error) => {
        setLoggedIn(false);
      });
  }, []);

  const handleLogout = () => {
    axios
      .get("http://localhost:8080/api/user/logout", null, {
        withCredentials: true,
      })
      .then((response) => {
        document.cookie =
          "Bearer=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/api;";
        setLoggedIn(false);
      })
      .catch((error) => {
        console.log(error);
      });
  };

  return (
    <Router>
      <nav className="nav">
        <div className="logo-container">
          <img src={DutlukLogo} alt="Logo" className="logo" />
        </div>
        <Link to="/" className="nav-link">
          Home
        </Link>
        {loggedIn ? (
          <>
            <Link to="/" onClick={handleLogout} className="nav-link">
              Logout
            </Link>
            <Link to="/user/my-profile" className="nav-link">
              My Profile
            </Link>
            <Link to="/story/add-story" className="nav-link">
              Add Story
            </Link>
            <Link to="/story/followings" className="nav-link">
              Story Feed
            </Link>
            <Link to="/story/my-stories" className="nav-link">
              My Stories
            </Link>
            <Link to="/story/all-stories" className="nav-link">
              All Stories
            </Link>
            <Link to="/story/search" className="nav-link">
              Search
            </Link>
          </>
        ) : (
          <>
            <Link to="/login" className="nav-link">
              Login
            </Link>
            <Link to="/register" className="nav-link">
              Register
            </Link>
          </>
        )}
      </nav>
      <Routes>
        <Route
          path="/"
          element={
            <div className="dutluk-container">
              <img src={DutlukImage} alt="Dutluk" className="dutluk-image" />
            </div>
          }
        />
        <Route path="/user/my-profile" element={<User />} />
        <Route path="/login" element={<Login />} />
        <Route path="/register" element={<Register />} />
        <Route path="/story/add-story" element={<AddStoryForm />} />
        <Route path="/story/my-stories" element={<MyStories />} />
        <Route path="/story/followings" element={<FollowedUserStories />} />
        <Route path="/story/all-stories" element={<AllStories />} />
        <Route path="/story/:id" element={<StoryDetails />} />
        <Route path="/user/:id" element={<Profile />} />
        <Route path="/story/search" element={<StorySearch />} />
      </Routes>
    </Router>
  );
}

export default App;
