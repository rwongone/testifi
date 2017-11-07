import { Map, List, fromJS } from 'immutable';
import {
    CREATE_COURSE_SUCCESS,
    RECEIVE_COURSES_SUCCESS
} from '../actions/course';
import { LOGOUT_SUCCESS } from '../actions/user';

export default function(state = Map({
    fetched: false,
    courses: List(),
}), action) {
    switch (action.type) {
        case CREATE_COURSE_SUCCESS:
            return state.update('courses', c => c.push(fromJS(action.course)));

        case RECEIVE_COURSES_SUCCESS:
            return state.merge({
                fetched: true,
                courses: fromJS(action.courses),
            });

        case LOGOUT_SUCCESS:
            return Map({
                fetched: false,
                courses: List(),
            });

        default:
            return state;
    }
}
