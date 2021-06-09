import * as types from '../types/stats'; 
import { combineReducers } from 'redux';

const isLoading = (state = false, action) => {
    switch(action.type){
        case types.STATS_LOADING:
            return true
        case types.STATS_LOADED:
            return false
        case types.STATS_ERROR:
            return false
        case types.LOGOUT_SUCCESS:
            return false
        default:
            return state
    }
}

const statsInfo = (state = {}, action) => {
    switch(action.type){
        case types.STATS_LOADED:
            return {
                ...state,
                ...action.payload,
            }
        case types.LOGOUT_SUCCESS:
            return {}
        default:
            return state
    }
}

const stats = combineReducers({
    isLoading,
    statsInfo,
})

export default stats;

export const getIsLoading = (state) => state.isLoading

export const getStats = (state, graphNum) => state.statsInfo[graphNum]