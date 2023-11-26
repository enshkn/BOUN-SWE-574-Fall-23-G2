import React, { useState } from "react";
import axios from "axios";
import { useNavigate } from "react-router-dom";
import { Space, message } from 'antd';
import "./css/Login.css";

function LoginComponent() {
  const [identifier, setIdentifier] = useState("");
  const [password, setPassword] = useState("");
  const Navigate = useNavigate();

  const [messageApi, contextHolder] = message.useMessage();

  const handleLogin = (event) => {
    event.preventDefault();

    axios
      .post(
        `${process.env.REACT_APP_BACKEND_URL}/api/user/login`,
        { identifier, password },
        { withCredentials: true }
      )
      .then((response) => {
        const cookieValue = response.headers["bearer"];
        localStorage.setItem("authToken", cookieValue);
        messageApi.open({ type: "success", content: "You logged in successfuly!"});
        Navigate("/story/all-stories")
      })
      .catch((error) => {
        if (error.response && error.response.status === 401) {
          messageApi.open({ type: "error", content: "Invalid username or password."});
        } else {
          messageApi.open({ type: "error", content: "An error occurred while logging in."});
        }
      });
  };

  return (
    <Space
    direction="vertical"
    style={{
      width: '100%',
    }}
    >
    {contextHolder}
    <form className="login-form" onSubmit={handleLogin}>
      <h2 className="login-heading">Log In</h2>
      <div className="login-input-group">
        <label htmlFor="identifier" className="login-label">
          Username or Email:
        </label>
        <input
          type="text"
          id="identifier"
          className="login-input"
          value={identifier}
          onChange={(event) => setIdentifier(event.target.value)}
        />
      </div>
      <div className="login-input-group">
        <label htmlFor="password" className="login-label">
          Password:
        </label>
        <input
          type="password"
          id="password"
          className="login-input"
          value={password}
          onChange={(event) => setPassword(event.target.value)}
        />
      </div>
      <button type="submit" className="login-button">
        Log in
      </button>
    </form>
    </Space>
  );
}

export default LoginComponent;
