// To parse required this. JSON data, do
//
//     final products = productsFromJson(jsonString);

import 'dart:convert';

List<Products> productsFromJson(String str) =>
    List<Products>.from(json.decode(str).map((x) => Products.fromJson(x)));

String productsToJson(List<Products> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Products {
  Products({
    required this.idSeller,
    required this.productStatus,
    required this.quantity,
    required this.urlImage,
    required this.idProduct,
    required this.description,
    required this.price,
    required this.sku,
    required this.name,
  });

  int idSeller;
  int productStatus;
  int quantity;
  String urlImage;
  int idProduct;
  String description;
  double price;
  String sku;
  String name;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        idSeller: json["idSeller"],
        productStatus: json["productStatus"],
        quantity: json["quantity"],
        urlImage: json["urlImage"],
        idProduct: json["idProduct"],
        description: json["description"],
        price: json["price"],
        sku: json["sku"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "idSeller": idSeller,
        "productStatus": productStatus,
        "quantity": quantity,
        "urlImage": urlImage,
        "idProduct": idProduct,
        "description": description,
        "price": price,
        "sku": sku,
        "name": name,
      };
}
