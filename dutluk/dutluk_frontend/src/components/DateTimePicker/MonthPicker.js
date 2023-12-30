import React from 'react'
import { useState } from 'react';
import ReactDatePicker from 'react-datepicker';

function MonthPicker({onDateTimeChange}) {
  const handleDateTimeChange = (date) => {
    setStartDate(date);
    onDateTimeChange(date);
  };
  
  const [startDate, setStartDate] = useState(new Date());
      return (
        <ReactDatePicker
        className='form-control'
        selected={startDate}
        onChange={handleDateTimeChange}
        dateFormat="MM/yyyy"
        showMonthYearPicker
        showFullMonthYearPicker
        />
      );
}

export default MonthPicker