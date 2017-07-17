import React, { Component } from 'react';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import { connect } from 'react-redux';
import Filedrop from '../Filedrop';
import { fetchSubmissions, submitSubmission } from '../../actions/submission';
import './SubmissionList.css';

class SubmissionList extends Component {
    static propTypes = {
        problemId: PropTypes.number.isRequired,
        courseId: PropTypes.number.isRequired,
        assignmentId: PropTypes.number.isRequired,
        dispatch: PropTypes.func.isRequired,
        submission: ImmutablePropTypes.mapOf(
                            ImmutablePropTypes.contains({
                                fetched: PropTypes.bool.isRequired,
                                submissions: ImmutablePropTypes.listOf(ImmutablePropTypes.contains({
                                    id: PropTypes.number.isRequired,
                                    created_at: PropTypes.instanceOf(Date).isRequired,
                                })).isRequired
                            }).isRequired
                            ).isRequired,
        history: PropTypes.shape({
            push: PropTypes.func.isRequired,
        }).isRequired
    }

    constructor(props) {
        super(props);
        this.state = {
            rejected: null
        };
    }

    onAccept = accepted => {
        const {
            dispatch,
            problemId,
            courseId,
            assignmentId,
            history: { push },
        } = this.props;

        this.setState({
            rejected: null,
        });

        dispatch(submitSubmission(problemId, accepted))
            .then(s => {
                push(`/courses/${courseId}/assignments/${assignmentId}/problems/${problemId}/submissions/${s.id}`);
            });
    }

    onReject = rejected => {
        this.setState({
            rejected
        });
    }

    componentWillMount() {
        const {
            dispatch,
            problemId,
            submission,
        } = this.props;
        if (!submission.getIn([problemId, 'fetched'])) {
            dispatch(fetchSubmissions(problemId));
        }
    }

    goToSubmission = submissionId => () => {
        const {
            history: { push },
            courseId,
            assignmentId,
            problemId,
        } = this.props;
        push(`/courses/${courseId}/assignments/${assignmentId}/problems/${problemId}/submissions/${submissionId}`);
    }

    render() {
        const { problemId, submission } = this.props;
        const { rejected } = this.state;
        const submissions = submission.getIn([problemId, 'submissions']);

        return (
                <div className="submissionList">
                    <div className="submitSection">
                        <h2>Submit</h2>
                        <Filedrop onAccept={ this.onAccept } onReject={ this.onReject } rejected={ rejected } accept=".java,.py" />
                    </div>
                    <h2>Previous Submissions</h2>
                    {
                    submissions.map((s, i) => (
                    <div className="submissionFrame frame" key={ s.get('id') } onClick={ this.goToSubmission(s.get('id')) }>
                        <h3>{ 'Submission ' + i }</h3>
                    </div>
                    ))
                    }
                </div>
                );
    }
}

export default connect(state => ({
    submission: state.submission,
}))(SubmissionList);
