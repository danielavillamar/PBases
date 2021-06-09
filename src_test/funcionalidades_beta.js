var participante = false
var pista = document.getElementById('pista')
var progress = document.getElementById('progress')
var titulo = document.getElementById('titulo')
var artista = document.getElementById('artista')
var album = document.getElementById('album')
var handler = document.getElementById('handler')
var current_track = 0
var cancion, audio, duration
var canciones_html = '' 

var canciones = [
    {
        album: 'REALONE',
        titulo: 'You and Me',
        artista: 'Disclosure (Flume remix)',
        audio: 'Disclosure.mp3'
    },
    {
        album: 'MRS',
        titulo: 'Scared to be lonely',
        artista: 'Martin Garrix & Dua Lipa',
        audio: 'ScaredToBeLonely.mp3'
    },
    {
        album: 'FEELS',
        titulo: 'One kiss',
        artista: 'Calvin Harris, Dua Lipa',
        audio: 'OneKiss.mp3'
    },
    {
        album: 'ENCORE',
        titulo: 'Numb',
        artista: 'Linkin Park',
        audio: 'Numb.mp3'
    },
    {
        album: 'GUATE',
        titulo: 'Anyway',
        artista: 'Francis Davila',
        audio: 'Anyway.mp3'
    },
    {
        album: 'STRESS',
        titulo: "Nico And The Niners",
        artista: 'Twenty One Pilots',
        audio: 'Niners.mp3'
    },
    {
        album: 'STARKICK',
        titulo: 'Rockstar',
        artista: 'Post Malone',
        audio: 'rockstar.mp3'
    },
    {
        album: 'REALFORG',
        titulo: 'Humble',
        artista: 'Kendrick Lamar',
        audio: 'HUMBLE.mp3'
    },
    {
        album: 'STARKICK',
        titulo: 'White Iverson',
        artista: 'Post Malone',
        audio: 'White_Iverson.mp3'
    },
]

$(document).ready(function () {
    $.each(canciones, function (index) {
        canciones_html += '<li class="list-group-item d-flex justify-content-between align-items-center" onclick="CancionSelect(' + index + ')">'
        canciones_html += '<blockquote class="blockquote">'
        canciones_html += '<h5>' + canciones[index].titulo + '</h5>'
        canciones_html += '<footer class="blockquote-footer">' + canciones[index].artista + '</footer>'
        canciones_html += '</blockquote>'
        canciones_html += '<h3><i id="play' + index + '" class="fas fa-play-circle"></i></h3>'
        canciones_html += '</li>'
    })
    $('#contenido').html(canciones_html)
    init()
})

function CancionSelect(id) {
    current_track = id
    cancion = canciones[current_track];
    audio.src = cancion.audio;
    audio.onloadeddata = function () {
        updateInfo();
        $('#play').removeClass('fa-play-circle')
        $('#play').addClass('fa-pause-circle')
        for (var i = 0; i <= canciones.length; i++) {
            $('#play' + i + '').removeClass('fa-pause-circle')
            $('#play' + i + '').addClass('fa-play-circle')
        }
        $('#play' + id + '').removeClass('fa-play-circle')
        $('#play' + id + '').addClass('fa-pause-circle')
        audio.addEventListener('timeupdate', initProgressBar, false);
    }
}

function init() {
    cancion = canciones[current_track]
    audio = new Audio()
    album.src = cancion.album
    audio.src = cancion.audio
    titulo.textContent = cancion.titulo
    artista.textContent = cancion.artista
}

function playTrack() {
    if ($('#play').hasClass('fa-pause-circle')) {
        $('#play').removeClass('fa-pause-circle')
        $('#play').addClass('fa-play-circle')
        $('#play' + current_track + '').removeClass('fa-pause-circle')
        $('#play' + current_track + '').addClass('fa-play-circle')
        audio.pause()
    } else {
        $('#play').removeClass('fa-play-circle')
        $('#play').addClass('fa-pause-circle')
        $('#play' + current_track + '').removeClass('fa-play-circle')
        $('#play' + current_track + '').addClass('fa-pause-circle')
        audio.play()
        audio.addEventListener('timeupdate', initProgressBar, false);
    }
}

function nextTrack() {
    current_track++;
    current_track = current_track % (canciones.length);
    cancion = canciones[current_track];
    audio.src = cancion.audio;
    audio.onloadeddata = function () {
        $('#play').removeClass('fa-play-circle')
        $('#play').addClass('fa-pause-circle')
        for (var i = 0; i <= canciones.length; i++) {
            $('#play' + i + '').removeClass('fa-pause-circle')
            $('#play' + i + '').addClass('fa-play-circle')
        }
        $('#play' + current_track + '').removeClass('fa-play-circle')
        $('#play' + current_track + '').addClass('fa-pause-circle')
        updateInfo();
    }
}

function prevTrack() {
    current_track--;
    current_track = (current_track == -1 ? (canciones.length - 1) : current_track);
    cancion = canciones[current_track];
    audio.src = cancion.audio;
    audio.onloadeddata = function () {
        $('#play').removeClass('fa-play-circle')
        $('#play').addClass('fa-pause-circle')
        for (var i = 0; i <= canciones.length; i++) {
            $('#play' + i + '').removeClass('fa-pause-circle')
            $('#play' + i + '').addClass('fa-play-circle')
        }
        $('#play' + current_track + '').removeClass('fa-play-circle')
        $('#play' + current_track + '').addClass('fa-pause-circle')
        updateInfo();
    }
	

}

function updateInfo() {
    titulo.textContent = cancion.titulo;
    artista.textContent = cancion.artista;
    album.src = cancion.album;
    album.onload = function () {
        audio.play();
    }
}

function initProgressBar() {
    var length = audio.duration
    var current_time = audio.currentTime

    var totalLength = calculateTotalValue(length)
    $('#end-time').html(totalLength)

    var currentTime = calculateCurrentValue(current_time)
    $('#start-time').html(currentTime)

    progress.value = (audio.currentTime / audio.duration);
    progress.addEventListener("click", seek);

    function seek(event) {
        var percent = event.offsetX / this.offsetWidth;
        audio.currentTime = percent * audio.duration;
        progress.value = percent / 100;
    }

}

function calculateTotalValue(length) {
    var minutes = Math.floor(length / 60),
        seconds_int = length - minutes * 60,
        seconds_str = seconds_int.toString(),
        seconds = seconds_str.substr(0, 2),
        time = minutes + ':' + seconds

    return time;
}

function calculateCurrentValue(currentTime) {
    var current_hour = parseInt(currentTime / 3600) % 24,
        current_minute = parseInt(currentTime / 60) % 60,
        current_seconds_long = currentTime % 60,
        current_seconds = current_seconds_long.toFixed(),
        current_time = (current_minute < 10 ? "0" + current_minute : current_minute) + ":" + (current_seconds < 10 ? "0" + current_seconds : current_seconds);

    return current_time;
}