import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import { Route } from 'react-router-dom';
import { fetchCourses } from '../../actions/course';
import CourseCreate from '../CourseCreate';

class CoursePage extends Component {
    static propTypes = {
        course: ImmutablePropTypes.contains({
            fetched: PropTypes.bool.isRequired,
        }).isRequired,
        user: ImmutablePropTypes.contains({
            isAdmin: PropTypes.bool.isRequired,
        }).isRequired,
        dispatch: PropTypes.func.isRequired
    }

    componentWillMount() {
        const {
            course,
            dispatch,
            history,
            location,
            user
        } = this.props;

        if (!course.get('fetched')) {
            dispatch(fetchCourses()).then(courses => {
                // if at the root of courses, need to redirect
                if (location.pathname === '/courses') {
                    if (user.get('isAdmin')) {
                        if (courses.length === 0) {
                            // redirect to the course create page
                            history.push('/courses/create');
                        } else {
                            // TODO pick a course to redirect to
                        }
                    } else {
                        if (courses.length === 0) {
                            // TODO show a splash screen telling the student to ask the teacher to enroll them
                        } else {
                            // TODO pick a course to redirect to
                        }
                    }
                }
            });
        }
    }

    render() {
        return (
                // TODO return different paths based on the situation
                <Route path="/courses/create" component={ CourseCreate } />
                );
    }
}

export default connect(state => ({
    course: state.course,
    user: state.user
}))(CoursePage);
