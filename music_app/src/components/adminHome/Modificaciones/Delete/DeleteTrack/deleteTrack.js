import React from 'react'; 

import { connect } from 'react-redux';
import { reduxForm, Field } from 'redux-form';
import { Alert } from 'reactstrap';
import { Redirect } from 'react-router-dom';

import * as actions from '../../../../../actions/req';
import * as selectors from '../../../../../reducers/index';
import makeRequest from '../../../../requests';

const DeleteTrack = ({ handleSubmit, submitting, reqSuccess, reqMsg, modSuccess, tracks }) => {

    return (
        <div className = "wrapper">
            <div className = "form-wrapper">
                <h1>Selecciona Cancion a Eliminar</h1>
                <form onSubmit={handleSubmit}>
                    <Field name="trackid" className="firsname" label="Canciones" component={renderSelect}>
                        {
                            Object.values(tracks).map( track => 
                                <option key={track.id} value={track.id}>
                                    {track.name}
                                </option>
                            )
                        }
                    </Field>
                    {
                        reqSuccess ? <div  className="alert" ><Alert color="danger">Ups! {reqMsg.msg}</Alert></div> : null
                    }
                    <div className="createAccount">
                        <button type="submit" disabled={submitting}>Eliminar Cancion</button>
                    </div>
                </form>
                {
                    modSuccess ? <Redirect to='/admin-home'/> : null
                }
            </div>
        </div>   
    )
}

const validate = values => {//Validacion del Register Form

    const error = {}

    if(!values.trackid){
        error.trackid = 'Campo requerido'
    }

    return error
}

const renderSelect = ({ input, label, children }) => 
    <div className='field'>
        <label>{label}</label>
        <select {...input}>{children}</select>        
    </div>

export default reduxForm({
    form: 'deleteSongForm',
    destroyOnUnmount: false,
    onSubmit(values, dispatch){
        const requestInfo = { uri: `http://localhost:8000/track/delete/${values.trackid}`, type: 'DELETE' };
        makeRequest(values, requestInfo, (res) => {
            dispatch(actions.doRequest(res.action));
        })
    },
    validate,
})(connect(
    state => ({
        reqSuccess: selectors.getReqSuccess(state),
        reqMsg: selectors.getReqMsg(state),
        modSuccess: selectors.getModSuccess(state),
        tracks: selectors.getTracks(state),
    }),
)(DeleteTrack))

