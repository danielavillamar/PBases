import * as types from '../types/tracks'; 
import { combineReducers } from 'redux';

const tracksLoaded = (state = false, action) => {
    switch(action.type){
        case types.TRACKS_LOADED:
            return true
        case types.LOGOUT_SUCCESS:
            return false
        default:
            return state
    }
}
const tracksInfo = (state = {}, action) => {
    switch(action.type){
        case types.TRACKS_LOADED:
            return {...action.payload}
        case types.LOGOUT_SUCCESS:
            return {}
        default:
            return state
    }
}

const tracks = combineReducers({
    tracksLoaded,
    tracksInfo,
})

export default tracks;

export const getTracksLoaded = (state) => state.tracksLoaded

export const getTracks = state => state.tracksInfo