import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';

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
