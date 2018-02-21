import { uuidv4 } from '../utils';
import { delay } from 'lodash';
import { uploadTokenReceived } from '../events/file-upload'
import { backend } from '../config';
import { store } from '../utils';
import moment from 'moment';

import $ from 'jquery';

class FileUpload {
  constructor(file) {
    this.file = file;
    this.id = uuidv4();
    this.name = file.name;
    this.type = file.type;

    delay(this.requestUploadToken.bind(this), 10);
  }

  receiveUploadToken(key) {
    console.log('dasdasd')
    this.uploadKey = key;
  }

  requestUploadToken() {
    const me=this;

    $.ajax('http://localhost:4000/api/upload-signature', {
      method: 'post',
      crossDomain: true,
      data: {
        filename: this.name,
        mimetype: this.type
      },
      success: function (response) {
        console.log('response', response);
        me.response = response;
    
        me.uploadFile.bind(me)();
      }
    })
  }

  uploadFile() {
  console.log('wannalet tick = monm upload file', this.name, this.response);
    let tick = moment();
    let nDateFull = tick.format("YYYYMMDDTHHmmss") + 'Z';
    let nDate = tick.format('YYYYMMDD');
    let formData = new FormData();
    formData.append('key', this.name);
    formData.append('policy', this.response.policy);
    formData.append('x-amz-algorithm', 'AWS4-HMAC-SHA256');
    formData.append('x-amz-credential', this.response.AWSAccessKeyId + '/' + nDate + '/eu-west-2/s3/aws4_request');
    formData.append('x-amz-date', nDateFull);
    formData.append('x-amz-signature', this.response.signature);
    formData.append('acl', 'public-read');
    //formData.append('contentType', this.type);

    console.log('file', this.file);
    formData.append('file', this.file);
    
    var bucket = 'development-store.webster-music.org';
    var endpoint = 'http://' + bucket + '.s3.amazonaws.com';
    $.ajax(endpoint, {
      method: 'POST',
      processData: false,
      contentType: false,
      data: formData,
      success: function(responseqq){
        console.log(responseqq)
      }
    })
  }
}
  
export default FileUpload;