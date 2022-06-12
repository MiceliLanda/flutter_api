// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:convert';
import 'package:consuming_api/models/caroussel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Market extends StatefulWidget {
  const Market({Key? key}) : super(key: key);

  @override
  State<Market> createState() => _MarketState();
}

class _MarketState extends State<Market> {
  final List<CarousselImage> _carousselImages = [];

  Future<List<CarousselImage>> postCaroussel() async {
    final response = await http.post(
        Uri.parse('http://desarrollovan-tis.dedyn.io:4030/GetImagesCarousel'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"idChannel": "1"}));
    List<CarousselImage> datos = [];
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body)['dtoImageCarousels'];
      for (var jsonData in jsonResponse) {
        datos.add(CarousselImage.fromJson(jsonData));
        print('JsonData -> ' + jsonData.toString());
      }
    } else {
      print('Error -> ' + response.statusCode.toString());
    }
    return datos;
  }

  @override
  void initState() {
    postCaroussel().then((value) {
      setState(() {
        _carousselImages.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: <Widget>[
                Image.network(_carousselImages[index].url.toString()),
                Text(_carousselImages[index].nombre.toString()),
              ],
            ),
          );
        },
        itemCount: _carousselImages.length,
      ),
    );
  }
}
