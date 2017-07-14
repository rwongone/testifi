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
            credentials: 'include'
        })
        .then(handleErrors)
        .then(resp => resp.json())
        .then(invites => {
            dispatch(inviteSuccess(invites));
            return invites;
        })
        .catch(e => console.error(e));
    }
}

export const INVITE_SUCCESS = 'INVITE_SUCCESS';
function inviteSuccess(invites) {
    return {
        type: INVITE_SUCCESS,
        invites
    }
}

export function redeemInvite(inviteId) {
    return function(dispatch) {
        let headers = new Headers();
        headers.append('Accept', 'application/json');
        headers.append('Content-Type', 'application/json');
        return fetch(`/api/invites/${inviteId}/redeem`, {
            method: 'GET',
            headers,
            credentials: 'include'
        })
        .then(handleErrors)
        .then(resp => resp.json())
        .then(inv => {
            // refresh courses
            dispatch(fetchCourses());
            return inv;
        })
        .catch(e => console.error(e));
    }
}
