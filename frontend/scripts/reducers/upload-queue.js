import { FILE_RECEIVED } from '../events/drag-drop';
import { UPLOAD_TOKEN_RECEIVED } from '../events/file-upload';

import { some, find } from 'lodash';
import FileUpload from '../models/file_upload';

function alreadyHas(list, file) {
  return some(list, {name: file.name});
}

function fileUploadFromId(list, id) {
  return find(list, {id: id});
}

const uploadQueue = (state = [], action) => {
  switch (action.type) {
    case UPLOAD_TOKEN_RECEIVED:
      const fileUpload = fileUploadFromId(state, action.id);

      if (fileUpload) {
        console.log('bandicoot');
        fileUpload.receiveUploadToken(action.token);
      }

      console.log('received token', action.token);
      return state;
    case FILE_RECEIVED:
      if (alreadyHas(state, action.file)) {
        return state;
      } else {
        const newFileUpload = new FileUpload(action.file);

        return [
          ...state,
          newFileUpload
        ]
      }
    
    default:
      return state
  }
}

export default uploadQueue;