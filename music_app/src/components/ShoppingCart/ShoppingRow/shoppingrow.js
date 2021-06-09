import React from "react"; 

import "./styles.css";

const ShoppingRow = ({ trackInfo, albumInfo }) => {
  if (trackInfo) {
    return (
      <div className="row">
        <div className="row-info">
          <div className="row-info-spec">
            <h5>Track ID: </h5>
            {trackInfo.id}
          </div>
          <div className="row-info-spec">
            <h5>Track Name:</h5>
            {trackInfo.name}
          </div>
          <div className="row-info-spec">
            <h5>Artist:</h5>
            {trackInfo.artist}
          </div>
        </div>
        <div className="row-price">{trackInfo.price}</div>
      </div>
    );
  }
  if (albumInfo) {
    return (
      <div className="row">
        <div className="row-info">
          <div className="row-info-spec">
            <h5>Album ID: </h5>
            {albumInfo.albumid}
          </div>
          <div className="row-info-spec">
            <h5>Album Name:</h5>
            {albumInfo.name}
          </div>
          {albumInfo.artist ? (
            <div className="row-info-spec">
              <h5>Artist:</h5>
              {albumInfo.artist}
            </div>
          ) : null}
        </div>
        <div className="row-price">{albumInfo.albumprice}</div>
      </div>
    );
  }
};

export default ShoppingRow;
