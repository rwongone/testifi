import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';
import ImmutablePropTypes from 'react-immutable-proptypes';
import PropTypes from 'prop-types';
import { withRouter } from 'react-router';
import './CourseDropdown.css';

const CREATE_ID = -1;
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
            return CREATE_ID;
        }

        return parseInt(course, 10);
    }

    selectCourse = e => {
        const { history } = this.props;

        let courseId = parseInt(e.target.value);
        if (courseId === CREATE_ID) {
            courseId = 'create';
        }
        history.push(`/courses/${courseId}`);
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
                            <option value={ CREATE_ID }>Create...</option>
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
