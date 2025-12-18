import 'package:flutter/material.dart';
import 'package:nobarpedia_mobile/widgets/left_drawer.dart';
import '../models/spot_entry.dart';
import '../widget/spot_entry_card.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:nobarpedia_mobile/config.dart';
import 'spot_form.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<SpotEntry>> _spotsFuture;

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    _spotsFuture = fetchSpot(request);
  }

  void _refreshSpots() {
    final request = context.read<CookieRequest>();
    setState(() {
      _spotsFuture = fetchSpot(request);
    });
  }

  Future<List<SpotEntry>> fetchSpot(CookieRequest request) async {
    final response = await request.get("$baseUrl/json/");
    var data = response;
    
    List<SpotEntry> listSpot = [];
    for (var d in data) {
      if (d != null) {
        listSpot.add(SpotEntry.fromJson(d));
      }
    }
    return listSpot;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

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
        padding: const EdgeInsets.all(4.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // ==== Bagian Header ====
              const SizedBox(height: 20),
              const Text(
                "Welcome to NobarPedia",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Temukan tempat nobar terbaik di sekitarmu. Gabung komunitas sesama pecinta bola dan rasakan atmosfer pertandingan bersama!",
                style: TextStyle(fontSize: 14, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              if (request.loggedIn) ...[
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SpotFormPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Add New Spot", style: TextStyle(color: Colors.white)),
                ),

                const SizedBox(height: 40),
              
              ],

              // ==== Gambar ====
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/homepage_image.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Pick Your Spot",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              const SizedBox(height: 20),

              // ==== Tombol Filter ====
              if (request.loggedIn) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: const Text("All Spot", style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.green),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: const Text("Your Spot", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
      

              // ==== LIST SPOT ====
              FutureBuilder(
                future: _spotsFuture,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("Belum ada spot di Nobarpedia."),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,        
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 350, 
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.75, 
                    ),

                    itemCount: snapshot.data.length,
                    itemBuilder: (_, index) => SpotEntryCard(
                      spot: snapshot.data[index],
                      onTap: () {
                      },
                      onDelete: () async {
                        _refreshSpots();
                      },
                    ),
                  );
                },
              ),

            ],
          ),
        ),
      ),

    );
  }
}
