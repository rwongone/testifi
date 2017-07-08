import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import { Route } from 'react-router-dom';
import AssignmentList from './AssignmentList';
import { fetchAssignments } from '../../actions/assignment';

class Assignment extends Component {
    static propTypes = {
        assignment: ImmutablePropTypes.mapOf(
                            ImmutablePropTypes.contains({
                                fetched: PropTypes.bool.isRequired,
                                assignments: ImmutablePropTypes.list.isRequired
                            }).isRequired
                            ).isRequired,
        dispatch: PropTypes.func.isRequired
    }

    componentWillMount() {
        const {
            assignment,
            dispatch,
            match: { params: { courseId } }
        } = this.props;

        const parsedCourseId = parseInt(courseId, 10);
        if (!assignment.getIn([parsedCourseId, 'fetched'])) {
            dispatch(fetchAssignments(parsedCourseId));
        }
    }

    render() {
        return (
                <Route exact path="/courses/:courseId/assignments" component={ AssignmentList } />
                );
    }
}

export default connect(state => ({
    assignment: state.assignment
}))(Assignment);
