import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../screen/menu.dart';
import 'package:flutter/material.dart';
import 'package:nobarpedia_mobile/config.dart';
import 'package:nobarpedia_mobile/widgets/left_drawer.dart';
import '../models/spot_entry.dart';

class SpotFormPage extends StatefulWidget {
    final SpotEntry? spotToEdit;
    const SpotFormPage({super.key,this.spotToEdit});

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

  void initState(){
    super.initState();
    if (widget.spotToEdit != null){
      _name = widget.spotToEdit!.name;
      _thumbnail = widget.spotToEdit!.thumbnail;
      _home_team = widget.spotToEdit!.homeTeam;
      _away_team = widget.spotToEdit!.awayTeam;
      _date = widget.spotToEdit!.date;
      _time = widget.spotToEdit!.time;
      _city = widget.spotToEdit!.city;
      _address = widget.spotToEdit!.address;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final hour = picked.hour.toString().padLeft(2, '0');
        final minute = picked.minute.toString().padLeft(2, '0');
        _time = "$hour:$minute:00";
      });
    }
  }

  bool get isEditMode => widget.spotToEdit != null;

    @override
    Widget build(BuildContext context) {
        final request = context.watch<CookieRequest>();
        return Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text(
                isEditMode ? 'Edit Nobar Spot' : 'Add Nobar Spot Form',
              ),
            ),
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

                  // === City ===
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "City",
                        labelText: "City",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _city = value!;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "City tidak boleh kosong!";
                        }
                        return null;
                      },
                    ),
                  ),

                  // === Date ===
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: "Date",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${_date.day.toString().padLeft(2, '0')}-${_date.month.toString().padLeft(2, '0')}-${_date.year}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // === Time ===
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => _selectTime(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: "Time",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _time.isEmpty ? "Select Time" : _time.substring(0, 5),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const Icon(Icons.access_time),
                          ],
                        ),
                      ),
                    ),
                  ),
                
                  // === Address ===
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "Address",
                        labelText: "Address",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _address = value!;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Address tidak boleh kosong!";
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

                              print("Is logged in: ${request.loggedIn}");
                              print("Cookies: ${request.cookies}");

                              String formattedDate = "${_date.year.toString().padLeft(4, '0')}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}";

                              final response = await request.postJson(
                                "$baseUrl/create-spot-flutter/",
                                jsonEncode({
                                  "name": _name,
                                  "home_team": _home_team,
                                  "away_team":_away_team,
                                  "thumbnail": _thumbnail,
                                  "date" : formattedDate,
                                  "time": _time,
                                  "city" : _city,
                                  "address" : _address,
                                  "username": request.jsonData['username'],
                                }),
                              );
                              print("Response: $response");
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
                        child:  Text(
                          isEditMode ? "Update" : "Save",
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