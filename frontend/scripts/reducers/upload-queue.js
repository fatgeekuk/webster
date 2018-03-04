import { FILE_RECEIVED } from '../events/drag-drop';
import { UPLOAD_TOKEN_RECEIVED, UPLOAD_PROGRESS_REPORTED } from '../events/file-upload';

import { some, find, assign } from 'lodash';
import FileUpload from '../models/file_upload';

function alreadyHas(list, file) {

  console.log('already ', list, file);
  return some(list, {name: file.name});
}

function fileUploadFromId(list, id) {
  console.log('looking for key', id, ' in ', list);
  return list[id];
}

const uploadQueue = (state = {}, action) => {
  let fileUpload;
  let newState;

  console.log('upload queue received event', action);
  switch (action.type) {
    case UPLOAD_TOKEN_RECEIVED:
      fileUpload = fileUploadFromId(state, action.id);

      if (fileUpload) {
        fileUpload.receiveUploadToken(action.token);
      }

      return state;

    case FILE_RECEIVED:
      if (alreadyHas(state, action.file)) {
        return state;
      } else {
       
        const newFileUpload = new FileUpload(action.file);
        
        newState = assign({}, state);
        newState[newFileUpload.id] = newFileUpload;
        return newState;
      }

    case UPLOAD_PROGRESS_REPORTED:
      fileUpload = fileUploadFromId(state, action.id);
      newState = assign({}, state);
      newState[fileUpload.id] =  fileUpload.updateProgress(action.progress);

      return newState;

    default:
      return state
  }
}

export default uploadQueue;