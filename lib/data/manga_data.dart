import '../models/comic.dart';

List<Comic> mangaList = [
  Comic(
    id: "op001",
    title: "One Piece",
    author: "Eiichiro Oda",
    description: "Petualangan bajak laut mencari harta karun legendaris.",
    coverImage:
        "https://upload.wikimedia.org/wikipedia/en/2/29/OnePieceCover1.jpg",
    rating: 4.9,
    genres: ["Action", "Adventure", "Fantasy"],
  ),
  Comic(
    id: "ds001",
    title: "Demon Slayer",
    author: "Koyoharu Gotouge",
    description:
        "Perjalanan Tanjiro menjadi pemburu iblis untuk menyelamatkan adiknya.",
    coverImage:
        "https://upload.wikimedia.org/wikipedia/en/0/09/Demon_Slayer_-_Kimetsu_no_Yaiba%2C_volume_1.jpg",
    rating: 4.8,
    genres: ["Action", "Dark Fantasy", "Supernatural"],
  ),
  Comic(
    id: "jjk001",
    title: "Jujutsu Kaisen",
    author: "Gege Akutami",
    description:
        "Cerita tentang siswa SMA yang terlibat dalam dunia kutukan dan jujutsu.",
    coverImage:
        "https://upload.wikimedia.org/wikipedia/en/4/46/Jujutsu_kaisen.jpg",
    rating: 4.8,
    genres: ["Action", "Supernatural", "Horror"],
  ),
];
