import React, { Component } from 'react';
import { connect } from 'react-redux';
import { PropTypes } from 'prop-types';
import { registerAdmin } from '../../actions/user';
import './AdminSignup.css';

class AdminSignup extends Component {
    static propTypes = {
        dispatch: PropTypes.func.isRequired,
    }

    constructor() {
        super();
        this.state = {
            password: '',
            confirmPassword: '',
            hasStartedConfirmingPassword: false,
        };
    }

    onSubmit = e => {
        const {
            dispatch,
        } = this.props;

        const data = {
            name: e.target.name.value,
            email: e.target.email.value,
            password: e.target.password.value,
        };
        if (data.password !== e.target.confirmPassword.value) {
            alert('Passwords must match before proceeding');
            e.preventDefault();
            return;
        }
        if (!data.password.length) {
            alert('Password cannot be empty');
            e.preventDefault();
            return;
        }
        dispatch(registerAdmin(data));
        e.preventDefault();
    }

    onPasswordChange = e => {
        this.setState({
            password: e.target.value,
        });
    }

    onConfirmPasswordChange = e => {
        this.setState({
            confirmPassword: e.target.value,
            hasStartedConfirmingPassword: true,
        });
    }

    render() {
        const {
            confirmPassword,
            password,
            hasStartedConfirmingPassword,
        } = this.state;

        let confirmPasswordClass = '';
        if (hasStartedConfirmingPassword) {
            confirmPasswordClass = password === confirmPassword
                ? 'passwordMatch'
                : 'passwordNonmatch';
        }

        return (
                <div className="adminSignup">
                    <div className="frame">
                        <h1>Welcome to Testifi</h1>
                        <h2>Please register an admin user</h2>
                        <form className="adminSignupForm" onSubmit={ this.onSubmit }>
                            <label htmlFor="name">Name: </label><input type="text" name="name" />
                            <label htmlFor="email">Email: </label><input type="text" name="email" />
                            <label htmlFor="password">Password: </label><input type="password" name="password" onChange={ this.onPasswordChange } value={ password } />
                            <label htmlFor="confirmPassword">Confirm Password: </label><input type="password" name="confirmPassword" onChange={ this.onConfirmPasswordChange } value={ confirmPassword } className={ confirmPasswordClass } />
                            <button className="submitButton" type="submit">Create</button>
                        </form>
                    </div>
                </div>
        );
    }
}

export default connect()(AdminSignup);
