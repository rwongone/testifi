import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import { Redirect } from 'react-router-dom';
import AssignmentNav from '../Assignment/AssignmentNav';

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

        return isAdmin ? (
                <div>
                    <AssignmentNav history={ history } courseId={ parsedCourseId } backEnabled={ true } />
                    Course admin here
                </div>
                ) : <Redirect to="/" />;
    }
}

export default connect(state => ({
    isAdmin: state.user.get('isAdmin')
}))(CourseAdmin);
