import { handleErrors } from './util';

export function fetchCourses() {
    return function(dispatch) {
        let headers = new Headers();
        headers.append('Accept', 'application/json');
        headers.append('Content-Type', 'application/json');
        return fetch('/api/courses/enrolled', {
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
