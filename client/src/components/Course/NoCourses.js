import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import './NoCourses.css';

class NoCourses extends Component {
    static propTypes = {
        user: ImmutablePropTypes.contains({
            isAdmin: PropTypes.bool.isRequired,
        }).isRequired,
    }

    render() {
        const { user } = this.props;

        return (
                <div className="noCourses">
                    <div className="frame">
                        <h2>
                            You are not enrolled in any classes<i className="fa fa-frown-o frown" aria-hidden="true"></i>
                        </h2>
                        <div>
                            Please ask your instructor to enroll { user.get('email') || 'you' } in a class so you can begin your studies.
                        </div>
                    </div>
                </div>
        );
    }
}

export default connect(state => ({
    user: state.user,
}))(NoCourses);
