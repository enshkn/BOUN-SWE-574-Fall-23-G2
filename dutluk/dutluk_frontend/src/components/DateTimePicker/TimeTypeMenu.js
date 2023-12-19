import React, { useState } from 'react';
import Dropdown from 'react-bootstrap/Dropdown';

function TimeTypeMenu() {

  const [selectedTimeType, setSelectedTimeType] = useState('');
  let timeType = '';

  const handleSelect = (eventKey) => {
    setSelectedTimeType(eventKey);

    // Perform operations based on the selected value
    switch (eventKey) {
      case 'Time Point':
        timeType = 'timePoint';
        console.log(timeType, 'value selected');
        break;
      case 'Time Interval':
        timeType = 'timeInterval';
        console.log(timeType, 'value selected');
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
