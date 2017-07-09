import React, { Component } from 'react';
import PropTypes from 'prop-types';
import './AssignmentTile.css';

export default class AssignmentTile extends Component {
    static propTypes = {
        title: PropTypes.string.isRequired,
        onClick: PropTypes.func.isRequired
    }

    render() {
        const { title, onClick } = this.props;
        return (
                <div className="assignmentTile" onClick={ onClick }>{ title }</div>
                );
    }
}
