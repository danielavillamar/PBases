import React, { useState } from "react"; 

import { connect } from "react-redux";
import { reduxForm, Field } from "redux-form";
import { Alert } from "reactstrap";
import { Redirect } from "react-router-dom";

import makeRequest from "../../../requests";
import * as selectors from "../../../../reducers/index";
import * as actions from "../../../../actions/stats";
import Graph12 from "../../Estadisticas/adminStats/Graph12/graph";

const SongsRepsPerArtist = ({
  handleSubmit,
  submitting,
  reqSuccess,
  reqMsg,
  modSuccess,
  artists,
  stats,
}) => {
  return (
    <div className="wrapper">
      <div className="form-wrapper">
        <h1>Reproducciones por Artista</h1>
        <form onSubmit={handleSubmit}>
          <Field
            name="artistname"
            className="firsname"
            label="Artista"
            component={renderSelect}
          >
            {Object.values(artists).map((artist) => (
              <option key={artist.id} value={artist.name}>
                {artist.name}
              </option>
            ))}
          </Field>
          <Field
            name="limit"
            className="firstName"
            label="Cantidad de Canciones"
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
          <h4>Reproducciones</h4>
          <div>
            <Graph12 />
          </div>
        </div>
      ) : null}
    </div>
  );
};

const validate = (values) => {
  //Validacion del Register Form

  const error = {};

  if (!values.artistname) {
    error.artistname = "Campo requerido";
  }

  if (!values.limit) {
    error.limit = "Campo requerido";
  } else if (/\D/.test(values.limit)) {
    error.limit = "Unicamente ingresar numeros";
  }
  return error;
};

const renderSelect = ({ input, label, children }) => (
  <div className="field">
    <label>{label}</label>
    <select {...input}>{children}</select>
  </div>
);

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
  form: "SongsRepsPerArtistForm",
  destroyOnUnmount: false,
  onSubmit(values, dispatch) {
    const requestInfo = {
      uri: `http://localhost:8000/song-reps-per-artist`,
      type: "POST",
    };
    makeRequest(values, requestInfo, (res) => {
      dispatch(actions.loadedStats(res.action));
    });
  },
  validate,
})(
  connect((state) => ({
    reqSuccess: selectors.getReqSuccess(state),
    reqMsg: selectors.getReqMsg(state),
    modSuccess: selectors.getModSuccess(state),
    artists: selectors.getArtists(state),
    stats: selectors.getStats(state, "graph12"),
  }))(SongsRepsPerArtist)
);
