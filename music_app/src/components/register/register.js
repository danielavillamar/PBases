import React from 'react'; 
import { connect } from 'react-redux';
import { reduxForm, Field } from 'redux-form';
import isValidEmail from 'sane-email-validation';
import { Alert } from 'reactstrap';
import { Link, Redirect } from 'react-router-dom';
import './styles.css';

import makeRequest from '../requests/index';

import * as actions from '../../actions/auth';
import * as selectors from '../../reducers/index';

//Variables de entorno
require('dotenv').config({ path: '../../../.env' });
//Encriptacion de password del usuario
const Cryptr = require('cryptr');
const cryptr = new Cryptr('proyecto-1-db');

const Register = ({ handleSubmit, submitting, error, isAuth, onClick }) => {
    return (
    <div className = "wrapper">
        <div className = "form-wrapper">
            <h1>Crea tu cuenta</h1>
            <form onSubmit={handleSubmit}>
                <Field name="firstname" className="firstName" label="Nombre" component={renderInput}/>
                <Field name="lastname" className="firstName" label="Apellido" component={renderInput}/>
                <Field name="emailAddress" type="email" label="Correo Electronico" component={renderInput}/>
                <div className="field">
                    <label>Contraseña</label>
                    <Field name="password" type="password" label="Contraseña" component="input" placeholder="Contraseña"/>
                </div>
                {
                    error ? <div  className="alert" ><Alert color="danger">Ups! {error}</Alert></div> : null
                }
                <div className="createAccount">
                    <button type="submit" disabled={submitting}>Crear Cuenta</button>
                    <Link to='/' onClick={onClick}><small>¿Ya tienes una cuenta?</small></Link>
                </div>
            </form>
            { isAuth ? <Redirect to='/select-your-plan'/> : null }
        </div>
    </div>
    )
};

const validate = values => {//Validacion del Register Form

    const error = {}

    if(!values.firstName){
        error.firstName = 'Campo requerido'
    }
    if(!values.lastName){
        error.lastName = 'Campo requerido'
    }
    if(!values.emailAddress){
        error.emailAddress = 'Campo requerido'
    } else if(!isValidEmail(values.emailAddress)){
        error.emailAddress = 'Correo electronico invalido'
    }
    if(!values.password){
        error.password = 'Campo requerido'
    }

    return error
}

const renderInput = ({ input, meta, label }) =>
    <div className="field" >
        <label>{label}</label>
        <input {...input} className={[meta.active ? 'active' : '', meta.error && meta.touched ? 'error' : '', meta.active && meta.error ? 'active' : ''].join('')} placeholder={label}/>
        {meta.error && meta.touched && <span className="errorMessage">{meta.error}</span>}
    </div>

export default reduxForm({
    form: 'registerForm',
    destroyOnUnmount: false,
    onSubmit(values, dispatch){
        dispatch(actions.loadUser());
        //Envia password encriptado a API
        values.password = cryptr.encrypt(values.password);
        //Info de la request
        const requestInfo = { uri: 'http://localhost:8000/users', type: 'POST' };
        makeRequest(values, requestInfo, (res) => {
            dispatch(actions.registerUser(res.action));
        });
    },
    validate
})(connect(
    state => ({
        error: selectors.getAuthMsg(state),
        isAuth: selectors.getIsAuth(state)
    }),
    dispatch => ({
        onClick(){
            dispatch(actions.clearError())
        }
    })
)(Register))