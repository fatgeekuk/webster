import React from 'react';
import { fileReceived } from '../../events/drag-drop';
import { connect } from 'react-redux';

;class FileImporter extends React.Component {
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
    const listItems = this.props.uploadQueue.map((d) => <li key={d.id}>FILE: {d.name}</li>);

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