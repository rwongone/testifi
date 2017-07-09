import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import { createTest } from '../../actions/test';
import './TestTile.css';
import './TestNew.css';

class TestNew extends Component {
    static propTypes = {
        dispatch: PropTypes.func.isRequired,
        problemId: PropTypes.number.isRequired
    }

    onSubmit = e => {
        const {
            dispatch,
            problemId
        } = this.props;

        const test = {
            name: e.target.name.value
        }

        dispatch(createTest(problemId, test));
        e.preventDefault();
    }

    render() {
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
                            <button className="submitButton" type="submit">Create</button>
                        </form>
                    </div>
                </div>
                );
    }
}

export default connect()(TestNew);
