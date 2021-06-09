/*

            Consultas de Postgres

    Aqui se escribiran todas las consultas a PostgreSQL 

*/

//Todas las variables de entorno se pueden acceder con proces.env.LAVARIABLE

const { v4: uuid } = require("uuid");

const dateFormat = require("dateformat");

require("dotenv").config();

const mongoose = require("mongoose");
mongoose.connect("mongodb://localhost/sales");
const Schema = mongoose.Schema;

const salesSchemaJSON = {
  date: String,
  users: {},
};
const salesSchema = new Schema(salesSchemaJSON);
const Sales = mongoose.model("DailySale", salesSchema);

const recomendationsSchemaJSON = {
  user: String,
  recomendation: {
    trackId: String,
    trackComposer: String,
    trackName: String,
    genreId: Number,
    releaseDate: String,
  },
};
const recomendationsSchema = new Schema(recomendationsSchemaJSON);
const Recomendation = mongoose.model("Recomendation", recomendationsSchema);

const Cryptr = require("cryptr");
cryptr = new Cryptr(process.env.CRYPTRKEY);

const { Pool } = require("pg");

//Configuracion de PostgreSQL en caso no usen archivo .env
// const config = {
//     host: 'localhost',
//     user: 'postgres',
//     password: 'postgres',
//     database: 'testdb'
// };

const pool = new Pool();

const getUsers = async (req, res) => {
  //Esto es para pruebas con el api y ver lo que devuelve
  const response = await pool.query(
    "SELECT * FROM customer ORDER BY email ASC"
  );
  res.status(200).json(response.rows);
};

const getAlbums = async (req, res) => {
  //GET ALBUMS
  const response = await pool.query(
    "SELECT albumid as id, title as name FROM album ORDER BY name ASC"
  );
  res.json({ action: { type: "ALBUMS_LOADED", payload: response.rows } });
};

const getTracks = async (req, res) => {
  //GET TRACKS
  const response = await pool.query(
    "SELECT trackid as id, name FROM track ORDER BY name ASC"
  );
  res.json({ action: { type: "TRACKS_LOADED", payload: response.rows } });
};

const getArtists = async (req, res) => {
  //GET ARTISTS
  const response = await pool.query(
    "SELECT artistid as id, name FROM artist ORDER BY name ASC"
  );
  res.json({ action: { type: "ARTISTS_LOADED", payload: response.rows } });
};

const getUserById = async (req, res) => {
  //Accede a la DB y verifica si existe el usuario

  const { emailAddress, password } = req.params;

  await pool
    .query("SELECT * FROM customer WHERE customer.email = $1", [emailAddress])
    .then((response) => {
      //Recibimos la informacion de PostgreSQL

      if (response.rows.length == 0) {
        //Verificamos si existe el usuario en CUSTOMER

        pool
          .query("SELECT * FROM employee WHERE employee.email = $1", [
            emailAddress,
          ])
          .then((response2) => {
            if (response2.rows.length == 0) {
              //Verificamos si existe el usuario en EMPLOYEE
              res.json({
                action: {
                  type: "LOGIN_FAIL",
                  payload: { msg: "User does not exists" },
                },
              });
            } else {
              if (
                cryptr.decrypt(response2.rows[0].password) ==
                cryptr.decrypt(password)
              ) {
                //Verificamos la contraseña
                res.json({
                  action: {
                    type: "REGISTER_SUCCES",
                    payload: { user: emailAddress, isAdminUser: true },
                  },
                });
              } else {
                //Si la contraseña no es valida
                res.json({
                  action: {
                    type: "AUTH_ERROR",
                    payload: { msg: "Wrong password" },
                  },
                });
              }
            }
          })
          .catch(() => {
            //En caso hay algun inconveniente con PostgreSQL

            res.json({
              action: { type: "LOGIN_FAIL", payload: { msg: "Server Issues" } },
            });
          });
      } else {
        //Si existe

        if (
          cryptr.decrypt(response.rows[0].password) == cryptr.decrypt(password)
        ) {
          //Verificamos la contraseña
          res.json({
            action: {
              type: "REGISTER_SUCCES",
              payload: { user: emailAddress },
            },
          });
        } else {
          //Si la contraseña no es valida
          res.json({
            action: { type: "AUTH_ERROR", payload: { msg: "Wrong password" } },
          });
        }
      }
    })
    .catch(() => {
      //En caso hay algun inconveniente con PostgreSQL

      res.json({
        action: { type: "LOGIN_FAIL", payload: { msg: "Server Issues" } },
      });
    });
};

const createUser = async (req, res) => {
  //Accede a la DB y crea el usuario

  //Informacion recibida
  const { emailAddress, password, firstname, lastname } = req.body;

  //Verificamos si el usuario ya existe
  await pool
    .query("SELECT * FROM customer WHERE customer.email = $1", [emailAddress])
    .then((response) => {
      //Se recibe informacion de PostgreSQL

      //En caso no existe
      if (response.rows.length == 0) {
        pool
          .query(
            "INSERT INTO customer(email, password, firstname, lastname) VALUES($1, $2, $3, $4)",
            [emailAddress, password, firstname, lastname]
          ) //Insertamos a la base de datos
          .then(() => {
            res.json({
              action: {
                type: "REGISTER_SUCCES",
                payload: { user: emailAddress, msg: "User Added successfully" },
              },
            });
          })
          .catch(() => {
            //En caso hay algun inconveniente con PostgreSQL

            res.json({
              action: {
                type: "REGISTER_FAIL",
                payload: { msg: "Server Issues. Try again later." },
              },
            });
          });
      } else {
        //En caso el usuario ya existe

        res.json({
          action: {
            type: "REGISTER_FAIL",
            payload: { msg: "User already exists" },
          },
        });
      }
    })
    .catch(() => {
      //En caso hay algun inconveniente con PostgreSQL

      res.json({
        action: {
          type: "REGISTER_FAIL",
          payload: { msg: "Server Issues. Try again later." },
        },
      });
    });
};

const updateUser = async (req, res) => {
  const { emailAddress } = req.params;

  const { plan, ccnumber, cvv } = req.body;

  await pool
    .query(
      "UPDATE customer SET plan = $1, ccnumber = $2, cvv = $3 WHERE email = $4",
      [plan, ccnumber, cvv, emailAddress]
    )
    .then(() => {
      res.json({
        action: {
          type: "REGISTER_SUCCES",
          payload: { msg: "Credit Card Added successfully" },
        },
      });
    })
    .catch(() => {
      res.json({
        action: {
          type: "REGISTER_FAIL",
          payload: { msg: "Server Issues. Try again later." },
        },
      });
    });
};

const inacTrack = async (req, res) => {
  const { trackid } = req.body;

  await pool
    .query("UPDATE track SET inactive = 1 WHERE trackid = $1", [trackid])
    .then(() => {
      res.json({
        action: {
          type: "REQUEST_SUCCESS",
          payload: { msg: "Track Inactivated successfully" },
        },
      });
    })
    .catch(() => {
      res.json({
        action: {
          type: "REQUEST_FAIL",
          payload: { msg: "Server Issues. Try again later." },
        },
      });
    });
};

const updateTrack = async (req, res) => {
  const {
    trackid,
    newtrackname,
    newalbumid,
    newunitprice,
    modifiedBy,
  } = req.body;

  await pool
    .query(
      "UPDATE track SET name = $1, albumid = $2, unitprice = $3, modified_by = $5 WHERE trackid = $4",
      [newtrackname, newalbumid, newunitprice, trackid, modifiedBy]
    )
    .then(() => {
      res.json({
        action: {
          type: "REQUEST_SUCCESS",
          payload: { msg: "Track Updated successfully" },
        },
      });
    })
    .catch(() => {
      res.json({
        action: {
          type: "REQUEST_FAIL",
          payload: { msg: "Server Issues. Try again later." },
        },
      });
    });
};

const updateArtist = async (req, res) => {
  const { artistid, newartistname, modifiedBy } = req.body;

  await pool
    .query(
      "UPDATE artist SET name = $1, modified_by = $3, modified_field = $4 WHERE artistid = $2",
      [newartistname, artistid, modifiedBy, "name"]
    )
    .then(() => {
      res.json({
        action: {
          type: "REQUEST_SUCCESS",
          payload: { msg: "Artist Updated successfully" },
        },
      });
    })
    .catch(() => {
      res.json({
        action: {
          type: "REQUEST_FAIL",
          payload: { msg: "Server Issues. Try again later." },
        },
      });
    });
};

const updateAlbum = async (req, res) => {
  const { albumid, newalbumname, newartistid, modifiedBy } = req.body;

  //

  await pool
    .query(
      "UPDATE album SET title = $1, artistid = $2, modified_by = $4 WHERE albumid = $3",
      [newalbumname, newartistid, albumid, modifiedBy]
    )
    .then(() => {
      res.json({
        action: {
          type: "REQUEST_SUCCESS",
          payload: { msg: "Album Updated successfully" },
        },
      });
    })
    .catch(() => {
      res.json({
        action: {
          type: "REQUEST_FAIL",
          payload: { msg: "Server Issues. Try again later." },
        },
      });
    });
};

const deleteUser = async (req, res) => {
  const id = parseInt(req.params.id);
  await pool.query("DELETE FROM users where id = $1", [id]);
  res.json(`User ${id} deleted Successfully`);
};

const deleteTrack = async (req, res) => {
  const { trackid } = req.params;

  //TODO HACER UPDATE PARA USUARIO QUE MODIFICA

  await pool
    .query("DELETE FROM track where trackid = $1", [trackid])
    .then(() => {
      res.json({
        action: {
          type: "REQUEST_SUCCESS",
          payload: { msg: "Track Deleted successfully" },
        },
      });
    })
    .catch(() => {
      res.json({
        action: {
          type: "REQUEST_FAIL",
          payload: { msg: "Server Issues. Try again later." },
        },
      });
    });
};

const deleteArtist = async (req, res) => {
  const { artistid } = req.params;

  await pool
    .query("DELETE FROM artist where artistid = $1", [artistid])
    .then(() => {
      res.json({
        action: {
          type: "REQUEST_SUCCESS",
          payload: { msg: "Artist Deleted successfully" },
        },
      });
    })
    .catch((e) => {
      res.json({
        action: {
          type: "REQUEST_FAIL",
          payload: { msg: "Server Issues. Try again later." },
        },
      });
    });
};

const deleteAlbum = async (req, res) => {
  const { albumid } = req.params;

  //TODO UPDATE ANTES DE DELETE

  await pool
    .query("DELETE FROM album where albumid = $1", [albumid])
    .then(() => {
      res.json({
        action: {
          type: "REQUEST_SUCCESS",
          payload: { msg: "Album Deleted successfully" },
        },
      });
    })
    .catch(() => {
      res.json({
        action: {
          type: "REQUEST_FAIL",
          payload: { msg: "Server Issues. Try again later." },
        },
      });
    });
};

const getStats = async (req, res) => {
  //Hace consultas de estadisticas

  const graph1 = await pool.query(
    "SELECT artist1.name, count(artist1.name) from album album1 join artist artist1 on album1.artistid = artist1.artistid group by artist1.name order by count(artist1.name) desc LIMIT 5;"
  );
  const graph2 = await pool.query(
    "SELECT COUNT(genre.genreid), genre.name FROM genre INNER JOIN track ON genre.genreid = track.genreid GROUP BY genre.genreid ORDER BY COUNT(genre.genreid) DESC LIMIT 5;"
  );
  const graph3 = await pool.query(
    "SELECT playlist.playlistid, playlist.name, SUM(track.milliseconds/1000) AS Count FROM playlist LEFT JOIN playlisttrack ON playlisttrack.playlistid = playlist.playlistid LEFT JOIN track ON track.trackid = playlisttrack.trackid WHERE track.milliseconds IS NOT NULL GROUP BY playlist.playlistid ORDER BY Count DESC;"
  );
  const graph4 = await pool.query(
    "SELECT artist1.name, track1.name, (track1.milliseconds/1000) As Count FROM album album1 join artist artist1 on album1.artistid = artist1.artistid join track track1 on track1.albumid = album1.albumid  WHERE track1.mediatypeid = 2 OR track1.mediatypeid = 1 OR track1.mediatypeid = 4 OR track1.mediatypeid = 5 ORDER BY (track1.milliseconds) DESC LIMIT 5;"
  );
  const graph5 = await pool.query(
    "SELECT employee1.email as name, COUNT (track1.employeeid) AS count FROM track track1 JOIN employee employee1 ON employee1.email = track1.employeeid GROUP BY employee1.email ORDER BY count DESC LIMIT 5;"
  );
  const graph6 = await pool.query(
    "SELECT genre.name, SUM(track.milliseconds)/COUNT(*) as count FROM track INNER JOIN genre ON track.genreid = genre.genreid GROUP BY genre.genreid;"
  );
  const graph7 = await pool.query(
    "SELECT playlist1.name, COUNT(artist1.artistid) FROM playlist playlist1 JOIN playlisttrack playlisttrack1 ON playlist1.playlistid = playlisttrack1.playlistid JOIN track track1 ON track1.trackid = playlisttrack1.trackid JOIN album album1 ON album1.albumid = track1.albumid JOIN artist artist1 ON artist1.artistid = album1.artistid GROUP BY playlist1.name ORDER BY COUNT(artist1.name) DESC;"
  );
  const graph8 = await pool.query(
    "SELECT artist1.name, count(DISTINCT track1.genreid) as count from genre genre1 join track track1 on genre1.genreid = track1.genreid join album album1 on album1.albumid = track1.albumid join artist artist1 on artist1.artistid = album1.artistid group by artist1.name order by count(genre1.genreid) desc LIMIT 5;"
  );
  res.json({
    action: {
      type: "STATS_LOADED",
      payload: {
        graph1: graph1.rows,
        graph2: graph2.rows,
        graph3: graph3.rows,
        graph4: graph4.rows,
        graph5: graph5.rows,
        graph6: graph6.rows,
        graph7: graph7.rows,
        graph8: graph8.rows,
      },
    },
  });
  res.status(200);
};

const newArtist = async (req, res) => {
  const { artistname, artistid, modifiedBy } = req.body;

  await pool
    .query("SELECT * FROM artist WHERE name=$1", [artistname])
    .then((response) => {
      //Se recibe informacion de PostgreSQL

      //En caso no existe
      if (response.rows.length == 0) {
        pool
          .query(
            "INSERT INTO artist(artistid, name, modified_by) VALUES($1, $2, $3)",
            [artistid, artistname, modifiedBy]
          ) //Insertamos a la base de datos
          .then(() => {
            res.json({
              action: {
                type: "REQUEST_SUCCESS",
                payload: { msg: "Artist Added successfully" },
              },
            });
          })
          .catch(() => {
            //En caso hay algun inconveniente con PostgreSQL

            res.json({
              action: {
                type: "REQUEST_FAIL",
                payload: { msg: "Server Issues. Try again later." },
              },
            });
          });
      } else {
        //En caso el artista ya existe

        res.json({
          action: {
            type: "REQUEST_FAIL",
            payload: { msg: "Artist already exists" },
          },
        });
      }
    })
    .catch(() => {
      res.json({
        action: {
          type: "REQUEST_FAIL",
          payload: { msg: "Server Issues. Try again later." },
        },
      });
    });
};

const newAlbum = async (req, res) => {
  const { albumname, albumid, artistid, modifiedBy } = req.body;

  await pool
    .query("INSERT INTO album VALUES($1, $2, $3, $4)", [
      albumid,
      albumname,
      artistid,
      modifiedBy,
    ]) //Insertamos a la base de datos
    .then(() => {
      res.json({
        action: {
          type: "REQUEST_SUCCESS",
          payload: { msg: "Album Added successfully" },
        },
      });
    })
    .catch(() => {
      //En caso hay algun inconveniente con PostgreSQL
      res.json({
        action: {
          type: "REQUEST_FAIL",
          payload: { msg: "Server Issues. Try again later." },
        },
      });
    });
};

const newTrack = async (req, res) => {
  const { trackid, trackname, albumid, unitprice, adminUser, url } = req.body;

  await pool
    .query(
      "INSERT INTO track(trackid, name, albumid, unitprice, employeeid, reproductions, modified_by, url) VALUES($1, $2, $3, $4, $5, 0, $5, $6)",
      [trackid, trackname, albumid, unitprice, adminUser, url]
    ) //Insertamos a la base de datos
    .then(() => {
      res.json({
        action: {
          type: "REQUEST_SUCCESS",
          payload: { msg: "Track Added successfully" },
        },
      });
    })
    .catch(() => {
      //En caso hay algun inconveniente con PostgreSQL
      res.json({
        action: {
          type: "REQUEST_FAIL",
          payload: { msg: "Server Issues. Try again later." },
        },
      });
    });
};

const searchAlbumTracks = async (album) => {
  const albumTracks = await pool.query(
    "SELECT trackid as id, name, unitprice as price FROM albumsongs WHERE albumid = $1",
    [album.albumid]
  );
  return { ...albumTracks.rows };
};

const search = async (req, res) => {
  const { searchValue } = req.params;

  let search = "%";
  search = search + searchValue;
  search = search + "%";

  const albumByArtist = await pool.query(
    "SELECT album.albumid, album.title AS name, artist.name AS artist FROM artist INNER JOIN album ON artist.artistid = album.artistid WHERE artist.name LIKE $1;",
    [search]
  );

  albumByArtist.rows.map(async (album) => {
    const albumTracks = await searchAlbumTracks(album);
    album["tracks"] = {};
    Object.values(albumTracks).map((track) => {
      album["tracks"][track.id] = { ...track };
    });
  });

  const albumByAlbum = await pool.query(
    "SELECT * FROM albumprice WHERE name LIKE $1;",
    [search]
  );

  albumByAlbum.rows.map(async (album) => {
    const albumTracks = await searchAlbumTracks(album);
    album["tracks"] = {};
    Object.values(albumTracks).map((track) => {
      album["tracks"][track.id] = { ...track };
    });
  });

  const trackByName = await pool.query(
    "SELECT track1.trackid as id, track1.unitprice as price, track1.name AS name, artist1.name AS artist FROM track track1 JOIN album album1 ON track1.albumid = album1.albumid JOIN artist artist1 ON artist1.artistid = album1.artistid WHERE track1.name LIKE $1 ORDER BY (track1.name)",
    [search]
  );
  const trackByGenre = await pool.query(
    "SELECT track1.trackid as id, track1.unitprice as price, track1.name AS name, artist1.name AS artist FROM track track1 JOIN genre genre1 ON track1.genreid = genre1.genreid  JOIN album album1 on album1.albumid = track1.albumid JOIN artist artist1 ON artist1.artistid = album1.artistid WHERE genre1.name LIKE $1 ORDER BY (track1.name)",
    [search]
  );

  res.json({
    action: {
      type: "ADD_SEARCHED_SONGS",
      payload: {
        albumByArtist: albumByArtist.rows,
        albumByAlbum: albumByAlbum.rows,
        trackByName: trackByName.rows,
        trackByGenre: trackByGenre.rows,
      },
    },
  });
};

const dailySales = async (req, res) => {
  //Perfilamiento y promoción con uso de DBs no relacionales

  const { date } = req.body;

  await pool
    .query(
      "SELECT DISTINCT customer.email, firstname, lastname, plan FROM invoice INNER JOIN customer ON invoice.email = customer.email WHERE invoicedate = $1 ",
      [date]
    )
    .then((response) => {
      //Crea un diccionario con la informacion de los usuarios que realizaron compras N dia
      const dailySales = new Sales({ date: date, users: response.rows });
      //Guarda el diccionario en MONGODB
      dailySales.save();
    })
    .catch(() => {
      res.json({
        action: {
          type: "REQUEST_FAIL",
          payload: { msg: "Server Issues. Try again later." },
        },
      });
    });

  await pool
    .query(
      "SELECT email, trackid, name, track.genreid, composer, addeddate FROM track, genreperuser WHERE track.genreid = genreperuser.genreid GROUP BY trackid, email, genreperuser.genreid ORDER BY addeddate DESC LIMIT 10"
    )
    .then((response) => {
      response.rows.map((rec) => {
        const recomendation = new Recomendation({
          user: rec.email,
          recomendation: {
            trackId: rec.trackid,
            trackComposer: rec.composer,
            trackName: rec.name,
            genreId: rec.genreid,
            releaseDate: rec.addeddate,
          },
        });
        recomendation.save();
      });
    });

  res.json({
    action: {
      type: "REQUEST_SUCCESS",
      payload: { msg: "Your stats are in MongoDB" },
    },
  });
};

const totalWeeklySales = async (req, res) => {
  const { day1, day2 } = req.params;

  //Devuelve las ventas totales por dia dentro del rango seleccionado
  const graph9 = await pool.query(
    "SELECT * FROM dailysales WHERE date > $1 and date < $2 ORDER BY date ASC",
    [day1, day2]
  );

  res.json({
    action: {
      type: "STATS_LOADED",
      payload: {
        graph9: graph9.rows,
      },
    },
  });
};

const totalWeeklyArtistSales = async (req, res) => {
  const { day1, day2, limit } = req.params;

  //Devuelve las ventas por dia dentro del rango seleccionado
  const graph10 = await pool.query(
    "SELECT artistsong.name as artistname, sum(unitprice) as total FROM invoiceline, invoice, ArtistSong WHERE invoiceline.invoiceid = invoice.invoiceid AND invoicedate > $1 AND invoicedate < $2 AND invoiceline.trackid = artistsong.trackid GROUP BY artistsong.name ORDER BY total DESC LIMIT $3",
    [day1, day2, limit]
  );

  res.json({
    action: {
      type: "STATS_LOADED",
      payload: {
        graph10: graph10.rows,
      },
    },
  });
};

const totalWeeklyGenreSales = async (req, res) => {
  const { day1, day2 } = req.params;

  //Devuelve las ventas totales por genero por dia dentro del rango seleccionado
  const graph11 = await pool.query(
    "SELECT genre, sum(total) as total FROM dailygenresales WHERE date > $1 and date < $2 GROUP BY genre ORDER BY genre ASC",
    [day1, day2]
  );

  res.json({
    action: {
      type: "STATS_LOADED",
      payload: {
        graph11: graph11.rows,
      },
    },
  });
};

const songRepsPerArtist = async (req, res) => {
  const { artistname, limit } = req.body;

  //Devuelve las ventas totales por genero por dia dentro del rango seleccionado
  const graph12 = await pool.query(
    "SELECT name as track, reproductions from track where composer = $1 ORDER BY reproductions DESC LIMIT $2",
    [artistname, limit]
  );

  res.json({
    action: {
      type: "STATS_LOADED",
      payload: {
        graph12: graph12.rows,
      },
    },
  });
};

const buySongs = async (req, res) => {
  const { fullTracksList, currentUser, total } = req.body;
  const invoiceId = uuid();
  const date = dateFormat(new Date(), "yyyy-mm-dd h:MM:ss");

  await pool
    .query(
      "INSERT INTO invoice(invoiceid, invoicedate, total, email) VALUES($1, $2, $3, $4);",
      [invoiceId, date, total, currentUser]
    )
    .then(() => {
      Object.values(fullTracksList).map(async (track) => {
        const invoicelineId = uuid();
        await pool.query(
          "INSERT INTO invoiceline(invoicelineid, invoiceid, trackid, unitprice, quantity) values($1, $2, $3, $4, 1)",
          [invoicelineId, invoiceId, track.id, track.price]
        );
      });
    });

  res.json({
    action: {
      type: "SONGS_BOUGHT",
    },
  });
};

const getMySongs = async (req, res) => {
  const { user } = req.params;
  const mySongs = await pool.query(
    "SELECT track1.trackid AS id, track1.name, composer AS artist, track1.url FROM invoice invoice1 JOIN invoiceline invoiceline1 ON invoice1.invoiceid = invoiceline1.invoiceid JOIN track track1 ON track1.trackid = invoiceline1.trackid WHERE invoice1.email = $1",
    [user]
  );
  res.json({
    action: {
      type: "GET_MY_SONGS",
      payload: {
        mySongs: mySongs.rows,
      },
    },
  });
};

const getBinnacle = async (req, res) => {
  const binnacle = await pool.query(
    "SELECT date, time, usuario, tipo, modified_table FROM bitacora ORDER BY date DESC, time DESC"
  );
  res.json({
    action: {
      type: "GET_BINNACLE",
      payload: { binnacle: { ...binnacle.rows } },
    },
  });
};

const addReproduction = async (req, res) => {
  const { trackId, currentUser } = req.body;

  await pool.query(
    "UPDATE track SET reproductions = reproductions + 1 WHERE trackid = $1",
    [trackId]
  );
  await pool.query("INSERT INTO reproductions VALUES($1, $2)", [
    trackId,
    currentUser,
  ]);

  res.json({ msg: "Song reproduced" });
};

module.exports = {
  getUsers,
  getAlbums,
  getArtists,
  getTracks,
  getUserById,
  createUser,
  updateUser,
  updateTrack,
  updateArtist,
  updateAlbum,
  inacTrack,
  deleteUser,
  deleteTrack,
  deleteArtist,
  deleteAlbum,
  getStats,
  newArtist,
  newAlbum,
  newTrack,
  search,
  dailySales,
  totalWeeklySales,
  totalWeeklyArtistSales,
  totalWeeklyGenreSales,
  songRepsPerArtist,
  buySongs,
  getMySongs,
  getBinnacle,
  addReproduction,
};
