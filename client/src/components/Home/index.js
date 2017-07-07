import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import { Link, Redirect, Route } from 'react-router-dom';
import CoursePage from '../CoursePage';
import './Home.css';

class Home extends Component {
    static propTypes = {
        user: ImmutablePropTypes.contains({
            id: PropTypes.number.isRequired,
        }).isRequired
    }

    render() {
        const fetched = this.props.user.get('fetched');
        // return null until we know if the user is logged in
        if (!fetched) {
            return null;
        }

        const id = this.props.user.get('id');
        const location = this.props.location;
        // if the user is not logged in
        if (id === -1) {
            // if not at the home page, redirect to the home page
            if (location.pathname !== '/') {
                return <Redirect to="/" />
            }

            // return the home page
            return (
                    <div className="home">
                        <div className="frame">
                            <h1>Welcome to Testifi</h1>
                            This is a platform for testing software. Please <Link to="/login">login</Link> to get started.
                        </div>
                    </div>
                    );
        }

        if (location.pathname === '/') {
            return <Redirect to="/courses" />
        }

        return (
                <Route path="/courses" component={ CoursePage } />
                );
    }
}

export default connect(state => ({
    user: state.user
}))(Home);
