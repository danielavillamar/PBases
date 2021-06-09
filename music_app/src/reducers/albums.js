import * as types from '../types/albums'; 
import { combineReducers } from 'redux';

const albumsLoaded = (state = false, action) => {
    switch(action.type){
        case types.ALBUMS_LOADED:
            return true
        case types.LOGOUT_SUCCESS:
            return false
        default:
            return state
    }
}
const albumsInfo = (state = {}, action) => {
    switch(action.type){
        case types.ALBUMS_LOADED:
            return {...action.payload}
            case types.LOGOUT_SUCCESS:
                return {}
        default:
            return state
    }
}

const albums = combineReducers({
    albumsLoaded,
    albumsInfo,
})

export default albums;

export const getAlbumsLoaded = (state) => state.albumsLoaded

export const getAlbums = state => state.albumsInfo
