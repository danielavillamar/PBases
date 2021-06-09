/*
            Routers

    Rutas para acceder al API.

    Estas rutas son las rupas publicas para que las aplicaciones accedan al API.

    Cada ruta ejecuta una consulta SQL a POSTGRESQL

*/

const { Router } = require("express");
const router = Router();

const {
  getUsers,
  getAlbums,
  getArtists,
  getTracks,
  getUserById,
  createUser,
  updateUser,
  deleteUser,
  deleteTrack,
  deleteArtist,
  deleteAlbum,
  getStats,
  newArtist,
  newAlbum,
  newTrack,
  inacTrack,
  updateTrack,
  updateArtist,
  updateAlbum,
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
} = require("../controllers/index");

//Aqui van todas las rutas para hacer las requests al API de Postgres
//Mediante router se define que tipo de REQUEST es .get, .post, .put, .delete, etc.

router.get("/users", getUsers);
router.get("/stats", getStats);
router.get("/albums", getAlbums);
router.get("/artists", getArtists);
router.get("/tracks", getTracks);
router.get("/user/:emailAddress/:password", getUserById);
router.get("/search/:searchValue", search);
router.get("/weekly-sales-stats/:day1/:day2", totalWeeklySales);
router.get(
  "/weekly-artists-sales-stats/:day1/:day2/:limit",
  totalWeeklyArtistSales
);
router.get("/get-my-songs/:user", getMySongs);
router.get("/weekly-genre-sales-stats/:day1/:day2", totalWeeklyGenreSales);
router.get("/binnacle", getBinnacle);
router.post("/song-reps-per-artist", songRepsPerArtist);
router.post("/users", createUser);
router.post("/new-artist", newArtist);
router.post("/new-album", newAlbum);
router.post("/new-track", newTrack);
router.post("/sales", dailySales);
router.post("/buy-songs", buySongs);
// router.put('/users/:id', updateUser)
router.put("/user/:emailAddress", updateUser);
router.put("/track/inactivate", inacTrack);
router.put("/track/update", updateTrack);
router.put("/artist/update", updateArtist);
router.put("/album/update", updateAlbum);
router.put("/add-rep", addReproduction);
router.delete("/users/:id", deleteUser);
router.delete("/track/delete/:trackid", deleteTrack);
router.delete("/artist/delete/:artistid", deleteArtist);
router.delete("/album/delete/:albumid", deleteAlbum);

//
module.exports = router;
