const bool useProductionUrl = false; // set to true to use production url

const String productionUrl = 'https://daffa-ismail-nobarpedia.pbp.cs.ui.ac.id';
const String developmentUrl = 'http://localhost:8000';

const String baseUrl = useProductionUrl ? productionUrl : developmentUrl;


// Cara kerja:

// 1. dibagian atas file yang perlu url django, tulis:
//    import 'package:nobarpedia_mobile/config.dart';
// 2. instead of nulis 'http://localhost:8000' atau 'https://daffa-ismail-nobarpedia.pbp.cs.ui.ac.id',
//    tulis '$baseUrl/...' sesuai endpoint yang dituju


// misal:

// ada ini:
// "http://localhost:8000/auth/login/",
//
// ganti jadi:
// "$baseUrl/auth/login/",
//
// dan pastiin ada import config.dart di file tsb
