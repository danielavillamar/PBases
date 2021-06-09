import * as types from "../types/searchSong";
import { combineReducers } from "redux";

const songsLoaded = (state = false, action) => {
  switch (action.type) {
    case types.ADD_SEARCHED_SONGS:
      return true;
    case types.LOGOUT_SUCCESS:
      return false; 
    default:
      return state;
  }
};

const albumByArtist = (state = {}, action) => {
  switch (action.type) {
    case types.ADD_SEARCHED_SONGS:
      return {
        ...action.payload.albumByArtist,
      };
    case types.LOGOUT_SUCCESS:
      return {};
    default:
      return state;
  }
};

const albumByAlbum = (state = {}, action) => {
  switch (action.type) {
    case types.ADD_SEARCHED_SONGS:
      return {
        ...action.payload.albumByAlbum,
      };
    case types.LOGOUT_SUCCESS:
      return {};
    default:
      return state;
  }
};

const trackByName = (state = {}, action) => {
  switch (action.type) {
    case types.ADD_SEARCHED_SONGS:
      return {
        ...action.payload.trackByName,
      };
    case types.LOGOUT_SUCCESS:
      return {};
    default:
      return state;
  }
};

const trackByGenre = (state = {}, action) => {
  switch (action.type) {
    case types.ADD_SEARCHED_SONGS:
      return {
        ...action.payload.trackByGenre,
      };
    case types.LOGOUT_SUCCESS:
      return {};
    default:
      return state;
  }
};

const searchSongs = combineReducers({
  songsLoaded,
  albumByAlbum,
  albumByArtist,
  trackByName,
  trackByGenre,
});

export default searchSongs;

export const getSongsLoaded = (state) => state.songsLoaded;

export const getAlbumByArtist = (state) => state.albumByArtist;

export const getAlbumByName = (state) => state.albumByAlbum;

export const getTrackByName = (state) => state.trackByName;

export const getTrackByGenre = (state) => state.trackByGenre;
