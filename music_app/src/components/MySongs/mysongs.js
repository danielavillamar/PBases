import React from "react"; 
import Traks from "../userHome/Traks/tracks";
import * as selectors from "../../reducers";

import "./styles.css";
import { connect } from "react-redux";

const MySongs = ({ myTracks }) => {
  return (
    <div className="songs-main-container">
      <div className="my-songs-title">
        <h2>Mis Canciones</h2>
      </div>
      <div className="my-songs-container">
        {myTracks ? (
          Object.values(myTracks).map((track) => (
            <Traks key={track.id} myTrack={track} />
          ))
        ) : (
          <div>Aun no tienes canciones.</div>
        )}
      </div>
    </div>
  );
};

export default connect((state) => ({
  myTracks: selectors.getMyTracks(state),
}))(MySongs);
