import React from "react";
import { Link } from "react-router-dom";
import * as actions from "../../../actions/req";
import { connect } from "react-redux"; 

const NewStats = ({ onClick }) => {
  return (
    <div className="mods-wrapper">
      <h2>Nuevas Modificaciones</h2>
      <Link
        to="/admin-home/new-stats/weekly-sales-stats"
        className="options"
        onClick={onClick}
      >
        <div className="mod-wrapper">
          <h4>Ventas por Semana</h4>
        </div>
      </Link>
      <Link
        to="/admin-home/new-stats/weekly-artists-sales-stats"
        className="options"
        onClick={onClick}
      >
        <div className="mod-wrapper">
          <h4>Artistas con Mayores Ventas</h4>
        </div>
      </Link>
      <Link
        to="/admin-home/new-stats/weekly-genre-sales-stats"
        className="options"
        onClick={onClick}
      >
        <div className="mod-wrapper">
          <h4>Ventas por Genero</h4>
        </div>
      </Link>
      <Link
        to="/admin-home/new-stats/song-reps-per-artist"
        className="options"
        onClick={onClick}
      >
        <div className="mod-wrapper">
          <h4>Canciones con Mas Reproducciones</h4>
        </div>
      </Link>
    </div>
  );
};

export default connect(undefined, (dispatch) => ({
  onClick() {
    dispatch(actions.remReqInfo());
  },
}))(NewStats);
