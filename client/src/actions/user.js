export const REGISTER_ADMIN = 'REGISTER_ADMIN';
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

export const RECEIVE_USER = 'RECEIVE_USER';
function receiveUser(user) {
    return {
        type: RECEIVE_USER,
        user
    }
}
