import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import './ProblemShow.css';

class ProblemShow extends Component {
    static propTypes = {
        assignment: ImmutablePropTypes.contains({
            assignments: ImmutablePropTypes.mapOf(
                ImmutablePropTypes.contains({
                    name: PropTypes.string.isRequired
                })
                )
        }),
        problem: ImmutablePropTypes.contains({
            problems: ImmutablePropTypes.mapOf(
                ImmutablePropTypes.contains({
                    name: PropTypes.string.isRequired
                })
                )
        }),
        match: PropTypes.shape({
            params: PropTypes.shape({
                assignmentId: PropTypes.string.isRequired,
                courseId: PropTypes.string.isRequired,
                problemId: PropTypes.string.isRequired
            }).isRequired
        }).isRequired,
        history: PropTypes.shape({
            push: PropTypes.func.isRequired
        }).isRequired
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
            match: { params: { assignmentId } }
        } = this.props;
        return parseInt(assignmentId, 10);
    }

    getAssignment = () => {
        const { assignment } = this.props;
        const assignmentId = this.getAssignmentId();
        const courseId = this.getCourseId();
        return assignment.getIn([courseId, 'assignments']).find(a => a.get('id') === assignmentId);
    }

    getProblem = assignment => {
        const { problem } = this.props;
        const problemId = this.getProblemId();
        return problem.getIn([assignment.get('id'), 'problems']).find(p => p.get('id') === problemId);
    }

    goBackToProblems = () => {
        const {
            history: { push }
        } = this.props;
        const courseId = this.getCourseId();
        const assignment = this.getAssignment();

        push(`/courses/${courseId}/assignments/${assignment.get('id')}`);
    }

    render() {
        const assignment = this.getAssignment();
        const problem = this.getProblem(assignment);

        return (
                <div className="problemShow">
                    <h1>
                        <div className="backButtonAndText" onClick={ this.goBackToProblems }><i className="fa fa-angle-left backButton" aria-hidden="true"></i>{ assignment.get('name') } - { problem.get('name') }</div>
                    </h1>
                </div>
                );
    }
}

export default connect(state => ({
    assignment: state.assignment,
    problem: state.problem
}))(ProblemShow);
