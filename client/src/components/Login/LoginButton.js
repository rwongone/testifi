import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';

class LoginButton extends Component {
    static propTypes = {
        action: PropTypes.func.isRequired,
        dispatch: PropTypes.func.isRequired,
        icon: PropTypes.string.isRequired,
        name: PropTypes.string.isRequired
    };

    loginAction = () => {
        const {
            action,
            dispatch
        } = this.props;

        dispatch(action());
    }

    render() {
        const {
            icon,
            name
        } = this.props;

        return (
                <div>
                    <button className="loginButton" onClick={ this.loginAction }><i className={ "fa fa-" + icon } aria-hidden="true"></i><span className="name">{ name }</span></button>
                </div>
                );
    }
}

export default connect()(LoginButton);
