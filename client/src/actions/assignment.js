import { handleErrors } from './util';

export const FETCH_ASSIGNMENTS = 'FETCH_ASSIGNMENTS';
export function fetchAssignments(courseId) {
    return function(dispatch) {
        dispatch({
            type: FETCH_ASSIGNMENTS,
            courseId,
        });
        let headers = new Headers();
        headers.append('Accept', 'application/json');
        headers.append('Content-Type', 'application/json');
        return fetch(`/api/courses/${courseId}/assignments`, {
            method: 'GET',
            headers,
            credentials: 'include',
        })
        .then(handleErrors)
        .then(resp => resp.json())
        .then(assignments => {
            dispatch(receiveAssignmentsSuccess(courseId, assignments));
            return assignments;
        })
        .catch(e => {
            dispatch(receiveAssignmentsFailure(courseId));
            console.error(e);
        });
    };
}

export const RECEIVE_ASSIGNMENTS_SUCCESS = 'RECEIVE_ASSIGNMENTS_SUCCESS';
function receiveAssignmentsSuccess(courseId, assignments) {
    return {
        type: RECEIVE_ASSIGNMENTS_SUCCESS,
        courseId,
        assignments,
    };
}

export const RECEIVE_ASSIGNMENTS_FAILURE = 'RECEIVE_ASSIGNMENTS_FAILURE';
function receiveAssignmentsFailure(courseId) {
    return {
        type: RECEIVE_ASSIGNMENTS_FAILURE,
        courseId,
    };
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
            credentials: 'include',
        })
        .then(handleErrors)
        .then(resp => resp.json())
        .then(assignment => {
            dispatch(createAssignmentSuccess(courseId, assignment));
            return assignment;
        })
        .catch(e => console.error(e));
    };
}

export const CREATE_ASSIGNMENT_SUCCESS = 'CREATE_ASSIGNMENT_SUCCESS';
function createAssignmentSuccess(courseId, assignment) {
    return {
        type: CREATE_ASSIGNMENT_SUCCESS,
        courseId,
        assignment,
    };
}

export function updateAssignment(info) {
    return function(dispatch) {
        let headers = new Headers();
        headers.append('Accept', 'application/json');
        headers.append('Content-Type', 'application/json');
        return fetch(`/api/assignments/${info.id}`, {
            method: 'PUT',
            headers,
            body: JSON.stringify(info),
            credentials: 'include',
        })
        .then(handleErrors)
        .then(resp => resp.json())
        .then(assignment => {
            dispatch(updateAssignmentSuccess(assignment));
            return assignment;
        })
        .catch(e => console.error(e));
    };
}

export const UPDATE_ASSIGNMENT_SUCCESS = 'UPDATE_ASSIGNMENT_SUCCESS';
function updateAssignmentSuccess(assignment) {
    return {
        type: UPDATE_ASSIGNMENT_SUCCESS,
        assignment,
    };
}
