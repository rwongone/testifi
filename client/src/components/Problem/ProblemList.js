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
                                problems: ImmutablePropTypes.listOf(ImmutablePropTypes.contains({
                                    id: PropTypes.number.isRequired,
                                })).isRequired,
                            }).isRequired
                            ).isRequired,
        user: ImmutablePropTypes.contains({
            isAdmin: PropTypes.bool.isRequired,
        }).isRequired,
        courseId: PropTypes.number.isRequired,
        assignmentId: PropTypes.number.isRequired,
        history: PropTypes.object.isRequired,
    }

    render() {
        const {
            problem,
            user,
            history,
            courseId,
            assignmentId,
        } = this.props;
        const problems = problem.getIn([assignmentId, 'problems']);

        return (
                <div className="problemList">
                    <h2>Problems</h2>
                    {
                    problems.map(p => <ProblemTile key={ p.get('id') } courseId={ courseId } assignmentId={ assignmentId } problem={ p } history={ history } />)
                    }
                    {
                    user.get('isAdmin')
                    ? <ProblemNew courseId={ courseId } assignmentId={ assignmentId } history={ history } />
                    : null
                    }
                </div>
        );
    }
}

export default connect(state => ({
    problem: state.problem,
    user: state.user,
}))(ProblemList);
