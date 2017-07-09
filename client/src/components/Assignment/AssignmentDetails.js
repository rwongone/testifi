import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import ProblemList from '../Problem/ProblemList';

class AssignmentDetails extends Component {
    static propTypes = {
        assignment: ImmutablePropTypes.contains({
            assignments: ImmutablePropTypes.mapOf(
                ImmutablePropTypes.contains({
                    name: PropTypes.string.isRequired,
                    description: PropTypes.string.isRequired
                })
                )
        }),
        match: PropTypes.shape({
            params: PropTypes.shape({
                assignmentId: PropTypes.string.isRequired,
                courseId: PropTypes.string.isRequired
            }).isRequired
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

    render() {
        const {
            assignment,
            history
        } = this.props;
        const assignmentId = this.getAssignmentId();
        const courseId = this.getCourseId();
        const ass = assignment.getIn([courseId, 'assignments']).find(a => a.get('id') === assignmentId);

        return (
                <div>
                    <h1>{ ass.get('name') }</h1>
                    <div>
                        Description:
                    </div>
                    <div>
                        { ass.get('description') }
                    </div>
                    <ProblemList courseId={ courseId } assignmentId={ assignmentId } history={ history } />
                </div>
                );
    }
}

export default connect(state => ({
    assignment: state.assignment
}))(AssignmentDetails);
