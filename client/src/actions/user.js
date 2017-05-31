import { GITHUB_CLIENT_ID } from '../constants';

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
        .then(resp => resp.json())
        .then(user => {
            dispatch(receiveUser(user));
        });
    }
}

export function loginGithub() {
    return function(dispatch) {
        document.location.assign(`http://github.com/login/oauth/authorize?client_id=${GITHUB_CLIENT_ID}`);
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
        .then(resp => {
            if (resp.ok) {
                return resp.json()
            } else {
                throw Error("User is not logged in");
            }
        })
        .then(user => {
            dispatch(receiveUser(user));
        })
        .catch(e => {
            console.log(e);
        });
    }
}

export const RECEIVE_USER = 'RECEIVE_USER';
function receiveUser(user) {
    return {
        type: RECEIVE_USER,
        user
    }
}
