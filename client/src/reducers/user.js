import { Map } from 'immutable';
import { RECEIVE_USER_SUCCESS, RECEIVE_USER_FAILURE } from '../actions/user';
import { UNKNOWN_USER_ID } from '../constants';
import { LOGOUT_SUCCESS } from '../actions/user';

const defaultUserState = Map({
    fetched: false,
    isAdmin: false,
    email: '',
    name: '',
    id: UNKNOWN_USER_ID,
});
export default function(state = defaultUserState, action) {
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

        case LOGOUT_SUCCESS:
            return defaultUserState.set('fetched', true);

        default:
            return state;
    }
}
