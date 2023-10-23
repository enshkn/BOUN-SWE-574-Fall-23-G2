FROM node:16-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

ENV REACT_APP_BACKEND_URL=$REACT_APP_BACKEND_URL

RUN npm run build

RUN npm install -g serve

EXPOSE 3000

CMD ["serve", "-s", "build"]
