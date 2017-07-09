import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';

class ProblemTile extends Component {
    static propTypes = {
        courseId: PropTypes.number.isRequired,
        assignmentId: PropTypes.number.isRequired,
        problem: ImmutablePropTypes.contains({
            id: PropTypes.number.isRequired,
            name: PropTypes.string.isRequired,
            description: PropTypes.string.isRequired
        }),
        history: PropTypes.shape({
            push: PropTypes.func.isRequired
        }).isRequired
    }

    goToProblem = () => {
        const {
            assignmentId,
            courseId,
            problem,
            history
        } = this.props;
        history.push(`/courses/${courseId}/assignments/${assignmentId}/problems/${problem.get('id')}`);
    }

    render() {
        const {
            problem
        } = this.props;

        return (
                <div>
                    { problem.get('name') }
                </div>
                );
    }
}

export default connect()(ProblemTile);
