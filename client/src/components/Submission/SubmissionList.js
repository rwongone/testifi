import React, { Component } from 'react';
import PropTypes from 'prop-types';
import Filedrop from '../Filedrop';
import { submitSubmission } from '../../actions/submission';

class SubmissionList extends Component {
    static propTypes = {
        problemId: PropTypes.number.isRequired,
        dispatch: PropTypes.func.isRequired,
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

    render() {
        const { problemId } = this.props;
        const { accepted, rejected } = this.state;

        return (
                <div className="submissionList">
                    <div className="submitSection">
                        <label htmlFor="input">Submit: </label>
                        <Filedrop onAccept={ this.onAccept } onReject={ this.onReject } accepted={ accepted } rejected={ rejected } accept=".java,.py" />
                    </div>
                    Submissions
                </div>
                );
    }
}

export default SubmissionList;
