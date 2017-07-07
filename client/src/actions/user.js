import { GITHUB_CLIENT_ID } from '../constants';
import { handleErrors } from './util';

export function registerAdmin(admin) {
    return function(dispatch) {
        let headers = new Headers();
        headers.append('Accept', 'application/json');
        headers.append('Content-Type', 'application/json');
        return fetch('/admin', {
            method: 'POST',
            body: JSON.stringify(admin),
            headers
        })
        .then(handleErrors)
        .then(resp => resp.json())
        .then(user => {
            dispatch(receiveUser(user));
        })
        .catch(e => console.error(e));
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
        fetch(`/api/users/oauth/google?code=${googleUser.getAuthResponse().id_token}`, {
            credentials: 'include',
            headers: headers
        })
        .then(handleErrors)
        .then(resp => resp.json())
        .then(user => {
            dispatch(receiveUser(user));
            return user;
        })
        .catch(e => console.error(e));
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
            dispatch(receiveUser(user));
            return user;
        })
        .catch(e => console.log(e));
    }
}

export const RECEIVE_USER = 'RECEIVE_USER';
function receiveUser(user) {
    return {
        type: RECEIVE_USER,
        user
    }
}
