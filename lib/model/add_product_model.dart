// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  String? name;
  String? image;
  String? description;
  String? price;

  Product({
    this.name,
    this.image,
    this.description,
    this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    name: json["name"],
    image: json["image"],
    description: json["description"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "image": image,
    "description": description,
    "price": price,
  };
}