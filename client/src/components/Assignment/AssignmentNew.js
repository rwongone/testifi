import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createAssignment } from '../../actions/assignment';
import AssignmentNav from './AssignmentNav';
import './AssignmentNew.css';

class AssignmentNew extends Component {
    static propTypes = {
        dispatch: PropTypes.func.isRequired
    }

    onSubmit = e => {
        const { dispatch } = this.props;

        const assignment = {
            name: e.target.name.value,
            description: e.target.description.value
        }

        dispatch(createAssignment(assignment));
        e.preventDefault();
    }

    render() {
        return (
                <div className="assignmentNew">
                    <AssignmentNav />
                    <div className="assignmentNewFrameContainer">
                        <div className="frame">
                            <h2>Create new Assignment</h2>
                            <form className="newAssignmentForm" onSubmit={ this.onSubmit }>
                                <label htmlFor="name">Name: </label><input type="text" name="name" />
                                <label htmlFor="description">Description: </label><input type="text" name="description" />
                                <button className="submitButton" type="submit">Create</button>
                            </form>
                        </div>
                    </div>
                </div>
                );
    }
}

export default connect()(AssignmentNew);
