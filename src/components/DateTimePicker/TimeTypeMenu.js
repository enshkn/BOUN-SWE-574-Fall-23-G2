import React, { useState } from 'react';
import Dropdown from 'react-bootstrap/Dropdown';

function TimeTypeMenu({ onTimeTypeChange}) {

  const [selectedTimeType, setSelectedTimeType] = useState('');

  const handleSelect = (eventKey) => {  
    setSelectedTimeType(eventKey);

    // Perform operations based on the selected value
    switch (eventKey) {
      case 'Time Point':
        onTimeTypeChange('timePoint')
        break;
      case 'Time Interval':
        onTimeTypeChange('timeInterval')
        break;
      default:
        break;
    }
  };

  return (
    <Dropdown onSelect={handleSelect}>
      <Dropdown.Toggle variant="primary" id="timeTypeDropdown">
        {selectedTimeType ? selectedTimeType : 'Select Time Type'}
      </Dropdown.Toggle>

      <Dropdown.Menu>
        <Dropdown.Item eventKey="Time Point">Time Point</Dropdown.Item>
        <Dropdown.Item eventKey="Time Interval">Time Interval</Dropdown.Item>
      </Dropdown.Menu>
    </Dropdown>
  );
}

export default TimeTypeMenu;
