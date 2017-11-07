import React, { Component } from 'react';
import { Route, Switch, withRouter } from 'react-router-dom';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import Home from '../Home';
import Login from '../Login';
import Nav from '../Nav';
import Notifications from '../Notifications';
import { fetchUser } from '../../actions/user';
import RedeemInvite from '../RedeemInvite';
import './App.css';

class App extends Component {
    static propTypes = {
        dispatch: PropTypes.func.isRequired,
        user: ImmutablePropTypes.contains({
            fetched: PropTypes.bool.isRequired,
        }),
    }

    componentWillMount() {
        const {
            dispatch,
            user: { fetched },
        } = this.props;

        if (!fetched) {
            dispatch(fetchUser());
        }
    }

    render() {
        return (
                <div>
                    <Nav />
                    <Switch>
                        <Route path="/login" component={ Login } />
                        <Route path="/redeem/:inviteId" component={ RedeemInvite } />
                        <Route path="/" component={ Home } />
                    </Switch>
                    <Notifications />
                </div>
        );
    }
}

// need withrouter to force a rerender on route change (user selects a course from dropdown)
export default withRouter(connect(state => ({
    user: state.user,
}))(App));
