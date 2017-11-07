import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { loginGithub } from '../../actions/user';

class GithubLoginButton extends Component {
    static propTypes = {
        dispatch: PropTypes.func.isRequired,
    };

    loginAction = () => {
        const {
            dispatch,
        } = this.props;

        dispatch(loginGithub());
    }

    render() {
        return (
                <button className="loginButton" onClick={ this.loginAction }>
                    <i className="fa fa-github" aria-hidden="true"></i><span className="name">Github</span>
                </button>
        );
    }
}

export default connect()(GithubLoginButton);
