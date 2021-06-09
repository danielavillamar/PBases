import { combineReducers } from "redux"; 

import * as types from "../types/bitacora";

const binnacle = (state = null, action) => {
  switch (action.type) {
    case types.GET_BINNACLE:
      return { ...action.payload.binnacle };
    default:
      return state;
  }
};

const binnacleStats = combineReducers({
  binnacle,
});

export default binnacleStats;

export const getBinnacle = (state) => state.binnacle;
