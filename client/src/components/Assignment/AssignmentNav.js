import React, { Component } from 'react';
import PropTypes from 'prop-types';
import './AssignmentNav.css';

export default class AssignmentNav extends Component {
    static propTypes = {
        title: PropTypes.string
    }

    render() {
        let { title } = this.props;
        if (!title) {
            title = 'Assignments';
        }

        return (
                <div className="assignmentNav">
                    { title }
                </div>
                    )
    }
}
