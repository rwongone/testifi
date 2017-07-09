import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import AssignmentNav from './AssignmentNav';
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
        history: PropTypes.object.isRequired
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
        const { history } = this.props;
        const courseId = this.getCourseId();

        return (
                <div className="assignmentShow">
                    <AssignmentNav courseId={ courseId } history={ history } backEnabled={ true } />
                    <div className="frame">
                        Josh
                    </div>
                </div>
                );
    }
}

export default connect(state => ({
    assignment: state.assignment
}))(AssignmentShow);
