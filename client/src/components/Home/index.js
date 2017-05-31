import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import { Link, Redirect } from 'react-router-dom';
import './Home.css';

class Home extends Component {
    static propTypes = {
        user: ImmutablePropTypes.contains({
            id: PropTypes.number.isRequired,
        })
    }

    render() {
        const id = this.props.user.get('id');

        return id === -1
            ? (
                    <div className="home">
                        <div className="frame">
                            <h1>Welcome to Testifi</h1>
                            This is a platform for testing software. Please <Link to="/login">login</Link> to get started.
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
})(Home);
