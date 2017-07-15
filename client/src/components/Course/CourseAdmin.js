import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import { Redirect } from 'react-router-dom';
import classNames from 'classnames';
import { List, Set } from 'immutable';
import { invite, resendInvite } from '../../actions/courseAdmin';
import { fetchUnusedInvites, fetchStudents } from '../../actions/courseAdmin';
import AssignmentNav from '../Assignment/AssignmentNav';
import './CourseAdmin.css';

class CourseAdmin extends Component {
    static propTypes = {
        history: PropTypes.shape({
            push: PropTypes.func.isRequired
        }).isRequired,
        match: PropTypes.shape({
            params: PropTypes.shape({
                courseId: PropTypes.string.isRequired,
            }).isRequired,
        }).isRequired,
        isAdmin: PropTypes.bool.isRequired,
        dispatch: PropTypes.func.isRequired,
        courseAdmin: ImmutablePropTypes.mapOf(ImmutablePropTypes.contains({
            studentsFetched: PropTypes.bool.isRequired,
            students: ImmutablePropTypes.listOf(ImmutablePropTypes.contains({
                email: PropTypes.string,
                name: PropTypes.string,
            })).isRequired,
            invitesFetched: PropTypes.bool.isRequired,
            invites: ImmutablePropTypes.listOf(ImmutablePropTypes.contains({
                email: PropTypes.string.isRequired,
            })).isRequired,
        }).isRequired).isRequired,
    }

    constructor(props) {
        super(props);
        this.state = {
            rawEmails: "",
            parsedEmails: List()
        };
    }

    componentWillMount() {
        const { courseAdmin, dispatch } = this.props;
        const courseId = this.getCourseId();
        if (!courseAdmin.getIn([courseId, 'invitesFetched'])) {
            dispatch(fetchUnusedInvites(courseId));
        }
        if (!courseAdmin.getIn([courseId, 'studentsFetched'])) {
            console.log('should fetch students');
            // dispatch(fetchStudents(courseId));
        }
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

        dispatch(invite(this.getCourseId(), parsedEmails))
            .then(() => this.setState({ rawEmails: "", parsedEmails: List() }));
    }

    resend = id => () => {
        const { dispatch } = this.props;
        dispatch(resendInvite(id));
    }

    render() {
        const {
            courseAdmin,
            history,
            isAdmin,
        } = this.props;
        const { parsedEmails, rawEmails } = this.state;
        const courseId = this.getCourseId();
        const invites = courseAdmin.getIn([courseId, 'invites']);
        const students = courseAdmin.getIn([courseId, 'students']);
        const showParsedEmails = parsedEmails.size;

        // TODO add a way of seeing user progress in the course
        return isAdmin ? (
                <div className="courseAdmin">
                    <AssignmentNav history={ history } courseId={ courseId } backEnabled={ true } />
                    <div className="frame">
                        {
                        !students.isEmpty()
                        ? (
                        <div>
                            <h2>Students</h2>
                            <div className="studentListFrame frame">
                                <div className="studentList">
                                    {
                                    students.map(s => (
                                    <div key={ s.get('id') }>
                                        { s.get('email') || s.get('name') }
                                    </div>
                                    ))
                                    }
                                </div>
                            </div>
                        </div>
                        ) : null
                        }
                        {
                        !invites.isEmpty()
                        ? (
                        <div>
                            <h2>Pending Invites</h2>
                            <div className="inviteListFrame frame">
                                <div className="inviteTableHeaders">
                                    <div>Email</div>
                                    <div>Date sent</div>
                                    <button className="hiddenButton inviteResendButton">Resend</button>
                                </div>
                                <div className="inviteList">
                                    {
                                    invites.map(i => (
                                    <div key={ i.get('id') } className="pendingInvite">
                                        <div>{ i.get('email') }</div>
                                        <div>{ i.get('created_at').toLocaleDateString() }</div>
                                        <button className="inviteResendButton" onClick={ this.resend(i.get('id')) }>Resend</button>
                                    </div>
                                    ))
                                    }
                                </div>
                            </div>
                        </div>
                        ) : null
                        }
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
    isAdmin: state.user.get('isAdmin'),
    courseAdmin: state.courseAdmin,
}))(CourseAdmin);
