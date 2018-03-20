import { combineReducers } from 'redux';

import uploadQueue from './upload-queue';

const baseReducer = combineReducers({
  uploadQueue
});

export default baseReducer;