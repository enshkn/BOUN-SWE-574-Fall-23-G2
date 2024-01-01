import React, {useState, useRef} from 'react';
import { Card, Row, Col, Button } from 'react-bootstrap';
import "./css/Timeline.css";

// Dummy Story Verileri
const dummyStories = [
  { // dummy story 1
    id: 1,
    title: 'Story 1',
    image: 'https://via.placeholder.com/150',
    description: 'Description for Story 1',
    date: '2023-12-01',
  },
  {
    id: 2,
    title: 'Story 2',
    image: 'https://via.placeholder.com/150',
    description: 'Description for Story 2',
    date: '2023-12-05',
  },
  {
    id: 3,
    title: 'Story 3',
    image: 'https://via.placeholder.com/150',
    description: 'Description for Story 3',
    date: '2023-12-10',
  },
  {
    id: 4,
    title: 'Story 4',
    image: 'https://via.placeholder.com/150',
    description: 'Description for Story 1',
    date: '2023-12-01',
  },
  {
    id: 5,
    title: 'Story 5',
    image: 'https://via.placeholder.com/150',
    description: 'Description for Story 2',
    date: '2023-12-05',
  },
  {
    id: 6,
    title: 'Story 6',
    image: 'https://via.placeholder.com/150',
    description: 'Description for Story 3',
    date: '2023-12-10',
  },
  {
    id: 7,
    title: 'Story 7',
    image: 'https://via.placeholder.com/150',
    description: 'Description for Story 1',
    date: '2023-12-01',
  },
  {
    id: 8,
    title: 'Story 8',
    image: 'https://via.placeholder.com/150',
    description: 'Description for Story 2',
    date: '2023-12-05',
  },
  {
    id: 9,
    title: 'Story 9',
    image: 'https://via.placeholder.com/150',
    description: 'Description for Story 3',
    date: '2023-12-10',
  },
  {
    id: 10,
    title: 'Story 10',
    image: 'https://via.placeholder.com/150',
    description: 'Description for Story 1',
    date: '2023-12-01',
  },
  {
    id: 11,
    title: 'Story 11',
    image: 'https://via.placeholder.com/150',
    description: 'Description for Story 2',
    date: '2023-12-05',
  },
  {
    id: 12,
    title: 'Story 12',
    image: 'https://via.placeholder.com/150',
    description: 'Description for Story 3',
    date: '2023-12-10',
  },
];

// Story Kartı Componenti
const StoryCard = ({ story, active, onFocus }) => {
    const handleFocus = () => {
      if (onFocus) {
        onFocus(story.date);
      }
    };
  
    return (
      <Card
        className={`timeline-card ${active ? 'active' : ''}`}
        onMouseOver={handleFocus}
      >
        <Card.Img variant="top" src={story.image} alt={story.title} />
        <Card.Body>
          <h2><a href={`/story/${story.id}`} className="story-title">{story.title}</a></h2>
          <Card.Text>{story.description}</Card.Text>
          <Card.Text>Date: {story.date}</Card.Text>
        </Card.Body>
      </Card>
    );
  };
  
  const Timeline = ({ items, visibleCount = 3 }) => {
    const [startIdx, setStartIdx] = useState(0);
  
    const handleMoveRight = () => {
      setStartIdx(prev => Math.min(prev + visibleCount, items.length - visibleCount));
    };
  
    const handleMoveLeft = () => {
      setStartIdx(prev => Math.max(prev - visibleCount, 0));
    };
  
    return (
      <div className="timeline">
        <div className="timeline-controls">
          <Button className="timeline-control-btn" onClick={handleMoveLeft}>{'<'}</Button>
          <Button className="timeline-control-btn" onClick={handleMoveRight}>{'>'}</Button>
        </div>
        <div className="timeline-carousel-container">
          <Row className="justify-content-center">
            <div className="timeline-carousel">
              {items.slice(startIdx, startIdx + visibleCount).map(item => (
                <StoryCard
                  key={item.id}
                  story={item}
                />
              ))}
            </div>
          </Row>
        </div>
      </div>
    );
  };
  
  export default Timeline;

