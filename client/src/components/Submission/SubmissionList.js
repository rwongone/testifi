import React, { Component } from 'react';
import PropTypes from 'prop-types';

class SubmissionList extends Component {
    static propTypes = {
        problemId: PropTypes.number.isRequired
    }

    render() {
        const { problemId } = this.props;

        return (
                <div className="submissionList">
                    Submissions
                </div>
                );
    }
}

export default SubmissionList;
