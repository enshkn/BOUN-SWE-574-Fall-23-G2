# Choose a base image
FROM node:16-alpine

# Set the working directory
WORKDIR /app

# Copy the entire frontend
COPY ./dutluk/dutluk_frontend /app

# Install npm
RUN npm install

# Declare the build argument
ARG REACT_APP_BACKEND_URL
ARG REACT_APP_FRONTEND_URL
ARG REACT_APP_GOOGLE_MAPS_API_KEY

# SET Env variables
ENV REACT_APP_BACKEND_URL=$REACT_APP_BACKEND_URL
ENV REACT_APP_FRONTEND_URL=$REACT_APP_FRONTEND_URL
ENV REACT_APP_GOOGLE_MAPS_API_KEY=$REACT_APP_GOOGLE_MAPS_API_KEY

# Build the app
RUN npm run build

RUN npm install -g serve

# Expose the port that the application will be running on
EXPOSE 80