import { Map, List, fromJS } from 'immutable';
import { RECEIVE_COURSES_SUCCESS } from '../actions/course';

export default function(state = Map({
    fetched: false,
    courses: List()
}), action) {
    switch (action.type) {
        case RECEIVE_COURSES_SUCCESS:
            return state.merge({
                fetched: true,
                courses: fromJS(action.courses)
            });

        default:
            return state;
    }
}
