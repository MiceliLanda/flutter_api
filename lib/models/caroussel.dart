import 'dart:convert';

List<CarousselImage> carousselImageFromJson(String str) =>
    List<CarousselImage>.from(
        json.decode(str).map((x) => CarousselImage.fromJson(x)));

String carousselImageToJson(List<CarousselImage> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CarousselImage {
  CarousselImage({
    required this.url,
    required this.accion,
    required this.nombre,
  });

  String url;
  String accion;
  String nombre;

  factory CarousselImage.fromJson(Map<String, dynamic> json) => CarousselImage(
        url: json["url"],
        accion: json["accion"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "accion": accion,
        "nombre": nombre,
      };
}
