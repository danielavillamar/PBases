import * as types from "../types/bitacora";

export const getBinnacle = (binnacle) => ({ 
  type: types.GET_BINNACLE,
  payload: { binnacle },
});
