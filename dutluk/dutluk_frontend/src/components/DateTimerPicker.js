import React from 'react'
import { useState, useEffect} from 'react'
import 'bootstrap/dist/css/bootstrap.min.css';
import TimeTypeMenu from './DateTimePicker/TimeTypeMenu'
import TimeExpression from './DateTimePicker/TimeExpression'
import MomentPicker from './DateTimePicker/MomentPicker'
import DayPicker from './DateTimePicker/DayPicker'
import MonthPicker from './DateTimePicker/MonthPicker'
import SeasonPicker from './DateTimePicker/SeasonPicker'
import YearPicker from './DateTimePicker/YearPicker'
import DecadePicker from './DateTimePicker/DecadePicker'
import SeasonMenu from './DateTimePicker/SeasonMenu'
import { format, set } from 'date-fns'
import { addDays } from 'date-fns/esm'
import { message } from 'antd';

function DateTimerPicker({
  onTimeTypeSelect,
  onTimeExpressionSelect, 
  onHourFlagSelect, 
  onDateFlagSelect,
  onEndHourFlagSelect,
  onEndDateFlagSelect,
  onTimeStampStartSelect, 
  onTimeStampEndSelect, 
  onSelectedSeasonStart, 
  onSelectedSeasonEnd, 
  onSelectedDecadeStart, 
  onSelectedDecadeEnd,
  onSelectedDateTimeStart,
  onSelectedDateTimeEnd,
  
}) {
  {/* -------------------------------------------------- STATES -------------------------------------------------- */}
  // time type
  const [selectedTimeType, setSelectedTimeType] = useState('');
  const handleTimeTypeChange = (selectedTimeType) => {
    setSelectedTimeType(selectedTimeType);
  };
  // time expression
  const [selectedTimeExpression, setSelectedTimeExpression] = useState('');
  const handleTimeExpressionChange = (selectedTimeExpression) => {
    setSelectedTimeExpression(selectedTimeExpression);
  };
  // date and hour flag
  const [dateFlag, setDateFlag] = useState(-1);
  const [hourFlag, setHourFlag] = useState(-1);
  const [endHourFlag, setEndHourFlag] = useState(-1);
  const [endDateFlag, setEndDateFlag] = useState(-1);
  // timestamp
  const [timeStampStart, setTimeStampStart] = useState(null);
  const [timeStampEnd, setTimeStampEnd] = useState(null);  
  // date time start end
  const [selectedDateTimeStart, setSelectedDateTimeStart] = useState(new Date());
  const [selectedDateTimeEnd, setSelectedDateTimeEnd] = useState(new Date());
  // season
  const [selectedSeasonStart, setSelectedSeasonStart] = useState('');
  const [selectedSeasonEnd, setSelectedSeasonEnd] = useState('');
  // decade
  const [selectedDecadeStart, setSelectedDecadeStart] = useState(null);
  const [selectedDecadeEnd, setSelectedDecadeEnd] = useState(null);

  const seasonDict = { 12:1,
    1:1,
    2:1,
    3:2,
    4:2,
    5:2,
    6:3,
    7:3,
    8:3,
    9:4,
    10:4,
    11:4,
  }


  {/* -------------------------------------------------- FORMATTERS -------------------------------------------------- */}

 // moment formatter
  function formatDate(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
  
    return `${year}-${month}-${day} ${hours}:${minutes}`;
  }
// day formatter
  function dayFormatter_start(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = '00';
    const minutes = '00';
  
    return `${year}-${month}-${day} ${hours}:${minutes}`;
  }

  function dayFormatter_end(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = '23';
    const minutes = '59';
  
    return `${year}-${month}-${day} ${hours}:${minutes}`;
  }  
// month formatter
  function monthStartFormatter(date) {
    const year = date.getFullYear();
    const month  = String(date.getMonth() + 1).padStart(2, '0');
    const day = '01';
    const hours = '00';
    const minutes = '00';

    return `${year}-${month}-${day} ${hours}:${minutes}`;
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
// year formatter
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
// season formatter
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
  
    const formattedStartTime = `${parsedStartYear}-${seasonStartMonth + 1}-01 00:00`;
    const formattedEndTimePoint = `${parsedStartYear}-${seasonEndMonth + 1}-${new Date(parsedStartYear, seasonEndMonth + 1, 0).getDate()} 23:59 `;
  
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
  
      const formattedEndTimeInterval = `${endYear}-${seasonEndMonth + 1}-${new Date(parsedEndYear, seasonEndMonth + 1, 0).getDate()} 23:59:59`;
  
      return { formattedStartTime, formattedEndTime: formattedEndTimeInterval };
    }
  
    return "Invalid timeType or insufficient parameters!";
  }
// decade formatter
  function getDecadeRangePoint(decade) {
    const startYear = decade;
    const endYear = decade + 9;
  
    
    const startDate = new Date(startYear, 0, 1, 0, 0, 0); 
    const endDate = new Date(endYear, 11, 31, 23, 59, 59);
  
    return { startDate, endDate };
  }

{/* -------------------------------------------------- SHOWING ELEMENTS AND VARIABLES -------------------------------------------------- */}
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

// variables for formatted date
  let formattedDateTimeStart = '';
  let formattedDateTimeEnd = '';
  let var_dateFlag = -1;
  let var_hourFlag = -1;
  let var_endHourFlag = -1;
  let var_endDateFlag = -1;

{/* -------------------------------------------------- RESET FORMS -------------------------------------------------- */}


  // reset form
  const resetForm = () => {
    setSelectedTimeExpression('');
    setSelectedDateTimeStart(new Date());
    setSelectedDateTimeEnd(new Date());
    setSelectedSeasonStart(null);
    setSelectedSeasonEnd(null);
    setSelectedDecadeStart(null);
    setSelectedDecadeEnd(null);
    setTimeStampStart(null);
    setTimeStampEnd(null);
    setDateFlag(-1);
    setHourFlag(-1);
    setEndHourFlag(-1);
    setEndDateFlag(-1);
  };
    // Reset the form when the selectedTimeType changes
    useEffect(() => {
      resetForm();
    }, [selectedTimeType]);

  const resetFormExpression = () => {
      setSelectedDateTimeStart(new Date());
      setSelectedDateTimeEnd(new Date());
      setSelectedSeasonStart(null);
      setSelectedSeasonEnd(null);
      setSelectedDecadeStart(null);
      setSelectedDecadeEnd(null);
      setTimeStampStart(null);
      setTimeStampEnd(null);
      setDateFlag(-1);
      setHourFlag(-1);
      setEndHourFlag(-1);
      setEndDateFlag(-1);
    };
    
    // Reset the form when the selectedTimeType changes
    useEffect(() => {
      resetFormExpression();
    }, [selectedTimeExpression]);

    // update timestamp when selectedDateTimeStart and selectedDateTimeEnd changes
    useEffect(() => {
    setTimeStampStart(formattedDateTimeStart);
    setTimeStampEnd(formattedDateTimeEnd);
    setDateFlag(var_dateFlag);
    setHourFlag(var_hourFlag);
    setEndHourFlag(var_endHourFlag);
    setEndDateFlag(var_endDateFlag);
    })

    // log timestamp when selectedDateTimeStart and selectedDateTimeEnd changes
    useEffect(() => {
      console.log("date flag: ", dateFlag, "hour flag: ", hourFlag, "time stamp end:", timeStampEnd, "time stamp start: ", timeStampStart, "end hour flag: ", endHourFlag, "end date flag: ", endDateFlag);
    }, [dateFlag, hourFlag, timeStampEnd, timeStampStart, endHourFlag, endDateFlag]);
    
    {/*  // this code block alreadt exists in the parent component

    useEffect(() => {
      if (selectedDateTimeStart && selectedDateTimeEnd && selectedDateTimeStart > selectedDateTimeEnd) {
      ('Start date should be before the end date');
      }
    }, [selectedDateTimeStart, selectedDateTimeEnd]);

    useEffect(() => {
      if (selectedDecadeStart && selectedDecadeEnd && selectedDecadeStart > selectedDecadeEnd) {
        alert('Start date should be before the end date');
      }
    }, [selectedDecadeStart, selectedDecadeEnd]);
    */}
  // props 
  
  { 
   // single props example 
  /*
  useEffect(() => {
    onTimeTypeSelect(selectedTimeType);
  }, [selectedTimeType, onTimeTypeSelect]);
  */
 }
{/* -------------------------------------------------- PROPS  -------------------------------------------------- */}
  useEffect(() => {
    onTimeTypeSelect(selectedTimeType);
    onTimeExpressionSelect(selectedTimeExpression);
    onSelectedDateTimeStart(selectedDateTimeStart);
    onSelectedDateTimeEnd(selectedDateTimeEnd);
    onHourFlagSelect(hourFlag);
    onDateFlagSelect(dateFlag);
    onEndHourFlagSelect(endHourFlag);
    onEndDateFlagSelect(endDateFlag);
    onTimeStampStartSelect(timeStampStart);
    onTimeStampEndSelect(timeStampEnd);
    onSelectedSeasonStart(selectedSeasonStart);
    onSelectedSeasonEnd(selectedSeasonEnd);
    onSelectedDecadeStart(selectedDecadeStart);
    onSelectedDecadeEnd(selectedDecadeEnd);

  }, [
    selectedTimeType,
    selectedTimeExpression,
    selectedDateTimeStart,
    selectedDateTimeEnd,
    hourFlag,
    dateFlag,
    endHourFlag,
    endDateFlag,
    timeStampStart,
    timeStampEnd,
    selectedSeasonStart,
    selectedSeasonEnd,
    selectedDecadeStart,
    selectedDecadeEnd,
    onTimeTypeSelect,
    onTimeExpressionSelect,
    onSelectedDateTimeStart,
    onSelectedDateTimeEnd,
    onHourFlagSelect,
    onDateFlagSelect,
    onEndHourFlagSelect,
    onEndDateFlagSelect,
    onTimeStampStartSelect,
    onTimeStampEndSelect,
    onSelectedSeasonStart,
    onSelectedSeasonEnd,
    onSelectedDecadeStart,
    onSelectedDecadeEnd,
  ]);
  

    {/* -------------------------------------------------- PICKER LOGIC  -------------------------------------------------- */}
  

  switch (selectedTimeType) {

    case 'timePoint':
      switch (selectedTimeExpression) {
        case 'moment':
          // showing relevant picker
          showStartMomentPicker = true;
          // formatting date
          formattedDateTimeStart = formatDate(selectedDateTimeStart);
          formattedDateTimeEnd = formattedDateTimeStart;
          // for backend timestamp configuration
          formattedDateTimeEnd = null;
          // flags
          var_dateFlag = 3;
          var_hourFlag = 1;
          var_endHourFlag = -1;
          var_endDateFlag = -1;
          break;
        case 'day':
          // showing relevant picker
          showStartDayPicker = true;
          // formatting date
          formattedDateTimeStart = dayFormatter_start(selectedDateTimeStart);
          formattedDateTimeEnd = dayFormatter_end(selectedDateTimeStart);
          // for backend timestamp configuration
          formattedDateTimeEnd = null;
          // flags
          var_dateFlag = 3;
          var_hourFlag = 0;
          var_endHourFlag = -1;
          var_endDateFlag = -1;
          break;
        case 'month':
          // showing relevant picker
          showStartMonthPicker = true;
          // formatting date
          formattedDateTimeStart = monthStartFormatter(selectedDateTimeStart);
          formattedDateTimeEnd = monthEndFormatter(selectedDateTimeStart);
          // for backend timestamp configuration
          formattedDateTimeEnd = null;
          // flags
          var_dateFlag = 2;
          var_hourFlag = 0;
          var_endHourFlag = -1;
          var_endDateFlag = -1;
          break;
        case 'season':
          showStartSeasonPicker = true;
          formattedDateTimeStart = formatDate(selectedDateTimeStart);
          // parsing year
          // let startYear = new Date(formattedDateTimeStart).getFullYear();
          //let startMonth = new Date(formattedDateTimeStart).getMonth();
          // let intSeasonStart = seasonDict[startMonth];
          // calculating season dates
          //const result = calculateSeasonDates(startYear, intSeasonStart, selectedTimeType);
          //formattedDateTimeStart = result.formattedStartTime;
          // formattedDateTimeEnd = result.formattedEndTime;
          // for backend timestamp configuration
          formattedDateTimeStart = yearStartFormatter(selectedDateTimeStart);
          formattedDateTimeEnd = null;
          var_dateFlag = 1;
          var_endDateFlag = -1;
          var_hourFlag = 0;
          var_endHourFlag = -1;
          break;
        case 'year':
          // showing relevant picker
          showStartYearPicker = true;
          // formatting date
          formattedDateTimeStart = yearStartFormatter(selectedDateTimeStart);
          formattedDateTimeEnd = yearEndFormatter(selectedDateTimeStart);
          // for backend timestamp configuration
          formattedDateTimeEnd = null;
          // flags
          var_dateFlag = 1;
          var_hourFlag = 0;
          var_endHourFlag = -1;
          var_endDateFlag = -1;
          break;
        case 'decade':
          // showing relevant picker
          showStartDecadePicker = true;
          // obtain decade range
          const decade_result = getDecadeRangePoint(selectedDecadeStart);
          let decade_start = decade_result.startDate;
          let decade_end = decade_result.endDate;
          // formatting date
          formattedDateTimeStart = formatDate(decade_start);
          formattedDateTimeEnd = formatDate(decade_end)
          // for backend timestamp configuration
          formattedDateTimeStart = null;
          formattedDateTimeEnd = null;
          break;
        case 'decade+season':
          showStartDecadeSeasonPicker = true;
          break;
      }
      break;
    case 'timeInterval':
      switch (selectedTimeExpression) {
        case 'moment':
          // showing relevant picker
          showStartMomentPicker = true;
          showEndMomentPicker = true;
          // formatting date
          formattedDateTimeStart = formatDate(selectedDateTimeStart);
          formattedDateTimeEnd = formatDate(selectedDateTimeEnd);
          // flags
          var_dateFlag = 3;
          var_hourFlag = 1;
          var_endDateFlag = 3;
          var_endHourFlag = 1;
          break;
        case 'day':
          // showing relevant picker
          showStartDayPicker = true;
          showEndDayPicker = true;
          // formatting date
          formattedDateTimeStart = dayFormatter_start(selectedDateTimeStart);
          formattedDateTimeEnd = dayFormatter_end(selectedDateTimeEnd);
          // flags
          var_dateFlag = 3;
          var_hourFlag = 0;
          var_endDateFlag = 3;
          var_endHourFlag = 0;
          break;
        case 'month':
          // showing relevant picker
          showStartMonthPicker = true;
          showEndMonthPicker = true;
          // formatting date
          formattedDateTimeStart = monthStartFormatter(selectedDateTimeStart);
          formattedDateTimeEnd = monthEndFormatter(selectedDateTimeEnd);
          // flags
          var_dateFlag = 2;
          var_hourFlag = 0;
          var_endDateFlag = 2;      
          var_endHourFlag = 0; 
          break;
        case 'season':
          // showing relevant picker
          showStartSeasonPicker = true;
          showEndSeasonPicker = true;
          // formatting date
          //formattedDateTimeStart = formatDate(selectedDateTimeStart);
          //formattedDateTimeEnd = formatDate(selectedDateTimeEnd);
          // parsing year
          //let startYear = new Date(formattedDateTimeStart).getFullYear();
          //let endYear = new Date(formattedDateTimeEnd).getFullYear();
          //let startMonth = new Date(formattedDateTimeStart).getMonth();
          //let endMonth = new Date(formattedDateTimeEnd).getMonth();
          // parsing season
          //let intSeasonStart = seasonDict[startMonth];
          //let intSeasonEnd = seasonDict[endMonth];
          // calculating season dates
          //const result = calculateSeasonDates(startYear, intSeasonStart, selectedTimeType, endYear, intSeasonEnd);
          // formatting date
          //formattedDateTimeStart = result.formattedStartTime;
          //formattedDateTimeEnd = result.formattedEndTime;
          formattedDateTimeStart = yearStartFormatter(selectedDateTimeStart);
          formattedDateTimeEnd = yearEndFormatter(selectedDateTimeEnd);
          var_dateFlag = 1;
          var_endDateFlag = 1;
          var_hourFlag = 0;
          var_endHourFlag = 0;
          break;
        case 'year':
          // showing relevant picker
          showStartYearPicker = true;
          showEndYearPicker = true;
          // formatting date
          formattedDateTimeStart = yearStartFormatter(selectedDateTimeStart)
          formattedDateTimeEnd = yearEndFormatter(selectedDateTimeEnd)
          // flags
          var_dateFlag = 1;
          var_hourFlag = 0;
          var_endDateFlag = 1;
          var_endHourFlag = 0;
          break;
        case 'decade':
          // showing relevant picker
          showStartDecadePicker = true;
          showEndDecadePicker = true;
          // obtain decade range
          let decade_result_start = getDecadeRangePoint(selectedDecadeStart);
          let decade_result_end = getDecadeRangePoint(selectedDecadeEnd);
          let decade_start = decade_result_start.startDate;
          let decade_end = decade_result_end.endDate;
          // formatting date
          formattedDateTimeStart = formatDate(decade_start);
          formattedDateTimeEnd = formatDate(decade_end)
          formattedDateTimeStart = null;
          formattedDateTimeEnd = null;
          break;
        case 'decade+season':
          showStartDecadeSeasonPicker = true;
          showEndDecadeSeasonPicker = true;

          break;
      }
      break;
      default:
      break;
  }
  return (
    <div className='container'>
    <div className='row'>
    <div className="col-md-6">
    <br></br>
    <div><i>Select a time resolotion which express best your story</i>
    <div className="my-2">
      <TimeTypeMenu onTimeTypeChange={handleTimeTypeChange}/>
      </div>
      <div className="my-2">
      <TimeExpression onTimeExpressionChange={handleTimeExpressionChange}/>
      </div>
      <div style={{ display: 'flex' }}>
      {showStartMomentPicker && (<MomentPicker onDateTimeChange={setSelectedDateTimeStart}/>)}
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
      {showStartDecadeSeasonPicker && 
      (<div>
        <DecadePicker onDateTimeChange={setSelectedDecadeStart} />
        <SeasonMenu onSeasonSelect={setSelectedSeasonStart} />
      </div>)}
      {showEndDecadeSeasonPicker && 
      (<div>
        <DecadePicker onDateTimeChange={setSelectedDecadeEnd} />
        <SeasonMenu onSeasonSelect={setSelectedSeasonEnd} />
      </div>)}
      </div>
    </div>
    </div>
    </div>
    </div> 
    
  )
}

export default DateTimerPicker