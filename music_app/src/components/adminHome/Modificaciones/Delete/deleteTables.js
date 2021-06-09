import React from 'react'; 
import { Link } from 'react-router-dom';
//import './styles.css';
// import * as actions from '../../../actions/req';
// import { connect } from 'react-redux';

const DeleteTables = () => {
    return(
        <div>
            <h2>Eliminar</h2>
            <div className="mods-wrapper">
                <Link to='/admin-home/mods/delete/song' className="options">
                    <div className="mod-wrapper">
                        <h4>Eliminar Cancion</h4>
                    </div>
                </Link>
                <Link to="/admin-home/mods/delete/album" className="options">
                    <div className="mod-wrapper">
                        <h4>Eliminar Album</h4>                    
                    </div>
                </Link>
                <Link to="/admin-home/mods/delete/artist" className="options">
                    <div className="mod-wrapper">
                        <h4>Eliminar Artista</h4>
                    </div>
                </Link>
            </div>
        </div>
    )
}

export default DeleteTables;