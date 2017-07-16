import React, { Component } from 'react';
import PropTypes from 'prop-types';
import './SubmissionShow.css';

export default class SubmissionShow extends Component {
    static propTypes = {
        match: PropTypes.shape({
            params: PropTypes.shape({
                assignmentId: PropTypes.string.isRequired,
                courseId: PropTypes.string.isRequired,
                problemId: PropTypes.string.isRequired,
                submissionId: PropTypes.string.isRequired,
            }).isRequired
        }).isRequired,
        history: PropTypes.shape({
            push: PropTypes.func.isRequired
        }).isRequired,
    }

    getCourseId = () => {
        const {
            match: { params: { courseId } }
        } = this.props;
        return parseInt(courseId, 10);
    }

    getAssignmentId = () => {
        const {
            match: { params: { assignmentId } }
        } = this.props;
        return parseInt(assignmentId, 10);
    }

    getProblemId = () => {
        const {
            match: { params: { problemId } }
        } = this.props;
        return parseInt(problemId, 10);
    }

    getSubmissionId = () => {
        const {
            match: { params: { submissionId } }
        } = this.props;
        return parseInt(submissionId, 10);
    }

    goBackToSubmissions = () => {
        const {
            history: { push }
        } = this.props;

        push(`/courses/${this.getCourseId()}/assignments/${this.getAssignmentId()}/problems/${this.getProblemId()}`);
    }

    render() {
        return (
                <div className="submissionShow">
                    <h1>
                        <div className="backButtonAndText" onClick={ this.goBackToSubmissions }><i className="fa fa-angle-left backButton" aria-hidden="true"></i>Submissions</div>
                    </h1>
                    <h2>Test Results</h2>
                </div>
                );
    }
}
