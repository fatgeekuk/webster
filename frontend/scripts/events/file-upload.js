const UPLOAD_TOKEN_RECEIVED = 'UPLOAD-TOKEN-RECEIVED';

function uploadTokenReceived(id, token) {
  return({
    type: UPLOAD_TOKEN_RECEIVED,
    id,
    token
  })
}

export {
  UPLOAD_TOKEN_RECEIVED,
  uploadTokenReceived
};