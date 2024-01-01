import React from 'react'
import { useState } from 'react';
import ReactDatePicker from 'react-datepicker';
import 'react-datepicker/dist/react-datepicker.css';
import 'bootstrap/dist/css/bootstrap.min.css';

function YearPicker({onDateTimeChange}) {
  const handleDateTimeChange = (date) => {
    setStartDate(date);
    onDateTimeChange(date);
  };
  
  const [startDate, setStartDate] = useState(new Date());
      return (
        <ReactDatePicker
        selected={startDate}
        onChange={handleDateTimeChange}
        showYearPicker
        dateFormat="yyyy"
        className='form-control'
        />
      );
}

export default YearPicker