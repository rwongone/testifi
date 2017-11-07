import React, { Component } from 'react';
import PropTypes from 'prop-types';
import './AssignmentTile.css';

export default class AssignmentTile extends Component {
    static propTypes = {
        name: PropTypes.string.isRequired,
        onClick: PropTypes.func.isRequired,
    }

    render() {
        const { name, onClick } = this.props;
        return (
                <div className="assignmentTile" onClick={ onClick }>{ name }</div>
        );
    }
}
