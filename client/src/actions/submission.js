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
        .then(resp => resp.json())
        .then(submission => {
            dispatch(createSubmissionSuccess(problemId, submission));
            return submission;
        })
        .catch(e => console.error(e));
    }
}

export const CREATE_SUBMISSION_SUCCESS = 'CREATE_SUBMISSION_SUCCESS';
function createSubmissionSuccess(problemId, submission) {
    return {
        type: CREATE_SUBMISSION_SUCCESS,
        problemId,
        submission
    }
}

export function fetchSubmissions(problemId) {
    return function(dispatch) {
        let headers = new Headers();
        headers.append('Accept', 'application/json');
        headers.append('Content-Type', 'application/json');
        return fetch(`/api/problems/${problemId}/submissions`, {
            method: 'GET',
            headers,
            credentials: 'include',
        })
        .then(handleErrors)
        .then(resp => resp.json())
        .then(submissions => {
            dispatch(receiveSubmissionsSuccess(problemId, submissions));
            return submissions;
        })
        .catch(e => console.error(e));
    }
}

export const RECEIVE_SUBMISSIONS_SUCCESS = 'RECEIVE_SUBMISSIONS_SUCCESS';
function receiveSubmissionsSuccess(problemId, submissions) {
    return {
        type: RECEIVE_SUBMISSIONS_SUCCESS,
        problemId,
        submissions,
    }
}
