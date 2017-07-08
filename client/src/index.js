import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';
import { BrowserRouter as Router } from 'react-router-dom';
import { createStore, applyMiddleware } from 'redux';
import thunkMiddleware from 'redux-thunk';
import App from './components/App';
import registerServiceWorker from './registerServiceWorker';
import reducers from './reducers';
import './index.css';

let store = createStore(
        reducers,
        applyMiddleware(thunkMiddleware)
        );

ReactDOM.render(
        <Provider store={store}>
            <Router>
                <App />
            </Router>
        </Provider>,
        document.getElementById('root')
        );
registerServiceWorker();
