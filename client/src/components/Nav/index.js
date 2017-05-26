import React, { Component } from 'react';
import { connect } from 'react-redux';
import './Nav.css';

class Nav extends Component {
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
