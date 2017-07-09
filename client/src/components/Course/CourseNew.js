import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createCourse } from '../../actions/course';
import './CourseNew.css';

class CourseNew extends Component {
    static propTypes = {
        dispatch: PropTypes.func.isRequired,
        history: PropTypes.shape({
            push: PropTypes.func.isRequired
        }).isRequired
    }

    onSubmit = e => {
        const {
            dispatch,
            history: { push }
        } = this.props;

        const course = {
            course_code: e.target.courseCode.value,
            title: e.target.title.value,
            description: e.target.description.value
        }

        dispatch(createCourse(course)).then(c => push(`/courses/${c.id}/assignments`));
        e.preventDefault();
    }

    render() {
        return (
                <div className="courseCreate">
                    <div className="frame">
                        <h2>Create new course</h2>
                        <form className="newCourseForm" onSubmit={ this.onSubmit }>
                            <label htmlFor="courseCode">Course Code: </label><input type="text" name="courseCode" />
                            <label htmlFor="title">Title: </label><input type="text" name="title" />
                            <label htmlFor="description">Description: </label><input type="text" name="description" />
                            <button className="submitButton" type="submit">Create</button>
                        </form>
                    </div>
                </div>
                );
    }
}

export default connect()(CourseNew);
