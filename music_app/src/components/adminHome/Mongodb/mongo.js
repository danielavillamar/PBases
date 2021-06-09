import React, { useState } from "react"; 

import { connect } from "react-redux";
import { reduxForm, Field } from "redux-form";
import { Alert } from "reactstrap";
import { Redirect } from "react-router-dom";

import makeRequest from "../../requests";
import * as selectors from "../../../reducers/index";
import * as actions from "../../../actions/req";

const MongoForm = ({
  handleSubmit,
  submitting,
  reqSuccess,
  reqMsg,
  modSuccess,
}) => {
  return (
    <div className="wrapper">
      <div className="form-wrapper">
        <h1>Recomendaciones y Tracks Mas Recientes</h1>
        <h4>Ingresa una fecha a consultar</h4>
        <form onSubmit={handleSubmit}>
          <Field
            name="date"
            className="firstName"
            label="Fecha"
            component={renderInput}
          />
          {reqSuccess ? (
            <div className="alert">
              <Alert color="danger">Ups! {reqMsg.msg}</Alert>
            </div>
          ) : null}
          <div className="createAccount">
            <button type="submit" disabled={submitting}>
              Guardar
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

  if (!values.date) {
    error.date = "Campo requerido";
  }

  return error;
};

const renderInput = ({ input, meta, label }) => (
  <div className="field">
    <label>{label}</label>
    <input
      {...input}
      type="date"
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
  form: "mongoForm",
  destroyOnUnmount: false,
  onSubmit(values, dispatch) {
    const requestInfo = { uri: `http://localhost:8000/sales`, type: "POST" };
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
  }))(MongoForm)
);
