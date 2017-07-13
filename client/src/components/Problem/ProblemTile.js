import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import Filedrop from '../Filedrop';
import { submitSubmission } from '../../actions/submission';

class ProblemTile extends Component {
    static propTypes = {
        courseId: PropTypes.number.isRequired,
        assignmentId: PropTypes.number.isRequired,
        problem: ImmutablePropTypes.contains({
            id: PropTypes.number.isRequired,
            name: PropTypes.string.isRequired
        }),
        history: PropTypes.shape({
            push: PropTypes.func.isRequired
        }).isRequired,
        dispatch: PropTypes.func.isRequired
    }

    constructor(props) {
        super(props);
        this.state = {
            accepted: null,
            rejected: null
        };
    }

    onAccept = accepted => {
        const { dispatch, problem } = this.props;

        this.setState({
            rejected: null,
        });

        dispatch(submitSubmission(problem.get('id'), accepted));
    }

    onReject = rejected => {
        this.setState({
            rejected
        });
    }

    goToProblem = () => {
        const {
            assignmentId,
            courseId,
            problem,
            history,
            user,
        } = this.props;
        if (user.get('isAdmin')) {
            history.push(`/courses/${courseId}/assignments/${assignmentId}/problems/${problem.get('id')}`);
        }
    }

    render() {
        const { problem, user } = this.props;
        const { accepted, rejected } = this.state;

        return (
                <div>
                    <div className="problemTileFrame frame existing" onClick={ this.goToProblem } >
                        <h3>{ problem.get('name') }</h3>
                        {
                        !user.get('isAdmin')
                        ? (
                        <div className="submitSection">
                            <label htmlFor="input">Submit: </label>
                            <Filedrop onAccept={ this.onAccept } onReject={ this.onReject } accepted={ accepted } rejected={ rejected } />
                        </div>
                        ) : null
                        }
                    </div>
                </div>
                );
    }
}

export default connect(state => ({
    user: state.user,
}))(ProblemTile);
