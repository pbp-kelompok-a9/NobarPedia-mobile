import 'package:flutter/material.dart';
import 'package:nobarpedia_mobile/account/models/user_profile.dart';
import 'package:nobarpedia_mobile/account/widget/user_card.dart';
import 'package:nobarpedia_mobile/config.dart';
import 'package:nobarpedia_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class AdminAccountPage extends StatefulWidget {
  const AdminAccountPage({super.key});

  @override
  State<AdminAccountPage> createState() => _AdminAccountPage();
}

class _AdminAccountPage extends State<AdminAccountPage> {
  Future<List<UserProfile>> fetchAllUser(CookieRequest request) async {
    final response = await request.get('$baseUrl/account/api/admin/');

    List<dynamic> temp = response['responseData'];
  
  // Convert list of JSON objects -> List of UserProfile objects
  return temp.map((item) => UserProfile.fromJson(item)).toList();
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
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
            children: <TextSpan>[
              TextSpan(
                text: 'Nobar',
                style: TextStyle(color: Colors.white),
              ),
              TextSpan(
                text: 'Pedia',
                style: TextStyle(color: Colors.green),
              ),
              TextSpan(
                text: ' Admin Page',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        // Warna latar belakang AppBar diambil dari skema warna tema aplikasi.
      ),
      drawer: LeftDrawer(),
      // Body halaman dengan padding di sekelilingnya.
      backgroundColor: const Color(0xFF1E1E1E), 
      body: FutureBuilder(
        future: fetchAllUser(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 20),
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                return UserCard(
                  userData: snapshot.data![index], 
                  request: request,
                  // Refresh page
                  onRefresh: () {
                    setState(() {}); 
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
