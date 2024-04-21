

import 'dart:convert';

AddUser addUserFromJson(String str) => AddUser.fromJson(json.decode(str));

String addUserToJson(AddUser data) => json.encode(data.toJson());

class AddUser {
  String? name;
  String? email;

  String? image;

  AddUser({
    this.name,
    this.email,
    this.image,
  });

  factory AddUser.fromJson(Map<String, dynamic> json) => AddUser(
        name: json["name"],
        email: json["email"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "image": image,
      };
}
