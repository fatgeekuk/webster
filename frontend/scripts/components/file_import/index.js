import React from 'react';
import { fileReceived } from '../../events/drag-drop';
import { connect } from 'react-redux';

class FileImport extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    console.log('fileimportxx', this.props);
    const id = this.props.id;
    const file = this.props.file;
    const progress = this.props.progress;

    return (
      <li key={id} data-file-type={file.type}>FILE: {file.name} ({progress})</li>
    )
  }
}

export default FileImport;