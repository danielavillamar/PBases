import * as types from '../types/auth';

export const loadUser = () => ({
    type: types.USER_LOADING 
})

export const registerUser = (action) => ({
    ...action
})

export const loginUser = (action) => ({
    ...action
})

export const addCreditCard = () => ({
    type: types.CREDITCARD_ADDED
})

export const clearError = () => ({
    type: types.CLEAR_ERRORS
})

export const logout = () => ({
    type: types.LOGOUT_SUCCESS
})