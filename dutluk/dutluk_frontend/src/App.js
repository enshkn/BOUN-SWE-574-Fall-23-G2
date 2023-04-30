import React from "react";
import { BrowserRouter as Router, Routes, Route, Link } from "react-router-dom";
import "./App.css";
import User from "./components/User";
import Login from "./components/Login";
import Register from "./components/Register";

function App() {
  return (
    <Router>
      <nav>
        <Link to="/">Home</Link>
        <Link to="/login">Login</Link>
        <Link to="/register">Register</Link>
        <Link to="/user/">Profile</Link>
      </nav>
      <Routes>
        <Route
          path="/"
          element={
            <div className="dutluk-container">
              <img
                src="https://tasova.gen.tr/wp-content/uploads/dutluk_koyu_001.jpg"
                alt="Dutluk"
                style={{
                  width: "1000px",
                  height: "auto",
                }}
              />
            </div>
          }
        />
        <Route path="/user/:id" element={<User />} />
        <Route path="/login" element={<Login />} />
        <Route path="/register" element={<Register />} />
      </Routes>
    </Router>
  );
}

export default App;
