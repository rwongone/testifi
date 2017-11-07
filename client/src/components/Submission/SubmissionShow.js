import React, { Component } from 'react';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import { connect } from 'react-redux';
import { fetchSubmissionResults } from '../../actions/submissionResults';
import './SubmissionShow.css';

class SubmissionShow extends Component {
    static propTypes = {
        match: PropTypes.shape({
            params: PropTypes.shape({
                assignmentId: PropTypes.string.isRequired,
                courseId: PropTypes.string.isRequired,
                problemId: PropTypes.string.isRequired,
                submissionId: PropTypes.string.isRequired,
            }).isRequired,
        }).isRequired,
        history: PropTypes.shape({
            push: PropTypes.func.isRequired,
        }).isRequired,
        submissionResults: ImmutablePropTypes.mapOf(ImmutablePropTypes.contains({
            fetched: PropTypes.bool.isRequired,
            results: ImmutablePropTypes.contains({
                total_tests: PropTypes.number.isRequired,
                num_passed: PropTypes.number.isRequired,
            }),
        })).isRequired,
        dispatch: PropTypes.func.isRequired,
    }

    getCourseId = () => {
        const {
            match: { params: { courseId } },
        } = this.props;
        return parseInt(courseId, 10);
    }

    getAssignmentId = () => {
        const {
            match: { params: { assignmentId } },
        } = this.props;
        return parseInt(assignmentId, 10);
    }

    getProblemId = () => {
        const {
            match: { params: { problemId } },
        } = this.props;
        return parseInt(problemId, 10);
    }

    getSubmissionId = () => {
        const {
            match: { params: { submissionId } },
        } = this.props;
        return parseInt(submissionId, 10);
    }

    goBackToSubmissions = () => {
        const {
            history: { push },
        } = this.props;

        push(`/courses/${this.getCourseId()}/assignments/${this.getAssignmentId()}/problems/${this.getProblemId()}`);
    }

    componentWillMount() {
        const { submissionResults, dispatch } = this.props;
        const submissionId = this.getSubmissionId();

        if (!submissionResults.getIn([submissionId, 'fetched'])) {
            dispatch(fetchSubmissionResults(submissionId));
        }
    }

    render() {
        const results = this.props.submissionResults.getIn([this.getSubmissionId(), 'results']);
        return (
                <div className="submissionShow">
                    <h1>
                        <div className="backButtonAndText" onClick={ this.goBackToSubmissions }><i className="fa fa-angle-left backButton" aria-hidden="true"></i>Submissions</div>
                    </h1>
                    {
                    results
                    ? (
                    <div>
                        <h2>Test Results</h2>
                        This submission passed { results.get('num_passed') }/{ results.get('total_tests') } tests.
                    </div>
                    ) : null
                    }
                </div>
        );
    }
}

export default connect(state => ({
    submissionResults: state.submissionResults,
}))(SubmissionShow);
