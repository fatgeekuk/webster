const FILE_RECEIVED = 'FILE-RECEIVED';

function fileReceived(file) {
  return({
    type: FILE_RECEIVED,
    file
  })
}

export {
  FILE_RECEIVED,
  fileReceived
};