import { combineReducers } from "redux"; 
import { reducer as formReducer } from "redux-form";

import auth, * as authSelectors from "./auth";
import stats, * as statsSelectors from "./stats";
import req, * as reqSelectors from "./req";
import albums, * as albumsSelectors from "./albums";
import artists, * as artistsSelectors from "./artists";
import tracks, * as tracksSelectors from "./tracks";
import searchSongs, * as searchSongsSelectors from "./searchSongs";
import shoppingCart, * as shoppingCartSelectors from "./shoppingcart";
import myTracksInfo, * as myTracksSelectors from "./mytracks";
import binnacleStats, * as binnacleSelectors from "./bitacora";

const reducer = combineReducers({
  auth,
  stats,
  req,
  albums,
  artists,
  tracks,
  searchSongs,
  shoppingCart,
  myTracksInfo,
  binnacleStats,
  form: formReducer,
});

export default reducer;

export const getUser = (state) => authSelectors.getUser(state.auth);

export const getAuthMsg = (state) => authSelectors.getMsg(state.auth);

export const getIsAuth = (state) => authSelectors.getIsAuth(state.auth);

export const getIsAdminUser = (state) =>
  authSelectors.getIsAdminUser(state.auth);

export const getCreditCard = (state) => authSelectors.getCreditCard(state.auth);

export const getLoadingStats = (state) =>
  statsSelectors.getIsLoading(state.stats);

export const getStats = (state, graphNum) =>
  statsSelectors.getStats(state.stats, graphNum);

export const getReqSuccess = (state) => reqSelectors.getReqSuccess(state.req);

export const getReqMsg = (state) => reqSelectors.getReqMsg(state.req);

export const getModSuccess = (state) => reqSelectors.getModSuccess(state.req);

export const getAlbumsLoaded = (state) =>
  albumsSelectors.getAlbumsLoaded(state.albums);

export const getAlbums = (state) => albumsSelectors.getAlbums(state.albums);

export const getArtistsLoaded = (state) =>
  artistsSelectors.getArtistsLoaded(state.artists);

export const getArtists = (state) => artistsSelectors.getArtists(state.artists);

export const getTracksLoaded = (state) =>
  tracksSelectors.getTracksLoaded(state.tracks);

export const getTracks = (state) => tracksSelectors.getTracks(state.tracks);

export const getSongsLoaded = (state) =>
  searchSongsSelectors.getSongsLoaded(state.searchSongs);

export const getAlbumByArtist = (state) =>
  searchSongsSelectors.getAlbumByArtist(state.searchSongs);

export const getAlbumByName = (state) =>
  searchSongsSelectors.getAlbumByName(state.searchSongs);

export const getTrackByName = (state) =>
  searchSongsSelectors.getTrackByName(state.searchSongs);

export const getTrackByGenre = (state) =>
  searchSongsSelectors.getTrackByGenre(state.searchSongs);

export const getShoppingCartAlbums = (state) =>
  shoppingCartSelectors.getAlbums(state.shoppingCart);

export const getShoppingCartTracks = (state) =>
  shoppingCartSelectors.getTracks(state.shoppingCart);

export const getMyTracks = (state) =>
  myTracksSelectors.getMyTracks(state.myTracksInfo);

export const getTotal = (state) =>
  shoppingCartSelectors.getTotal(state.shoppingCart);

export const getBinnacle = (state) =>
  binnacleSelectors.getBinnacle(state.binnacleStats);
