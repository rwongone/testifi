import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import AssignmentTile from './AssignmentTile';

class AssignmentList extends Component {
    static propTypes = {
        assignment: ImmutablePropTypes.mapOf(
                            ImmutablePropTypes.contains({
                                fetched: PropTypes.bool.isRequired,
                                assignments: ImmutablePropTypes.list.isRequired
                            }).isRequired
                            ).isRequired,
        user: ImmutablePropTypes.contains({
            isAdmin: PropTypes.bool.isRequired,
        }).isRequired
    }

    render() {
        const {
            user,
            match
        } = this.props;

        debugger;
        return (
                <div>
                </div>
                );
    }
}

export default connect(state => ({
    assignment: state.assignment,
    user: state.user
}))(AssignmentList);
