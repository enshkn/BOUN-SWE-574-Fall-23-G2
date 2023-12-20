import React, { useState } from 'react';
import ReactDatePicker from 'react-datepicker';
import 'react-datepicker/dist/react-datepicker.css';
import 'bootstrap/dist/css/bootstrap.min.css'; // Add Bootstrap CSS file

function MomentPicker({ onDateTimeChange }) {
  const [startDate, setStartDate] = useState(new Date());

  // export selected value with onChange function
  const handleDateTimeChange = (date) => {
    setStartDate(date);
    onDateTimeChange(date);
  };

  return (
    <div className="mb-3">
      <ReactDatePicker
        selected={startDate}
        onChange={handleDateTimeChange}
        timeInputLabel="Time:"
        dateFormat="dd/MM/yyyy h:mm aa"
        showTimeInput
        className='form-control'
      />
    </div>
  );
}

export default MomentPicker;
