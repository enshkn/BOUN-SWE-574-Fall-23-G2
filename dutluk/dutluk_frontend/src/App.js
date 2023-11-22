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
import EditStoryForm from "./components/EditStory";
import MyStories from "./components/MyStories";
import StoryDetails from "./components/StoryDetails";
import Recommended from "./components/Recommended";
import AllStories from "./components/AllStories";
import FollowedUserStories from "./components/FollowedUserStories";
import StorySearch from "./components/StorySearch";
import TimelineSearch from "./components/TimelineSearch";
import LabelSearch from "./components/LabelSearch"; // Add import for LabelSearch
import axios from "axios";

function App() {
  const [loggedIn, setLoggedIn] = useState(false);

  useEffect(() => {
    axios
      .get(`${process.env.REACT_APP_BACKEND_URL}/api/user/profile`, {
        withCredentials: true,
      })
      .then((response) => {
        setLoggedIn(true);
      })
      .catch((error) => {
        setLoggedIn(false);
      });
  }, []);

  const handleLogout = () => {
    axios
      .get(`${process.env.REACT_APP_BACKEND_URL}/api/user/logout`, null, {
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
          <Link to="/">
            <img src={DutlukLogo} alt="Logo" className="logo" />
          </Link>
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
            <Link to="/story/recommended-stories" className="nav-link">
              Recommended Stories
            </Link>
            <Link to="/story/all-stories" className="nav-link">
              All Stories
            </Link>
            <Link to="/story/search" className="nav-link">
              Search
            </Link>
            <Link to="/story/timeline-search" className="nav-link">
              Timeline Search
            </Link>
            <Link to="/story/search/label/:label" className="nav-link">
              Label Search
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
        <Route
          path="/login"
          element={<Login onLogin={() => setLoggedIn(true)} />}
        />
        <Route path="/register" element={<Register />} />
        <Route path="/story/add-story" element={<AddStoryForm />} />
        <Route path="/story/edit/:id" element={<EditStoryForm />} />
        <Route path="/story/my-stories" element={<MyStories />} />
        <Route path="/story/followings" element={<FollowedUserStories />} />
        <Route path="/story/all-stories" element={<AllStories />} />
        <Route path="/story/:id" element={<StoryDetails />} />
        <Route path="/user/:id" element={<Profile />} />
        <Route path="/story/search" element={<StorySearch />} />
        <Route path="/story/timeline-search" element={<TimelineSearch />} />
        <Route path="/story/search/label/:label" element={<LabelSearch />} />
        <Route path="/story/recommended" element={<Recommended />} />
      </Routes>
    </Router>
  );
}

export default App;