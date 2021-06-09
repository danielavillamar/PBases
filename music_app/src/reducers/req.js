import * as types from '../types/req'; 
import { combineReducers } from 'redux';

const success = (state = false, action) => {
    switch(action.type){
        case types.REQUEST_FAIL:
        case types.REQUEST_SUCCESS:
            return true
        case types.REMOVE_REQINFO:
            return false
        case types.LOGOUT_SUCCESS:
            return false
        default:
            return state
    }
}

const mod = (state= false, action) => {
    switch(action.type){
        case types.REQUEST_SUCCESS:
            return true
        case types.REMOVE_REQINFO:
            return false
        case types.LOGOUT_SUCCESS:
            return false
        default:
            return state

    }
}

const msg = (state = '', action) => {
    switch(action.type){
        case types.REQUEST_FAIL:
            return {...action.payload}
        case types.REQUEST_SUCCESS:
            return {...action.payload}
        case types.REMOVE_REQINFO:
            return ''
        case types.LOGOUT_SUCCESS:
            return ''
        default:
            return state
    }
}

const req = combineReducers({
    success,
    msg,
    mod,
})

export default req;

export const getReqSuccess = (state) => state.success

export const getReqMsg = (state) => state.msg

export const getModSuccess = state => state.mod