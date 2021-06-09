import * as types from '../types/auth'; 
import { combineReducers } from 'redux';

const authInfo = (state = {user: null, isAuthenticated: false, isLoading: false, msg: '', isAdminUser: false}, action) => {
    switch(action.type) {
        case types.USER_LOADING:
            return {
                ...state,
                isLoading: true
            }
        case types.USER_LOADED:
            return {
                ...state,
                isAuthenticated: true,
                isLoading: false,
                user: action.payload
            }
        case types.LOGIN_SUCCESS:
        case types.REGISTER_SUCCES:
            return {
                ...state,
                ...action.payload,
                isAuthenticated: true,
                isLoading: false
            }
        case types.AUTH_ERROR:
        case types.LOGIN_FAIL:
        case types.REGISTER_FAIL:
            return {
                ...state,
                ...action.payload,
                user: null,
                isAuthenticated: false,
                isLoading: false,
            }
        case types.CLEAR_ERRORS:
            return{
                ...state,
                msg: null
            }
        case types.LOGOUT_SUCCESS:
            return{
                user: null,
                isAuthenticated: false, 
                isLoading: false, 
                msg: '', 
                isAdminUser: false,
            }
        default: return state;
    }
}

const creditCard = (state = false, action) => {
    switch(action.type){
        case types.CREDITCARD_ADDED:
            return true
        case types.LOGOUT_SUCCESS:
            return false
        default:
            return state
    }
}

const auth = combineReducers({
    authInfo,
    creditCard,
})

export default auth;

export const getUser = state => state.authInfo.user

export const getMsg = state => state.authInfo.msg

export const getIsAuth = state => state.authInfo.isAuthenticated

export const getIsAdminUser = state => state.authInfo.isAdminUser

export const getCreditCard = state => state.creditCard