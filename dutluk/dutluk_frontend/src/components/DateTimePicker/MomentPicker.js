import React from 'react'
import { useState } from 'react'
import ReactDatePicker from 'react-datepicker'
import 'react-datepicker/dist/react-datepicker.css'


function MomentPicker() {
const [startDate, setStartDate] = useState(new Date());

  return (
    <div>
        <ReactDatePicker
              selected={startDate}
              onChange={(date) => setStartDate(date)}
              timeInputLabel="Time:"
              dateFormat="dd/MM/yyyy h:mm aa"
              showTimeInput
        />
    </div>
  )
}

export default MomentPicker