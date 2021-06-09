import React from "react"; 
import { connect } from "react-redux";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faShoppingCart } from "@fortawesome/free-solid-svg-icons";

import * as actions from "../../../actions/shoppingcart";

const itemStyle = {
  padding: "20px",
  borderRadius: "40px",
  margin: "20px",
  marginBottom: "50px",
  background: "#ACC5EB",
};

const Album = ({ album, onClick }) => {
  return (
    <div className="jumbotron media" style={itemStyle}>
      <img
        classname=""
        src="https://cdn.onlinewebfonts.com/svg/img_375331.png"
      />
      <div className="media-body">
        <h5 className="mt-0">{album.name}</h5>
        <hr></hr>
        <div className="info">
          <div>
            <div className="col-7">Aritsta:</div>
            <div className="col-4">{album.artist}</div>
          </div>
          <div className="add-shopping-cart" onClick={() => onClick(album)}>
            <FontAwesomeIcon icon={faShoppingCart} />
          </div>
        </div>
        <hr></hr>
      </div>
    </div>
  );
};

export default connect(undefined, (dispatch) => ({
  onClick(album) {
    dispatch(actions.addAlbum(album));
  },
}))(Album);
