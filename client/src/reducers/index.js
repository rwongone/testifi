import { combineReducers } from 'redux';
import user from './user';
import course from './course';

export default combineReducers({
    course,
    user
});
