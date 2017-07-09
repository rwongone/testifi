import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import { NEW_ASSIGNMENT_ID } from '../../constants';
import AssignmentTile from './AssignmentTile';
import AssignmentNav from './AssignmentNav';
import './AssignmentList.css';

class AssignmentList extends Component {
    static propTypes = {
        assignment: ImmutablePropTypes.mapOf(
                            ImmutablePropTypes.contains({
                                assignments: ImmutablePropTypes.listOf(
                                                     ImmutablePropTypes.contains({
                                                         id: PropTypes.number.isRequired,
                                                         title: PropTypes.string.isRequired
                                                     })
                                                     ).isRequired
                            }).isRequired
                            ).isRequired,
        user: ImmutablePropTypes.contains({
            isAdmin: PropTypes.bool.isRequired,
        }).isRequired
    }

    render() {
        const {
            assignment,
            user,
            match: { params: { courseId } }
        } = this.props;
        const parsedCourseId = parseInt(courseId, 10);

        return (
                <div>
                    <AssignmentNav />
                    <div className="assignmentList">
                        {
                        assignment.getIn([parsedCourseId, 'assignments']).map(
                        a => <AssignmentTile key={ a.get('id') } title={ a.get('title') } id={ a.get('id') } />
                        )
                        }
                        {
                        user.get('isAdmin')
                        ? (
                        <AssignmentTile title="Create New Assignment" id={ NEW_ASSIGNMENT_ID } />
                        ) : null
                        }
                    </div>
                </div>
                );
    }
}

export default connect(state => ({
    assignment: state.assignment,
    user: state.user
}))(AssignmentList);
