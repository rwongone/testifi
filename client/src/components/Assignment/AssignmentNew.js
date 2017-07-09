import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createAssignment } from '../../actions/assignment';
import AssignmentNav from './AssignmentNav';
import './AssignmentNew.css';

class AssignmentNew extends Component {
    static propTypes = {
        dispatch: PropTypes.func.isRequired,
        match: PropTypes.shape({
            params: PropTypes.shape({
                courseId: PropTypes.string.isRequired
            }).isRequired
        }).isRequired
    }

    getCourseId = () => {
        const {
            match: { params: { courseId } }
        } = this.props;
        return parseInt(courseId, 10);
    }

    onSubmit = e => {
        const { courseId, dispatch } = this.props;

        const assignment = {
            name: e.target.name.value,
            description: e.target.description.value
        }

        dispatch(createAssignment(this.getCourseId(), assignment));
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
