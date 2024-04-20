// To parse this JSON data, do
//
//     final addUser = addUserFromJson(jsonString);

import 'dart:convert';

AddUser addUserFromJson(String str) => AddUser.fromJson(json.decode(str));

String addUserToJson(AddUser data) => json.encode(data.toJson());

class AddUser {
  String? name;
  String? email;
  String? phone;

  String? image;

  bool? online;
  String? fcmToken;

  AddUser(
      {this.name,
      this.email,
      this.phone,
      this.image,
      this.online,
      this.fcmToken});

  factory AddUser.fromJson(Map<String, dynamic> json) => AddUser(
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        image: json["image"],
        online: json["online"],
        fcmToken: json["fcmToken"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phone": phone,
        "image": image,
        "online": online,
        "fcmToken": fcmToken
      };
}
