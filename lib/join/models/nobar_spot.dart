// To parse this JSON data, do
//
//     final nobarSpot = nobarSpotFromJson(jsonString);

import 'dart:convert';

List<NobarSpot> nobarSpotFromJson(String str) =>
    List<NobarSpot>.from(json.decode(str).map((x) => NobarSpot.fromJson(x)));

String nobarSpotToJson(List<NobarSpot> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NobarSpot {
  String id;
  String name;
  String city;
  String time;
  String hostId;
  String hostUsername;
  int joinedCount;

  NobarSpot({
    required this.id,
    required this.name,
    required this.city,
    required this.time,
    required this.hostId,
    required this.hostUsername,
    required this.joinedCount,
  });

  factory NobarSpot.fromJson(Map<String, dynamic> json) => NobarSpot(
    id: json["id"],
    name: json["name"],
    city: json["city"],
    time: json["time"],
    hostId: json["host_id"],
    hostUsername: json["host_username"],
    joinedCount: json["joined_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "city": city,
    "time": time,
    "host_id": hostId,
    "host_username": hostUsername,
    "joined_count": joinedCount,
  };
}
