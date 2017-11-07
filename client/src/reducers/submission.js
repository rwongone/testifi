import { Map, List, fromJS } from 'immutable';
import { CREATE_PROBLEM_SUCCESS, RECEIVE_PROBLEMS_SUCCESS } from '../actions/problem';
import { CREATE_SUBMISSION_SUCCESS, RECEIVE_SUBMISSIONS_SUCCESS } from '../actions/submission';
import { LOGOUT_SUCCESS } from '../actions/user';

const defaultStateForProblem = Map({
    fetched: false,
    submissions: List(),
});

export default function(state = Map(), action) {
    switch (action.type) {
        case CREATE_SUBMISSION_SUCCESS:
            return state.updateIn([action.problemId, 'submissions'], p => p.push(fromJS(action.submission).update('created_at', d => new Date(d))));

        case RECEIVE_PROBLEMS_SUCCESS:
            for (let a of action.problems) {
                if (!state.get(a.id)) {
                    state = state.set(a.id, defaultStateForProblem);
                }
            }
            return state;

        case CREATE_PROBLEM_SUCCESS:
            return state.set(action.problem.id, defaultStateForProblem);

        case RECEIVE_SUBMISSIONS_SUCCESS:
            return state.set(action.problemId, Map({
                fetched: true,
                submissions: fromJS(action.submissions).map(s => s.update('created_at', d => new Date(d))),
            }));

        case LOGOUT_SUCCESS:
            return Map();

        default:
            return state;
    }
}
