import React, { Component } from 'react';
import { Route } from 'react-router-dom';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import AssignmentNav from './AssignmentNav';
import AssignmentDetails from './AssignmentDetails';
import ProblemShow from '../Problem/ProblemShow';
import { fetchProblems } from '../../actions/problem';
import './AssignmentShow.css';

class AssignmentShow extends Component {
    static propTypes = {
        dispatch: PropTypes.func.isRequired,
        match: PropTypes.shape({
            params: PropTypes.shape({
                assignmentId: PropTypes.string.isRequired,
                courseId: PropTypes.string.isRequired
            }).isRequired
        }).isRequired,
        history: PropTypes.object.isRequired,
        problem: ImmutablePropTypes.mapOf(
                ImmutablePropTypes.contains({
                    fetched: PropTypes.bool.isRequired
                })
                )
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

    componentWillMount() {
        const { problem, dispatch } = this.props;
        const assignmentId = this.getAssignmentId();
        if (!problem.getIn([assignmentId, 'fetched'])) {
            dispatch(fetchProblems(assignmentId));
        }
    }

    render() {
        const { problem, history } = this.props;
        const courseId = this.getCourseId();
        const assignmentId = this.getAssignmentId();

        return (
                <div className="assignmentShow">
                    <AssignmentNav courseId={ courseId } history={ history } backEnabled={ true } />
                        {
                        problem.getIn([assignmentId, 'fetched'])
                        ? (
                        <div className="frame">
                            <Route exact path="/courses/:courseId/assignments/:assignmentId" component={ AssignmentDetails } />
                            <Route path="/courses/:courseId/assignments/:assignmentId/problems/:problemId" component={ ProblemShow } />
                        </div>
                        ) : null
                        }
                </div>
                );
    }
}

export default connect(state => ({
    problem: state.problem
}))(AssignmentShow);
