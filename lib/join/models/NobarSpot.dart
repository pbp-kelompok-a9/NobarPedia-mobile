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
  HostUsername hostUsername;
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
    hostUsername: hostUsernameValues.map[json["host_username"]]!,
    joinedCount: json["joined_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "city": city,
    "time": time,
    "host_id": hostId,
    "host_username": hostUsernameValues.reverse[hostUsername],
    "joined_count": joinedCount,
  };
}

enum HostUsername { PBP }

final hostUsernameValues = EnumValues({"pbp": HostUsername.PBP});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
