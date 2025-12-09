// To parse this JSON data, do
//
//     final spotEntry = spotEntryFromJson(jsonString);

import 'dart:convert';

List<SpotEntry> spotEntryFromJson(String str) => List<SpotEntry>.from(json.decode(str).map((x) => SpotEntry.fromJson(x)));

String spotEntryToJson(List<SpotEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SpotEntry {
    String id;
    String name;
    String thumbnail;
    String homeTeam;
    String awayTeam;
    DateTime date; //
    String time; //
    String city;
    String address;
    int host;

    SpotEntry({
        required this.id,
        required this.name,
        required this.thumbnail,
        required this.homeTeam,
        required this.awayTeam,
        required this.date,
        required this.time,
        required this.city,
        required this.address,
        required this.host,
    });

    factory SpotEntry.fromJson(Map<String, dynamic> json) => SpotEntry(
        id: json["id"],
        name: json["name"],
        thumbnail: json["thumbnail"] ?? "",
        homeTeam: json["home_team"],
        awayTeam: json["away_team"],
        date: DateTime.parse(json["date"]),
        time: json["time"],
        city: json["city"],
        address: json["address"],
        host: json["host"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "thumbnail": thumbnail,
        "home_team": homeTeam,
        "away_team": awayTeam,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "time": time,
        "city": city,
        "address": address,
        "host": host,
    };
}
