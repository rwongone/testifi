import { Map, List, fromJS } from 'immutable';
import { CREATE_ASSIGNMENT_SUCCESS, RECEIVE_ASSIGNMENTS_SUCCESS } from '../actions/assignment';
import { CREATE_PROBLEM_SUCCESS, RECEIVE_PROBLEMS_SUCCESS } from '../actions/problem';
import { CREATE_SUBMISSION_SUCCESS } from '../actions/submission';
import { LOGOUT_SUCCESS } from '../actions/user';

const defaultStateForAssignment = Map({
    fetched: false,
    problems: List(),
});

export default function(state = Map(), action) {
    switch (action.type) {
        case CREATE_PROBLEM_SUCCESS:
            return state.updateIn([action.assignmentId, 'problems'], p => p.push(fromJS(action.problem)));

        case RECEIVE_ASSIGNMENTS_SUCCESS:
            for (let a of action.assignments) {
                // there is a race where problems can be fetched before assignments
                if (!state.get(a.id)) {
                    state = state.set(a.id, defaultStateForAssignment);
                }
            }
            return state;

        case CREATE_ASSIGNMENT_SUCCESS:
            return state.set(action.assignment.id, defaultStateForAssignment);

        case RECEIVE_PROBLEMS_SUCCESS:
            return state.set(action.assignmentId, Map({
                fetched: true,
                problems: fromJS(action.problems),
            }));

        case CREATE_SUBMISSION_SUCCESS: {
            if (!action.isSolution) {
                return state;
            }
            const problemIndex = state.getIn([action.assignmentId, 'problems']).findIndex(p => p.get('id') === action.problemId);
            return state.setIn([action.assignmentId, 'problems', problemIndex, 'solution_id'], action.submission.id);
        }

        case LOGOUT_SUCCESS:
            return Map();

        default:
            return state;
    }
}
