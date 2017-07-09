import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Route } from 'react-router-dom';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import AssignmentNav from './AssignmentNav';
import Problem from '../Problem';
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
        assignment: ImmutablePropTypes.contains({
            assignments: ImmutablePropTypes.mapOf(
                ImmutablePropTypes.contains({
                    name: PropTypes.string.isRequired,
                    description: PropTypes.string.isRequired
                })
                )
        })
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
            history,
        } = this.props;
        const courseId = this.getCourseId();
        const assignmentId = this.getAssignmentId();
        const ass = assignment.getIn([courseId, 'assignments']).find(a => a.get('id') === assignmentId);

        return (
                <div className="assignmentShow">
                    <AssignmentNav courseId={ courseId } history={ history } backEnabled={ true } />
                    <div className="frame">
                        <h1>{ ass.get('name') }</h1>
                        <div>
                            Description:
                        </div>
                        <div>
                            { ass.get('description') }
                        </div>
                        <Route path="/courses/:courseId/assignments/:assignmentId" component={ Problem } />
                    </div>
                </div>
                );
    }
}

export default connect(state => ({
    assignment: state.assignment
}))(AssignmentShow);
