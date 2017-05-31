import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Redirect } from 'react-router-dom';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import { loginGithub } from '../../actions/user';
import LoginButton from './LoginButton.js';
import './Login.css';

class Login extends Component {
    static propTypes = {
        user: ImmutablePropTypes.contains({
            id: PropTypes.number.isRequired
        })
    }

    render() {
        let id = this.props.user.get('id');
        return id === -1 ? (
                <div className="login">
                    <div className="frame">
                        <div>Please login with one of the supported services:</div>
                        <LoginButton icon="github" name="GitHub" action={ loginGithub } />
                    </div>
                </div>
                )
            : (
                    <Redirect to="/courses" />
                    );
    }
}

export default connect(state => {
    return {
        user: state.user
    }
})(Login);
