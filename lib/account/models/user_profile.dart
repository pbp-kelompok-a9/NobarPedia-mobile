// To parse this JSON data, do
//
//     final userProfile = userProfileFromJson(jsonString);

import 'dart:convert';

UserProfile userProfileFromJson(String str) => UserProfile.fromJson(json.decode(str));

String userProfileToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
    String username;
    String email;
    String fullname;
    String bio;
    String profilePictureUrl;
    bool showUpdateButton;

    UserProfile({
        required this.username,
        required this.email,
        required this.fullname,
        required this.bio,
        required this.profilePictureUrl,
        required this.showUpdateButton,
    });

    factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        username: json["username"],
        email: json["email"],
        fullname: json["fullname"],
        bio: json["bio"],
        profilePictureUrl: json["profile_picture_url"],
        showUpdateButton: json["show_update_button"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "fullname": fullname,
        "bio": bio,
        "profile_picture_url": profilePictureUrl,
        "show_update_button": showUpdateButton,
    };
}
