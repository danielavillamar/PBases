import React from "react"; 

import { connect } from "react-redux";
import { reduxForm, Field } from "redux-form";
import { v4 as uuid } from "uuid";
import { Alert } from "reactstrap";
import { Redirect } from "react-router-dom";

import * as actions from "../../../../actions/req";
import * as selectors from "../../../../reducers/index";
import makeRequest from "../../../requests";

const NewArtist = ({
  handleSubmit,
  submitting,
  reqSuccess,
  reqMsg,
  modSuccess,
  loggeduser,
  onSubmit,
  dispatch,
}) => {
  //TODO Agregar usuario a consulta
  return (
    <div className="wrapper">
      <div className="form-wrapper">
        <h1>Ingresa un Artista Nuevo</h1>
        <form
          onSubmit={handleSubmit((values) => {
            values.modifiedBy = loggeduser;
            onSubmit(values, dispatch);
          })}
        >
          <Field
            name="artistname"
            className="firstName"
            label="Nombre de Artista"
            component={renderInput}
          />
          {reqSuccess ? (
            <div className="alert">
              <Alert color="danger">Ups! {reqMsg.msg}</Alert>
            </div>
          ) : null}
          <div className="createAccount">
            <button type="submit" disabled={submitting}>
              Agregar Artista
            </button>
          </div>
        </form>
        {modSuccess ? <Redirect to="/admin-home" /> : null}
      </div>
    </div>
  );
};

const validate = (values) => {
  //Validacion del Register Form

  const error = {};

  if (!values.artistname) {
    error.artistname = "Campo requerido";
  }

  return error;
};

const renderInput = ({ input, meta, label }) => (
  <div className="field">
    <label>{label}</label>
    <input
      {...input}
      className={[
        meta.active ? "active" : "",
        meta.error && meta.touched ? "error" : "",
        meta.active && meta.error ? "active" : "",
      ].join("")}
      placeholder={label}
    />
    {meta.error && meta.touched && (
      <span className="errorMessage">{meta.error}</span>
    )}
  </div>
);

export default reduxForm({
  form: "newArtistForm",
  destroyOnUnmount: false,
  onSubmit(values, dispatch) {
    values.artistid = uuid();
    const requestInfo = {
      uri: `http://localhost:8000/new-artist`,
      type: "POST",
    };
    makeRequest(values, requestInfo, (res) => {
      dispatch(actions.doRequest(res.action));
    });
  },
  validate,
})(
  connect((state) => ({
    reqSuccess: selectors.getReqSuccess(state),
    reqMsg: selectors.getReqMsg(state),
    modSuccess: selectors.getModSuccess(state),
    loggeduser: selectors.getUser(state),
  }))(NewArtist)
);
