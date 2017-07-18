import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import classNames from 'classnames';
import ProblemList from '../Problem/ProblemList';
import { updateAssignment } from '../../actions/assignment';
import './AssignmentDetails.css';

class AssignmentDetails extends Component {
    static propTypes = {
        assignment: ImmutablePropTypes.contains({
            assignments: ImmutablePropTypes.mapOf(
                ImmutablePropTypes.contains({
                    id: PropTypes.number.isRequired,
                    name: PropTypes.string.isRequired,
                    description: PropTypes.string.isRequired
                })
                )
        }),
        match: PropTypes.shape({
            params: PropTypes.shape({
                assignmentId: PropTypes.string.isRequired,
                courseId: PropTypes.string.isRequired
            }).isRequired
        }).isRequired,
        dispatch: PropTypes.func.isRequired,
        history: PropTypes.object.isRequired,
        isAdmin: PropTypes.bool.isRequired,
    }

    constructor(props) {
        super(props);
        const assignment = this.getAssignment(props);
        this.state = {
            nameEdit: false,
            name: assignment.get('name'),
        };
    }

    getCourseId = () => {
        const {
            match: { params: { courseId } }
        } = this.props;
        return parseInt(courseId, 10);
    }

    getAssignment = props => {
        const {
            match: { params: { assignmentId } },
            assignment,
        } = props;
        const parsedAssignmentId = parseInt(assignmentId, 10);
        const courseId = this.getCourseId();
        return assignment.getIn([courseId, 'assignments']).find(a => a.get('id') === parsedAssignmentId);
    }

    beginNameEdit = () => {
        const { isAdmin } = this.props;
        if (!isAdmin) {
            return;
        }

        this.setState({ nameEdit: true });
    }

    submitNameEdit = () => {
        const { dispatch } = this.props;
        const { name } = this.state;
        const info = this.getAssignment(this.props).toJS();
        info.name = name;
        dispatch(updateAssignment(info));
        this.setState({ nameEdit: false });
    }

    cancelNameEdit = () => {
        this.setState({ nameEdit: false });
    }

    onChange = field => e => {
        const newState = {};
        newState[field] = e.target.value;
        this.setState(newState);
        e.preventDefault();
    }

    render() {
        const {
            history,
            isAdmin,
        } = this.props;
        const {
            nameEdit,
            name,
        } = this.state;
        const courseId = this.getCourseId();
        const ass = this.getAssignment(this.props);

        return (
                <div className="assignmentDetails">
                    {
                    nameEdit
                    ? (
                    <div className="nameEdit">
                        <input type="text" value={ name } onChange={ this.onChange('name') }/>
                        <button onClick={ this.cancelNameEdit }>Cancel</button>
                        <button onClick={ this.submitNameEdit }>Edit</button>
                    </div>
                    )
                    : <h1 onClick={ this.beginNameEdit } className={ classNames({ editable: isAdmin }) }>{ ass.get('name') }</h1>
                    }
                    <div>
                        Description:
                    </div>
                    <div>
                        { ass.get('description') }
                    </div>
                    <ProblemList courseId={ courseId } assignmentId={ ass.get('id') } history={ history } />
                </div>
                );
    }
}

export default connect(state => ({
    assignment: state.assignment,
    isAdmin: state.user.get('isAdmin'),
}))(AssignmentDetails);
