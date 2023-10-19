# Choose a base image
FROM node:16-alpine

# Set the working directory
WORKDIR /app

# Copy the entire frontend
COPY ./dutluk/dutluk_frontend /app

# Install npm
RUN npm install

# Build the app
RUN npm run build

RUN npm install -g serve

# Expose the port that the application will be running on
EXPOSE 80

