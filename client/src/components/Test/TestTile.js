import React, { Component } from 'react';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import './TestTile.css';

export default class TestTile extends Component {
    static propTypes = {
        test: ImmutablePropTypes.contains({
            name: PropTypes.string.isRequired
        }).isRequired
    }

    render() {
        const {
            test
        } = this.props;
        return (
                <div className="testTile">
                    <div className="testTileFrame frame">
                        <h3>{ test.get('name') }</h3>
                        {
                        test.get('hint')
                        ? <div>Hint: { test.get('hint') }</div>
                        : null
                        }
                    </div>
                </div>
                );
    }
}
