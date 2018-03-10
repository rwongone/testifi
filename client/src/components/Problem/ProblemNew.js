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
            push: PropTypes.func.isRequired,
        }).isRequired,
    }

    goToProblem = problemId => {
        const {
            assignmentId,
            courseId,
            history,
        } = this.props;
        history.push(`/courses/${courseId}/assignments/${assignmentId}/problems/${problemId}`);
    }

    onSubmit = e => {
        const {
            dispatch,
            assignmentId,
            courseId,
            history: { push },
        } = this.props;

        const problem = {
            name: e.target.name.value,
            description: e.target.description.value,
        };

        dispatch(createProblem(assignmentId, problem)).then(p => push(`/courses/${courseId}/assignments/${assignmentId}/problems/${p.id}`));
        e.preventDefault();
    }

    render() {
        return (
                <div className="problemNew">
                    <div className="problemTileFrame frame">
                        <form className="newProblemForm" onSubmit={ this.onSubmit }>
                            <div>
                                <label htmlFor="name">Name: </label>
                            </div>
                            <div>
                                <input type="text" name="name" className="problemInputField" />
                            </div>
                            <div>
                                <label htmlFor="description">Description: </label>
                            </div>
                            <div>
                                <textarea rows="16" name="description" className="problemInputField" />
                            </div>
                            <button className="submitButton" type="submit">Create</button>
                        </form>
                    </div>
                </div>
        );
    }
}

export default connect()(ProblemNew);
