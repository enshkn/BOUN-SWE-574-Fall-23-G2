import React from 'react';
import { Form } from 'react-bootstrap';

function DecadePicker({ selectedDecade, onChange }) {
  const decades = [];
  const currentYear = new Date().getFullYear();
  const startDecade = Math.floor(currentYear / 10) * 10; // Bulunduğumuz on yılın başlangıç yılı

  // Geçmişten şu andaki on yılın başlangıcına kadar olan on yılları listeye ekleme
  for (let decadeStart = startDecade; decadeStart >= 1900; decadeStart -= 10) {
    decades.push(decadeStart);
  }

  return (
    <Form.Select
      value={selectedDecade}
      onChange={(e) => {
        onChange(parseInt(e.target.value));
      }}
    >
      <option value="">Select Decade</option>
      {decades.map((decade) => (
        <option key={decade} value={decade}>
          {decade}-{decade + 9}
        </option>
      ))}
    </Form.Select>
  );
}

export default DecadePicker;