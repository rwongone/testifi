import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import './AssignmentNav.css';

class AssignmentNav extends Component {
    static propTypes = {
        backEnabled: PropTypes.bool,
        courseId: PropTypes.number.isRequired,
        history: PropTypes.shape({
            push: PropTypes.func.isRequired
        }).isRequired,
        isAdmin: PropTypes.bool.isRequired
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

    goToAdmin = () => {
        const {
            courseId,
            history: { push }
        } = this.props;
        push(`/courses/${courseId}/admin`);
    }

    render() {
        const { backEnabled, isAdmin } = this.props;
        return (
                <div className="assignmentNav">
                    <div className="backButtonAndText" onClick={ this.goBack }>
                        {
                        backEnabled ? (
                        <i className="fa fa-angle-left backButton" aria-hidden="true"></i>
                        ) : null
                        }
                        Assignments
                    </div>
                    <div className="adminButton">
                    {
                    isAdmin ? <button className="courseAdminButton" onClick={ this.goToAdmin }>Course Administration</button> : null
                    }
                    </div>
                </div>
                    )
    }
}

export default connect(state => ({
    isAdmin: state.user.get('isAdmin')
}))(AssignmentNav);
