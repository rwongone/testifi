import { Map, List, fromJS } from 'immutable';
import {
    CREATE_COURSE_SUCCESS,
    RECEIVE_COURSES_SUCCESS,
} from '../actions/course';

export default function(state = Map({
    fetched: false,
    courses: List()
}), action) {
    switch (action.type) {
        case CREATE_COURSE_SUCCESS:
            return state.update('courses', c => c.push(fromJS(action.course)));

        case RECEIVE_COURSES_SUCCESS:
            return state.merge({
                fetched: true,
                courses: fromJS(action.courses)
            });

        default:
            return state;
    }
}
