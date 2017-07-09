import { Map, List, fromJS } from 'immutable';
import { CREATE_COURSE_SUCCESS, RECEIVE_COURSES_SUCCESS } from '../actions/course';
import {
    CREATE_ASSIGNMENT_SUCCESS,
    FETCH_ASSIGNMENTS,
    RECEIVE_ASSIGNMENTS_FAILURE,
    RECEIVE_ASSIGNMENTS_SUCCESS
} from '../actions/assignment';

const defaultStateForCourse = Map({
    fetched: false,
    fetching: false,
    assignments: List()
});
export default function(state = Map(), action) {
    switch (action.type) {
        case CREATE_ASSIGNMENT_SUCCESS:
            return state.updateIn([action.courseId, 'assignments'], a => a.push(fromJS(action.assignment)));

        case RECEIVE_COURSES_SUCCESS:
            for (let c of action.courses) {
                // there is a race where assignments can be fetched before courses
                if (!state.get(c.id)) {
                    state = state.set(c.id, defaultStateForCourse);
                }
            }
            return state;

        case CREATE_COURSE_SUCCESS:
            return state.set(action.course.id, Map({
                fetched: false,
                assignments: List()
            }));

        case FETCH_ASSIGNMENTS:
            if (!state.get(action.courseId)) {
                return state.set(action.courseId, defaultStateForCourse.set('fetching', true));
            }
            return state.update(action.courseId, m => m.merge({
                fetching: true
            }));

        case RECEIVE_ASSIGNMENTS_SUCCESS:
            return state.set(action.courseId, Map({
                fetched: true,
                fetching: false,
                assignments: fromJS(action.assignments)
            }));

        case RECEIVE_ASSIGNMENTS_FAILURE:
            return state.update(action.courseId, m => m.merge({
                fetched: false,
                fetching: false
            }));

        default:
            return state;
    }
}
