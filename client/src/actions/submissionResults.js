import { handleErrors } from './util';

export function fetchSubmissionResults(submissionId) {
    return function(dispatch) {
        let headers = new Headers();
        headers.append('Accept', 'application/json');
        return fetch(`/api/submissions/${submissionId}/results`, {
            method: 'GET',
            headers,
            credentials: 'include',
        })
        .then(handleErrors)
        .then(resp => resp.json())
        .then(results => {
            dispatch(receiveSubmissionResultsSuccess(submissionId, results));
            return results;
        })
        .catch(e => console.error(e));
    }
}

export const RECEIVE_SUBMISSION_RESULTS_SUCCESS = 'RECEIVE_SUBMISSION_RESULTS_SUCCESS';
function receiveSubmissionResultsSuccess(submissionId, results) {
    return {
        type: RECEIVE_SUBMISSION_RESULTS_SUCCESS,
        submissionId,
        results,
    }
}

