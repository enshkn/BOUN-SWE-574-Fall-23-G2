import React from 'react';
import 'react-datepicker/dist/react-datepicker.css';
import 'bootstrap/dist/css/bootstrap.min.css';

function SeasonMenu({ onSeasonSelect }) {
  const handleSeasonChange = (e) => {
    const selectedSeason = e.target.value;
    onSeasonSelect(selectedSeason);
  };

  return (
    <div className='mt-3'>
    <select className='form-select' onChange={handleSeasonChange} >
      <option value="1">Winter</option>
      <option value="2">Spring</option>
      <option value="3">Summer</option>
      <option value="4">Fall</option>
    </select>
    </div>
  );
}

export default SeasonMenu;