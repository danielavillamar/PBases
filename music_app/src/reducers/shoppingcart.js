import { combineReducers } from "redux";
import * as types from "../types/shoppingcart";

const albums = (state = null, action) => {
  switch (action.type) {
    case types.ALBUM_ADDED_SHOPPING_CART:
      const newState = { ...state };
      newState[action.payload.albumInfo.albumid] = {
        ...action.payload.albumInfo,
      };
      return newState;
    case types.SONGS_BOUGHT:
      return null;
    case types.REMOVE_SHOPPING_CART_SONGS:
      return null; 
    default:
      return state;
  }
};
const tracks = (state = null, action) => {
  switch (action.type) {
    case types.TRACK_ADDED_SHOPPING_CART:
      const newState = { ...state };
      newState[action.payload.trackInfo.id] = { ...action.payload.trackInfo };
      return newState;
    case types.SONGS_BOUGHT:
      return null;
    case types.REMOVE_SHOPPING_CART_SONGS:
      return null;
    default:
      return state;
  }
};

const total = (state = 0.0, action) => {
  switch (action.type) {
    case types.TRACK_ADDED_SHOPPING_CART:
      let newState = state;
      newState = newState + parseFloat(action.payload.trackInfo.price);
      return newState;
    case types.ALBUM_ADDED_SHOPPING_CART:
      let newS = state;
      newS = newS + parseFloat(action.payload.albumInfo.albumprice);
      return newS;
    case types.SONGS_BOUGHT:
      return null;
    case types.REMOVE_SHOPPING_CART_SONGS:
      return null;
    default:
      return state;
  }
};

const shoppingCart = combineReducers({
  albums,
  tracks,
  total,
});

export default shoppingCart;

export const getAlbums = (state) => state.albums;
export const getTracks = (state) => state.tracks;
export const getTotal = (state) => state.total;
