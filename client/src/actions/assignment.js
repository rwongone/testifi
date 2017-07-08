import { handleErrors } from './util';

export function fetchAssignments(courseId) {
    return function(dispatch) {
        let headers = new Headers();
        headers.append('Accept', 'application/json');
        headers.append('Content-Type', 'application/json');
        return fetch(`/api/courses/${courseId}/assignments`, {
            method: 'GET',
            headers,
            credentials: 'include'
        })
        .then(handleErrors)
        .then(resp => resp.json())
        .then(assignments => {
            dispatch(receiveAssignmentsSuccess(courseId, assignments));
            return assignments;
        })
        .catch(e => console.error(e));
    }
}

export const RECEIVE_ASSIGNMENTS_SUCCESS = 'RECEIVE_ASSIGNMENTS_SUCCESS';
function receiveAssignmentsSuccess(courseId, assignments) {
    return {
        type: RECEIVE_ASSIGNMENTS_SUCCESS,
        courseId,
        assignments
    }
}

export function createAssignment(courseId, info) {
    return function(dispatch) {
        let headers = new Headers();
        headers.append('Accept', 'application/json');
        headers.append('Content-Type', 'application/json');
        return fetch(`/api/courses/${courseId}/assignments`, {
            method: 'POST',
            headers,
            body: JSON.stringify(info),
            credentials: 'include'
        })
        .then(handleErrors)
        .then(resp => resp.json())
        .then(assignment => {
            dispatch(createAssignmentSuccess(courseId, assignment));
            return assignment;
        })
        .catch(e => console.error(e));
    }
}

export const CREATE_ASSIGNMENT_SUCCESS = 'CREATE_ASSIGNMENT_SUCCESS';
function createAssignmentSuccess(courseId, assignment) {
    return {
        type: CREATE_ASSIGNMENT_SUCCESS,
        courseId,
        assignment
    }
}
