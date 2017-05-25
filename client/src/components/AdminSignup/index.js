import React, { Component } from 'react';
import './AdminSignup.css';

class AdminSignup extends Component {
    onSubmit = e => {
        // TODO post the info to the server
        e.preventDefault();
    }

    render() {
        return (
                <div className="adminSignup">
                    <div className="frame">
                        <h1>Welcome to Testifi</h1>
                        <h2>Please register an admin user</h2>
                        <form className="adminSignupForm" onSubmit={ this.onSubmit }>
                            <label htmlFor="name">Name: </label><input type="text" name="name" />
                            <label htmlFor="email">Email: </label><input type="text" name="email" />
                            <label htmlFor="password">Password: </label><input type="password" name="password" />
                            <label htmlFor="confirmPassword">Confirm Password: </label><input type="password" name="confirmPassword" />
                            <button className="submitButton" type="submit">Create</button>
                        </form>
                    </div>
                </div>
                );
    }
}

export default AdminSignup;
