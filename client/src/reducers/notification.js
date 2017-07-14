import { List, Map } from 'immutable';
import { NOTIFY, UNNOTIFY } from '../actions/notification';

export default function(state = List(), action) {
    switch (action.type) {
        case NOTIFY: {
            return state.push(Map({
                id: action.id,
                notificationType: action.notificationType,
                message: action.message,
            }));
        }

        case UNNOTIFY: {
            return state.filter(n => n.get('id') !== action.id);
        }

        default:
            return state;
    }
}
