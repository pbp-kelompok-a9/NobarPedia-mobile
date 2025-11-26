// To parse this JSON data, do
//
//     final joinEntry = joinEntryFromJson(jsonString);

import 'dart:convert';

List<JoinEntry> joinEntryFromJson(String str) =>
    List<JoinEntry>.from(json.decode(str).map((x) => JoinEntry.fromJson(x)));

String joinEntryToJson(List<JoinEntry> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class JoinEntry {
  String id;
  String user;
  String userId;
  String nobarPlaceId;
  String nobarPlaceName;
  String nobarPlaceCity;
  String nobarPlaceTime;
  String status;
  DateTime createdAt;

  JoinEntry({
    required this.id,
    required this.user,
    required this.userId,
    required this.nobarPlaceId,
    required this.nobarPlaceName,
    required this.nobarPlaceCity,
    required this.nobarPlaceTime,
    required this.status,
    required this.createdAt,
  });

  factory JoinEntry.fromJson(Map<String, dynamic> json) => JoinEntry(
    id: json["id"],
    user: json["user"],
    userId: json["user_id"],
    nobarPlaceId: json["nobar_place_id"],
    nobarPlaceName: json["nobar_place_name"],
    nobarPlaceCity: json["nobar_place_city"],
    nobarPlaceTime: json["nobar_place_time"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user,
    "user_id": userId,
    "nobar_place_id": nobarPlaceId,
    "nobar_place_name": nobarPlaceName,
    "nobar_place_city": nobarPlaceCity,
    "nobar_place_time": nobarPlaceTime,
    "status": status,
    "created_at": createdAt.toIso8601String(),
  };
}
