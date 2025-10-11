import 'package:mango/models/comic/comic.dart';
import 'package:mango/models/comic/manhwa_comic.dart';

List<Comic> manhwaList = [
  Manhwa(
    id: "sl001",
    title: "Solo Leveling",
    author: "Chugong",
    description: "Seorang hunter lemah menjadi hunter terkuat dengan sistem misterius.",
    coverImage: "https://m.media-amazon.com/images/I/81OYRZEQG7L._SY425_.jpg",
    rating: 4.9,
    genres: ["Action", "Fantasy", "Adventure"],
    status: 'completed',
    chapters: 179,
    releaseYear: '2018',
  ),
  Manhwa(
    id: "tghs001",
    title: "The God of High School",
    author: "Yongje Park",
    description: "menceritakan tentang seorang remaja bernama Jin Mori yang mengikuti kompetisi bela diri tingkat nasional.",
    coverImage: "https://images.weserv.nl/?url=thumbnail.komiku.org/uploads/manga/the-god-of-high-school/manga_thumbnail-Komik-The-God-of-High-School.jpg",
    rating: 4.9,
    genres: ["Action", "Martial Arts", "Supernatural"],
    status: 'completed',
    chapters: 526,
    releaseYear: '2011',
  ),
  Manhwa(
    id: "wb001",
    title: "Wind Breaker",
    author: "Jo Yongseok",
    description: "Wind Breaker menceritakan kisah Jo Jaemin, seorang siswa SMA yang dikenal sebagai pemuda penuh semangat dan bakat dalam dunia sepeda BMX.",
    coverImage: "https://images.weserv.nl/?url=thumbnail.komiku.org/uploads/manga/wind-breaker/manga_thumbnail-Manhwa-Wind-Breaker.jpg",
    rating: 4.9,
    genres: ["Action", "Sports"],
    status: 'completed',
    chapters: 556,
    releaseYear: '2018',
  ),
];
