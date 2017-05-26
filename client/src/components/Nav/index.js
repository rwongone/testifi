import React, { Component } from 'react';
import { connect } from 'react-redux';
import ImmutablePropTypes from 'react-immutable-proptypes';
import PropTypes from 'prop-types';
import './Nav.css';

class Nav extends Component {
    static propTypes = {
        user: ImmutablePropTypes.contains({
            admin: PropTypes.bool.isRequired,
            email: PropTypes.string.isRequired,
            name: PropTypes.string.isRequired,
            id: PropTypes.number.isRequired
        })
    }

    render() {
        const {
            user
        } = this.props;

        return (
                <div className="nav">
                    <div className="name">
                        Testifi
                    </div>
                    <div className="greeting">
                        { user.get('fetched') ? `Hello ${user.get('name')}` : '' }
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
