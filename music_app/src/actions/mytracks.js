import * as types from "../types/mytracks";

export const getMyTracks = (action) => ({ 
  ...action,
});

export const removeMyTracks = () => ({
  type: types.REMOVE_MY_SONGS,
});
