import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import { Redirect } from 'react-router-dom';
import AssignmentNav from '../Assignment/AssignmentNav';
import './CourseAdmin.css';

class CourseAdmin extends Component {
    static propTypes = {
        history: PropTypes.shape({
            push: PropTypes.func.isRequired
        }).isRequired,
        isAdmin: PropTypes.bool.isRequired
    }

    render() {
        const {
            match: { params: { courseId } },
            history,
            isAdmin
        } = this.props;
        const parsedCourseId = parseInt(courseId, 10);

        // TODO add two ways students can be registered in courses (list upload or text field)
        // TODO add list of pending invitations (with resend button)
        // TODO add list of registered students in the course
        // TODO add a way of seeing user progress in the course
        return isAdmin ? (
                <div className="courseAdmin">
                    <AssignmentNav history={ history } courseId={ parsedCourseId } backEnabled={ true } />
                    <div className="frame">
                        <h2>Student Registration</h2>
                    </div>
                </div>
                ) : <Redirect to="/" />;
    }
}

export default connect(state => ({
    isAdmin: state.user.get('isAdmin')
}))(CourseAdmin);
