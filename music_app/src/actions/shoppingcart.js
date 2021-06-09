import * as types from "../types/shoppingcart";

export const addAlbum = (albumInfo) => ({ 
  type: types.ALBUM_ADDED_SHOPPING_CART,
  payload: { albumInfo },
});

export const addTrack = (trackInfo) => ({
  type: types.TRACK_ADDED_SHOPPING_CART,
  payload: { trackInfo },
});

export const songsBought = (action) => ({
  ...action,
});

export const removeShoppingcartList = () => ({
  type: types.REMOVE_SHOPPING_CART_SONGS,
});
