import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import { Redirect } from 'react-router-dom';
import classNames from 'classnames';
import { List, Set } from 'immutable';
import { invite } from '../../actions/invite';
import AssignmentNav from '../Assignment/AssignmentNav';
import './CourseAdmin.css';

class CourseAdmin extends Component {
    static propTypes = {
        history: PropTypes.shape({
            push: PropTypes.func.isRequired
        }).isRequired,
        isAdmin: PropTypes.bool.isRequired,
        dispatch: PropTypes.func.isRequired
    }

    constructor(props) {
        super(props);
        this.state = {
            rawEmails: "",
            parsedEmails: List()
        };
    }

    emailChange = e => {
        const parsedEmails = Set(e.target.value.split(/[\s,]+/g)).remove("").toList().sort();
        this.setState({
            parsedEmails,
            rawEmails: e.target.value
        });
    }

    getCourseId = () => {
        const {
            match: { params: { courseId } },
        } = this.props;
        return parseInt(courseId, 10);
    }

    sendInvites = () => {
        const { parsedEmails } = this.state;
        const { dispatch } = this.props;
        if (parsedEmails.isEmpty()) {
            return;
        }

        dispatch(invite(this.getCourseId(), parsedEmails)).then(() => this.setState({ rawEmails: "", parsedEmails: List() }));
    }

    render() {
        const {
            history,
            isAdmin
        } = this.props;
        const { parsedEmails, rawEmails } = this.state;
        const courseId = this.getCourseId();
        const showParsedEmails = parsedEmails.size;

        // TODO add list of pending invitations (with resend button)
        // TODO add list of registered students in the course
        // TODO add a way of seeing user progress in the course
        return isAdmin ? (
                <div className="courseAdmin">
                    <AssignmentNav history={ history } courseId={ courseId } backEnabled={ true } />
                    <div className="frame">
                        <h2>Student Registration</h2>
                        <div className="filedropSection">
                            <div className="instructions">
                                Enter emails into the textbox and then click invite
                            </div>
                            <div className="emailsContainer">
                                <textarea className={ classNames('emailInput', { showParsedEmails }) } onChange={ this.emailChange } value={ rawEmails }/>
                                <div className={ classNames('emails', 'frame', { showParsedEmails }) }>
                                    { parsedEmails.map(e => <div key={ e }>{ e }</div>) }
                                </div>
                            </div>
                            <button className="inviteButton" onClick={ this.sendInvites }>Invite</button>
                        </div>
                    </div>
                </div>
                ) : <Redirect to="/" />;
    }
}

export default connect(state => ({
    isAdmin: state.user.get('isAdmin')
}))(CourseAdmin);
