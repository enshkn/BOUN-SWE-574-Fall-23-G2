import React, { useState } from 'react';
import ReactDatePicker from 'react-datepicker';
import 'react-datepicker/dist/react-datepicker.css';
import SeasonMenu from './SeasonMenu';

function SeasonPicker({ onDateTimeChange }) {
  const [startDate, setStartDate] = useState(new Date());
  const [selectedSeason, setSelectedSeason] = useState('1');

  const handleDateTimeChange = (date) => {
    setStartDate(date);
    onDateTimeChange(date, selectedSeason);
  };

  const handleSeasonSelect = (selectedSeason) => {
    setSelectedSeason(selectedSeason);
    onDateTimeChange(startDate, selectedSeason);
  };

  return (
    <div>
      <ReactDatePicker
        className='form-control'
        selected={startDate}
        onChange={handleDateTimeChange}
        showYearPicker
        dateFormat="yyyy"
      />
      <SeasonMenu onSeasonSelect={handleSeasonSelect} />
    </div>
  );
}

export default SeasonPicker;
