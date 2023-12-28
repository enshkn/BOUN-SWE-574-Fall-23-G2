import axios from "axios";
import { useState, useEffect } from "react";
import { Space, message } from 'antd';
import { useParams } from "react-router-dom";
import "./css/AllStories.css";
import StoryList from "./StoryList";

const LabelSearch = () => {
  const { label } = useParams();
  const [labeledStories, setLabeledStories] = useState([]);
  const [messageApi, contextHolder] = message.useMessage();

  useEffect(() => {
    axios
      .get(`${process.env.REACT_APP_BACKEND_URL}/api/story/search/label?label=${label}`, {
        withCredentials: true,
      })
      .then((response) => {
        setLabeledStories(response.data);
      })
      .catch((error) => {
        console.log(error);
        messageApi.open({ type: "error", content: "Error occured while loading stories from label!"});
      });
  }, [label, messageApi]);

  return (
    <Space
    direction="vertical"
    align="center"
    style={{
      width: '100%',
    }}
    >
    {contextHolder}
    <div className="all-stories">
    <center><h1>Stories with label: "{label}"</h1></center>
      {labeledStories.map((story) => (
        <StoryList story={story} key={story.id} />
      ))}
    </div>
    </Space>
  );
};

export default LabelSearch;
