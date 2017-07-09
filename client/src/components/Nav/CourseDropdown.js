import React, { Component } from 'react';
import { connect } from 'react-redux';
import ImmutablePropTypes from 'react-immutable-proptypes';
import PropTypes from 'prop-types';
import { withRouter } from 'react-router';
import { NEW_COURSE_ID } from '../../constants';
import './CourseDropdown.css';

class CourseDropdown extends Component {
    static propTypes = {
        course: ImmutablePropTypes.contains({
            courses: ImmutablePropTypes.listOf(
                             ImmutablePropTypes.contains({
                                 title: PropTypes.string.isRequired,
                                 course_code: PropTypes.string.isRequired,
                                 id: PropTypes.number.isRequired
                             })
                             ).isRequired
        }).isRequired,
        location: PropTypes.shape({
            pathname: PropTypes.string.isRequired
        }).isRequired,
        history: PropTypes.shape({
            push: PropTypes.func.isRequired
        }).isRequired
    }

    getSelectedCourse = () => {
        const { location: { pathname } } = this.props;

        if (!pathname.startsWith('/courses/')) {
            return;
        }

        // trim prefix
        let course = pathname.replace('/courses/', '');

        // trim suffix
        const slashIndex = course.indexOf('/');
        if (slashIndex !== -1) {
            course = course.substr(0, slashIndex);
        }

        if (course === 'create') {
            return NEW_COURSE_ID;
        }

        return parseInt(course, 10);
    }

    selectCourse = e => {
        const { history } = this.props;

        let courseId = parseInt(e.target.value, 10);
        if (courseId === NEW_COURSE_ID) {
            history.push(`/courses/create`);
            return;
        }
        history.push(`/courses/${courseId}/assignments`);
    }

    render() {
        const { course } = this.props;
        const selectedCourse = this.getSelectedCourse();

        return selectedCourse && !course.get('courses').isEmpty()
            ? (
                    <div className="courseDropdown">
                        <select value={ selectedCourse } onChange={ this.selectCourse }>
                            {
                            course.get('courses').map(c => (
                            <option
                                key={ c.get('id') }
                                value={ c.get('id') }
                            >{ `${c.get('course_code')}: ${c.get('title')}` }</option>
                            ))
                            }
                            <option value={ NEW_COURSE_ID }>Create New Course...</option>
                        </select>
                    </div>
                    )
            : null;
    }
}

// the withRouter decorator injects the current path location
export default withRouter(connect(state => ({
    course: state.course
}))(CourseDropdown));
