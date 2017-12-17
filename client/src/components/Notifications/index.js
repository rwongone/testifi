import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import Notification from './Notification';
import './Notification.css';

class Notifications extends Component {
    static propTypes = {
        notification: ImmutablePropTypes.listOf(ImmutablePropTypes.contains({
            id: PropTypes.number.isRequired,
        })).isRequired,
    }

    render() {
        const { notification } = this.props;
        return (
                <div className="notifications">
                    { notification.map(n => <Notification key={ n.get('id') } data={ n } />) }
                </div>
        );
    }
}

export default connect(state => ({
    notification: state.notification,
}))(Notifications);
