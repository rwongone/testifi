import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import { Route, Switch } from 'react-router-dom';
import AssignmentList from './AssignmentList';
import AssignmentNew from './AssignmentNew';
import AssignmentShow from './AssignmentShow';
import { fetchAssignments } from '../../actions/assignment';

class Assignment extends Component {
    static propTypes = {
        assignment: ImmutablePropTypes.mapOf(
                            ImmutablePropTypes.contains({
                                fetched: PropTypes.bool.isRequired,
                                fetching: PropTypes.bool.isRequired,
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

    getCourseId = props => {
        const {
            match: { params: { courseId } }
        } = props;
        return parseInt(courseId, 10);
    }

    fetchAssignmentsIfNecessary = props => {
        const {
            assignment,
            dispatch
        } = props;

        const courseId = this.getCourseId(props);
        if (!assignment.getIn([courseId, 'fetched'])
                && !assignment.getIn([courseId, 'fetching'])) {
            dispatch(fetchAssignments(courseId));
        }
    }

    componentWillReceiveProps(nextProps) {
        this.fetchAssignmentsIfNecessary(nextProps);
    }

    componentWillMount() {
        this.fetchAssignmentsIfNecessary(this.props);
    }

    render() {
        const { assignment } = this.props;
        const courseId = this.getCourseId(this.props);

        // make sure the assignments have been fetched before rendering anything
        return assignment.getIn([courseId, 'fetched']) ? (
                <Switch>
                    <Route exact path="/courses/:courseId/assignments" component={ AssignmentList } />
                    <Route path="/courses/:courseId/assignments/:assignmentId" component={ AssignmentShow } />
                    <Route exact path="/courses/:courseId/assignments/create" component={ AssignmentNew } />
                </Switch>
                ) : null;
    }
}

export default connect(state => ({
    assignment: state.assignment
}))(Assignment);
