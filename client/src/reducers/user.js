import { Map } from 'immutable';
import { RECEIVE_USER } from '../actions/user';

export default function(state = Map({
    fetched: false,
    admin: false,
    email: '',
    name: '',
    id: null
}), action) {
    switch (action.type) {
        case RECEIVE_USER:
            const {
                admin,
                email,
                name,
                id
            } = action.user;

            return state.merge({
                fetched: true,
                admin,
                email,
                name,
                id
            });
        default:
            return state;
    }
}
