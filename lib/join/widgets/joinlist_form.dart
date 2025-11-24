import 'package:flutter/material.dart';
import 'package:nobarpedia_mobile/join/models/NobarSpot.dart';
import 'package:nobarpedia_mobile/widgets/left_drawer.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:nobarpedia_mobile/join/screens/menu.dart';
import 'package:nobarpedia_mobile/config.dart';

class CreateJoinPage extends StatefulWidget {
  final NobarSpot place;
  const CreateJoinPage({super.key, required this.place});

  @override
  State<CreateJoinPage> createState() => _CreateJoinPageState();
}

class _CreateJoinPageState extends State<CreateJoinPage> {
  final _formKey = GlobalKey<FormState>();
  String _status = "mungkin"; // Default status
  final List<String> _statuses = ["mungkin", "pasti"];

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Nobar Spot'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "You are joining:",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.place.name,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.place.city,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const Divider(),

              // === Status ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Your Status",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  value: _status,
                  items: _statuses
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(status[0].toUpperCase() + status.substring(1)),
                        ),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _status = newValue!;
                    });
                  },
                ),
              ),
              // === Save Button ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final response = await request.postJson(
                          "$baseUrl/join/create-flutter/",
                          jsonEncode({
                            "nobar_place_id": widget.place.id,
                            "status": _status,
                          }),
                        );
                        if (context.mounted) {
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Successfully joined the spot!"),
                              ),
                            );
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const JoinPage(mine: false),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Something went wrong, please try again.",
                                ),
                              ),
                            );
                          }
                        }
                      }
                    },
                    child: const Text(
                      "Join",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
