import { handleErrors } from './util';
import { fetchCourses } from './course';

export function invite(courseId, emails) {
    return function(dispatch) {
        let headers = new Headers();
        headers.append('Accept', 'application/json');
        headers.append('Content-Type', 'application/json');
        return fetch(`/api/courses/${courseId}/invites`, {
            method: 'POST',
            headers,
            body: JSON.stringify({ emails }),
            credentials: 'include',
        })
        .then(handleErrors)
        .then(resp => resp.json())
        .then(invites => {
            dispatch(inviteSuccess(courseId, invites));
            return invites;
        })
        .catch(e => console.error(e));
    };
}

export const INVITE_SUCCESS = 'INVITE_SUCCESS';
function inviteSuccess(courseId, invites) {
    return {
        type: INVITE_SUCCESS,
        courseId,
        invites,
    };
}

export function resendInvite(inviteId) {
    return function(dispatch) {
        let headers = new Headers();
        headers.append('Accept', 'application/json');
        return fetch(`/api/invites/${inviteId}/resend`, {
            method: 'POST',
            headers,
            credentials: 'include',
        })
        .then(handleErrors)
        .catch(e => console.error(e));
    };
}

export function redeemInvite(inviteId) {
    return function(dispatch) {
        let headers = new Headers();
        headers.append('Accept', 'application/json');
        return fetch(`/api/invites/${inviteId}/redeem`, {
            headers,
            credentials: 'include',
        })
        .then(handleErrors)
        .then(resp => resp.json())
        .then(inv => {
            // refresh courses
            dispatch(fetchCourses());
            return inv;
        })
        .catch(e => console.error(e));
    };
}

export function fetchUnusedInvites(courseId) {
    return function(dispatch) {
        let headers = new Headers();
        headers.append('Accept', 'application/json');
        return fetch(`/api/courses/${courseId}/invites/unused`, {
            headers,
            credentials: 'include',
        })
        .then(handleErrors)
        .then(resp => resp.json())
        .then(invites => {
            dispatch(receiveInvitesSuccess(courseId, invites));
            return invites;
        })
        .catch(e => console.error(e));
    };
}

export const RECEIVE_INVITES_SUCCESS = 'RECEIVE_INVITES_SUCCESS';
function receiveInvitesSuccess(courseId, invites) {
    return {
        type: RECEIVE_INVITES_SUCCESS,
        courseId,
        invites,
    };
}

export function fetchStudents(courseId) {
    return function(dispatch) {
        let headers = new Headers();
        headers.append('Accept', 'application/json');
        return fetch(`/api/courses/${courseId}/students`, {
            headers,
            credentials: 'include',
        })
        .then(handleErrors)
        .then(resp => resp.json())
        .then(students => {
            dispatch(receiveStudentsSuccess(courseId, students));
            return students;
        })
        .catch(e => console.error(e));
    };
}

export const RECEIVE_STUDENTS_SUCCESS = 'RECEIVE_STUDENTS_SUCCESS';
function receiveStudentsSuccess(courseId, students) {
    return {
        type: RECEIVE_STUDENTS_SUCCESS,
        courseId,
        students,
    };
}
