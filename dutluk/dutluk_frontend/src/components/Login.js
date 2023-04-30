import React, { useState } from "react";
import axios from "axios";

function LoginComponent() {
  const [identifier, setIdentifier] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");

  const handleSubmit = (event) => {
    event.preventDefault();
    axios
      .post("http://localhost:8080/api/user/login", { identifier, password })
      .then((response) => console.log(response.data))
      .catch((error) => setError(error.response.data.message));
  };

  return (
    <div>
      <form onSubmit={handleSubmit}>
        <label>
          Identifier:
          <input
            type="text"
            value={identifier}
            onChange={(event) => setIdentifier(event.target.value)}
          />
        </label>
        <label>
          Password:
          <input
            type="password"
            value={password}
            onChange={(event) => setPassword(event.target.value)}
          />
        </label>
        <button type="submit">Login</button>
      </form>
      {error && <div>{error}</div>}
    </div>
  );
}

export default LoginComponent;
