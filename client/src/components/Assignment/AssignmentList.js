import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import { NEW_ASSIGNMENT_ID } from '../../constants';
import AssignmentTile from './AssignmentTile';
import AssignmentNav from './AssignmentNav';
import NoAssignments from './NoAssignments';
import './AssignmentList.css';

class AssignmentList extends Component {
    static propTypes = {
        assignment: ImmutablePropTypes.mapOf(
                            ImmutablePropTypes.contains({
                                assignments: ImmutablePropTypes.listOf(
                                                     ImmutablePropTypes.contains({
                                                         id: PropTypes.number.isRequired,
                                                         name: PropTypes.string.isRequired,
                                                     })
                                                     ).isRequired,
                            }).isRequired
                            ).isRequired,
        user: ImmutablePropTypes.contains({
            isAdmin: PropTypes.bool.isRequired,
        }).isRequired,
        match: PropTypes.shape({
            params: PropTypes.shape({
                courseId: PropTypes.string.isRequired,
            }).isRequired,
        }).isRequired,
        history: PropTypes.shape({
            push: PropTypes.func.isRequired,
        }).isRequired,
    }

    goToAssignment = assignmentId => () => {
        const {
            match: { params: { courseId } },
            history,
        } = this.props;

        if (assignmentId === NEW_ASSIGNMENT_ID) {
            history.push(`/courses/${courseId}/assignments/create`);
            return;
        }
        history.push(`/courses/${courseId}/assignments/${assignmentId}`);
    }

    render() {
        const {
            assignment,
            user,
            match: { params: { courseId } },
            history,
        } = this.props;
        const parsedCourseId = parseInt(courseId, 10);
        const assignments = assignment.getIn([parsedCourseId, 'assignments']);

        return (
                <div>
                    <AssignmentNav history={ history } courseId={ parsedCourseId } />
                    <div className="assignmentList">
                        {
                        assignments.map(
                        a => <AssignmentTile
                            key={ a.get('id') }
                            name={ a.get('name') }
                            onClick={ this.goToAssignment(a.get('id')) } />
                        )
                        }
                        {
                        user.get('isAdmin')
                        ? (
                        <AssignmentTile
                            name="Create New Assignment"
                            onClick={ this.goToAssignment(NEW_ASSIGNMENT_ID) } />
                        ) : null
                        }
                        {
                        !user.get('isAdmin') && assignments.isEmpty()
                        ? (
                        <NoAssignments />
                        )
                        : null
                        }
                    </div>
                </div>
        );
    }
}

export default connect(state => ({
    assignment: state.assignment,
    user: state.user,
}))(AssignmentList);
