import React, { Component } from 'react';
import { BrowserRouter as Router, Route } from 'react-router-dom';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import Home from '../Home';
import Login from '../Login';
import Nav from '../Nav';
import { fetchUser } from '../../actions/user';
import './App.css';

class App extends Component {
    static propTypes = {
        dispatch: PropTypes.func.isRequired,
        user: ImmutablePropTypes.contains({
            fetched: PropTypes.bool.isRequired,
        })
    }

    componentWillMount() {
        const {
            dispatch,
            user: { fetched }
        } = this.props;

        if (!fetched) {
            dispatch(fetchUser());
        }
    }

    render() {
        return (
                <Router>
                    <div>
                        <Nav />
                        <Route exact path="/" component={ Home } />
                        <Route path="/login" component={ Login } />
                    </div>
                </Router>
                );
    }
}

export default connect(state => {
    return {
        user: state.user
    };
})(App);
