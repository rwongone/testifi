import { GITHUB_CLIENT_ID } from '../constants';
import { handleErrors } from './util';

export function logout() {
    return function(dispatch) {
        let headers = new Headers();
        return fetch(`/api/logout`, {
            credentials: 'include',
            headers: headers,
        })
        .then(handleErrors)
        .then(() => {
            dispatch(logoutSuccess());
        })
        .catch(e => {
            console.error(e)
        });
    }
}

export const LOGOUT_SUCCESS = 'LOGOUT_SUCCESS';
function logoutSuccess() {
    return {
        type: LOGOUT_SUCCESS,
    }
}

export function loginGithub() {
    return function(dispatch) {
        document.location.assign(`http://github.com/login/oauth/authorize?client_id=${GITHUB_CLIENT_ID}`);
    }
}

export function loginGoogle(googleUser) {
    return function(dispatch) {
        let headers = new Headers();
        headers.append('Accept', 'application/json');
        headers.append('Content-Type', 'application/json');
        return fetch(`/api/users/oauth/google?code=${googleUser.getAuthResponse().id_token}`, {
            credentials: 'include',
            headers: headers
        })
        .then(handleErrors)
        .then(resp => resp.json())
        .then(user => {
            dispatch(receiveUserSuccess(user));
            return user;
        })
        .catch(e => {
            dispatch(receiveUserFailure());
            console.error(e)
        });
    }
}

export function fetchUser() {
    return function(dispatch) {
        let headers = new Headers();
        headers.append('Accept', 'application/json');
        headers.append('Content-Type', 'application/json');
        return fetch('/api/user', {
            method: 'GET',
            headers,
            credentials: 'include'
        })
        .then(handleErrors)
        .then(resp => resp.json())
        .then(user => {
            dispatch(receiveUserSuccess(user));
            return user;
        })
        .catch(e => {
            dispatch(receiveUserFailure());
            console.error(e);
        });
    }
}

export const RECEIVE_USER_SUCCESS = 'RECEIVE_USER_SUCCESS';
function receiveUserSuccess(user) {
    return {
        type: RECEIVE_USER_SUCCESS,
        user
    }
}

export const RECEIVE_USER_FAILURE = 'RECEIVE_USER_FAILURE';
function receiveUserFailure() {
    return {
        type: RECEIVE_USER_FAILURE
    }
}
