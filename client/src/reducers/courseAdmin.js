import { Map, List, Set, fromJS } from 'immutable';
import { INVITE_SUCCESS } from '../actions/courseAdmin';
import {
    CREATE_COURSE_SUCCESS,
    RECEIVE_COURSE_SUCCESS,
    RECEIVE_COURSES_SUCCESS,
} from '../actions/course';

function mergeAndSort(l1, l2) {
    return Set(l1).union(l2).toList().sortBy(i => i.get('email'));
}


const defaultStateForCourse = Map({
    fetched: false,
    invites: List(),
    students: List(),
});
export default function(state = Map(), action) {
    switch (action.type) {
        case INVITE_SUCCESS: {
            return state.updateIn(
                    [action.courseId, 'invites'],
                    invs => mergeAndSort(
                        invs,
                        fromJS(action.invites),
                        )
                    );
        }

        case RECEIVE_COURSES_SUCCESS:
            for (let c of action.courses) {
                // make sure not to clobber a fetched course
                if (!state.get(c.id)) {
                    state = state.set(c.id, defaultStateForCourse);
                }
            }
            return state;

        case RECEIVE_COURSE_SUCCESS:
            return state.set(action.course.id, Map({
                fetched: true,
                invites: fromJS(action.course.invites) || List(),
                students: fromJS(action.course.students) || List(),
            }));

        case CREATE_COURSE_SUCCESS:
            return state.set(action.course.id, defaultStateForCourse);

        default:
            return state;
    }
}
