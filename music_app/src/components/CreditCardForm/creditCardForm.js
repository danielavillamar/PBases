import React from 'react'; 
import { connect } from 'react-redux';
import { reduxForm, Field } from 'redux-form';
import { Redirect } from 'react-router-dom';

import './styles.css';

import makeRequest from '../requests/index';

import * as actions from '../../actions/auth';
import * as selectors from '../../reducers/index';

//Variables de entorno
require('dotenv').config({ path: '../../../.env' });
//Encriptacion de password del usuario
const Cryptr = require('cryptr');
const cryptr = new Cryptr('proyecto-1-db');

const plans = [0, 3, 6, 12];

const CreditCardForm = ({ handleSubmit, submitting, emailAddress, onSubmit, dispatch, creditCardAdded }) => {
    return (
    <div className = "wrapper">
        <div className = "form-wrapper">
            <h1>Selecciona tu Plan</h1>
            <form onSubmit={handleSubmit(values => {
                    values.emailAddress = emailAddress;
                    onSubmit(values, dispatch)
                })}>
                <Field name="plan" className="firstName" label="Plan" component={renderSelect}>
                    {plans.map(plan =>
                        <option key={plan} value={plan}>
                        {plan} Meses
                        </option>
                    )}
                </Field>
                <Field name="ccnumber" type="number" className="firstName" label="Numero de Tarjeta" component={renderInput}/>
                <Field name="cvv" label="CVV" component={renderInput}/>
                <div className="createAccount">
                    <button type="submit" disabled={submitting}>Agregar Tarjeta</button>
                </div>
            </form>
            { creditCardAdded ? <Redirect to="/user-home"/> : null}
        </div>
    </div>
    )
};

const validate = values => {//Validacion del Register Form

    const error = {}

    if(!values.plan){
        error.plan = 'Campo requerido'
    }
    if(!values.ccnumber){
        error.ccnumber = 'Campo requerido'
    } else if (values.ccnumber.length !== 16 || /\D/.test(values.ccnumber)){
        error.ccnumber = 'Numero de Tarjeta invalido'
    }
    if(!values.cvv){
        error.cvv = 'Campo requerido'
    } else if(values.cvv.length !== 3 || /\D/.test(values.cvv)){
        error.cvv = 'CVV Invalido'
    }

    return error
}

const renderSelect = ({ input, children, label }) => 
    <div className="field">
        <label>{label}</label>
        <select {...input}>{children}</select>
    </div>

const renderInput = ({ input, meta, label }) =>
    <div className="field" >
        <label>{label}</label>
        <input {...input} className={[meta.active ? 'active' : '', meta.error && meta.touched ? 'error' : '', meta.active && meta.error ? 'active' : ''].join('')} placeholder={label}/>
        {meta.error && meta.touched && <span className="errorMessage">{meta.error}</span>}
    </div>

export default reduxForm({
    form: 'creditcardForm',
    destroyOnUnmount: false,
    onSubmit(values, dispatch){
        values.ccnumber = cryptr.encrypt(values.ccnumber);
        values.cvv = cryptr.encrypt(values.cvv);
        dispatch(actions.loadUser());
        const requestInfo = { uri: `http://localhost:8000/user/${values.emailAddress}`, type: 'PUT' };
        makeRequest(values, requestInfo, (res) => {
            dispatch(actions.addCreditCard());
        });
    },
    validate,
})(connect(
    state => ({
        emailAddress: selectors.getUser(state),
        creditCardAdded: selectors.getCreditCard(state),
    }),
)(CreditCardForm))