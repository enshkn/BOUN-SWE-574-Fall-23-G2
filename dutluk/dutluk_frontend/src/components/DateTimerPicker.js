import React from 'react'
import { useState } from 'react'
import TimeTypeMenu from './DateTimePicker/TimeTypeMenu'
import TimeExpression from './DateTimePicker/TimeExpression'
import MomentPicker from './DateTimePicker/MomentPicker'
import DayPicker from './DateTimePicker/DayPicker'

function DateTimerPicker() {
  const [selectedTimeType, setSelectedTimeType] = useState('');
  const handleTimeTypeChange = (selectedTimeType) => {
    setSelectedTimeType(selectedTimeType);
  };
  const [selectedTimeExpression, setSelectedTimeExpression] = useState('');
  const handleTimeExpressionChange = (selectedTimeExpression) => {
    setSelectedTimeExpression(selectedTimeExpression);
  };
  const [selectedDateTimeStart, setSelectedDateTimeStart] = useState(new Date());
  const [selectedDateTimeEnd, setSelectedDateTimeEnd] = useState(new Date());

  function formatDate(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
  
    return `${year} ${month}.${day} ${hours}:${minutes}`;
  }

  let showStartMomentPicker = false;
  let showEndMomentPicker = false;
  let showStartDayPicker = false;
  let showEndDayPicker = false;

  let formattedDateTimeStart = '';
  let formattedDateTimeEnd = '';

  switch (selectedTimeType) {
    case 'timePoint':
      switch (selectedTimeExpression) {
        case 'moment':
          showStartMomentPicker = true;
          formattedDateTimeStart = formatDate(selectedDateTimeStart);
          console.log(formattedDateTimeStart);
          break;
        case 'day':
          showStartDayPicker = true;
          formattedDateTimeStart = formatDate(selectedDateTimeStart);
          console.log(selectedTimeType, 'day selected with switch');
          break;
        case 'month':
          console.log(selectedTimeType, 'month selected with switch');
          break;
        case 'season':
          console.log(selectedTimeType, 'season selected with switch');
          break;
        case 'year':
          console.log(selectedTimeType, 'year selected with switch');
          break;
        case 'decade':
          console.log(selectedTimeType ,'decade selected with switch');
          break;
        case 'decade+season':
          console.log(selectedTimeType, 'decade+season selected with switch');
          break;
      }
      break;
    case 'timeInterval':
      switch (selectedTimeExpression) {
        case 'moment':
          showStartMomentPicker = true;
          showEndMomentPicker = true;
          formattedDateTimeStart = formatDate(selectedDateTimeStart);
          formattedDateTimeEnd = formatDate(selectedDateTimeEnd);
          console.log(formattedDateTimeStart);
          console.log(formattedDateTimeEnd);
          break;
        case 'day':
          showStartDayPicker = true;
          showEndDayPicker = true;
          formattedDateTimeStart = formatDate(selectedDateTimeStart);
          formattedDateTimeEnd = formatDate(selectedDateTimeEnd);
          console.log(formattedDateTimeStart);
          console.log(formattedDateTimeEnd);
          break;
        case 'month':
          console.log(selectedTimeType, 'month selected with switch');
          break;
        case 'season':
          console.log(selectedTimeType, 'season selected with switch');
          break;
        case 'year':
          console.log(selectedTimeType, 'year selected with switch');
          break;
        case 'decade':
          console.log(selectedTimeType, 'decade selected with switch');
          break;
        case 'decade+season':
          console.log(selectedTimeType, 'decade+season selected with switch');
          break;
      }
      break;
    default:
      break;
  }

  return (
    <div>DateTimerPicker
      <TimeTypeMenu onTimeTypeChange={handleTimeTypeChange}/>
      <TimeExpression onTimeExpressionChange={handleTimeExpressionChange}/>
      <div style={{ display: 'flex' }}>
      {showStartMomentPicker && (<MomentPicker onDateTimeChange={setSelectedDateTimeStart}/>)}
      {showEndMomentPicker && (<MomentPicker onDateTimeChange={setSelectedDateTimeEnd} />)}
      {showStartDayPicker && (<DayPicker onDateTimeChange={setSelectedDateTimeStart}/>)}
      {showEndDayPicker && (<DayPicker onDateTimeChange={setSelectedDateTimeEnd} />)}
      </div>
    </div>
    
  )
}

export default DateTimerPicker