import 'package:mango/models/comic.dart';
import 'package:mango/models/manga_comic.dart';

List<Comic> mangaList = [
  Manga(
    id: "op001",
    title: "One Piece",
    author: "Eiichiro Oda",
    description: "Petualangan bajak laut mencari harta karun legendaris.",
    coverImage:
        "https://thumbnail.komiku.org/uploads/manga/komik-one-piece-indo/manga_thumbnail-Komik-One-Piece.jpg?",
    rating: 4.9,
    genres: ["Action", "Adventure", "Fantasy"],
    status: "Ongoing",
    chapters: 1160,
    releaseYear: "1997",
  ),
  Manga(
    id: "ds001",
    title: "Demon Slayer",
    author: "Koyoharu Gotouge",
    description:
        "Perjalanan Tanjiro menjadi pemburu iblis untuk menyelamatkan adiknya.",
    coverImage:
        "https://upload.wikimedia.org/wikipedia/en/0/09/Demon_Slayer_-_Kimetsu_no_Yaiba%2C_volume_1.jpg",
    rating: 4.8,
    genres: ["Action", "Dark Fantasy", "Supernatural"],
    status: "competed",
    chapters: 205,
    releaseYear: "2016",
  ),
  Manga(
    id: "jjk001",
    title: "Jujutsu Kaisen",
    author: "Gege Akutami",
    description:
        "Cerita tentang siswa SMA yang terlibat dalam dunia kutukan dan jujutsu.",
    coverImage:
        "https://upload.wikimedia.org/wikipedia/en/4/46/Jujutsu_kaisen.jpg",
    rating: 4.8,
    genres: ["Action", "Supernatural", "Horror"],
    status: "competed",
    chapters: 271,
    releaseYear: "2018",
  ),
  Manga(
    id: "bnh001",
    title: "Boku no Hero Academia",
    author: "Kohei Horikoshi",
    description:
        "Kisah seorang anak tanpa kekuatan di dunia penuh pahlawan super.",
    coverImage:
        "https://thumbnail.komiku.org/uploads/manga/boku-no-hero-academia-indonesia/manga_thumbnail-Komik-Boku-no-Hero-Academia.jpg",
    rating: 4.8,
    genres: ["Action", "Superhero", "School"],
    status: "competed",
    chapters: 430,
    releaseYear: "2014",
  ),
];
