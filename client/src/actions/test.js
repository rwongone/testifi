import { handleErrors } from './util';

export function fetchTests(problemId) {
    return function(dispatch) {
        let headers = new Headers();
        headers.append('Accept', 'application/json');
        headers.append('Content-Type', 'application/json');
        return fetch(`/api/problems/${problemId}/tests`, {
            method: 'GET',
            headers,
            credentials: 'include'
        })
        .then(handleErrors)
        .then(resp => resp.json())
        .then(tests => {
            dispatch(receiveTestsSuccess(problemId, tests));
            return tests;
        })
        .catch(e => console.error(e));
    }
}

export const RECEIVE_TESTS_SUCCESS = 'RECEIVE_TESTS_SUCCESS';
function receiveTestsSuccess(problemId, tests) {
    return {
        type: RECEIVE_TESTS_SUCCESS,
        problemId,
        tests
    }
}

export function createTest(problemId, info) {
    return function(dispatch) {
        // since tests contain an input file, they must be posted as form data
        const fd = new FormData();
        fd.append("name", info.name);
        fd.append("hint", info.hint);
        fd.append("file", info.file);
        let headers = new Headers();
        headers.append('Accept', 'application/json');
        return fetch(`/api/problems/${problemId}/tests`, {
            method: 'POST',
            headers,
            body: fd,
            credentials: 'include'
        })
        .then(handleErrors)
        .then(resp => resp.json())
        .then(test => {
            dispatch(createTestSuccess(problemId, test));
            return test;
        })
        .catch(e => console.error(e));
    }
}

export const CREATE_TEST_SUCCESS = 'CREATE_TEST_SUCCESS';
function createTestSuccess(problemId, test) {
    return {
        type: CREATE_TEST_SUCCESS,
        problemId,
        test
    }
}
