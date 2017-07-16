import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import { fetchTests } from '../../actions/test';
import { submitSubmission } from '../../actions/submission';
import Filedrop from '../Filedrop';
import TestList from '../Test/TestList';
import './ProblemShow.css';

class ProblemShow extends Component {
    static propTypes = {
        assignment: ImmutablePropTypes.contains({
            assignments: ImmutablePropTypes.mapOf(
                ImmutablePropTypes.contains({
                    id: PropTypes.number.isRequired,
                    name: PropTypes.string.isRequired
                })
                )
        }),
        problem: ImmutablePropTypes.contains({
            problems: ImmutablePropTypes.mapOf(
                ImmutablePropTypes.contains({
                    id: PropTypes.number.isRequired,
                    name: PropTypes.string.isRequired
                })
                )
        }),
        test: ImmutablePropTypes.contains({
            fetched: PropTypes.bool.required,
            tests: ImmutablePropTypes.mapOf(
                ImmutablePropTypes.contains({
                    id: PropTypes.number.isRequired,
                    name: PropTypes.string.isRequired,
                    solution: PropTypes.string.isRequired
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
        }).isRequired,
        isAdmin: PropTypes.bool.required,
    }

    constructor(props) {
        super(props);
        this.state = {
            rejected: null
        };
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

    componentWillMount() {
        const { test, dispatch } = this.props;
        const problemId = this.getProblemId();
        if (!test.getIn([problemId, 'fetched'])) {
            dispatch(fetchTests(problemId));
        }
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

    onAccept = accepted => {
        const { dispatch, problem } = this.props;

        this.setState({
            rejected: null
        })

        dispatch(submitSubmission(this.getProblemId(), accepted))
    }

    onReject = rejected => {
        this.setState({
            rejected
        })
    }

    render() {
        const assignment = this.getAssignment();
        const problem = this.getProblem(assignment);
        const { isAdmin, test } = this.props;
        const { rejected } = this.state;

        return (
            <div className="problemShow">
                <h1>
                    <div className="backButtonAndText" onClick={ this.goBackToProblems }><i className="fa fa-angle-left backButton" aria-hidden="true"></i>{ assignment.get('name') } - { problem.get('name') }</div>
                </h1>
                {
                    test.getIn([problem.get('id'), 'fetched'])
                ? (
                    <TestList problemId={ problem.get('id') } />
                ) : null
                }
                {
                    isAdmin
                ? (
                    <div classname="submitSection">
                        <label>Upload canonical solution:</label>
                        <Filedrop onAccept={ this.onAccept } onReject={ this.onReject } rejected={ rejected } accept=".java,.py" />
                    </div>
                ) : null
                }
            </div>
        );
    }
}

export default connect(state => ({
    assignment: state.assignment,
    problem: state.problem,
    test: state.test,
    isAdmin: state.user.get('isAdmin'),
}))(ProblemShow);
