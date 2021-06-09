import React from "react"; 

import { connect } from "react-redux";
import { reduxForm, Field } from "redux-form";
import { v4 as uuid } from "uuid";
import { Alert } from "reactstrap";
import { Redirect } from "react-router-dom";

import * as actions from "../../../../actions/req";
import * as selectors from "../../../../reducers/index";
import makeRequest from "../../../requests";

const NewSong = ({
  handleSubmit,
  submitting,
  reqSuccess,
  reqMsg,
  modSuccess,
  albums,
  onSubmit,
  dispatch,
  adminUser,
}) => {
  return (
    <div className="wrapper">
      <div className="form-wrapper">
        <h1>Ingresa una Cancion Nueva</h1>
        <form
          onSubmit={handleSubmit((values) =>
            onSubmit(values, dispatch, adminUser)
          )}
        >
          <Field
            name="trackname"
            className="firstName"
            label="Nombre de Cancion"
            component={renderInput}
          />
          <Field
            name="albumid"
            className="firsname"
            label="Album"
            component={renderSelect}
          >
            {Object.values(albums).map((album) => (
              <option key={album.id} value={album.id}>
                {album.name}
              </option>
            ))}
          </Field>
          <Field
            name="unitprice"
            className="firstName"
            label="Precio"
            component={renderInput}
          />
          <Field
            name="url"
            className="firstName"
            label="Youtube URL"
            component={renderInput}
          />
          {reqSuccess ? (
            <div className="alert">
              <Alert color="danger">Ups! {reqMsg.msg}</Alert>
            </div>
          ) : null}
          <div className="createAccount">
            <button type="submit" disabled={submitting}>
              Agregar Cancion
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

  if (!values.trackname) {
    error.trackname = "Campo requerido";
  }
  if (!values.unitprice) {
    error.unitprice = "Campo requerido";
  } else if (/\D/.test(values.unitprice)) {
    error.unitprice = "Numero invalido";
  }
  if (!values.url) {
    error.url = "Campo requerido";
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
  form: "newSongForm",
  destroyOnUnmount: false,
  onSubmit(values, dispatch, adminUser) {
    values.trackid = uuid();
    values.adminUser = adminUser;
    const requestInfo = {
      uri: `http://localhost:8000/new-track`,
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
    albums: selectors.getAlbums(state),
    adminUser: selectors.getUser(state),
  }))(NewSong)
);
