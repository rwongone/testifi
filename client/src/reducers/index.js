import { combineReducers } from 'redux';
import user from './user';
import course from './course';
import assignment from './assignment';
import courseAdmin from './courseAdmin';
import problem from './problem';
import test from './test';
import submission from './submission';
import submissionResults from './submissionResults';
import notification from './notification';

export default combineReducers({
    assignment,
    course,
    courseAdmin,
    problem,
    submission,
    submissionResults,
    test,
    user,
    notification,
});
