import { handleErrors } from './util';

export function fetchProblems(assignmentId) {
    return function(dispatch) {
        let headers = new Headers();
        headers.append('Accept', 'application/json');
        headers.append('Content-Type', 'application/json');
        return fetch(`/api/assignments/${assignmentId}/problems`, {
            method: 'GET',
            headers,
            credentials: 'include'
        })
        .then(handleErrors)
        .then(resp => resp.json())
        .then(problems => {
            dispatch(receiveProblemsSuccess(assignmentId, problems));
            return problems;
        })
        .catch(e => console.error(e));
    }
}

export const RECEIVE_PROBLEMS_SUCCESS = 'RECEIVE_PROBLEMS_SUCCESS';
function receiveProblemsSuccess(assignmentId, problems) {
    return {
        type: RECEIVE_PROBLEMS_SUCCESS,
        assignmentId,
        problems
    }
}

export function createProblem(assignmentId, info) {
    return function(dispatch) {
        let headers = new Headers();
        headers.append('Accept', 'application/json');
        headers.append('Content-Type', 'application/json');
        return fetch(`/api/assignments/${assignmentId}/problems`, {
            method: 'POST',
            headers,
            body: JSON.stringify(info),
            credentials: 'include'
        })
        .then(handleErrors)
        .then(resp => resp.json())
        .then(problem => {
            dispatch(createProblemSuccess(assignmentId, problem));
            return problem;
        })
        .catch(e => console.error(e));
    }
}

export const CREATE_PROBLEM_SUCCESS = 'CREATE_PROBLEM_SUCCESS';
function createProblemSuccess(assignmentId, problem) {
    return {
        type: CREATE_PROBLEM_SUCCESS,
        assignmentId,
        problem
    }
}
