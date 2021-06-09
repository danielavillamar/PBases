import React from 'react'; 
import { Link } from 'react-router-dom';
//import './styles.css';
// import * as actions from '../../../actions/req';
// import { connect } from 'react-redux';

const ModTables = () => {
    return(
        <div>
            <h2>Modificaciones</h2>
            <div className="mods-wrapper">
                <Link to='/admin-home/mods/update/song' className="options">
                    <div className="mod-wrapper">
                        <h4>Modificar Cancion</h4>
                    </div>
                </Link>
                <Link to="/admin-home/mods/update/album" className="options">
                    <div className="mod-wrapper">
                        <h4>Modificar Album</h4>                    
                    </div>
                </Link>
                <Link to="/admin-home/mods/update/artist" className="options">
                    <div className="mod-wrapper">
                        <h4>Modificar Artista</h4>
                    </div>
                </Link>
            </div>
        </div>
    )
}

export default ModTables;