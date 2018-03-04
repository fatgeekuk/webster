import React from 'react';
import { fileReceived } from '../../events/drag-drop';
import { connect } from 'react-redux';
import FileImport from '../file_import';

class FileImporter extends React.Component {
  constructor(props) {
    super(props);

    this.dropFile = this.dropFile.bind(this);
    this.dragOver = this.dragOver.bind(this);
    this.receiveFile = this.receiveFile.bind(this);
  }

  dropFile(event) {
    event.preventDefault();
    event.stopPropagation();

    // If dropped items aren't files, reject them
    var dt = event.dataTransfer;
    if (dt.items) {
      // Use DataTransferItemList interface to access the file(s)
      for (var i=0; i < dt.items.length; i++) {
        if (dt.items[i].kind == "file") {
          var f = dt.items[i].getAsFile();
          this.receiveFile(f);
        }
      }
    } else {
      // Use DataTransfer interface to access the file(s)
      for (var i=0; i < dt.files.length; i++) {
        this.receiveFile(dt.files[i]);
      }  
    }
  }

  receiveFile(file) {
    this.props.fileReceived(file);
  }

  dragOver(event) {
    event.preventDefault();
  }

  renderUploadList() {
    console.log('FileUpload', this.props);
    let listItems = [];
    for (var key in this.props.uploadQueue) {
      const upload = this.props.uploadQueue[key];
      console.log('loop', upload);
      listItems[listItems.length] = (<FileImport key={upload.id} id={upload.id} file={upload.file} progress={upload.progress}/>);
    };
console.log('list', listItems);
    return (
      <ul className='upload-list'>
        {listItems}
      </ul>
    );
  }

  render() {
    const uploadList = this.renderUploadList();

    return (
      <div className='file-importer' onDrop={this.dropFile} onDragOver={this.dragOver}>
        {uploadList}
        <div className='drop-zone'>
          <p>Drop files here</p>
        </div>
      </div>
    )
  }
}

function mapStateToProps(state) {
  const uploadQueue = state.uploadQueue;
  return {
    uploadQueue
  }
}

export default connect(mapStateToProps, {fileReceived}) (FileImporter);