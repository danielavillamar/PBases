import React from "react"; 

import "./styles.css";

const BinnacleRow = ({ rowInfo }) => {
  return (
    <div className="binnacle-row">
      <div className="binnacle-cell">{rowInfo.date}</div>
      <div className="binnacle-cell">{rowInfo.time}</div>
      <div className="binnacle-cell">{rowInfo.usuario}</div>
      <div className="binnacle-cell">{rowInfo.tipo}</div>
      <div className="binnacle-cell">{rowInfo.modified_table}</div>
    </div>
  );
};

export default BinnacleRow;
