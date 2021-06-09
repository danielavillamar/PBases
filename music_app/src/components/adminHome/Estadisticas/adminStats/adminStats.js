import React from 'react';

import Graph1 from './Graph1/graph';
import Graph2 from './Graph2/graph'; 
import Graph3 from './Graph3/graph';
import Graph4 from './Graph4/graph';
import Graph5 from './Graph5/graph';
import Graph6 from './Graph6/graph';
import Graph7 from './Graph7/graph';
import Graph8 from './Graph8/graph';

import './styles.css';

const Graphs = () => {

    return(
        <div className="stats-wrapper">
            <h2>Estadisticas</h2>
            <div className='graph-wrapper'>
                <h4>1. Los 5 artistas con más álbumes publicados</h4>
                <div>
                    <Graph1/>
                </div>
            </div>
            <div className='graph-wrapper'>
                <h4>2. Géneros con más canciones</h4>
                <div>
                    <Graph2/>
                </div>
            </div>
            <div className='graph-wrapper'>
                <h4>3. Total de duración de cada playlist</h4>
                <div>
                    <Graph3/>
                </div>
            </div>
            <div className='graph-wrapper'>
                <h4>4. Canciones de mayor duración con la información de sus artistas (mostrar cinco resultados)</h4>
                <div>
                    <Graph4/>
                </div>
            </div>
            <div className='graph-wrapper'>
                <h4>5. Usuarios que han registrado más canciones</h4>
                <div>
                    <Graph5/>
                </div>
            </div>
            <div className='graph-wrapper'>
                <h4>6.Promedio de duración de canciones por género</h4>
                <div>
                    <Graph6/>
                </div>
            </div>
            <div className='graph-wrapper'>
                <h4>7. Cantidad de artistas diferentes por playlist</h4>
                <div>
                    <Graph7/>
                </div>
            </div>
            <div className='graph-wrapper'>
                <h4>8. Los artistas con más diversidad de géneros musicales</h4>
                <div>
                    <Graph8/>
                </div>
            </div>
        </div>
    )

}

export default Graphs;