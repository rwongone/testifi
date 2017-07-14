import React, { Component } from 'react';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import './TestTile.css';

export default class TestTile extends Component {
    static propTypes = {
        test: ImmutablePropTypes.contains({
            name: PropTypes.string.isRequired,
            db_file_id: PropTypes.number.isRequired,
        }).isRequired,
        isAdmin: PropTypes.bool.isRequired,
    }

    render() {
        const {
            isAdmin,
            test,
        } = this.props;
        // TODO input link
        return (
                <div className="testTile">
                    <div className="testTileFrame frame">
                        <h3>{ test.get('name') }</h3>
                        {
                        isAdmin
                        ? <a target="_blank" href={ `/api/files/${test.get('db_file_id')}` }>Input</a>
                        : null
                        }
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
