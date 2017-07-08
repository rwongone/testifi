import { handleErrors } from './util';

export function fetchCourses() {
    return function(dispatch) {
        let headers = new Headers();
        headers.append('Accept', 'application/json');
        headers.append('Content-Type', 'application/json');
        return fetch('/api/courses/visible', {
            method: 'GET',
            headers,
            credentials: 'include'
        })
        .then(handleErrors)
        .then(resp => resp.json())
        .then(courses => {
            dispatch(receiveCoursesSuccess(courses));
            return courses;
        })
        .catch(e => console.error(e));
    }
}

export const RECEIVE_COURSES_SUCCESS = 'RECEIVE_COURSES_SUCCESS';
function receiveCoursesSuccess(courses) {
    return {
        type: RECEIVE_COURSES_SUCCESS,
        courses
    }
}

export function createCourse(info) {
    return function(dispatch) {
        let headers = new Headers();
        headers.append('Accept', 'application/json');
        headers.append('Content-Type', 'application/json');
        return fetch('/api/courses', {
            method: 'POST',
            headers,
            body: JSON.stringify(info),
            credentials: 'include'
        })
        .then(handleErrors)
        .then(resp => resp.json())
        .then(course => {
            dispatch(createCourseSuccess(course));
            return course;
        })
        .catch(e => console.error(e));
    }
}

export const CREATE_COURSE_SUCCESS = 'CREATE_COURSE_SUCCESS';
function createCourseSuccess(course) {
    return {
        type: CREATE_COURSE_SUCCESS,
        course
    }
}
