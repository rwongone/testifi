import { Map, List, fromJS } from 'immutable';
import { CREATE_PROBLEM_SUCCESS, RECEIVE_PROBLEMS_SUCCESS } from '../actions/problem';
import { CREATE_TEST_SUCCESS, RECEIVE_TESTS_SUCCESS } from '../actions/test';
import { LOGOUT_SUCCESS } from '../actions/user';

const defaultStateForProblem = Map({
    fetched: false,
    tests: List()
});

export default function(state = Map(), action) {
    switch (action.type) {
        case CREATE_TEST_SUCCESS:
            return state.updateIn([action.problemId, 'tests'], p => p.push(fromJS(action.test)));

        case RECEIVE_PROBLEMS_SUCCESS:
            for (let a of action.problems) {
                // there is a race where tests can be fetched before problems
                if (!state.get(a.id)) {
                    state = state.set(a.id, defaultStateForProblem);
                }
            }
            return state;

        case CREATE_PROBLEM_SUCCESS:
            return state.set(action.problem.id, defaultStateForProblem);

        case RECEIVE_TESTS_SUCCESS:
            return state.set(action.problemId, Map({
                fetched: true,
                tests: fromJS(action.tests)
            }));

        case LOGOUT_SUCCESS:
            return Map();

        default:
            return state;
    }
}
