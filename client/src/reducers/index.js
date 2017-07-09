import { combineReducers } from 'redux';
import user from './user';
import course from './course';
import assignment from './assignment';
import problem from './problem';

export default combineReducers({
    assignment,
    course,
    problem,
    user
});
