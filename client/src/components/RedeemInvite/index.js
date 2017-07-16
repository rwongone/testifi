import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import { UNKNOWN_USER_ID } from '../../constants';
import { redeemInvite } from '../../actions/courseAdmin';
import Login from '../Login';

class RedeemInvite extends Component {
    static propTypes = {
        dispatch: PropTypes.func.isRequired,
        user: ImmutablePropTypes.contains({
            fetched: PropTypes.bool.isRequired,
            id: PropTypes.number.isRequired
        }),
        history: PropTypes.shape({
            push: PropTypes.func.isRequired,
        }).isRequired
    }

    getInviteId = () => {
        const {
            match: { params: { inviteId } }
        } = this.props;

        return inviteId;
    }

    receiveUser = props => {
        const {
            dispatch,
            user,
            history: { push },
        } = props;

        // ensure logged in
        if (user.get('id') === UNKNOWN_USER_ID) {
            return;
        }

        dispatch(redeemInvite(this.getInviteId())).then(inv => {
            if (inv) {
                push(`/courses/${inv.course_id}/assignments`);
            }
        });
    }

    componentWillMount() {
        if (this.props.user.get('fetched')) {
            this.receiveUser(this.props);
        }
    }

    componentWillReceiveProps(nextProps) {
        if (nextProps.user.get('fetched')) {
            this.receiveUser(nextProps);
        }
    }

    render() {
        const { user } = this.props;
        if (!user.get('fetched')) {
            return null;
        }
        return (
                <Login dontRedirectWhenLoggedIn={ true } instructionText="Please login to enroll in the course:" />
                );
    }
}

export default connect(state => ({
    user: state.user
}))(RedeemInvite);
