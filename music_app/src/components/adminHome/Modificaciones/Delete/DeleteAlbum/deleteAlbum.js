import React from 'react'; 

import { connect } from 'react-redux';
import { reduxForm, Field } from 'redux-form';
import { v4 as uuid } from 'uuid';
import { Alert } from 'reactstrap';
import { Redirect } from 'react-router-dom';

import * as actions from '../../../../../actions/req';
import * as selectors from '../../../../../reducers/index';
import makeRequest from '../../../../requests';

const DeleteAlbum = ({ handleSubmit, submitting, reqSuccess, reqMsg, modSuccess, albums }) => {

    return (
        <div className = "wrapper">
            <div className = "form-wrapper">
                <h1>Selecciona Album a Eliminar</h1>
                <form onSubmit={handleSubmit}>
                    <Field name="albumid" className="firsname" label="Album" component={renderSelect}>
                        {
                            Object.values(albums).map( album => 
                                <option key={album.id} value={album.id}>
                                    {album.name}
                                </option>
                            )
                        }
                    </Field>
                    {
                        reqSuccess ? <div  className="alert" ><Alert color="danger">Ups! {reqMsg.msg}</Alert></div> : null
                    }
                    <div className="createAccount">
                        <button type="submit" disabled={submitting}>Eliminar Album</button>
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

    if(!values.albumid){
        error.albumid = 'Campo requerido'
    }

    return error
}

const renderSelect = ({ input, label, children }) => 
    <div className='field'>
        <label>{label}</label>
        <select {...input}>{children}</select>        
    </div>

export default reduxForm({
    form: 'deleteAlbumForm',
    destroyOnUnmount: false,
    onSubmit(values, dispatch){
        const requestInfo = { uri: `http://localhost:8000/album/delete/${values.albumid}`, type: 'DELETE' };
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
        albums: selectors.getAlbums(state),
    }),
)(DeleteAlbum))

