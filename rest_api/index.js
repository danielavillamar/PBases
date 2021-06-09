/*
                REST API

    API que se conecta con PostgreSQL

Creado por:

Mirka Monzon           
Andres Quinto
Daniela Villamar

*/


//API de Postgres

const express = require('express');

const app = express();

// middlewares
app.use(express.json());
app.use(express.urlencoded({extended: false}));
app.use(function(req, res, next) {
    
    res.header("Access-Control-Allow-Origin", "*");
    res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE');
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  
    next();
});

//app.use(require('cors'));

// Routes
app.use(require('./routes/index'));

app.listen(8000);
console.log('Server on port', 8000);