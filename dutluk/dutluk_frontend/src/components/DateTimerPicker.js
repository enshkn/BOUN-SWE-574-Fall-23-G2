import React from 'react'
import { useState } from 'react'
import TimeTypeMenu from './DateTimePicker/TimeTypeMenu'
import TimeExpression from './DateTimePicker/TimeExpression'
import MomentPicker from './DateTimePicker/MomentPicker'

function DateTimerPicker() {
  const [selectedTimeType, setSelectedTimeType] = useState('');
  const handleTimeTypeChange = (selectedTimeType) => {
    setSelectedTimeType(selectedTimeType);
  };
  const [selectedTimeExpression, setSelectedTimeExpression] = useState('');
  const handleTimeExpressionChange = (selectedTimeExpression) => {
    setSelectedTimeExpression(selectedTimeExpression);
  };

  switch (selectedTimeType) {
    case 'timePoint':
      switch (selectedTimeExpression) {
        case 'moment':
          console.log(selectedTimeType, 'moment selected with switch');
          break;
        case 'day':
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
          console.log(selectedTimeType, 'moment selected with switch');
          break;
        case 'day':
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
      <MomentPicker />

    </div>
    
  )
}

export default DateTimerPicker