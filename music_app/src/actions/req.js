import * as types from '../types/req';

export const doRequest = (action) => ({ 
    ...action
})

export const remReqInfo = () => ({
    type: types.REMOVE_REQINFO
})