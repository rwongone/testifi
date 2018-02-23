import React, { Component } from 'react';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import classNames from 'classnames';
import './ExecutionList.css';

export default class ExecutionList extends Component {
    static propTypes = {
        executions: ImmutablePropTypes.listOf(ImmutablePropTypes.contains({
            output: PropTypes.string.isRequired,
            std_err: PropTypes.string,
            status: PropTypes.string.isRequired,
            hint: PropTypes.string,
            test_name: PropTypes.string,
        }).isRequired)
    }

    render() {
        const { executions } = this.props;

        return executions ? (
                <div className="executionList">
                    { executions.map((execution, idx) => (
                    <div key={ idx } className={ classNames("execution frame", execution.get('status')) }>
                        <div className="executionDetail">
                            <div>{ execution.get('test_name') || "Unnamed Test" }</div>
                        </div>
                        { execution.get('std_error') ? (
                        <div className="executionDetail">
                            <label>Error Output:</label>
                            <div>{ execution.get('std_error') }</div>
                        </div>
                        ) : null }
                        { execution.get('hint') && execution.get('status') === "failed" ? (
                        <div className="executionDetail">
                            <label>Hint:</label>
                            <div>{ execution.get('hint') }</div>
                        </div>
                        ) : null }
                    </div>
                    )) }
                </div>
        ) : null;
    }
}
