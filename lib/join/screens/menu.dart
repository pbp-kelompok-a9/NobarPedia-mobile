import 'package:flutter/material.dart';
import 'package:nobarpedia_mobile/join/models/JoinEntry.dart';
import 'package:nobarpedia_mobile/join/widgets/join_entry_card.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:nobarpedia_mobile/config.dart';
import 'package:nobarpedia_mobile/widgets/left_drawer.dart';

class JoinPage extends StatefulWidget {
  final bool mine;

  const JoinPage({super.key, this.mine = false});

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  Future<List<JoinEntry>> fetchJoin(CookieRequest request) async {
    // /join/get needs user data attached
    // /json needs .filter with host_id (host field, fk to User models)
    final url = widget.mine ? '$baseUrl/json' : '$baseUrl/join/get';
    final response = await request.get(url);

    // Decode response to json format
    var data = response;

    // Convert json data to ProductEntry objects
    List<JoinEntry> listJoin = [];
    for (var d in data) {
      if (d != null) {
        listJoin.add(JoinEntry.fromJson(d));
      }
    }
    return listJoin;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mine ? 'My Spots' : 'All Joined Spots',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(30, 30, 30, 1),
      ),
      drawer: const LeftDrawer(),
      backgroundColor: Color.fromRGBO(30, 30, 30, 1),
      // child: [] or body: [] theres image, filterbuttons, then the future builder
      body: Column(
        children: [
          // image
          Image.asset(
            'assets/images/joinhero.png',
            fit: BoxFit.cover,
            height: 150, // Adjust height as needed
            width: double.infinity,
          ),
          const SizedBox(height: 16),
          // filter buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Implement filter logic
                  },
                  child: 
                    Text('All Joined Spots',
                      style: TextStyle( 
                        color: widget.mine ? Colors.white : Colors.green
                      )
                    ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement filter logic
                  },
                  child: const Text('My Nobar Spot'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder(
              future: fetchJoin(request),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (!snapshot.hasData) {
                    return Column(
                      children: [
                        Text(
                          widget.mine
                              ? 'You have not made any spots.'
                              : 'You have not joined any spots yet.',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color(0xff59A5D8),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) => JoinEntryCard(
                        join: snapshot.data![index],
                        // maybe an ontap redirect to the detail/review page?
                      ),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
