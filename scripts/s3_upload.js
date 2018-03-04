const fs = require('fs');
const _ = require('lodash');

const AWS = require('aws-sdk');
const region =  process.env.S3_REGION;
const accessKey = process.env.CODE_ACCESS_KEY_ID;
const accessSecret = process.env.CODE_SECRET_ACCESS_KEY;

const endpoint = 'https://s3.' + region + '.amazonaws.com';

const s3 = new AWS.S3({
  endpoint: endpoint,
  region: region,
  signatureVersion: 'v4',
  accessKeyId: accessKey,
  secretAccessKey: accessSecret
});

const bucketName = process.env.S3_CODE_BUCKET;

const path = 'frontend/_dist';

const contentTypes = {
  html: 'text/html',
  css: 'text/css'
};

fs.readdir(path, (err, files) => {
  _.each(files, (file, index) => {
    
    fs.readFile([path, file].join('/'), (err, data) => {
      if (err) throw err;
      
      const ext = file.replace(/.*\./, '');
      
      var params = {
        Bucket: bucketName,
        Key: file,
        Body: data,
        ContentType: contentTypes[ext]
      };

      s3.putObject(params, (err, data) => {
        if (err) {
          console.log(file, ' error, failed to upload');
          console.log(err);
        } else {
          console.log(file, ' success, upload complete');
        }
      });  
    });
  });
});