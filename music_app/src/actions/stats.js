import * as types from '../types/stats'; 

export const loadStats = () => ({
    type: types.STATS_LOADING
})

export const loadedStats = action => ({
    type: types.STATS_LOADED,
    payload: {...action.payload}
})