import React from 'react'
import { useState } from 'react';
import ReactDatePicker from 'react-datepicker';
import 'react-datepicker/dist/react-datepicker.css';

function SeasonPicker({onDateTimeChange}) {
  const handleDateTimeChange = (date) => {
    setStartDate(date);
    onDateTimeChange(date);
  };
  
  const [startDate, setStartDate] = useState(new Date());
      return (
        <ReactDatePicker
        selected={startDate}
        onChange={handleDateTimeChange}
        dateFormat="yyyy, QQQ"
        showQuarterYearPicker
        />
      );
}

export default SeasonPicker