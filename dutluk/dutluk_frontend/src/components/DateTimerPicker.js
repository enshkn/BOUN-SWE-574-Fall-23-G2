import React from 'react'
import { Row, Col } from 'react-bootstrap';
import { useState } from 'react'
import TimeTypeMenu from './DateTimePicker/TimeTypeMenu'
import TimeExpression from './DateTimePicker/TimeExpression'
import MomentPicker from './DateTimePicker/MomentPicker'
import DayPicker from './DateTimePicker/DayPicker'
import MonthPicker from './DateTimePicker/MonthPicker'
import SeasonPicker from './DateTimePicker/SeasonPicker'
import YearPicker from './DateTimePicker/YearPicker'
import DecadePicker from './DateTimePicker/DecadePicker'
import SeasonMenu from './DateTimePicker/SeasonMenu'
import { start } from '@popperjs/core';

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

  const [selectedSeasonStart, setSelectedSeasonStart] = useState('');
  const [selectedSeasonEnd, setSelectedSeasonEnd] = useState('');

  const [selectedDecadeStart, setSelectedDecadeStart] = useState('');
  const [selectedDecadeEnd, setSelectedDecadeEnd] = useState('');


  function formatDate(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
  
    return `${year} ${month}.${day} ${hours}:${minutes}`;
  }

  function dayStartFormatter(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
  
    // Set hours and minute as 00:00
    const hours = '00';
    const minutes = '00';
  
    return `${year}-${month}-${day} ${hours}:${minutes}`;
  }

  function dayEndFormatter(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
  
    // Set hours and minute as 00:00
    const hours = '23';
    const minutes = '59';
  
    return `${year}-${month}-${day} ${hours}:${minutes}`;
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
  function calculateSeasonDates(startYear, startSeason, timeType, endYear = null, endSeason = null) {
    let seasonStartMonth = 0;
    let seasonEndMonth = 0;
  
    switch (startSeason) {
      case 1: // Winter: Starts in December
        seasonStartMonth = 11; // December
        seasonEndMonth = 1;    // February
        break;
      case 2: // Spring: Starts in March
        seasonStartMonth = 2;  // March
        seasonEndMonth = 4;    // May
        break;
      case 3: // Summer: Starts in June
        seasonStartMonth = 5;  // June
        seasonEndMonth = 7;    // August
        break;
      case 4: // Autumn: Starts in September
        seasonStartMonth = 8;  // September
        seasonEndMonth = 10;   // November
        break;
      default:
        return "Invalid season value!";
    }
  
    const parsedStartYear = startYear;
    const startTime = new Date(parsedStartYear, seasonStartMonth, 1, 0, 0, 0); // Start of the season
    const endTimePoint = new Date(parsedStartYear, seasonEndMonth + 1, 0, 23, 59, 59); // End of the season
  
    const formattedStartTime = `${parsedStartYear}-${seasonStartMonth + 1}-01 00:00:00`;
    const formattedEndTimePoint = `${parsedStartYear}-${seasonEndMonth + 1}-${new Date(parsedStartYear, seasonEndMonth + 1, 0).getDate()} 23:59:59`;
  
    if (timeType === "timePoint") {
      return { formattedStartTime, formattedEndTime: formattedEndTimePoint };
    }
  
    if (timeType === "timeInterval" && endYear && endSeason) {
      const parsedEndYear = endYear;
  
      switch (endSeason) {
        case 1: // Winter
          seasonEndMonth = 1;
          break;
        case 2: // Spring
          seasonEndMonth = 4;
          break;
        case 3: // Summer
          seasonEndMonth = 7;
          break;
        case 4: // Autumn
          seasonEndMonth = 10;
          break;
        default:
          return "Invalid endSeason value!";
      }
  
      const endTimeInterval = new Date(parsedEndYear, seasonEndMonth + 1, 0, 23, 59, 59);
      const formattedEndTimeInterval = `${endYear}-${seasonEndMonth + 1}-${new Date(parsedEndYear, seasonEndMonth + 1, 0).getDate()} 23:59:59`;
  
      return { formattedStartTime, formattedEndTime: formattedEndTimeInterval };
    }
  
    return "Invalid timeType or insufficient parameters!";
  }

  function getDecadeRangePoint(decade) {
    const startYear = decade;
    const endYear = decade + 9;
  
    const startDate = new Date(startYear, 0, 1, 0, 0, 0);
    const endDate = new Date(endYear, 11, 31, 23, 59, 59);
  
    return { startDate, endDate };
  }

  function getDecadeRangeInterval(startDecade, endDecade) {
    const startYear = startDecade;
    const endYear = endDecade + 9;
  
    const startDate = new Date(startYear, 0, 1, 0, 0, 0); 
    const endDate = new Date(endYear, 11, 31, 23, 59, 59); 
  
    return { startDate, endDate };
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
  let showStartDecadePicker = false;
  let showEndDecadePicker = false;
  let showStartDecadeSeasonPicker = false;
  let showEndDecadeSeasonPicker = false;


  let formattedDateTimeStart = '';
  let formattedDateTimeEnd = '';

  let startSeason  = '';
  let endSeason = '';

  let decade_start = 0
  let decade_end = 0

  let startHourFlag = -1;
  let endHourFlag = -1;
  let startDateFlag = -1;
  let endDateFlag = -1;

  switch (selectedTimeType) {
    case 'timePoint':
      switch (selectedTimeExpression) {
        case 'moment':
          showStartMomentPicker = true;
          formattedDateTimeStart = formatDate(selectedDateTimeStart);
          formattedDateTimeEnd = formattedDateTimeStart
          startHourFlag = 1;
          endHourFlag = 1;
          startDateFlag = 3;
          endDateFlag = 3;
          console.log(formattedDateTimeStart, formattedDateTimeEnd);
          break;
        case 'day':
          showStartDayPicker = true;
          formattedDateTimeStart = dayStartFormatter(selectedDateTimeStart);
          formattedDateTimeEnd = formattedDateTimeStart
          startHourFlag = 0;
          endHourFlag = 0;
          startDateFlag = 3;
          endDateFlag = 3;
          console.log(formattedDateTimeStart, formattedDateTimeEnd, typeof formattedDateTimeStart, typeof formattedDateTimeEnd);
          break;
        case 'month':
          showStartMonthPicker = true;
          formattedDateTimeStart = monthStartFormatter(selectedDateTimeStart);
          formattedDateTimeEnd = monthEndFormatter(selectedDateTimeStart);
          startHourFlag = 0;
          endHourFlag = 0;
          startDateFlag = 2;
          endDateFlag = 2;
          console.log(formattedDateTimeStart, formattedDateTimeEnd, typeof formattedDateTimeStart, typeof formattedDateTimeEnd);
          break;
        case 'season':
          showStartSeasonPicker = true;
          let formattedDate = formatDate(selectedDateTimeStart);
          let startYear = new Date(formattedDate).getFullYear();
          let intSeasonStart = parseInt(selectedSeasonStart, 10);
          startSeason = intSeasonStart;
          endSeason = intSeasonStart;
          const result = calculateSeasonDates(startYear, intSeasonStart, selectedTimeType);
          formattedDateTimeStart = result.formattedStartTime;
          formattedDateTimeEnd = result.formattedEndTime;
          console.log(formattedDateTimeStart, formattedDateTimeEnd, typeof formattedDateTimeStart, typeof formattedDateTimeEnd);
          break;
        case 'year':
          showStartYearPicker = true;
          formattedDateTimeStart = yearStartFormatter(selectedDateTimeStart);
          formattedDateTimeEnd = yearEndFormatter(selectedDateTimeStart);
          startHourFlag = 0;
          endHourFlag = 0;
          startDateFlag = 1;
          endDateFlag = 1;
          console.log(formattedDateTimeStart, formattedDateTimeEnd, typeof formattedDateTimeStart, typeof formattedDateTimeEnd);
          break;
        case 'decade':
          showStartDecadePicker = true;
          const decade_result = getDecadeRangePoint(selectedDecadeStart);
          decade_start = decade_result.startDate;
          decade_end = decade_result.endDate;
          formattedDateTimeStart = formatDate(decade_start);
          formattedDateTimeEnd = formatDate(decade_end);
          console.log(formattedDateTimeStart, formattedDateTimeEnd, typeof formattedDateTimeStart, typeof formattedDateTimeEnd);
          break;
        case 'decade+season':
        showStartDecadeSeasonPicker = true;  
        const decade_season_result = getDecadeRangePoint(selectedDecadeStart);
          decade_start = decade_season_result.startDate;
          decade_end = decade_season_result.endDate;
          formattedDateTimeStart = formatDate(decade_start);
          formattedDateTimeEnd = formatDate(decade_end)
          startSeason = parseInt(selectedSeasonStart, 10);
          endSeason = parseInt(selectedSeasonEnd, 10);
          console.log(formattedDateTimeStart, formattedDateTimeEnd, typeof formattedDateTimeStart, typeof formattedDateTimeEnd);
          console.log(selectedSeasonStart, selectedSeasonEnd, typeof selectedSeasonStart, typeof selectedSeasonEnd)
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
          startHourFlag = 1;
          endHourFlag = 1;
          startDateFlag = 3;
          endDateFlag = 3;
          console.log(formattedDateTimeStart, formattedDateTimeEnd, typeof formattedDateTimeStart, typeof formattedDateTimeEnd);
          break;
        case 'day':
          showStartDayPicker = true;
          showEndDayPicker = true;
          formattedDateTimeStart = dayStartFormatter(selectedDateTimeStart);
          formattedDateTimeEnd = dayEndFormatter(selectedDateTimeEnd);
          startHourFlag = 0;
          endHourFlag = 0;
          startDateFlag = 3;
          endDateFlag = 3;
          console.log(formattedDateTimeStart, formattedDateTimeEnd, typeof formattedDateTimeStart, typeof formattedDateTimeEnd);
          break;
        case 'month':
          showStartMonthPicker = true;
          showEndMonthPicker = true;
          formattedDateTimeStart = monthStartFormatter(selectedDateTimeStart);
          formattedDateTimeEnd = monthEndFormatter(selectedDateTimeEnd);
          startHourFlag = 0;
          endHourFlag = 0;
          startDateFlag = 2;
          endDateFlag = 2;
          console.log(formattedDateTimeStart, formattedDateTimeEnd, typeof formattedDateTimeStart, typeof formattedDateTimeEnd);
          break;
        case 'season':
          showStartSeasonPicker = true;
          showEndSeasonPicker = true;
          formattedDateTimeStart = formatDate(selectedDateTimeStart);
          formattedDateTimeEnd = formatDate(selectedDateTimeEnd);
          
          let startYear = new Date(formattedDateTimeStart).getFullYear();
          let endYear = new Date(formattedDateTimeEnd).getFullYear();

          let intSeasonStart = parseInt(selectedSeasonStart, 10);
          let intSeasonEnd = parseInt(selectedSeasonEnd, 10);

          startSeason = parseInt(selectedSeasonStart, 10);
          endSeason = parseInt(selectedSeasonEnd, 10);

          const result = calculateSeasonDates(startYear, intSeasonStart, selectedTimeType, endYear, intSeasonEnd);
          formattedDateTimeStart = result.formattedStartTime;
          formattedDateTimeEnd = result.formattedEndTime;
          console.log(formattedDateTimeStart, formattedDateTimeEnd, typeof formattedDateTimeStart, typeof formattedDateTimeEnd);
          console.log(selectedSeasonStart, selectedSeasonEnd, typeof selectedSeasonStart, typeof selectedSeasonEnd);
          break;
        case 'year':
          showStartYearPicker = true;
          showEndYearPicker = true;
          formattedDateTimeStart = yearStartFormatter(selectedDateTimeStart);
          formattedDateTimeEnd = yearEndFormatter(selectedDateTimeEnd);
          startHourFlag = 0;
          endHourFlag = 0;
          startDateFlag = 1;
          endDateFlag = 1;
          console.log(formattedDateTimeStart, formattedDateTimeEnd, typeof formattedDateTimeStart, typeof formattedDateTimeEnd);
          break;
        case 'decade':
          showStartDecadePicker = true;
          showEndDecadePicker = true;
          const decade_result = getDecadeRangeInterval(selectedDecadeStart, selectedDecadeEnd);
          decade_start = decade_result.startDate;
          decade_end = decade_result.endDate;
          formattedDateTimeStart = formatDate(decade_start);
          formattedDateTimeEnd = formatDate(decade_end);
          console.log(formattedDateTimeStart, formattedDateTimeEnd, typeof formattedDateTimeStart, typeof formattedDateTimeEnd);
          break;
        case 'decade+season':
          showStartDecadeSeasonPicker = true;
          showEndDecadeSeasonPicker = true;
          const decade_season_result = getDecadeRangeInterval(selectedDecadeStart, selectedDecadeEnd);
          decade_start = decade_season_result.startDate;
          decade_end = decade_season_result.endDate;
          formattedDateTimeStart = formatDate(decade_start);
          formattedDateTimeEnd = formatDate(decade_end);
          startSeason = parseInt(selectedSeasonStart, 10);
          endSeason = parseInt(selectedSeasonEnd, 10);
          console.log(formattedDateTimeStart, formattedDateTimeEnd, typeof formattedDateTimeStart, typeof formattedDateTimeEnd);
          console.log(selectedSeasonStart, selectedSeasonEnd, typeof selectedSeasonStart, typeof selectedSeasonEnd);
          break;
      }
      return {
        timeType: selectedTimeType,
        timeExpression: selectedTimeExpression,
        startHourFlag: startHourFlag,
        endHourFlag: endHourFlag,
        formattedDateTimeStart: formattedDateTimeStart,
        formattedDateTimeEnd: formattedDateTimeEnd,
        startSeason: startSeason,
        endSeason: endSeason,
        decade_start: decade_start,
        decade_end: decade_end
      };

    default:
      break;
    }

  return (
    <div className="container">
    <div>
      <br />
      <h3>Date Time Picker</h3>
      <Row>
      <Col md={6}>
      <div className="mb-3">
      <TimeTypeMenu onTimeTypeChange={handleTimeTypeChange}/>
      </div>
      <div className="mb-3">
      <TimeExpression onTimeExpressionChange={handleTimeExpressionChange}/>
      </div>
      <div className="mb-3 me-3">
      <div style={{ display: 'flex', flexWrap: 'wrap' }}>
      {showStartMomentPicker && (<MomentPicker onDateTimeChange={setSelectedDateTimeStart}/>)
      }
      {showEndMomentPicker && (<MomentPicker onDateTimeChange={setSelectedDateTimeEnd} />)}
      {showStartDayPicker && (<DayPicker onDateTimeChange={setSelectedDateTimeStart}/>)}
      {showEndDayPicker && (<DayPicker onDateTimeChange={setSelectedDateTimeEnd} />)}
      {showStartMonthPicker && (<MonthPicker onDateTimeChange={setSelectedDateTimeStart} />)}
      {showEndMonthPicker && (<MonthPicker onDateTimeChange={setSelectedDateTimeEnd} />)}
      {showStartSeasonPicker && (
        <SeasonPicker 
          onDateTimeChange={(date, season) => {
          setSelectedDateTimeStart(date);
          setSelectedSeasonStart(season);
        }}
        />
      )}
      {showEndSeasonPicker && (
        <SeasonPicker 
            onDateTimeChange={(date, season) => {
            setSelectedDateTimeEnd(date);
            setSelectedSeasonEnd(season);
          }}
        />
    )}
      {showStartYearPicker && (<YearPicker onDateTimeChange={setSelectedDateTimeStart} />)}
      {showEndYearPicker && (<YearPicker onDateTimeChange={setSelectedDateTimeEnd} />)}
      {showStartDecadePicker && (<DecadePicker onDateTimeChange={setSelectedDecadeStart} />)}
      {showEndDecadePicker && (<DecadePicker onDateTimeChange={setSelectedDecadeEnd} />)}
      {showStartDecadeSeasonPicker && (
        <div>
          <DecadePicker onDateTimeChange={setSelectedDecadeStart} />
          <SeasonMenu onSeasonSelect={setSelectedSeasonStart} />
        </div>
      )}
      {showEndDecadeSeasonPicker && (
        <div>
          <DecadePicker onDateTimeChange={setSelectedDecadeEnd} />
          <SeasonMenu onSeasonSelect={setSelectedSeasonEnd} />
        </div>
      )}
      </div>
      </div>
      </Col>
      </Row>
    </div>
    </div>
    
  )
}

export default DateTimerPicker