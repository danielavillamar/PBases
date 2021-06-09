import React, { useState } from "react"; 

import { connect } from "react-redux";
import { reduxForm, Field } from "redux-form";
import { Alert } from "reactstrap";
import { Redirect } from "react-router-dom";

// import "./styles.css";
import makeRequest from "../../../requests";
import * as selectors from "../../../../reducers/index";
import * as actions from "../../../../actions/stats";
import Graph10 from "../../Estadisticas/adminStats/Graph10/graph";

const WeeklyArtistsSales = ({
  handleSubmit,
  submitting,
  reqSuccess,
  reqMsg,
  modSuccess,
  stats,
}) => {
  return (
    <div className="wrapper">
      <div className="form-wrapper">
        <h1>Artistas con Mayores Ventas</h1>
        <h4>Ingresa una fecha a consultar</h4>
        <form onSubmit={handleSubmit}>
          <Field
            name="day1"
            className="firstName"
            label="Fecha"
            component={renderInput}
          />
          <Field
            name="day2"
            className="firstName"
            label="Fecha"
            component={renderInput}
          />
          <Field
            name="limit"
            className="firstName"
            label="Cantidad de Artistas"
            component={renderInput}
          />
          {reqSuccess ? (
            <div className="alert">
              <Alert color="danger">Ups! {reqMsg.msg}</Alert>
            </div>
          ) : null}
          <div className="createAccount">
            <button type="submit" disabled={submitting}>
              Consultar
            </button>
          </div>
        </form>
      </div>
      {stats ? (
        <div className="sales-wrapper">
          <h4>Ventas</h4>
          <div>
            <Graph10 />
          </div>
        </div>
      ) : null}
    </div>
  );
};

const validate = (values) => {
  //Validacion del Register Form

  const error = {};

  if (!values.day1) {
    error.day1 = "Campo requerido";
  }

  if (!values.day2) {
    error.day2 = "Campo requerido";
  }

  if (!values.limit) {
    error.limit = "Campo requerido";
  } else if (/\D/.test(values.limit)) {
    error.limit = "Unicamente ingresar numeros";
  }

  return error;
};

const renderInput = ({ input, meta, label }) => (
  <div className="field">
    <label>{label}</label>
    <input
      {...input}
      type={label === "Fecha" ? "date" : "text"}
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
  form: "weeklyArtistsSalesForm",
  destroyOnUnmount: false,
  onSubmit(values, dispatch) {
    //Get Weekly Sales
    const { day1, day2, limit } = values;
    const requestInfo = {
      uri: `http://localhost:8000/weekly-artists-sales-stats/${day1}/${day2}/${limit}`,
      type: "GET",
    };
    makeRequest(null, requestInfo, (res) => {
      console.log(res);
      dispatch(actions.loadedStats(res.action));
    });
  },
  validate,
})(
  connect((state) => ({
    reqSuccess: selectors.getReqSuccess(state),
    reqMsg: selectors.getReqMsg(state),
    modSuccess: selectors.getModSuccess(state),
    stats: selectors.getStats(state, "graph10"),
  }))(WeeklyArtistsSales)
);
