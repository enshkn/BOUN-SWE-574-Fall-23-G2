import React, { useState } from 'react';
import Dropdown from 'react-bootstrap/Dropdown';

function TimeExpression({ onTimeExpressionChange}) {

  let timeExpression = '';
  const [selectedExpression, setSelectedExpression] = useState('');
 

  const handleSelect = (eventKey) => {
    setSelectedExpression(eventKey);

    // Perform operations based on the selected value
    switch (eventKey) {
      case 'Moment':
        onTimeExpressionChange('moment')
        break;
      case 'Day':
        onTimeExpressionChange('day')
        break;
      case 'Month with Year':
        onTimeExpressionChange('month')
        break;
      case 'Season with Year':
        onTimeExpressionChange('season')
        break;
      case 'Year':
        onTimeExpressionChange('year')
        break;
      case 'Decade':
        onTimeExpressionChange('decade')
        break;
      case 'Decade with Season':
        onTimeExpressionChange('decade+season')
        break;
      default:
        break;
    }
  };

  return (
    <Dropdown onSelect={handleSelect}>
      <Dropdown.Toggle variant="primary" id="timeExpressionDropdown">
        {selectedExpression ? selectedExpression : 'Select Time Expression'}
      </Dropdown.Toggle>

      <Dropdown.Menu>
        <Dropdown.Item eventKey="Moment">Moment</Dropdown.Item>
        <Dropdown.Item eventKey="Day">Day</Dropdown.Item>
        <Dropdown.Item eventKey="Month with Year">Month with Year</Dropdown.Item>
        <Dropdown.Item eventKey="Season with Year">Season with Year</Dropdown.Item>
        <Dropdown.Item eventKey="Year">Year</Dropdown.Item>
        <Dropdown.Item eventKey="Decade">Decade</Dropdown.Item>
        {/* 
        <Dropdown.Item eventKey="Decade with Season">Decade with Season</Dropdown.Item>
        */}
      </Dropdown.Menu>
    </Dropdown>
  );
}

export default TimeExpression;
