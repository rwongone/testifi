import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import { Route, Switch } from 'react-router-dom';
import { fetchCourses } from '../../actions/course';
import Assignment from '../Assignment';
import CourseNew from './CourseNew';
import NoCourses from './NoCourses';

class Course extends Component {
    static propTypes = {
        course: ImmutablePropTypes.contains({
            fetched: PropTypes.bool.isRequired,
            courses: ImmutablePropTypes.list.isRequired
        }).isRequired,
        user: ImmutablePropTypes.contains({
            isAdmin: PropTypes.bool.isRequired,
        }).isRequired,
        dispatch: PropTypes.func.isRequired,
        history: PropTypes.shape({
            push: PropTypes.func.isRequired
        }).isRequired
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
                    history.push(`/courses/${course.get('courses').first().get('id')}/assignments`);
                }
            } else {
                if (!course.get('courses').isEmpty()) {
                    // redirect to the first available course
                    history.push(`/courses/${course.get('courses').first().get('id')}/assignments`);
                }
                // if there are no courses, do not redirect and the splash screen will display
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
        const { course } = this.props;

        return course.get('fetched') ? (
                <Switch>
                    <Route exact path="/courses" component={ NoCourses } />
                    <Route path="/courses/create" component={ CourseNew } />
                    <Route path="/courses/:courseId/assignments" component={ Assignment } />
                </Switch>
                ) : null;
    }
}

export default connect(state => ({
    course: state.course,
    user: state.user
}))(Course);
