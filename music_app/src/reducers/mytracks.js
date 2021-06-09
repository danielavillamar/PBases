import { combineReducers } from "redux";
import * as types from "../types/mytracks";

const myTracks = (state = null, action) => {
  switch (action.type) {
    case types.GET_MY_SPONGS:
      return { ...action.payload.mySongs }; 
    case types.REMOVE_MY_SONGS:
      return null;
    default:
      return null;
  }
};

const myTracksInfo = combineReducers({
  myTracks,
});

export default myTracksInfo;

export const getMyTracks = (state) => state.myTracks;
