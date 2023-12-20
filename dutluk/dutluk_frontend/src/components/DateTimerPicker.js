import React from 'react'
import { useState } from 'react'
import TimeTypeMenu from './DateTimePicker/TimeTypeMenu'
import TimeExpression from './DateTimePicker/TimeExpression'
import MomentPicker from './DateTimePicker/MomentPicker'
import DayPicker from './DateTimePicker/DayPicker'
import MonthPicker from './DateTimePicker/MonthPicker'
import SeasonPicker from './DateTimePicker/SeasonPicker'
import YearPicker from './DateTimePicker/YearPicker'

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

  function monthStartFormatter(date) {
    const year = date.getFullYear();
    const month  = String(date.getMonth() + 1).padStart(2, '0');
    const day = '01';
    const hours = '00';
    const minutes = '00';

    return `${year} ${month}.${day} ${hours}:${minutes}`;
  }

  function monthEndFormatter(date) {
    const year = date.getFullYear();
    const month = date.getMonth() + 1;
    const lastDay = new Date(year, month, 0).getDate();
    const formattedMonth = String(month).padStart(2, '0');
    const formattedLastDay = String(lastDay).padStart(2, '0');
    const hours = '23';
    const minutes = '59';
  
    return `${year}-${formattedMonth}-${formattedLastDay} ${hours}:${minutes}`;
  }

  function yearStartFormatter(date) {
    const year = date.getFullYear();
    const month = '01';
    const day = '01';
    const hours = '00';
    const minutes = '00';
  
    return `${year}-${month}-${day} ${hours}:${minutes}`;
  }

  function yearEndFormatter(date) {
    const year = date.getFullYear();
    const month = '12';
    const day = '31';
    const hours = '23';
    const minutes = '59';
  
    return `${year}-${month}-${day} ${hours}:${minutes}`;
  }

  let showStartMomentPicker = false;
  let showEndMomentPicker = false;
  let showStartDayPicker = false;
  let showEndDayPicker = false;
  let showStartMonthPicker = false;
  let showEndMonthPicker = false;
  let showStartSeasonPicker = false;
  let showEndSeasonPicker = false;
  let showStartYearPicker = false;
  let showEndYearPicker = false;


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
          console.log(selectedDateTimeStart);
          break;
        case 'month':
          showStartMonthPicker = true;
          formattedDateTimeStart = monthStartFormatter(selectedDateTimeStart);
          console.log(formattedDateTimeStart);
          break;
        case 'season':
          showStartSeasonPicker = true;
          console.log(setSelectedDateTimeStart);
          break;
        case 'year':
          showStartYearPicker = true;
          console.log(selectedDateTimeStart);
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
          showStartMonthPicker = true;
          showEndMonthPicker = true;
          formattedDateTimeStart = monthStartFormatter(selectedDateTimeStart);
          formattedDateTimeEnd = monthEndFormatter(selectedDateTimeEnd);
          console.log(formattedDateTimeStart);
          console.log(formattedDateTimeEnd);
          break;
        case 'season':
          showStartSeasonPicker = true;
          showEndSeasonPicker = true;
          console.log(setSelectedDateTimeStart);
          console.log(setSelectedDateTimeEnd);
          break;
        case 'year':
          showStartYearPicker = true;
          showEndYearPicker = true;
          console.log(selectedDateTimeStart);
          console.log(selectedDateTimeEnd);
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
      {showStartMonthPicker && (<MonthPicker onDateTimeChange={setSelectedDateTimeStart} />)}
      {showEndMonthPicker && (<MonthPicker onDateTimeChange={setSelectedDateTimeEnd} />)}
      {showStartSeasonPicker && (<SeasonPicker onDateTimeChange={setSelectedDateTimeStart} />)}
      {showEndSeasonPicker && (<SeasonPicker onDateTimeChange={setSelectedDateTimeEnd} />)}
      {showStartYearPicker && (<YearPicker onDateTimeChange={setSelectedDateTimeStart} />)}
      {showEndYearPicker && (<YearPicker onDateTimeChange={setSelectedDateTimeEnd} />)}
      </div>
    </div>
    
  )
}

export default DateTimerPicker