import { Map, fromJS } from 'immutable';
import { CREATE_SUBMISSION_SUCCESS, RECEIVE_SUBMISSIONS_SUCCESS } from '../actions/submission';
import { RECEIVE_SUBMISSION_RESULTS_SUCCESS } from '../actions/submissionResults';
import { LOGOUT_SUCCESS } from '../actions/user';

const defaultStateForSubmission = Map({
    fetched: false,
});

export default function(state = Map(), action) {
    switch (action.type) {
        case CREATE_SUBMISSION_SUCCESS:
            return state.set(action.submission.id, defaultStateForSubmission);

        case RECEIVE_SUBMISSIONS_SUCCESS:
            for (let s of action.submissions) {
                state = state.set(s.id, defaultStateForSubmission);
            }
            return state;

        case RECEIVE_SUBMISSION_RESULTS_SUCCESS:
            return state.set(action.submissionId, Map({
                fetched: true,
                results: fromJS(action.results),
            }));

        case LOGOUT_SUCCESS:
            return Map();

        default:
            return state;
    }
}
