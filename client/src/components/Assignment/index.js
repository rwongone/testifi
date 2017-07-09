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

    componentWillMount() {
        const {
            assignment,
            dispatch
        } = this.props;

        const courseId = this.getCourseId();
        if (!assignment.getIn([courseId, 'fetched'])) {
            dispatch(fetchAssignments(courseId));
        }
    }

    render() {
        const { assignment } = this.props;
        const courseId = this.getCourseId();

        // make sure the assignments have been fetched before rendering anything
        return assignment.getIn([courseId, 'fetched']) ? (
                <Route exact path="/courses/:courseId/assignments" component={ AssignmentList } />
                ) : null;
    }
}

export default connect(state => ({
    assignment: state.assignment
}))(Assignment);
