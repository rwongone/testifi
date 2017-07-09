import { Map, List, fromJS } from 'immutable';
import { RECEIVE_COURSES_SUCCESS } from '../actions/course';
import { CREATE_ASSIGNMENT_SUCCESS, RECEIVE_ASSIGNMENTS_SUCCESS } from '../actions/assignment';

export default function(state = Map(), action) {
    switch (action.type) {
        case CREATE_ASSIGNMENT_SUCCESS:
            return state.updateIn([action.courseId, 'assignments'], a => a.push(fromJS(action.assignment)));

        case RECEIVE_COURSES_SUCCESS:
            for (let c of action.courses) {
                // there is a race where assignments can be fetched before courses
                if (!state.get(c.id)) {
                    state = state.set(c.id, Map({
                        fetched: false,
                        assignments: List()
                    }));
                }
            }
            return state;

        case RECEIVE_ASSIGNMENTS_SUCCESS:
            return state.set(action.courseId, Map({
                fetched: true,
                assignments: fromJS(action.assignments)
            }));

        default:
            return state;
    }
}
