import * as types from '../types/artists';
import { combineReducers } from 'redux';

const artistsLoaded = (state = false, action) => {
    switch(action.type){
        case types.ARTISTS_LOADED: 
            return true
        case types.LOGOUT_SUCCESS:
            return false
        default:
            return state
    }
}
const artistsInfo = (state = {}, action) => {
    switch(action.type){
        case types.ARTISTS_LOADED:
            return {...action.payload}
        case types.LOGOUT_SUCCESS:
            return {}
        default:
            return state
    }
}

const artists = combineReducers({
    artistsLoaded,
    artistsInfo,
})

export default artists;

export const getArtistsLoaded = (state) => state.artistsLoaded

export const getArtists = state => state.artistsInfo