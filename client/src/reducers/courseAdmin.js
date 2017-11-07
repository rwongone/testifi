import { Map, List, fromJS } from 'immutable';
import {
    RECEIVE_INVITES_SUCCESS,
    RECEIVE_STUDENTS_SUCCESS,
    INVITE_SUCCESS
} from '../actions/courseAdmin';
import {
    CREATE_COURSE_SUCCESS,
    RECEIVE_COURSES_SUCCESS
} from '../actions/course';

function parseAndSort(...inviteLists) {
    let invs = List();
    for (const l of inviteLists) {
        invs = invs.concat(l);
    }
    invs = invs.map(i => i.update('created_at', s => new Date(s)));
    return invs.sortBy(i => i.get('email'));
}

const defaultStateForCourse = Map({
    invitesFetched: false,
    invites: List(),
    studentsFetched: false,
    students: List(),
});
export default function(state = Map(), action) {
    switch (action.type) {
        case INVITE_SUCCESS: {
            return state.updateIn(
                    [action.courseId, 'invites'],
                    invs => parseAndSort(invs, fromJS(action.invites))
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

        case RECEIVE_INVITES_SUCCESS:
            return state.update(action.courseId, courseState => {
                return courseState
                    .set('invitesFetched', true)
                    .set(
                            'invites',
                            parseAndSort(fromJS(action.invites)),
                            );
            });

        case RECEIVE_STUDENTS_SUCCESS:
            return state.update(action.courseId, courseState => courseState.set('studentsFetched', true).set('students', fromJS(action.students)));

        case CREATE_COURSE_SUCCESS:
            return state.set(action.course.id, defaultStateForCourse);

        default:
            return state;
    }
}
