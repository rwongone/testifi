import React, { Component } from 'react';
import PropTypes from 'prop-types';
import './AssignmentNav.css';

export default class AssignmentNav extends Component {
    static propTypes = {
        backEnabled: PropTypes.bool,
        courseId: PropTypes.number,
        history: PropTypes.shape({
            push: PropTypes.func.isRequired
        })
    }

    goBack = () => {
        if (!this.props.backEnabled) {
            return;
        }

        const {
            courseId,
            history: { push }
        } = this.props;
        push(`/courses/${courseId}/assignments`);
    }

    render() {
        return (
                <div className="assignmentNav">
                    <div className="backButtonAndText" onClick={ this.goBack }>
                        {
                        this.props.backEnabled ? (
                        <i className="fa fa-angle-left backButton" aria-hidden="true"></i>
                        ) : null
                        }
                        Assignments
                    </div>
                </div>
                    )
    }
}
