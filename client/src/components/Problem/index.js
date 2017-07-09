import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Route } from 'react-router-dom';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import { fetchProblems } from '../../actions/problem';
import ProblemList from './ProblemList';

class Problem extends Component {
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
        return (
                <div className="problem">
                    <Route path="/courses/:courseId/assignments/:assignmentId" component={ ProblemList } />
                </div>
                );
    }
}

export default connect(state => ({
    problem: state.problem
}))(Problem);
