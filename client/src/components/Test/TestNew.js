import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import { createTest } from '../../actions/test';
import Filedrop from '../Filedrop';
import './TestTile.css';
import './TestNew.css';

class TestNew extends Component {
    static propTypes = {
        dispatch: PropTypes.func.isRequired,
        problemId: PropTypes.number.isRequired,
    }

    constructor(props) {
        super(props);
        this.state = {
            accepted: null,
            rejected: null,
        };
    }

    onSubmit = e => {
        const {
            dispatch,
            problemId,
        } = this.props;

        const test = {
            name: e.target.name.value,
            hint: e.target.hint.value,
            file: this.state.accepted,
        };

        const target = e.target;
        dispatch(createTest(problemId, test)).then(() => {
            // clear the form
            target.reset();
            this.setState({
                accepted: null,
                rejected: null,
            });
        });
        e.preventDefault();
    }

    onAccept = accepted => {
        this.setState({
            accepted,
            rejected: null,
        });
    }

    onReject = rejected => {
        this.setState({
            accepted: null,
            rejected,
        });
    }

    render() {
        const { accepted, rejected } = this.state;
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
                                <Filedrop onAccept={ this.onAccept } onReject={ this.onReject } accepted={ accepted } rejected={ rejected } />
                            </div>
                            <button className="submitButton" type="submit">Create</button>
                        </form>
                    </div>
                </div>
        );
    }
}

export default connect()(TestNew);
