import { handleErrors } from './util';

export function submitSubmission(problemId, file) {
    return function(dispatch) {
        // submit file as formdata
        const fd = new FormData();
        fd.append("file", file);
        let headers = new Headers();
        headers.append('Accept', 'application/json');
        return fetch(`/api/problems/${problemId}/submissions`, {
            method: 'POST',
            headers,
            body: fd,
            credentials: 'include'
        })
        .then(handleErrors)
        // TODO notify the user of success somehow (perhaps messaging system)
        .catch(e => console.error(e));
    }
}
