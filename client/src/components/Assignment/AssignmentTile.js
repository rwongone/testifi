import React, { Component } from 'react';
import PropTypes from 'prop-types';
import './AssignmentTile.css';

export default class AssignmentTile extends Component {
    static propTypes = {
        title: PropTypes.string.isRequired,
        id: PropTypes.number.isRequired
    }

    // TODO make tiles clickable
    render() {
        const { title } = this.props;
        return (
                <div className="assignmentTile">{ title }</div>
                );
    }
}
