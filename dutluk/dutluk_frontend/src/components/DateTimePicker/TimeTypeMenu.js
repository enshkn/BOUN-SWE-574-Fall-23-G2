import React, { useState } from 'react';
import Dropdown from 'react-bootstrap/Dropdown';

function TimeTypeMenu() {
  // State to store the selected time type
  const [selectedTimeType, setSelectedTimeType] = useState('');

  // Function to handle selection in the dropdown
  const handleSelect = (eventKey) => {
    // Set the selected time type when an option is clicked
    setSelectedTimeType(eventKey);

    // Perform operations based on the selected value (e.g., setting timePoint and timeInterval values)
    if (eventKey === 'Time Point') {
      // Actions to perform when Time Point is selected
      console.log('Time Point value selected');
    } else if (eventKey === 'Time Interval') {
      // Actions to perform when Time Interval is selected
      console.log('Time Interval value selected');
    }
  };

  return (
    <Dropdown onSelect={handleSelect}>
      {/* Dropdown Toggle Button */}
      <Dropdown.Toggle variant="primary" id="timeTypeDropdown">
        {/* Display selected time type or default message */}
        {selectedTimeType ? selectedTimeType : 'Select Time Type'}
      </Dropdown.Toggle>

      {/* Dropdown Menu */}
      <Dropdown.Menu>
        {/* Dropdown Items */}
        <Dropdown.Item eventKey="Time Point">Time Point</Dropdown.Item>
        <Dropdown.Item eventKey="Time Interval">Time Interval</Dropdown.Item>
      </Dropdown.Menu>
    </Dropdown>
  );
}

export default TimeTypeMenu;
