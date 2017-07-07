import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import { fetchCourses } from '../../actions/course';

class CoursePage extends Component {
    static propTypes = {
        course: ImmutablePropTypes.contains({
            fetched: PropTypes.bool.isRequired,
        }),
        dispatch: PropTypes.func.isRequired
    }

    componentWillMount() {
        const { course, dispatch } = this.props;
        if (!course.get('fetched')) {
            dispatch(fetchCourses()).then(
                    // TODO go to a course if none is selected
                    courses => console.log(courses)
                    );
        }
    }

    render() {
        // TODO render course details page once a course is selected
        return <div>Course</div>
    }
}

export default connect(state => ({
    course: state.course
}))(CoursePage);

