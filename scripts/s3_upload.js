const fs = require('fs');
const _ = require('lodash');

var AWS = require('aws-sdk');
var region =  process.env.AWS_REGION;
var endpoint = 'https://s3.' + region + '.amazonaws.com';

var s3 = new AWS.S3({
  endpoint: endpoint,
  region: region,
  signatureVersion: 'v4'
});

const bucketName = process.env.AWS_BUCKET;

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