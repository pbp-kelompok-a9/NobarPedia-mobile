import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../screen/menu.dart';
import 'package:flutter/material.dart';
import 'package:nobarpedia_mobile/config.dart';
import 'package:nobarpedia_mobile/widgets/left_drawer.dart';

class SpotFormPage extends StatefulWidget {
    const SpotFormPage({super.key});

    @override
    State<SpotFormPage> createState() => _SpotFormPageState();
}

class _SpotFormPageState extends State<SpotFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _name = "";
  String _thumbnail = "";
  String _home_team = "";
  String _away_team = "";
  DateTime _date = DateTime.now();
  String _time = "";
  String _city = "";
  String _address = "";

    @override
    Widget build(BuildContext context) {
        final request = context.watch<CookieRequest>();
        return Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text(
                'Add Nobar Spot Form',
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 31, 123, 53),
            foregroundColor: Colors.white,
          ),
          drawer: LeftDrawer(),
          body : Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ==name==
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Name",
                        labelText: "Nama Spot",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _name = value!;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Nama tidak boleh kosong!";
                        }
                        return null;
                      },
                    ),
                  ),

                  // === Home team ===
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Home team",
                        labelText: "Home team",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _home_team = value!;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Home team tidak boleh kosong!";
                        }
                        return null;
                      },
                    ),
                  ),

                  // === Away team ===
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Away team",
                        labelText: "Away team",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _away_team = value!;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Away team tidak boleh kosong!";
                        }
                        return null;
                      },
                    ),
                  ),

                 // === Thumbnail URL ===
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "URL Thumbnail (opsional)",
                        labelText: "URL Thumbnail",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _thumbnail = value!;
                        });
                      },
                      validator: (String? value){
                        if (value == null ||value.isEmpty){
                          return null;
                        }
                        final urlPattern =
                            r'^(https?:\/\/)?' // awalan http atau https
                            r'([a-zA-Z0-9\-]+\.)+[a-zA-Z]{2,}' // domain
                            r'(\/\S*)?$'; // path opsional
                        final regExp = RegExp(urlPattern);

                        if (!regExp.hasMatch(value)) {
                          return "Masukkan URL yang valid!";
                        }

                        return null;

                      },
                    ),
                  ),


                  // === Tombol Simpan ===
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(const Color.fromARGB(255, 63, 181, 83)),
                        ),
                        onPressed: () async{
                          if (_formKey.currentState!.validate()) {
                             // TODO: Replace the URL with your app's URL
                              // To connect Android emulator with Django on localhost, use URL http://10.0.2.2/
                              // If you using chrome,  use URL http://localhost:8000
                              
                              final response = await request.postJson(
                                "$baseUrl/create-spot-flutter/",
                                jsonEncode({
                                  "name": _name,
                                  "home_team": _home_team,
                                  "away_team":_away_team,
                                  "thumbnail": _thumbnail,
                                  "date" : _date,
                                  "time": _time,
                                  "city" : _city,
                                  "address" : _address,
                                }),
                              );
                              if (context.mounted) {
                                if (response['status'] == 'success') {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Spot successfully saved!"),
                                  ));
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyHomePage()),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Something went wrong, please try again."),
                                  ));
                                }
                              }
                          }
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  
                ],





              ),











            ),)
        );
    }
}