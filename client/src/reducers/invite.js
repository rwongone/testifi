import { Map, List, Set } from 'immutable';
import { INVITE_SUCCESS } from '../actions/invite';
import { CREATE_COURSE_SUCCESS, RECEIVE_COURSES_SUCCESS } from '../actions/course';

function mergeAndSort(l1, l2) {
    return Set(l1).union(l2).toList().sort();
}


const defaultStateForCourse = Map({
    fetched: false,
    invites: List()
});
export default function(state = Map(), action) {
    switch (action.type) {
        case INVITE_SUCCESS: {
            return state.updateIn(
                    [action.courseId, 'invites'],
                    invs => mergeAndSort(
                        invs,
                        action.invites.map(i => i.email)
                        )
                    );
        }

        case RECEIVE_COURSES_SUCCESS:
            for (let c of action.courses) {
                state = state.set(c.id, defaultStateForCourse);
            }
            return state;

        case CREATE_COURSE_SUCCESS:
            return state.set(action.course.id, defaultStateForCourse);

        default:
            return state;
    }
}
