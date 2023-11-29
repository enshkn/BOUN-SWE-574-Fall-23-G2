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
import Container from 'react-bootstrap/Container';
import Nav from 'react-bootstrap/Nav';
import Navbar from 'react-bootstrap/Navbar';
import NavDropdown from 'react-bootstrap/NavDropdown';


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
      <Navbar bg="primary" data-bs-theme="dark" expand="lg" sticky="top" className="nav">
        <Container>
          <Navbar.Brand href="/"><img src={DutlukLogo} alt="Logo" className="logo" /></Navbar.Brand>
          {loggedIn ? (
          <>
              <Nav.Link href="/story/followings" className="nav-link">Story Feed</Nav.Link>
              <Nav.Link href="/story/recommended-stories" className="nav-link">Recommended Stories</Nav.Link>
              <Nav.Link href="/story/all-stories" className="nav-link">All Stories</Nav.Link>
              <Nav.Link href="/story/search" className="nav-link">Search</Nav.Link>
              <Nav.Link href="/story/timeline-search" className="nav-link">Timeline Search</Nav.Link>
              <NavDropdown title="My account" id="basic-nav-dropdown" className="nav-link ">
                <NavDropdown.Item href="/user/my-profile" className="justify-content-end">My Profile</NavDropdown.Item>
                <NavDropdown.Item href="/story/my-stories" className="justify-content-end">My Stories</NavDropdown.Item>
                <NavDropdown.Item href="/story/add-story" className="justify-content-end">Add Story</NavDropdown.Item>
                <NavDropdown.Divider />
                <NavDropdown.Item href="/" onClick={handleLogout} className="justify-content-end">Logout</NavDropdown.Item>
              </NavDropdown>
            </>
          ) : (
            <>
              <Nav.Link href="/login" className="nav-link">Login</Nav.Link>
              <Nav.Link href="/register" className="nav-link">Register</Nav.Link>
            </>
          )}
        </Container>
      </Navbar>
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