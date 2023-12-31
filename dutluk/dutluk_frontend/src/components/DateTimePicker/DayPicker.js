import React, { useState } from 'react';
import ReactDatePicker from 'react-datepicker';
import 'react-datepicker/dist/react-datepicker.css';

function DayPicker({ onDateTimeChange }) {
  const [startDate, setStartDate] = useState(new Date());

  // export selected value with onChange function
  const handleDateTimeChange = (date) => {
    setStartDate(date);
    onDateTimeChange(date);
  };

  return (
    <div>
      <div className="form-group">
      <ReactDatePicker
        selected={startDate}
        onChange={handleDateTimeChange}
        timeInputLabel="Time:"
        dateFormat="dd/MM/yyyy"
        className="form-control"
        
      />
      </div>
    </div>
  );
}

export default DayPicker;
