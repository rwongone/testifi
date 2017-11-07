import React, { Component } from 'react';
import PropTypes from 'prop-types';
import Dropzone from 'react-dropzone';
import classNames from 'classnames';
import './Filedrop.css';

export default class Filedrop extends Component {
    static propTypes = {
        // accepted is a file that has been accepted by the dropzone
        accepted: PropTypes.instanceOf(File),
        rejected: PropTypes.instanceOf(File),
        onAccept: PropTypes.func.isRequired,
        onReject: PropTypes.func.isRequired,
        // accept is a string representing accepted filetypes
        accept: PropTypes.string,
    }

    filedrop = (accepted, rejected) => {
        const { onAccept, onReject } = this.props;
        if (rejected.length) {
            onReject(rejected[0]);
            return;
        }
        onAccept(accepted[0]);
    }

    render() {
        const { accepted, rejected, accept } = this.props;
        return (
                <Dropzone className={ classNames('filedrop', { accepted, rejected }) } activeClassName="active" maxSize={ 10000 } multiple={ false } onDrop={ this.filedrop } accept={ accept }>
                    {
                    rejected
                    ? (
                    <div>
                        <div>{ rejected.name }<i className="fa fa-times rejectedX" aria-hidden="true"></i></div>
                        <div>Please use a file under 10kB</div>
                    </div>
                    ) :
                    accepted
                    ? <div>{ accepted.name }<i className="fa fa-check-square acceptedCheck" aria-hidden="true"></i></div>
                    : <div>Drop input file here or click to upload...</div>
                    }
                </Dropzone>
        );
    }
}
