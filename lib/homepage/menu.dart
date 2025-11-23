import 'package:flutter/material.dart';
import 'package:nobarpedia_mobile/widgets/left_drawer.dart';
// import 'package:nobarpedia_mobile/widgets/product_card.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold menyediakan struktur dasar halaman dengan AppBar dan body.
    return Scaffold(
      // AppBar adalah bagian atas halaman yang menampilkan judul.
      appBar: AppBar(
        // Judul aplikasi dengan teks putih dan tebal.
        title: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
            children: <TextSpan>[
              TextSpan(text: 'Nobar', style: TextStyle(color: Colors.white)),
              TextSpan(text: 'Pedia', style: TextStyle(color: Colors.green)),
            ],
          ),
        ),
        // Warna latar belakang AppBar diambil dari skema warna tema aplikasi.
      ),
      drawer: LeftDrawer(),
      // Body halaman dengan padding di sekelilingnya.
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Menyusun widget secara vertikal dalam sebuah kolom.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // isi

          ],
        ),
      ),
    );
  }
}
