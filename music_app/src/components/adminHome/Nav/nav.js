import React from "react"; 
import { Link, Redirect } from "react-router-dom";
import { reduxForm, Field } from "redux-form";
import { connect } from "react-redux";
import * as actions from "../../../actions/auth";
import * as actions2 from "../../../actions/searchSong";
import * as myTracksActions from "../../../actions/mytracks";
import * as shoppingCartActions from "../../../actions/shoppingcart";
import * as binnacleActions from "../../../actions/bitacora";
import * as selectors from "../../../reducers/index";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faShoppingCart, faPlay } from "@fortawesome/free-solid-svg-icons";
import "./styles.css";
import makeRequest from "../../requests";

const Search = ({ handleSubmit, submitting }) => {
  return (
    <div className="box">
      <form onSubmit={handleSubmit}>
        <Field
          name="searchValue"
          type="text"
          className="search-text"
          placeholder="Search"
          component={renderInput}
        />
        <button className="search-btn" disabled={submitting}>
          ?
        </button>
      </form>
    </div>
  );
};

const renderInput = ({ input }) => (
  <div>
    <input {...input} className="search-text" />
  </div>
);

const validate = (values) => {
  //Validacion del Register Form

  const error = {};

  if (!values.searchValue) {
    error.searchValue = "Campo requerido";
  }

  return error;
};

const SearchBox = reduxForm({
  form: "searchForm",
  destroyOnUnmount: false,
  onSubmit(values, dispatch) {
    //CARCARG BUSQUEDA DE CANCION, ALBUM, ETC.
    const requestInfo = {
      uri: `http://localhost:8000/search/${values.searchValue}`,
      type: "GET",
    };
    makeRequest(values, requestInfo, (res) => {
      dispatch(actions2.loadSongs(res.action));
    });
  },
  validate,
})(Search);

const Nav = ({
  onClick,
  isLoggedIn,
  isAdminUser,
  currentUser,
  onSubmit,
  getBinnacle,
}) => {
  return (
    <nav>
      {!isLoggedIn ? <h2>Proyecto 1 DB</h2> : null}
      {isLoggedIn && isAdminUser ? (
        <Link to="/admin-home">
          <h2>Proyecto 1 DB</h2>
        </Link>
      ) : null}
      {isLoggedIn && !isAdminUser ? (
        <Link to="/user-home">
          <h2>Proyecto 1 DB</h2>
        </Link>
      ) : null}
      <ul className="nav-links">
        {isLoggedIn && !isAdminUser ? (
          <li>
            <SearchBox />
          </li>
        ) : null}
        {isLoggedIn && isAdminUser ? (
          <Link to="/admin-home/mods">
            <li>Modificaciones</li>
          </Link>
        ) : null}
        {isLoggedIn && isAdminUser ? (
          <Link to="/admin-home/stats">
            <li>Estadisticas</li>
          </Link>
        ) : null}
        {isLoggedIn && isAdminUser ? (
          <Link to="/admin-home/binnacle" onClick={getBinnacle}>
            <li>Bitacora</li>
          </Link>
        ) : null}
        {isLoggedIn && isAdminUser ? (
          <Link to="/admin-home/new-stats">
            <li>New Stats</li>
          </Link>
        ) : null}
        {isLoggedIn && isAdminUser ? (
          <Link to="/admin-home/mongo">
            <li>MongoDB</li>
          </Link>
        ) : null}
        {isLoggedIn && !isAdminUser ? (
          <Link to="/my-songs" onClick={() => onSubmit(currentUser)}>
            <FontAwesomeIcon icon={faPlay} />
          </Link>
        ) : null}
        {isLoggedIn && !isAdminUser ? (
          <Link to="/shopping-cart">
            <FontAwesomeIcon icon={faShoppingCart} />
          </Link>
        ) : null}
        {isLoggedIn ? (
          <Link to="/" onClick={onClick}>
            <li>Logout</li>
          </Link>
        ) : null}
      </ul>
    </nav>
  );
};

export default connect(
  (state) => ({
    isLoggedIn: selectors.getIsAuth(state),
    isAdminUser: selectors.getIsAdminUser(state),
    currentUser: selectors.getUser(state),
  }),
  (dispatch) => ({
    onClick() {
      dispatch(actions.logout());
      dispatch(myTracksActions.removeMyTracks());
      dispatch(shoppingCartActions.removeShoppingcartList());
    },
    onSubmit(currentUser) {
      const requestInfo = {
        uri: `http://localhost:8000/get-my-songs/${currentUser}`,
        type: "GET",
      };
      makeRequest(null, requestInfo, (res) => {
        dispatch(myTracksActions.getMyTracks(res.action));
      });
    },
    getBinnacle() {
      const requestInfo = {
        uri: "http://localhost:8000/binnacle",
        type: "GET",
      };
      makeRequest(null, requestInfo, async (res) => {
        dispatch(binnacleActions.getBinnacle(res.action.payload.binnacle));
      });
    },
  })
)(Nav);
