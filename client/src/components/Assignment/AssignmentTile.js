import React, { Component } from 'react';
import PropTypes from 'prop-types';

export default class AssignmentTile extends Component {
    static propTypes = {
        title: PropTypes.string.isRequired,
        id: PropTypes.number.isRequired
    }

    render() {
        const { title } = this.props;
        return (
                <div>{ title }</div>
                );
    }
}
