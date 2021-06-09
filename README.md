# Proyecto Base de Datos

Desarrollo y Consulta de Base de Datos. El proyecto general consiste en la implementación de una base de datos relacional para soportar un servicio de música en st reaming colaborativo, que funciona bajo un modelo de suscripción de usuarios pagando una membresía de forma mensual, semestral y/o anual.

## Creado por: 

<ul>
    <li>Mirka Monzon</li>
    <li>Andres Quinto</li>
    <li>Daniela Villamar </li>
</ul>

Para poder ejecutar esta aplicacion es necesario tener instalado lo siguiente:<br/>

- [Nodejs](https://nodejs.org/es/).    
- [Yarn](https://classic.yarnpkg.com/en/docs/install/#windows-stable).

Al tener instalado lo anterior es necesario estar dentro de cada una de las carpetas 

* [music_app](./music_app)

Al estar dentro de music_app debes ejecutar los siguentes comandos:

```
yarn install
yarn start

```

Esto ejecutara la aplicacion en modo desarrollador [http://localhost:3000](http://localhost:3000).


* [rest_api](./rest_api)

Al estar dentro de rest_api debes ejecutar el siguiente comando:

```
node index.js
```

Esto ejecutara la API en el puerto 8000 [http://localhost:8000](http://localhost:8000).