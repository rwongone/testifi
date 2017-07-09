import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import { createProblem } from '../../actions/problem';
import './ProblemTile.css';
import './ProblemNew.css';

class ProblemNew extends Component {
    static propTypes = {
        dispatch: PropTypes.func.isRequired,
        assignmentId: PropTypes.number.isRequired,
        courseId: PropTypes.number.isRequired,
        history: PropTypes.shape({
            push: PropTypes.func.isRequired
        }).isRequired
    }

    goToProblem = problemId => {
        const {
            assignmentId,
            courseId,
            history
        } = this.props;
        history.push(`/courses/${courseId}/assignments/${assignmentId}/problems/${problemId}`);
    }

    onSubmit = e => {
        const {
            dispatch,
            assignmentId,
            courseId,
            history: { push }
        } = this.props;

        const problem = {
            name: e.target.name.value,
            description: e.target.description.value
        }

        dispatch(createProblem(problem)).then(p => push(`/courses/${courseId}/assignments/${assignmentId}/problems/${p.id}`));
        e.preventDefault();
    }

    render() {
        return (
                <div className="problemNew problemTileFrame frame">
                    <form className="newProblemForm" onSubmit={ this.onSubmit }>
                        <label htmlFor="name">Name: </label><input type="text" name="name" />
                        <label htmlFor="description">Description: </label><input type="text" name="description" />
                        <button className="submitButton" type="submit">Create</button>
                    </form>
                </div>
                );
    }
}

export default connect()(ProblemNew);
