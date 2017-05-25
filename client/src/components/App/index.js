import React, { Component } from 'react';
import AdminSignup from '../AdminSignup';
import Nav from '../Nav';
import './App.css';

class App extends Component {
    render() {
        // TODO only display admin signup when necessary
        return (
                <div>
                    <Nav />
                    <AdminSignup />
                </div>
                );
    }
}

export default App;
