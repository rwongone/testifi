import { combineReducers } from 'redux';
import user from './user';
import course from './course';
import assignment from './assignment';
import invite from './invite';
import problem from './problem';
import test from './test';

export default combineReducers({
    assignment,
    course,
    invite,
    problem,
    test,
    user
});
