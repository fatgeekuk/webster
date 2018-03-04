const UPLOAD_TOKEN_RECEIVED = 'UPLOAD-TOKEN-RECEIVED';
const UPLOAD_PROGRESS_REPORTED = 'UPLOAD-PROGRESS-REPORTED';

function uploadTokenReceived(id, token) {
  return({
    type: UPLOAD_TOKEN_RECEIVED,
    id,
    token
  })
}

function uploadProgressReceived(id, progress) {
  return({
    type: UPLOAD_PROGRESS_REPORTED,
    id,
    progress
  })
}

export {
  UPLOAD_TOKEN_RECEIVED,
  UPLOAD_PROGRESS_REPORTED,
  uploadTokenReceived,
  uploadProgressReceived
};