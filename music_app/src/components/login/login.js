import React from 'react'; 
import { connect } from 'react-redux';
import { reduxForm, Field } from 'redux-form';
import isValidEmail from 'sane-email-validation';
import { Link, Redirect } from 'react-router-dom';
import { Alert } from 'reactstrap';
import './styles.css';

import makeRequest from '../requests/index';
import * as selectors from '../../reducers/index';

import * as actions from '../../actions/auth';
import * as actions2 from '../../actions/stats';
import * as actions3 from '../../actions/albums';
import * as actions4 from '../../actions/artists';
import * as actions5 from '../../actions/tracks';

//Variables de entorno
require('dotenv').config({ path: '../../../.env' });
//Encriptacion de password del usuario
const Cryptr = require('cryptr');
const cryptr = new Cryptr('proyecto-1-db');

const Login = ({ handleSubmit, submitting, error, onClick, isAdminUser, isAuthenticated, isLoadingStats, albumsLoaded, artistsLoaded, tracksLoaded }) => {
    return (
    <div className = "wrapper">
        <div className = "form-wrapper">
            <h1>Ingresa a tu cuenta</h1>
            <form onSubmit={handleSubmit}>
                <Field name="emailAddress" type="email" label="Correo Electronico" component={renderInput}/>
                <div className="field">
                    <label>Contraseña</label>
                    <Field name="password" type="password" label="Contraseña" component="input" placeholder="Contraseña"/>
                </div>
                {
                    error ? <div  className="alert" ><Alert color="danger">Ups! {error}</Alert></div> : null
                }
                <div className="createAccount">
                    <button type="submit" disabled={submitting}>Login</button>
                    <Link to='/register' onClick={onClick}><small>¿No tienes una cuenta?</small></Link>
                </div>
            </form>
            { isAdminUser && isAuthenticated && !isLoadingStats && albumsLoaded && artistsLoaded && tracksLoaded ? <Redirect to='/admin-home'/> : null}
            { !isAdminUser && isAuthenticated ? <Redirect to='/user-home'/> : null}
        </div>
    </div>
    )
};

const validate = values => {//Validacion del Register Form

    const error = {}

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
    form: 'loginForm',
    destroyOnUnmount: false,
    onSubmit(values, dispatch){

        //ESTADISTICAS
        dispatch(actions2.loadStats());
        const requestInfo2 = { uri: `http://localhost:8000/stats`, type: 'GET' };
        makeRequest(null, requestInfo2, (res2) => {
            dispatch(actions2.loadedStats(res2.action));
        })

        //ALBUMS
        const requestInfo3 = { uri: `http://localhost:8000/albums`, type: 'GET' };
        makeRequest(null, requestInfo3, (res3) => {
            dispatch(actions3.loadAlbums(res3.action));
        })

        //ARTISTS
        const requestInfo4 = { uri: `http://localhost:8000/artists`, type: 'GET' };
        makeRequest(null, requestInfo4, (res4) => {
            dispatch(actions4.loadArtists(res4.action));
        })

        //TRACKS
        const requestInfo5 = { uri: `http://localhost:8000/tracks`, type: 'GET' };
        makeRequest(null, requestInfo5, (res5) => {
            dispatch(actions5.loadTracks(res5.action));
        })

        //Logea al usuario y verifica si es ADMIN
        dispatch(actions.loadUser());
        const requestInfo = { uri: `http://localhost:8000/user/${values.emailAddress}/${cryptr.encrypt(values.password)}`, type: 'GET' };
        makeRequest(values, requestInfo, (res) => {
            dispatch(actions.loginUser(res.action));
        });
        
    },
    validate
})(connect(
    state => ({
        error: selectors.getAuthMsg(state),
        isAdminUser: selectors.getIsAdminUser(state),
        isAuthenticated: selectors.getIsAuth(state),
        isLoadingStats: selectors.getLoadingStats(state),
        albumsLoaded: selectors.getAlbumsLoaded(state),
        artistsLoaded: selectors.getArtistsLoaded(state),
        tracksLoaded: selectors.getTracksLoaded(state),
    }),
    dispatch => ({
        onClick(){
            dispatch(actions.clearError())
        }
    })
)(Login))