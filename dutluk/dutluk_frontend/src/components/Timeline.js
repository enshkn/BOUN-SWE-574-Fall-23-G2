import React, {useState} from 'react';
import { Card, Row, Button } from 'react-bootstrap';
import "./css/Timeline.css";

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

