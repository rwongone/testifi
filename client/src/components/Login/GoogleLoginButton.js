/*global gapi*/
import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import { loginGoogle } from '../../actions/user';

class GoogleLoginButton extends Component {
    static propTypes = {
        dispatch: PropTypes.func.isRequired
    }

    componentDidMount() {
        const { dispatch } = this.props;

        gapi.load('auth2', function(){
            const auth2 = gapi.auth2.init({
                client_id: '20208689027-nbm2lpcslog9r8a42c5c06dfg059f7hq.apps.googleusercontent.com',
                cookiepolicy: 'single_host_origin',
                scope: 'email'
            });
            let element = document.getElementById('googleLoginButton');
            auth2.attachClickHandler(element, {},
                    function(googleUser) {
                        dispatch(loginGoogle(googleUser));
                    }, function(error) {
                        console.error(JSON.stringify(error, undefined, 2));
                    });
        });
    }

    render() {
        return (
                <button id="googleLoginButton" className="loginButton">
                    <i className="fa fa-google" aria-hidden="true"></i><span className="name">Google</span>
                </button>
                );
    }
}

export default connect()(GoogleLoginButton);
