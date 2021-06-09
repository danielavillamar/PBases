import React from 'react';
import { useClearCache } from "react-clear-cache";
 
const clearCache = () => { 
  useClearCache.emptyCacheStorage();
  return (
    <div>
        
    </div>
  );
};

export default clearCache;