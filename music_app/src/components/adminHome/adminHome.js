import React from 'react';

import './styles.css';

const AdminHome = () => {
    return(
        <div className="admin-home-wrapper">
            <h2>Proyecto Bases</h2>
            <h3>Desarrollo y Consulta de Base de Datos</h3>
            <h4>Grupo 7</h4>
            <div className="description">
                <div>
                    <h5>Descripción general del proyecto</h5>
                    <div>
                    El proyecto contempla el uso de tecnología de Base de Datos para la creación, modelación y 
                    carga de modelos datos, con el objetivo de utilizar lenguaje SQL para investigación, desarrollo y 
                    presentación de resultados sobre preguntas de negocio para apoyo en toma de decisiones.<br/><br/>

                    El proyecto general consiste en la implementación de una base de datos relacional para soportar 
                    un servicio de música en streaming colaborativo, que funciona bajo un modelo de suscripción de 
                    usuarios pagando una membresía de forma mensual, semestral y/o anual.<br/><br/>

                    Se debe contar con una aplicación (móvil, desktop o web) que soporte la gestión de canciones 
                    en el catálogo, que permita realizar búsquedas con base en el artista, género de música, álbum 
                    o canción, y cualquier parámetro que se considere conveniente a criterio del desarrollador. La 
                    aplicación  debe  contemplar  dos  módulos:  el  administrativo  y  el  de  cliente  del  servicio  de 
                    streaming. El módulo administrativo debe permitir gestionar usuarios, roles y permisos; y es 
                    accedido únicamente por un usuario administrador en la pantalla principal. Esto implica crear las 
                    tablas necesarias para abarcar los siguientes casos de uso en el módulo de usuario:<br/><br/>

                    <ul>
                        <li>Registro de artistas</li>
                        <li>Registro de álbumes</li>
                        <li>Registro de canciones</li>
                        <li>Inactivación de una canción del cátalogo</li>
                        <li>Modificación de la información de una canción, album y artista de la base de datos</li>
                        <li>Eliminación de una canción, album y artista de la base de datos</li>
                        <li>Sign in y log in de usuarios</li>
                    </ul>

                    Adicionalmente se debe implementar un módulo de reportería que incluya los siguientes reportes:

                    <ol>
                        <li>Artistas por área</li>
                        <li>Géneros con más canciones</li>
                        <li>Artistas con más albums individuales</li>
                        <li>Canciones de mayor duración con la información de sus artistas</li>
                        <li>Usuarios que han registrado más canciones</li>
                        <li>Promedio de duración de canciones por género</li>
                        <li>Álbumes más recientes</li>
                        <li>Artistas más colaborativos</li>
                    </ol>
                    </div>
                </div>
            </div>
        </div>
    )
}

export default AdminHome;