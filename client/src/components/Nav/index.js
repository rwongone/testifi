import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Link, withRouter } from 'react-router-dom';
import ImmutablePropTypes from 'react-immutable-proptypes';
import PropTypes from 'prop-types';
import CourseDropdown from './CourseDropdown';
import { UNKNOWN_USER_ID } from '../../constants';
import './Nav.css';

class Nav extends Component {
    static propTypes = {
        user: ImmutablePropTypes.contains({
            name: PropTypes.string.isRequired
        }).isRequired
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
                    <CourseDropdown />
                    <div className="greeting">
                        {
                        user.get('fetched') && user.get('id') !== UNKNOWN_USER_ID
                        ? `Hello ${user.get('name')}`
                        : <Link to="/login"><button>Login</button></Link>
                        }
                    </div>
                </div>
                );
    }
}

// need withrouter to force a rerender on route change (user selects a course from dropdown)
export default withRouter(connect(state => ({
    user: state.user
}))(Nav));
