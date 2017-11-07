import React, { Component } from 'react';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import classNames from 'classnames';

export default class Notification extends Component {
    static propTypes = {
        data: ImmutablePropTypes.contains({
            notificationType: PropTypes.string.isRequired,
            message: PropTypes.string.isRequired,
        }).isRequired,
    }

    render() {
        const { data } = this.props;
        return (
                <div className={ classNames('notification frame', data.get('notificationType')) }>
                    { data.get('message') }
                </div>
        );
    }
}
