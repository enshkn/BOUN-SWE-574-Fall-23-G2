import React from 'react';

function SeasonMenu({ onSeasonSelect }) {
  const handleSeasonChange = (e) => {
    const selectedSeason = e.target.value;
    onSeasonSelect(selectedSeason);
  };

  return (
    <select className='form-control' onChange={handleSeasonChange}>
      <option value="">Select Season</option>
      <option value="1">Winter</option>
      <option value="2">Spring</option>
      <option value="3">Summer</option>
      <option value="4">Fall</option>
    </select>
  );
}

export default SeasonMenu;