import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';

class CourseNew extends Component {
    static propTypes = {
        dispatch: PropTypes.func.isRequired
    }

    render() {
        return (
                <div>Course create form here</div>
                );
    }
}

export default connect()(CourseNew);
