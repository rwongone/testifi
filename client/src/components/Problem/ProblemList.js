import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import ProblemTile from './ProblemTile';
import ProblemNew from './ProblemNew';

class ProblemList extends Component {
    static propTypes = {
        problem: ImmutablePropTypes.mapOf(
                            ImmutablePropTypes.contains({
                                problems: ImmutablePropTypes.list.isRequired
                            }).isRequired
                            ).isRequired,
        user: ImmutablePropTypes.contains({
            isAdmin: PropTypes.bool.isRequired,
        }).isRequired,
        match: PropTypes.shape({
            params: PropTypes.shape({
                assignmentId: PropTypes.string.isRequired,
                courseId: PropTypes.string.isRequired
            }).isRequired
        }).isRequired,
        history: PropTypes.object.isRequired
    }

    render() {
        const {
            problem,
            user,
            history,
            match: { params: { assignmentId, courseId } }
        } = this.props;
        const parsedAssignmentId = parseInt(assignmentId, 10);
        const parsedCourseId = parseInt(courseId, 10);
        const problems = problem.getIn([parsedAssignmentId, 'problems']);

        return (
                <div>
                    <h2>Problems</h2>
                    {
                    problems.map(p => <ProblemTile key={ p.get('id') } courseId={ parsedCourseId } assignmentId={ parsedAssignmentId } problem={ p } history={ history } />)
                    }
                    {
                    user.get('isAdmin')
                    ? <ProblemNew courseId={ parsedCourseId } assignmentId={ parsedAssignmentId } history={ history } />
                    : null
                    }
                </div>
                );
    }
}

export default connect(state => ({
    problem: state.problem,
    user: state.user
}))(ProblemList);
