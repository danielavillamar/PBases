import React from "react"; 

import BinnacleRow from "./BitacoraRow/bitacorarow";
import * as selectors from "../../../reducers";

import "./styles.css";
import { connect } from "react-redux";

const Bitacora = ({ binnacle }) => {
  return (
    <div className="binnacle-main-container">
      <div className="binnacle-container">
        <h2>Bitacora</h2>
        <div className="binnacle-titles">
          <div className="binnacle-title">Date</div>
          <div className="binnacle-title">Time</div>
          <div className="binnacle-title">Usuario</div>
          <div className="binnacle-title">Type</div>
          <div className="binnacle-title">Modified Table</div>
        </div>
        <div className="binnacle-rows">
          {binnacle ? (
            Object.values(binnacle).map((binnacleRow) => (
              <BinnacleRow rowInfo={binnacleRow} />
            ))
          ) : (
            <div> Aun no hay registros </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default connect((state) => ({
  binnacle: selectors.getBinnacle(state)
    ? selectors.getBinnacle(state)
    : undefined,
}))(Bitacora);
