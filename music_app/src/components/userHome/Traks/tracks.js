import React from "react"; 
import { connect } from "react-redux";
import { Link, Redirect } from "react-router-dom";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faShoppingCart } from "@fortawesome/free-solid-svg-icons";

import * as selectors from "../../../reducers";
import * as actions from "../../../actions/shoppingcart";

import "./styles.css";
import makeRequest from "../../requests";

const itemStyle = {
  padding: "20px",
  borderRadius: "40px",
  margin: "20px",
  marginBottom: "50px",
  background: "#ACC5EB",
};

const Track = ({ track, onClick, myTrack, onPlay, currentUser }) => {
  if (track) {
    return (
      <div className="" style={itemStyle}>
        <img
          classname=""
          src="https://cdn.onlinewebfonts.com/svg/img_375331.png"
        />
        <div className="">
          <h5 className="">{track.name}</h5>
          <hr></hr>
          <div className="info">
            <div className="">
              <div className="">Aritsta:</div>
              <div className="">{track.artist}</div>
            </div>
            <div className="add-shopping-cart" onClick={() => onClick(track)}>
              <FontAwesomeIcon icon={faShoppingCart} />
            </div>
          </div>
          <hr></hr>
        </div>
      </div>
    );
  }
  if (myTrack) {
    return (
      <a
        href={myTrack.url}
        target="_blank"
        onClick={() => onPlay(myTrack.id, currentUser)}
      >
        <div className="" style={itemStyle}>
          <img
            classname=""
            src="https://cdn.onlinewebfonts.com/svg/img_375331.png"
          />
          <div className="">
            <h5 className="">{myTrack.name}</h5>
            <hr></hr>
            <div className="info">
              <div className="">
                {myTrack.artist ? (
                  <div>
                    <div className="">Aritsta:</div>
                    <div className="">{myTrack.artist}</div>
                  </div>
                ) : null}
              </div>
            </div>
            <hr></hr>
          </div>
        </div>
      </a>
    );
  }
};

export default connect(
  (state) => ({
    currentUser: selectors.getUser(state),
  }),
  (dispatch) => ({
    onClick(track) {
      dispatch(actions.addTrack(track));
    },
    onPlay(trackId, currentUser) {
      const values = { trackId, currentUser };
      const requestInfo = {
        uri: `http://localhost:8000/add-rep`,
        type: "PUT",
      };
      makeRequest(values, requestInfo, (res) => {
        console.log(res);
      });
    },
  })
)(Track);
