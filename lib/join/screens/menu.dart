import 'package:flutter/material.dart';
import 'package:nobarpedia_mobile/join/models/JoinEntry.dart';
import 'package:nobarpedia_mobile/join/models/NobarSpot.dart';
import 'package:nobarpedia_mobile/join/widgets/join_entry_card.dart';
import 'package:nobarpedia_mobile/join/widgets/my_spots_card.dart';
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
  Future<List<dynamic>> fetchJoin(CookieRequest request) async {
    final url = widget.mine ? '$baseUrl/user-spots-json/' : '$baseUrl/join/get';
    final response = await request.get(url);

    var data = response;

    if (widget.mine) {
      List<NobarSpot> listSpot = [];
      for (var d in data) {
        if (d != null) {
          listSpot.add(NobarSpot.fromJson(d));
        }
      }
      return listSpot;
    } else {
      List<JoinEntry> listJoin = [];
      for (var d in data) {
        if (d != null) {
          listJoin.add(JoinEntry.fromJson(d));
        }
      }
      return listJoin;
    }
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
      body: Column(
        children: [
          Center(
            child: SizedBox(
              width: double.infinity,
              height: 150, 
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/joinhero.png',
                      fit: BoxFit.cover,
                      color: Colors.black.withOpacity(0.5),
                      colorBlendMode: BlendMode.darken,
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 24.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: 'Bring the '),
                                  TextSpan(
                                    text: 'Stadium',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  TextSpan(text: ' Closer to You'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Experience the thrill of football, together',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Filter buttons
          Center(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 32.0),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        // TODO: Implement filter Joined Spot
                        if (widget.mine) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const JoinPage(mine: false),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(
                          'Joined Spot',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        // TODO: Implement filter My Nobar Spot
                        if (!widget.mine) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const JoinPage(mine: true),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(
                          'My Nobar Spot',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // List
          Expanded(
            child: FutureBuilder(
              future: fetchJoin(request),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.mine
                              ? 'You have not made any spots.'
                              : 'You have not joined any spots yet.',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) {
                      if (widget.mine) {
                        return MySpotsCard(
                            spot: snapshot.data![index] as NobarSpot);
                      } else {
                        return JoinEntryCard(
                            join: snapshot.data![index] as JoinEntry);
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
