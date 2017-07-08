import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import { Route } from 'react-router-dom';
import { fetchCourses } from '../../actions/course';
import CourseNew from './CourseNew';

class Course extends Component {
    static propTypes = {
        course: ImmutablePropTypes.contains({
            fetched: PropTypes.bool.isRequired,
            courses: ImmutablePropTypes.list.isRequired
        }).isRequired,
        user: ImmutablePropTypes.contains({
            isAdmin: PropTypes.bool.isRequired,
        }).isRequired,
        dispatch: PropTypes.func.isRequired
    }

    redirectToSubPage = () => {
        const {
            course,
            history,
            location,
            user
        } = this.props;

        // if at the root of courses, need to redirect
        if (location.pathname === '/courses') {
            if (user.get('isAdmin')) {
                if (course.get('courses').isEmpty()) {
                    // redirect to the course create page
                    history.push('/courses/create');
                } else {
                    // redirect to the first available course
                    history.push(`/courses/${course.get('courses').first().get('id')}`);
                }
            } else {
                if (course.get('courses').isEmpty()) {
                    // TODO show a splash screen telling the student to ask the teacher to enroll them
                } else {
                    // TODO pick a course to redirect to
                }
            }
        }
    }

    componentWillMount() {
        const {
            course,
            dispatch
        } = this.props;

        if (!course.get('fetched')) {
            dispatch(fetchCourses()).then(this.redirectToSubPage);
        } else {
            this.redirectToSubPage();
        }
    }

    render() {
        return (
                // TODO return different paths based on the situation
                <Route path="/courses/create" component={ CourseNew } />
                );
    }
}

export default connect(state => ({
    course: state.course,
    user: state.user
}))(Course);
