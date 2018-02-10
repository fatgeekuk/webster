import { FILE_RECEIVED } from '../events/drag-drop';
import { some } from 'lodash';
import { uuidv4 } from '../utils';

function alreadyHas(list, file) {
  return some(list, {name: file.name});
}

const uploadQueue = (state = [], action) => {
  switch (action.type) {
    case FILE_RECEIVED:
      if (alreadyHas(state, action.file)) {
        return state;
      } else {
        return [
          ...state,
          {
            id: uuidv4(),
            file: action.file,
            name: action.file.name
          }
        ]
      }
    
    default:
      return state
  }
}

export default uploadQueue;