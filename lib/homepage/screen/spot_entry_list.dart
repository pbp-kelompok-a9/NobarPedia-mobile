import 'package:flutter/material.dart';
import '../models/spot_entry.dart';
import '../../widgets/left_drawer.dart';
import '../widget/spot_entry_card.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:nobarpedia_mobile/config.dart';

class SpotEntryListPage extends StatefulWidget {
  const SpotEntryListPage({super.key});

  @override
  State<SpotEntryListPage> createState() => _SpotEntryListPageState();
}

class _SpotEntryListPageState extends State<SpotEntryListPage> {
  Future<List<SpotEntry>> fetchSpot(CookieRequest request) async {
    // TODO: Replace the URL with your app's URL and don't forget to add a trailing slash (/)!
    // To connect Android emulator with Django on localhost, use URL http://10.0.2.2/
    // If you using chrome,  use URL http://localhost:8000
    
    final response = await request.get('$baseUrl/show_json/');
    
    // Decode response to json format
    var data = response;
    
    // Convert json data to NewsEntry objects
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spot Entry List'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchSpot(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    'There are no spot in nobarpedia yet.',
                    style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => SpotEntryCard(
                  spot: snapshot.data![index],
                  onTap: () {
                    // Show a snackbar when news card is clicked
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text("You clicked on ${snapshot.data![index].name}"),
                        ),
                      );
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }
}