// To parse this JSON data, do
//
//     final petTaxonimia = petTaxonimiaFromJson(jsonString);

import 'dart:convert';

List<PetTaxonimia> petTaxonimiaFromJson(String str) => List<PetTaxonimia>.from(
    json.decode(str).map((x) => PetTaxonimia.fromJson(x)));

String petTaxonimiaToJson(List<PetTaxonimia> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PetTaxonimia {
  PetTaxonimia({
    required this.pet,
  });

  List<Pet> pet;

  factory PetTaxonimia.fromJson(Map<String, dynamic> json) => PetTaxonimia(
        pet: List<Pet>.from(json["pet"].map((x) => Pet.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pet": List<dynamic>.from(pet.map((x) => x.toJson())),
      };
}

class Pet {
  Pet({
    required this.pet,
    required this.detallePets,
  });

  String pet;
  List<DetallePet> detallePets;

  factory Pet.fromJson(Map<String, dynamic> json) => Pet(
        pet: json["pet"],
        detallePets: List<DetallePet>.from(
            json["detallePets"].map((x) => DetallePet.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pet": pet,
        "detallePets": List<dynamic>.from(detallePets.map((x) => x.toJson())),
      };
}

class DetallePet {
  DetallePet({
    required this.item,
  });

  String item;

  factory DetallePet.fromJson(Map<String, dynamic> json) => DetallePet(
        item: json["item"],
      );

  Map<String, dynamic> toJson() => {
        "item": item,
      };
}
