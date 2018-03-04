import { uuidv4 } from '../utils';
import { delay, forEach } from 'lodash';
import { uploadTokenReceived, uploadProgressReceived } from '../events/file-upload'
import { backend } from '../config';
import { store } from '../utils';

import $ from 'jquery';

class FileUpload {
  constructor(file, id=uuidv4(), progress = 0.0) {
    this.file = file;
    this.id = id;
    this.name = file.name;
    this.type = file.type;
    this.progress = progress;

    if (progress == 0.0)
      delay(this.requestUploadToken.bind(this), 10);
  }

  receiveUploadToken(key) {
    this.uploadKey = key;
  }

  requestUploadToken() {
    const me=this;

    $.ajax(`${ backend }/api/upload-signature`, {
      method: 'post',
      crossDomain: true,
      data: {
        filename: this.name,
        mimetype: this.type
      },
      success: function (response) {
        me.response = response;
    
        me.uploadFile.bind(me)();
      }
    })
  }

  updateProgress(newProgress) {
    return new FileUpload(this.file, this.id, newProgress);
  }

  uploadFile() {
    let formData = new FormData();
    let id=this.id;

    forEach(this.response.params, function(value, key){ 
      formData.append(key, value);
    });

    formData.append('file', this.file);
    
    var endpoint = this.response.action;
    $.ajax({
      url: endpoint,
      xhr: function() {
        var xhr = new window.XMLHttpRequest();
        xhr.upload.addEventListener("progress", function(evt) {
          if (evt.lengthComputable) {
              var percentComplete = evt.loaded / evt.total;
              //Do something with upload progress here
              console.log('progress!', percentComplete);
              console.log('storis',store);
              store.dispatch(uploadProgressReceived(id, percentComplete));
          }
        }, false);

        xhr.addEventListener("progress", function(evt) {
          if (evt.lengthComputable) {
              var percentComplete = evt.loaded / evt.total;
              //Do something with download progress
              console.log('progress!', percentComplete);
              console.log('storis',store);
              store.dispatch(uploadProgressReceived(id, percentComplete));
          }
        }, false);

        return xhr;
      },
      method: 'POST',
      processData: false,
      contentType: false,
      data: formData,
      success: function(responseqq){
        console.log('yabba dabba doo', responseqq)
      }
    })
  }
}
  
export default FileUpload;