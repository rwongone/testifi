import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import TestTile from './TestTile';
import TestNew from './TestNew';

class TestList extends Component {
    static propTypes = {
        test: ImmutablePropTypes.mapOf(
                            ImmutablePropTypes.contains({
                                tests: ImmutablePropTypes.listOf(ImmutablePropTypes.contains({
                                    id: PropTypes.number.isRequired
                                })).isRequired
                            }).isRequired
                            ).isRequired,
        user: ImmutablePropTypes.contains({
            isAdmin: PropTypes.bool.isRequired,
        }).isRequired,
        problemId: PropTypes.number.isRequired
    }

    render() {
        const {
            test,
            user,
            problemId
        } = this.props;
        const tests = test.getIn([problemId, 'tests']);
        const isAdmin = user.get('isAdmin');

        return (
                <div className="testList">
                    <h2>Tests</h2>
                    {
                    tests.map(t => <TestTile key={ t.get('id') } test={ t } isAdmin={ isAdmin } />)
                    }
                    {
                    user.get('isAdmin')
                    ? <TestNew problemId={ problemId } />
                    : null
                    }
                </div>
                );
    }
}

export default connect(state => ({
    test: state.test,
    user: state.user
}))(TestList);
