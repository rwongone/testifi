import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import { UNKNOWN_USER_ID } from '../../constants';
import GithubLoginButton from './GithubLoginButton.js';
import GoogleLoginButton from './GoogleLoginButton.js';
import './Login.css';

class Login extends Component {
    static propTypes = {
        user: ImmutablePropTypes.contains({
            id: PropTypes.number.isRequired
        }).isRequired,
        history: PropTypes.shape({
            push: PropTypes.func.isRequired
        }),
        dontRedirectWhenLoggedIn: PropTypes.bool,
        instructionText: PropTypes.string,
    }

    redirectWhenLoggedIn = props => {
        const {
            history,
            dontRedirectWhenLoggedIn,
            user
        } = props;
        if (user.get('id') !== UNKNOWN_USER_ID && !dontRedirectWhenLoggedIn) {
            history.push('/courses');
        }
    }

    componentWillMount() {
        this.redirectWhenLoggedIn(this.props);
    }

    componentWillReceiveProps(nextProps) {
        this.redirectWhenLoggedIn(nextProps);
    }

    render() {
        const { instructionText } = this.props;

        return (
                <div className="login">
                    <div className="frame">
                        <div>{ instructionText || 'Please login with one of the supported services:' }</div>
                        <div className="loginButtons">
                            <GoogleLoginButton />
                            <GithubLoginButton />
                        </div>
                    </div>
                </div>
                );
    }
}

export default connect(state => ({
    user: state.user
}))(Login);
