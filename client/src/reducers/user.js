import { Map } from 'immutable';
import { RECEIVE_USER_SUCCESS, RECEIVE_USER_FAILURE } from '../actions/user';
import { UNKNOWN_USER_ID } from '../constants';

export default function(state = Map({
    fetched: false,
    isAdmin: false,
    email: '',
    name: '',
    id: UNKNOWN_USER_ID,
}), action) {
    switch (action.type) {
        case RECEIVE_USER_SUCCESS:
            const {
                admin,
                email,
                name,
                id
            } = action.user;

            return state.merge({
                fetched: true,
                isAdmin: admin,
                email,
                name,
                id
            });

        case RECEIVE_USER_FAILURE:
            return state.merge({
                fetched: true
            });

        default:
            return state;
    }
}
