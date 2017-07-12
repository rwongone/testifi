import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import Dropzone from 'react-dropzone';
import classNames from 'classnames';
import { createTest } from '../../actions/test';
import './TestTile.css';
import './TestNew.css';

class TestNew extends Component {
    static propTypes = {
        dispatch: PropTypes.func.isRequired,
        problemId: PropTypes.number.isRequired
    }

    constructor(props) {
        super(props);
        this.state = {
            accepted: null,
            rejected: null
        };
    }

    onSubmit = e => {
        const {
            dispatch,
            problemId
        } = this.props;

        const test = {
            name: e.target.name.value,
            hint: e.target.hint.value,
            file: this.state.accepted
        }

        const target = e.target;
        dispatch(createTest(problemId, test)).then(() => {
            // clear the form
            target.reset();
            this.setState({
                accepted: null,
                rejected: null
            });
        });
        e.preventDefault();
    }

    filedrop = (accepted, rejected) => {
        if (rejected.length) {
            this.setState({
                rejected: rejected[0],
                accepted: null
            });
            return;
        }
        this.setState({
            accepted: accepted[0],
            rejected: null
        });
    }

    render() {
        const accepted = this.state.accepted;
        const rejected = this.state.rejected;
        return (
                <div className="testNew">
                    <div className="testTileFrame frame">
                        <form className="newTestForm" onSubmit={ this.onSubmit }>
                            <div>
                                <label htmlFor="name">Name: </label>
                            </div>
                            <div>
                                <input type="text" name="name" className="testInputField" />
                            </div>
                            <div>
                                <label htmlFor="hint">Hint (optional): </label>
                            </div>
                            <div>
                                <input type="text" name="hint" className="testInputField" />
                            </div>
                            <div>
                                <label htmlFor="input">Input: </label>
                            </div>
                            <div>
                                <Dropzone className={ classNames('dropzone', { accepted, rejected }) } activeClassName="active" maxSize={ 5000 } multiple={ false } onDrop={ this.filedrop }>
                                    {
                                    rejected
                                    ? (
                                    <div>
                                        <div>{ rejected.name }<i className="fa fa-times rejectedX" aria-hidden="true"></i></div>
                                        <div>Please use a file under 5kB</div>
                                    </div>
                                    ) :
                                    accepted
                                    ? <div>{ accepted.name }<i className="fa fa-check-square acceptedCheck" aria-hidden="true"></i></div>
                                    : <div>Drop input file here or click to upload...</div>
                                    }
                                </Dropzone>
                            </div>
                            <button className="submitButton" type="submit">Create</button>
                        </form>
                    </div>
                </div>
                );
    }
}

export default connect()(TestNew);
