import React from "react"; 
import ShoppingRow from "./ShoppingRow/shoppingrow";
import { connect } from "react-redux";
import Pdf from "react-to-pdf";

import * as selectors from "../../reducers";
import * as actions from "../../actions/shoppingcart";

import "./styles.css";
import makeRequest from "../requests";

const ref = React.createRef();

const ShoppingCart = ({ tracks, albums, onClick, currentUser, total }) => {
  if (tracks || albums) {
    return (
      <div className="shopping-cart-main-container">
        <div className="receipt-container">
          <div className="pdf-container" ref={ref}>
            <h2>Detalle de Compra</h2>
            <hr></hr>
            <div className="receipt-headers">
              <div className="receipt-description">
                <h4>Description</h4>
              </div>
              <div className="receipt-price">
                <h4>Price</h4>
              </div>
            </div>
            <div className="rows-container">
              {tracks
                ? Object.values(tracks).map((track) => (
                    <ShoppingRow trackInfo={track} />
                  ))
                : null}
              {albums
                ? Object.values(albums).map((album) => (
                    <ShoppingRow albumInfo={album} />
                  ))
                : null}
              <div className="shopping-cart-total">
                <div className="total">
                  <h4>Total</h4>
                </div>
                <div className="amount">{total}</div>
              </div>
            </div>
          </div>
          <Pdf targetRef={ref} filename="receipt.pdf">
            {({ toPdf }) => {
              return (
                <div onClick={toPdf}>
                  <div
                    className="shopping-cart-btn"
                    onClick={() => onClick(tracks, albums, total, currentUser)}
                  >
                    Comprar
                  </div>
                </div>
              );
            }}
          </Pdf>
        </div>
      </div>
    );
  }
  return (
    <div className="shopping-cart-main-container">
      <div className="receipt-container">Aun no tienes nada en tu carrito.</div>
    </div>
  );
};

export default connect(
  (state) => ({
    tracks: selectors.getShoppingCartTracks(state),
    albums: selectors.getShoppingCartAlbums(state),
    total: selectors.getTotal(state),
    currentUser: selectors.getUser(state),
  }),
  (dispatch) => ({
    onClick(tracks, albums, total, currentUser) {
      let fullTracksList = {};
      fullTracksList = { ...tracks };
      if (albums) {
        Object.values(albums).map((album) => {
          Object.values(album.tracks).map((track) => {
            fullTracksList[track.id] = { ...track };
          });
        });
      }

      const values = {
        fullTracksList,
        total,
        currentUser,
      };

      const requestInfo = {
        uri: `http://localhost:8000/buy-songs`,
        type: "POST",
      };
      makeRequest(values, requestInfo, (res) => {
        dispatch(actions.songsBought(res.action));
      });
    },
  })
)(ShoppingCart);
