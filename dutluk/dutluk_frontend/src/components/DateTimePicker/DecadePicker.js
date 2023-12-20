import React, { useState } from 'react';
import { Form } from 'react-bootstrap';

function DecadePicker({ onDateTimeChange }) {
  const [selectedDecade, setSelectedDecade] = useState(""); // State to hold the selected year

  const decades = [];
  const currentYear = new Date().getFullYear();
  const startDecade = Math.floor(currentYear / 10) * 10; // Start year of the current decade

  // Adding decades from the past to the beginning of the current decade to the list
  for (let decadeStart = startDecade; decadeStart >= 1900; decadeStart -= 10) {
    decades.push(decadeStart);
  }

  return (
    <Form.Select
      value={selectedDecade} // Value of the selected decade
      onChange={(e) => {
        const selectedValue = parseInt(e.target.value);
        setSelectedDecade(selectedValue); // Update the state with the selected value
        onDateTimeChange(selectedValue); // Pass the selected value to the parent component
      }}
    >
      <option value="">Select Decade</option>
      {decades.map((decade) => (
        <option key={decade} value={decade}>
          {`${decade}s`} {/* Displaying the decade as "1950s", "1960s", etc. */}
        </option>
      ))}
    </Form.Select>
  );
}

export default DecadePicker;
