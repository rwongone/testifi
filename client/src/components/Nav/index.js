import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';
import ImmutablePropTypes from 'react-immutable-proptypes';
import PropTypes from 'prop-types';
import './Nav.css';

class Nav extends Component {
    static propTypes = {
        user: ImmutablePropTypes.contains({
            name: PropTypes.string.isRequired
        })
    }

    render() {
        const {
            user
        } = this.props;

        return (
                <div className="nav">
                    <Link to="/">
                        <div className="name">
                            Testifi
                        </div>
                    </Link>
                    <div className="greeting">
                        {
                        user.get('fetched')
                        ? `Hello ${user.get('name')}`
                        : <Link to="/login"><button>Login</button></Link>
                        }
                    </div>
                </div>
                );
    }
}

export default connect(state => {
    return {
        user: state.user
    }
})(Nav);
