import React, { useState } from 'react';
import ReactDatePicker from 'react-datepicker';
import 'react-datepicker/dist/react-datepicker.css';

function MomentPicker({ onDateTimeChange }) {
  const [startDate, setStartDate] = useState(new Date());

  // export selected value with onChange function
  const handleDateTimeChange = (date) => {
    setStartDate(date);
    onDateTimeChange(date);
  };

  return (
    <div>
      <ReactDatePicker
        className="form-control"
        selected={startDate}
        onChange={handleDateTimeChange}
        timeInputLabel="Time:"
        dateFormat="dd/MM/yyyy h:mm aa"
        showTimeInput
      />
    </div>
  );
}

export default MomentPicker;
