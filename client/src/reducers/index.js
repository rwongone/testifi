import { combineReducers } from 'redux';
import user from './user';
import course from './course';
import assignment from './assignment';

export default combineReducers({
    assignment,
    course,
    user
});
