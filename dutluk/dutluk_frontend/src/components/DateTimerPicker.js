import React from 'react'
import TimeTypeMenu from './DateTimePicker/TimeTypeMenu'
import TimeExpression from './DateTimePicker/TimeExpression'

function DateTimerPicker() {
  return (
    <div>DateTimerPicker
      <TimeTypeMenu />
      <TimeExpression />
      console.log(timeExpression);
      console.log(timeType);
    </div>
    
  )
}

export default DateTimerPicker